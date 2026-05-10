# syntax=docker/dockerfile:1
# Expo SDK v50 Gitpod Development Environment
FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Expo SDK v50 Gitpod development environment"
LABEL org.opencontainers.image.version="v50"

USER gitpod

RUN bash -c ". /home/gitpod/.nvm/nvm.sh &&     nvm install 20 &&     nvm use 20 &&     nvm alias default 20"

RUN bash -c ". /home/gitpod/.nvm/nvm.sh &&     npm install -g expo@~50.0.0 eas-cli @expo/ngrok"

WORKDIR /workspace
EXPOSE 19000 19001 19002
