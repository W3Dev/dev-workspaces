# syntax=docker/dockerfile:1
# React Native v0.80 Core Development Environment
# Minimal setup for React Native development

FROM node:20-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="React Native v0.80 core development environment"
LABEL org.opencontainers.image.version="v0.80"

# Set environment variables
ENV NODE_ENV=development
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    python3 \
    make \
    g++ \
    openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Install React Native CLI and common tools
RUN npm install -g react-native-cli metro react-native-reanimated

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Expose Metro bundler and React Native packager ports
EXPOSE 8081 8082 19000 19001

# Default command
CMD ["/bin/bash"]