# syntax=docker/dockerfile:1
# Next.js v15 Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v15 Gitpod development environment"
LABEL org.opencontainers.image.version="v15"

# Set environment variables
ENV NODE_ENV=development

USER gitpod

# Install Node.js 20 via nvm
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    nvm install 20 && \
    nvm use 20 && \
    nvm alias default 20"

# Install global packages
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    npm install -g pnpm@latest"
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    npm install -g next@15 create-next-app@latest turbo vercel"

# Pre-configure Git
RUN git config --global pull.rebase false && \
    git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose ports
EXPOSE 3000 3001
