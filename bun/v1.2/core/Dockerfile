# syntax=docker/dockerfile:1
# Bun v1.2 Core Development Environment
# Minimal setup for Bun JavaScript runtime

FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Bun v1.2 core development environment"
LABEL org.opencontainers.image.version="v1.2"

# Set environment variables
ENV BUN_VERSION=1.2.18
ENV BUN_INSTALL=/usr/local
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Verify installation
RUN bun --version

# Expose common ports
EXPOSE 3000 4000 5173 8080

# Default command
CMD ["/bin/bash"]