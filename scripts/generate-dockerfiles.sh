#!/bin/bash
# Script to generate Dockerfiles for all stack versions

set -euo pipefail

# Create scripts directory if it doesn't exist
mkdir -p scripts

# Function to create Python Dockerfiles
create_python_dockerfile() {
    local version=$1
    local variant=$2
    local dir="python/${version}/${variant}"
    
    case $variant in
        "core")
            cat > "${dir}/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# Python ${version} Core Development Environment
FROM python:${version#v}-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Python ${version} core development environment"
LABEL org.opencontainers.image.version="${version}"

RUN apt-get update && apt-get install -y --no-install-recommends \\
    git curl build-essential && \\
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pipenv poetry virtualenv

WORKDIR /workspace
EXPOSE 8000 5000
CMD ["/bin/bash"]
EOF
            ;;
        "gitpod")
            cat > "${dir}/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# Python ${version} Gitpod Development Environment
FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Python ${version} Gitpod development environment"
LABEL org.opencontainers.image.version="${version}"

USER gitpod

RUN pyenv install ${version#v} && \\
    pyenv global ${version#v} && \\
    pip install --upgrade pip setuptools wheel && \\
    pip install pipenv poetry virtualenv black flake8 mypy pytest

WORKDIR /workspace
EOF
            ;;
    esac
}

# Function to create Go Dockerfiles
create_go_dockerfile() {
    local version=$1
    local variant=$2
    local dir="golang/${version}/${variant}"
    
    case $variant in
        "core")
            cat > "${dir}/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# Go ${version} Core Development Environment
FROM golang:${version#v}-alpine

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go ${version} core development environment"
LABEL org.opencontainers.image.version="${version}"

RUN apk add --no-cache git make build-base

RUN go install golang.org/x/tools/gopls@latest && \\
    go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /workspace
EXPOSE 8080
CMD ["/bin/sh"]
EOF
            ;;
    esac
}

# Function to create Expo Dockerfiles
create_expo_dockerfile() {
    local version=$1
    local variant=$2
    local dir="expo/${version}/${variant}"
    
    case $variant in
        "core")
            cat > "${dir}/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# Expo SDK ${version} Core Development Environment
FROM node:20-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Expo SDK ${version} core development environment"
LABEL org.opencontainers.image.version="${version}"

RUN apt-get update && apt-get install -y --no-install-recommends \\
    git curl && \\
    rm -rf /var/lib/apt/lists/*

# Install Expo CLI and EAS CLI
RUN npm install -g expo@~${version#v}.0.0 eas-cli @expo/ngrok

WORKDIR /workspace
EXPOSE 19000 19001 19002
CMD ["/bin/bash"]
EOF
            ;;
    esac
}

# Generate Python Dockerfiles
for version in v3.13 v3.12 v3.11; do
    for variant in core gitpod; do
        create_python_dockerfile $version $variant
    done
done

# Generate Go Dockerfiles
for version in v1.23 v1.22 v1.21; do
    for variant in core; do
        create_go_dockerfile $version $variant
    done
done

# Generate Expo Dockerfiles
for version in v53 v52 v51 v50; do
    for variant in core; do
        create_expo_dockerfile $version $variant
    done
done

echo "Dockerfiles generated successfully!"