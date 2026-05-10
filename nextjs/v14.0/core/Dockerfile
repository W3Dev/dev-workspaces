# syntax=docker/dockerfile:1
# Next.js v14.0 Core Development Environment
# Minimal setup for Next.js development

FROM node:20-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Next.js v14.0 core development environment"
LABEL org.opencontainers.image.version="v14.0"

# Set environment variables
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm globally
RUN npm install -g pnpm@latest

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Install Next.js v14.0 globally
RUN npm install -g next@14.0 create-next-app@latest

# Expose common Next.js ports
EXPOSE 3000 3001

# Default command
CMD ["/bin/bash"]