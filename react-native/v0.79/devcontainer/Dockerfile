# syntax=docker/dockerfile:1
# React Native v0.79 Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM mcr.microsoft.com/devcontainers/javascript-node:20

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="React Native v0.79 devcontainer development environment"
LABEL org.opencontainers.image.version="v0.79"

# Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"
ENV DEBIAN_FRONTEND=noninteractive

# Install Java and other dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    openjdk-17-jdk \
    python3 \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Accept licenses and install Android components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Install global Node packages
RUN su node -c "npm install -g react-native-cli expo-cli eas-cli metro"

# Install Watchman
RUN cd /tmp && \
    wget https://github.com/facebook/watchman/releases/download/v2024.01.15.00/watchman-v2024.01.15.00-linux.zip && \
    unzip watchman-v2024.01.15.00-linux.zip && \
    cd watchman-v2024.01.15.00-linux && \
    mkdir -p /usr/local/{bin,lib} && \
    cp bin/* /usr/local/bin/ && \
    cp lib/* /usr/local/lib/ && \
    chmod 755 /usr/local/bin/watchman && \
    rm -rf /tmp/watchman*

# Configure Git
RUN git config --global init.defaultBranch main

# Create workspace directory with proper permissions
RUN mkdir -p /workspaces && \
    chown -R node:node /workspaces

# Switch to non-root user
USER node

# Set working directory
WORKDIR /workspaces

# Expose React Native ports
EXPOSE 8081 8082 19000 19001

# Keep container running
CMD ["sleep", "infinity"]