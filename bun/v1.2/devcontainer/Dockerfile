# syntax=docker/dockerfile:1
# Bun v1.2 Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Bun v1.2 devcontainer development environment"
LABEL org.opencontainers.image.version="v1.2"

# Set environment variables
ENV BUN_VERSION=1.2.18
ENV BUN_INSTALL=/usr/local
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    python3 \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# Install global packages
RUN bun install -g typescript @types/bun prettier eslint nodemon

# Configure Git
RUN git config --global init.defaultBranch main

# Create workspace directory with proper permissions
RUN mkdir -p /workspaces && \
    chown -R vscode:vscode /workspaces

# Switch to non-root user
USER vscode

# Set working directory
WORKDIR /workspaces

# Expose common ports
EXPOSE 3000 4000 5173 8080

# Keep container running
CMD ["sleep", "infinity"]