# syntax=docker/dockerfile:1
# Flutter v3.29 Core Development Environment
# Minimal setup for Flutter development

FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter v3.29 core development environment"
LABEL org.opencontainers.image.version="v3.29"

# Set environment variables
ENV FLUTTER_VERSION=3.29.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \
    tar xf flutter.tar.xz -C /opt && \
    rm flutter.tar.xz

# Pre-download Flutter dependencies and disable analytics
RUN flutter config --no-analytics && \
    flutter doctor && \
    flutter precache

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Accept Android licenses (if Android SDK is installed later)
RUN yes | flutter doctor --android-licenses || true

# Expose common Flutter ports
EXPOSE 9100 9101

# Default command
CMD ["/bin/bash"]