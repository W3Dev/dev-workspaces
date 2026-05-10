# syntax=docker/dockerfile:1
# Bun v1.2 Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Bun v1.2 Gitpod development environment"
LABEL org.opencontainers.image.version="v1.2"

# Set environment variables
ENV BUN_VERSION=1.2.18
ENV BUN_INSTALL=/home/gitpod/.bun
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

USER gitpod

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# Install common global packages with Bun
RUN bun install -g typescript @types/bun prettier eslint

# Pre-configure Git
RUN git config --global pull.rebase false && \
    git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Install useful VS Code extensions for Bun/TypeScript development
RUN bash -c "code --install-extension dbaeumer.vscode-eslint && \
    code --install-extension esbenp.prettier-vscode && \
    code --install-extension ms-vscode.vscode-typescript-next && \
    code --install-extension oven.bun-vscode"

# Expose common ports
EXPOSE 3000 4000 5173 8080