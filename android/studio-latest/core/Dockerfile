# syntax=docker/dockerfile:1
# Android Studio Latest Core Development Environment
# Minimal Android development setup

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Android Studio latest core development environment"
LABEL org.opencontainers.image.version="studio-latest"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    curl \
    libpulse0 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Install Android command line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Accept licenses and install basic SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "extras;google;google_play_services" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Expose ADB port
EXPOSE 5037

# Default command
CMD ["/bin/bash"]