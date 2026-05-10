# syntax=docker/dockerfile:1
# Go v1.21 with Code-Server Development Environment
FROM golang:v1.21_NUM

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go v1.21 with code-server development environment"
LABEL org.opencontainers.image.version="v1.21"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git sudo && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /workspace && chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

RUN code-server --install-extension golang.go

EXPOSE 8080 8000
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]
