# syntax=docker/dockerfile:1
# Deno v2.3 Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Deno v2.3 Gitpod development environment"
LABEL org.opencontainers.image.version="v2.3"

# Set environment variables
ENV DENO_VERSION=2.3.3
ENV DENO_INSTALL=/home/gitpod/.deno
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

USER gitpod

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v${DENO_VERSION}

# Pre-cache common Deno dependencies
RUN deno install -f --allow-read --allow-write --allow-env --allow-net --allow-run \
    https://deno.land/x/denon/denon.ts && \
    deno cache https://deno.land/std@0.224.0/http/server.ts

# Pre-configure Git
RUN git config --global pull.rebase false && \
    git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Install useful VS Code extensions for Deno development
RUN bash -c "code --install-extension denoland.vscode-deno && \
    code --install-extension dbaeumer.vscode-eslint && \
    code --install-extension esbenp.prettier-vscode"

# Configure VS Code for Deno
RUN mkdir -p /home/gitpod/.config/Code/User && \
    echo '{"deno.enable": true, "deno.lint": true, "deno.unstable": true}' > /home/gitpod/.config/Code/User/settings.json

# Expose common ports
EXPOSE 8000 8080 3000 4000