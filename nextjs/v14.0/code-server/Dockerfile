# syntax=docker/dockerfile:1
# Next.js v14.0 with Code-Server Development Environment
# Includes VS Code in the browser via code-server

FROM node:20

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v14.0 with code-server development environment"
LABEL org.opencontainers.image.version="v14.0"

# Set environment variables
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1
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
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install global Node packages
RUN npm install -g pnpm@latest next@14.0 create-next-app@latest turbo vercel

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

# Install VS Code extensions for Next.js
RUN code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension bradlc.vscode-tailwindcss && \
    code-server --install-extension formulahendry.auto-rename-tag && \
    code-server --install-extension dsznajder.es7-react-js-snippets

# Expose ports
EXPOSE 8080 3000 3001

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]