# syntax=docker/dockerfile:1
# Next.js v14.2 Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM mcr.microsoft.com/devcontainers/javascript-node:20

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v14.2 devcontainer development environment"
LABEL org.opencontainers.image.version="v14.2"

# Set environment variables
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install global Node packages
RUN su node -c "npm install -g pnpm@latest next@14.2 create-next-app@latest turbo vercel serve"

# Configure Git
RUN git config --global init.defaultBranch main

# Create workspace directory with proper permissions
RUN mkdir -p /workspaces && \
    chown -R node:node /workspaces

# Switch to non-root user
USER node

# Set working directory
WORKDIR /workspaces

# Expose Next.js development ports
EXPOSE 3000 3001 4000 5000

# Keep container running
CMD ["sleep", "infinity"]