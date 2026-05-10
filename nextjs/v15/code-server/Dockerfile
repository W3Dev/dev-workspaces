# syntax=docker/dockerfile:1
# Next.js v15 with Code-Server Development Environment
# VS Code in browser with Next.js v15

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v15 with code-server development environment"
LABEL org.opencontainers.image.version="v15"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    ca-certificates \
    gnupg \
    lsb-release \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Node.js specific
ENV NODE_VERSION=20

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm@latest next@15 create-next-app@latest turbo vercel

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && \
    chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

# Configure code-server
RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

# Install VS Code extensions
RUN code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension dsznajder.es7-react-js-snippets

# Expose ports
EXPOSE 8080

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]
