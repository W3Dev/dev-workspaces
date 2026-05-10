# syntax=docker/dockerfile:1
# Deno v2.3 with Code-Server Development Environment
# VS Code in browser with Deno runtime

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Deno v2.3 with code-server development environment"
LABEL org.opencontainers.image.version="v2.3"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DENO_VERSION=2.3.3
ENV DENO_INSTALL=/usr/local
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    ca-certificates \
    unzip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v${DENO_VERSION}

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && \
    chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

# Install Deno tools
RUN deno install -f --allow-read --allow-write --allow-env --allow-net --allow-run \
    https://deno.land/x/denon/denon.ts

# Configure code-server
RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

# Install VS Code extensions
RUN code-server --install-extension denoland.vscode-deno && \
    code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension usernamehw.errorlens

# Configure VS Code for Deno
RUN mkdir -p ~/.local/share/code-server/User && \
    echo '{"deno.enable": true, "deno.lint": true, "deno.unstable": true}' > ~/.local/share/code-server/User/settings.json

# Expose ports
EXPOSE 8080 8000 3000 4000

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]