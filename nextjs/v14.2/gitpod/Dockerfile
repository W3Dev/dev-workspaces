# syntax=docker/dockerfile:1
# Next.js v14.2 Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v14.2 Gitpod development environment"
LABEL org.opencontainers.image.version="v14.2"

# Set environment variables
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1

USER gitpod

# Install Node.js 20 via nvm
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    nvm install 20 && \
    nvm use 20 && \
    nvm alias default 20"

# Install global packages
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    npm install -g pnpm@latest next@14.2 create-next-app@latest turbo vercel"

# Install useful VS Code extensions for Next.js development
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/gitpod-io/workspace-images/main/chunks/tool-node/extensions.json | jq -r '.recommendations[]' | while read ext; do echo \"code --install-extension $ext\"; done)"

# Pre-configure Git
RUN git config --global pull.rebase false && \
    git config --global init.defaultBranch main

# Create common directories
RUN mkdir -p /workspace/node_modules /workspace/.next

# Expose Next.js ports
EXPOSE 3000 3001

# Set working directory
WORKDIR /workspace