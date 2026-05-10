# syntax=docker/dockerfile:1
# Expo SDK v52 Core Development Environment
FROM node:20-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Expo SDK v52 core development environment"
LABEL org.opencontainers.image.version="v52"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl && \
    rm -rf /var/lib/apt/lists/*

# Install Expo CLI and EAS CLI
RUN npm install -g expo@~52.0.0 eas-cli @expo/ngrok

WORKDIR /workspace
EXPOSE 19000 19001 19002
CMD ["/bin/bash"]
