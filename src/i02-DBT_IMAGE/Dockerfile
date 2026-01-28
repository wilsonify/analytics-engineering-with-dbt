# Multi-stage Dockerfile built from dbt-core source
# Source: https://github.com/dbt-labs/dbt-core/blob/main/docker/Dockerfile

ARG py_version=3.11.2

# ============================================================================
# Base Stage: Common dependencies and Python setup
# ============================================================================
FROM python:${py_version}-slim-bullseye AS base

# Update system packages and install build dependencies
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    build-essential=12.9 \
    ca-certificates=20210119 \
    libpq-dev=13.23-0+deb11u1 \
    make=4.3-4.1 \
    openssh-client=1:8.4p1-5+deb11u3 \
    software-properties-common=0.96.20.2-2.1 \
    wget \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libssl-dev \
    zlib1g-dev \
  # Build and install git from source (newer than Debian bullseye provides)
  && wget https://github.com/git/git/archive/refs/tags/v2.50.1.tar.gz \
  && tar -xf v2.50.1.tar.gz \
  && cd git-2.50.1 \
  && make prefix=/usr/local NO_TCLTK=1 NO_GETTEXT=1 all \
  && make prefix=/usr/local NO_TCLTK=1 NO_GETTEXT=1 install \
  && cd .. \
  && rm -rf git-2.50.1 v2.50.1.tar.gz \
  # Remove build dependencies to keep image slim
  && apt-get remove -y \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libssl-dev \
    wget \
    zlib1g-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Set Python environment variables
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Upgrade pip, setuptools, and wheel
RUN python -m pip install --upgrade "pip==24.0" "setuptools==69.2.0" "wheel==0.43.0" --no-cache-dir

# ============================================================================
# dbt-postgres Stage: Build dbt-postgres from source
# ============================================================================
FROM base AS dbt-postgres

ARG commit_ref=main

# Health check
HEALTHCHECK CMD dbt --version || exit 1

# Set working directory and entrypoint
WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

# Install dbt-postgres from git repository
RUN python -m pip install --no-cache-dir "dbt-postgres @ git+https://github.com/dbt-labs/dbt-core@${commit_ref}#subdirectory=plugins/postgres"