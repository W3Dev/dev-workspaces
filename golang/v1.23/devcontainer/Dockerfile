# syntax=docker/dockerfile:1
# Go v1.23 Devcontainer Development Environment
FROM mcr.microsoft.com/devcontainers/go:v1.23_NUM

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go v1.23 devcontainer development environment"
LABEL org.opencontainers.image.version="v1.23"

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

RUN git config --global init.defaultBranch main

USER vscode
WORKDIR /workspaces

EXPOSE 8080
CMD ["sleep", "infinity"]
