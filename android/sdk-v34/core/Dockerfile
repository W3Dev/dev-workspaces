# syntax=docker/dockerfile:1
# Android SDK v34 Core Development Environment
# Android SDK 34 without IDE

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Android SDK v34 core development environment"
LABEL org.opencontainers.image.version="sdk-v34"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_VERSION=34
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    curl \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    lib32ncurses6 \
    && rm -rf /var/lib/apt/lists/*

# Install Android command line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Accept licenses and install Android SDK 34
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-${ANDROID_VERSION}" \
    "build-tools;34.0.0" \
    "sources;android-${ANDROID_VERSION}" \
    "system-images;android-${ANDROID_VERSION};google_apis;x86_64" \
    "emulator"

# Install Gradle
ENV GRADLE_VERSION=8.5
RUN cd /opt && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -q gradle-${GRADLE_VERSION}-bin.zip && \
    rm gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin/gradle

# Create workspace directory
RUN mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

# Expose ADB port
EXPOSE 5037

# Default command
CMD ["/bin/bash"]