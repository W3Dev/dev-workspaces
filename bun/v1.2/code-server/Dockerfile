# syntax=docker/dockerfile:1
# Bun v1.2 with Code-Server Development Environment
# VS Code in browser with Bun runtime

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Bun v1.2 with code-server development environment"
LABEL org.opencontainers.image.version="v1.2"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV BUN_VERSION=1.2.18
ENV BUN_INSTALL=/usr/local
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    ca-certificates \
    unzip \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && \
    chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

# Install global packages with Bun
RUN bun install -g typescript @types/bun prettier eslint

# Configure code-server
RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

# Install VS Code extensions
RUN code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension ms-vscode.vscode-typescript-next && \
    code-server --install-extension usernamehw.errorlens

# Expose ports
EXPOSE 8080 3000 4000 5173

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]