# syntax=docker/dockerfile:1
# Go v1.23 Core Development Environment
FROM golang:1.23-alpine

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go v1.23 core development environment"
LABEL org.opencontainers.image.version="v1.23"

RUN apk add --no-cache git make build-base

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /workspace
EXPOSE 8080
CMD ["/bin/sh"]
