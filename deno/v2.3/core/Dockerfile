# syntax=docker/dockerfile:1
# Deno v2.3 Core Development Environment
# Minimal setup for Deno runtime

FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Deno v2.3 core development environment"
LABEL org.opencontainers.image.version="v2.3"

# Set environment variables
ENV DENO_VERSION=2.3.3
ENV DENO_INSTALL=/usr/local
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v${DENO_VERSION}

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Verify installation
RUN deno --version

# Expose common ports
EXPOSE 8000 8080 3000 4000

# Default command
CMD ["/bin/bash"]