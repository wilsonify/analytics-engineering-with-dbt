#!/usr/bin/env bash
set -euo pipefail

# Migrate local example data from Postgres 15 (volume) to Postgres 17.
# Usage:
#   ./scripts/migrate-postgres-15-to-17.sh
#   ./scripts/migrate-postgres-15-to-17.sh --project-dir "../c02-Data Modeling for Analytics" --init-examples

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
INIT_EXAMPLES="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-dir)
      PROJECT_DIR="$2"
      shift 2
      ;;
    --init-examples)
      INIT_EXAMPLES="true"
      shift 1
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

cd "$PROJECT_DIR"

if [[ ! -f .env ]]; then
  echo "Missing .env in $PROJECT_DIR" >&2
  exit 1
fi

# Load env vars from .env
set -a
# shellcheck disable=SC1091
source .env
set +a

# Derive compose project name (matches docker compose default behavior)
# Keep hyphens, remove other non-alphanumeric characters.
project_name="$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')"
old_volume="${project_name}_postgres_data"

dump_dir="$PROJECT_DIR/migrations"
mkdir -p "$dump_dir"
dump_file="$dump_dir/postgres15_dump_${POSTGRES_DB}_$(date +%Y%m%d_%H%M%S).sql"

old_container="${project_name}_pg15_migrate"
new_container="${project_name}_pg17_restore"

cleanup() {
  docker rm -f "$old_container" >/dev/null 2>&1 || true
  docker rm -f "$new_container" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# Stop services to free the volume
if command -v docker >/dev/null 2>&1; then
  docker compose down >/dev/null 2>&1 || true
else
  echo "Docker is required." >&2
  exit 1
fi

if ! docker volume inspect "$old_volume" >/dev/null 2>&1; then
  # Fallback: try to find a matching postgres_data volume
  fallback_volume="$(docker volume ls --format '{{.Name}}' | grep -i "postgres_data" | grep -i "${project_name}" | head -n 1 || true)"
  if [[ -n "$fallback_volume" ]]; then
    old_volume="$fallback_volume"
  else
    echo "Volume $old_volume not found. Nothing to migrate." >&2
    exit 1
  fi
fi

echo "Starting temporary Postgres 15 container to export data..."
docker run -d --name "$old_container" \
  -e POSTGRES_USER="$POSTGRES_USER" \
  -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  -e POSTGRES_DB="$POSTGRES_DB" \
  -v "$old_volume":/var/lib/postgresql/data \
  postgres:15-alpine >/dev/null

# Wait for readiness
old_ready="false"
for _ in {1..30}; do
  if docker exec -i "$old_container" pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; then
    old_ready="true"
    break
  fi
  # stop waiting if the container already exited
  if ! docker inspect -f '{{.State.Running}}' "$old_container" >/dev/null 2>&1 || \
     [[ "$(docker inspect -f '{{.State.Running}}' "$old_container" 2>/dev/null)" != "true" ]]; then
    break
  fi
  sleep 1
done

if [[ "$old_ready" != "true" ]]; then
  echo "Postgres 15 container did not start. Checking if volume is already Postgres 17..."
  docker rm -f "$old_container" >/dev/null 2>&1 || true

  docker run -d --name "$new_container" \
    -e POSTGRES_USER="$POSTGRES_USER" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
    -e POSTGRES_DB="$POSTGRES_DB" \
    -v "$old_volume":/var/lib/postgresql/data \
    postgres:17-alpine >/dev/null

  for _ in {1..30}; do
    if docker exec -i "$new_container" pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; then
      echo "Volume already compatible with Postgres 17. Skipping migration."
      docker rm -f "$new_container" >/dev/null 2>&1 || true
      exit 0
    fi
    if ! docker inspect -f '{{.State.Running}}' "$new_container" >/dev/null 2>&1 || \
       [[ "$(docker inspect -f '{{.State.Running}}' "$new_container" 2>/dev/null)" != "true" ]]; then
      break
    fi
    sleep 1
  done

  echo "Unable to start either Postgres 15 or Postgres 17 with the current volume." >&2
  exit 1
fi

echo "Dumping data to $dump_file ..."
docker exec -i "$old_container" pg_dump \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  --no-owner \
  --no-privileges \
  > "$dump_file"

echo "Removing old Postgres 15 data volume..."
docker rm -f "$old_container" >/dev/null

docker volume rm "$old_volume" >/dev/null

echo "Creating fresh volume for Postgres 17..."
docker volume create "$old_volume" >/dev/null

echo "Starting temporary Postgres 17 container to restore data..."
docker run -d --name "$new_container" \
  -e POSTGRES_USER="$POSTGRES_USER" \
  -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  -e POSTGRES_DB="$POSTGRES_DB" \
  -v "$old_volume":/var/lib/postgresql/data \
  postgres:17-alpine >/dev/null

# Wait for readiness
for _ in {1..30}; do
  if docker exec -i "$new_container" pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "Restoring dump into Postgres 17..."
docker exec -i "$new_container" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 < "$dump_file"

docker rm -f "$new_container" >/dev/null

echo "Migration complete. You can now start services with:"
echo "  docker compose up -d"

if [[ "$INIT_EXAMPLES" == "true" ]]; then
  init_sql="$PROJECT_DIR/init-db/01-init.sql"
  if [[ -f "$init_sql" ]]; then
    echo "Starting services and initializing example data..."
    docker compose up -d >/dev/null 2>&1 || true

    for _ in {1..30}; do
      if docker compose exec -T postgres pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    docker compose exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/01-init.sql
    echo "Example data initialized."
  else
    echo "No init-db/01-init.sql found for $PROJECT_DIR. Skipping example initialization."
  fi
fi
