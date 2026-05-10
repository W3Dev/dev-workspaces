# syntax=docker/dockerfile:1
# Python v3.11 Core Development Environment
FROM python:3.11-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Python v3.11 core development environment"
LABEL org.opencontainers.image.version="v3.11"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pipenv poetry virtualenv

WORKDIR /workspace
EXPOSE 8000 5000
CMD ["/bin/bash"]
