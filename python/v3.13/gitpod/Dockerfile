# syntax=docker/dockerfile:1
# Python v3.13 Gitpod Development Environment
FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Python v3.13 Gitpod development environment"
LABEL org.opencontainers.image.version="v3.13"

USER gitpod

RUN pyenv install 3.13 && \
    pyenv global 3.13 && \
    pip install --upgrade pip setuptools wheel && \
    pip install pipenv poetry virtualenv black flake8 mypy pytest

WORKDIR /workspace
