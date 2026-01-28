# Multi-stage Dockerfile built from dbt-core source
# Source: https://github.com/dbt-labs/dbt-core/blob/main/docker/Dockerfile
#
# Build args:
#   py_version: Python version to use (default: 3.11.2)
#   commit_ref: Git ref/branch to build from (default: main)
#   git_version: Git version to compile (default: 2.50.1)

ARG py_version=3.11.2
ARG git_version=2.50.1

# ============================================================================
# Builder Stage: Compile git from source
# ============================================================================
FROM debian:bullseye-slim AS git-builder

ARG git_version

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libssl-dev \
    make \
    zlib1g-dev \
  && curl -fSL https://github.com/git/git/archive/refs/tags/v${git_version}.tar.gz -o git.tar.gz \
  && tar -xzf git.tar.gz \
  && cd git-${git_version} \
  && make prefix=/usr/local NO_TCLTK=1 NO_GETTEXT=1 NO_PERL=1 all \
  && make prefix=/usr/local NO_TCLTK=1 NO_GETTEXT=1 NO_PERL=1 install \
  && cd .. \
  && rm -rf git-${git_version} git.tar.gz \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ============================================================================
# Base Stage: Common dependencies and Python setup
# ============================================================================
FROM python:${py_version}-slim-bullseye AS base

# Copy pre-compiled git from builder stage
COPY --from=git-builder /usr/local/bin/git* /usr/local/bin/
COPY --from=git-builder /usr/local/libexec/git-core /usr/local/libexec/git-core

# Install runtime dependencies only (no build tools)
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libcurl4 \
    libexpat1 \
    libpq5 \
    openssh-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Python environment variables
ENV PYTHONIOENCODING=utf-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    GIT_PYTHON_GIT_EXECUTABLE=/usr/local/bin/git

# Upgrade pip, setuptools, and wheel
RUN python -m pip install --upgrade --no-cache-dir \
    "pip==24.0" \
    "setuptools==69.2.0" \
    "wheel==0.43.0"

# ============================================================================
# dbt-core Stage: Build dbt-core from source
# ============================================================================
FROM base AS dbt-core

ARG commit_ref=main

LABEL maintainer="dbt Labs" \
      description="dbt-core: data build tool for analytics engineering"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD dbt --version || exit 1

WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

RUN python -m pip install --no-cache-dir \
    "dbt-core @ git+https://github.com/dbt-labs/dbt-core@${commit_ref}#subdirectory=core"

# ============================================================================
# dbt-postgres Stage: Build dbt-postgres from source
# ============================================================================
FROM base AS dbt-postgres

ARG commit_ref=main

LABEL maintainer="dbt Labs" \
      description="dbt-postgres: PostgreSQL adapter for dbt"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD dbt --version || exit 1

WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

RUN python -m pip install --no-cache-dir \
    "dbt-postgres @ git+https://github.com/dbt-labs/dbt-core@${commit_ref}#subdirectory=plugins/postgres"

# ============================================================================
# dbt-all Stage: Includes dbt-core with additional adapters (optional)
# ============================================================================
FROM base AS dbt-all

ARG commit_ref=main
ARG dbt_third_party=""

LABEL maintainer="dbt Labs" \
      description="dbt with core and optional third-party adapters"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD dbt --version || exit 1

WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

RUN python -m pip install --no-cache-dir \
    "dbt-core @ git+https://github.com/dbt-labs/dbt-core@${commit_ref}#subdirectory=core"

RUN if [ -n "${dbt_third_party}" ]; then \
        python -m pip install --no-cache-dir ${dbt_third_party}; \
    else \
        echo "No third-party adapters specified"; \
    fi