# Multi-stage Dockerfile built from dbt-core source
# Source: https://github.com/dbt-labs/dbt-core/blob/main/docker/Dockerfile
#
# Build args:
#   py_version: Python version to use (default: 3.11.2)
#   commit_ref: Git ref/branch to build from (default: main)

ARG py_version=3.11.2

# ============================================================================
# Base Stage: Common dependencies and Python setup
# ============================================================================
FROM python:${py_version}-slim-bullseye AS base

# Install all dependencies (build + runtime) for simplicity
# This is more similar to the original dbt-core Dockerfile approach
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    libpq-dev \
    make \
    openssh-client \
    software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Python environment variables
ENV PYTHONIOENCODING=utf-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

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
# dbt-postgres Stage: Build dbt-core + dbt-postgres adapter
# ============================================================================
FROM base AS dbt-postgres

ARG commit_ref=main

LABEL maintainer="dbt Labs" \
      description="dbt-postgres: PostgreSQL adapter for dbt"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD dbt --version || exit 1

WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

# Install both dbt-core and dbt-postgres adapter
RUN python -m pip install --no-cache-dir \
    "dbt-core @ git+https://github.com/dbt-labs/dbt-core@${commit_ref}#subdirectory=core" \
    "dbt-postgres @ git+https://github.com/dbt-labs/dbt-postgres@main"

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