# syntax=docker/dockerfile:1
# Next.js v15 Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM mcr.microsoft.com/devcontainers/javascript-node:20

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v15 devcontainer development environment"
LABEL org.opencontainers.image.version="v15"

# Install global Node packages
RUN su node -c "npm install -g pnpm@latest next@15 create-next-app@latest turbo vercel serve"

# Configure Git
RUN git config --global init.defaultBranch main

# Create workspace directory with proper permissions
RUN mkdir -p /workspaces && \
    chown -R node:node /workspaces

# Switch to non-root user
USER node

# Set working directory
WORKDIR /workspaces

# Expose common ports
EXPOSE 3000 3001 4000 5000

# Keep container running
CMD ["sleep", "infinity"]
