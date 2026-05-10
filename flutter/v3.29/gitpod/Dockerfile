# syntax=docker/dockerfile:1
# Flutter v3.29 Gitpod Development Environment
# Optimized for Gitpod cloud development with Android SDK

FROM gitpod/workspace-full-vnc:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter v3.29 Gitpod development environment"
LABEL org.opencontainers.image.version="v3.29"

# Set environment variables
ENV FLUTTER_VERSION=3.29.0
ENV FLUTTER_HOME=/home/gitpod/flutter
ENV ANDROID_HOME=/home/gitpod/android-sdk
ENV PATH="${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

USER gitpod

# Install Flutter
RUN cd ~ && \
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# Install Android SDK
RUN cd ~ && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "emulator" "system-images;android-34;google_apis;x86_64"

# Configure Flutter
RUN flutter config --no-analytics && \
    flutter config --android-sdk ${ANDROID_HOME} && \
    flutter doctor --android-licenses && \
    flutter doctor && \
    flutter precache

# Install Chrome for web development
USER root
RUN apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*
USER gitpod

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose Flutter ports
EXPOSE 9100 9101 5037