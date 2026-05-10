# syntax=docker/dockerfile:1
# Deno v2.3 Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Deno v2.3 devcontainer development environment"
LABEL org.opencontainers.image.version="v2.3"

# Set environment variables
ENV DENO_VERSION=2.3.3
ENV DENO_INSTALL=/usr/local
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    python3 \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v${DENO_VERSION}

# Install global Deno tools
RUN deno install -f --allow-read --allow-write --allow-env --allow-net --allow-run \
    https://deno.land/x/denon/denon.ts

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
EXPOSE 8000 8080 3000 4000

# Keep container running
CMD ["sleep", "infinity"]