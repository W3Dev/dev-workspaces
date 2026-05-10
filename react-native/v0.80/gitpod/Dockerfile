# syntax=docker/dockerfile:1
# React Native v0.80 Gitpod Development Environment
# Optimized for Gitpod with Android development support

FROM gitpod/workspace-full-vnc:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="React Native v0.80 Gitpod development environment"
LABEL org.opencontainers.image.version="v0.80"

# Set environment variables
ENV ANDROID_HOME=/home/gitpod/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

USER root

# Install Java 17 for React Native 0.80
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

USER gitpod

# Install Node.js 20 via nvm
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    nvm install 20 && \
    nvm use 20 && \
    nvm alias default 20"

# Install Android SDK
RUN cd ~ && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "system-images;android-34;google_apis;x86_64" \
    "emulator"

# Install React Native and Expo tools
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    npm install -g react-native-cli expo-cli eas-cli metro"

# Install Watchman
USER root
RUN cd /tmp && \
    wget https://github.com/facebook/watchman/releases/download/v2024.01.15.00/watchman-v2024.01.15.00-linux.zip && \
    unzip watchman-v2024.01.15.00-linux.zip && \
    cd watchman-v2024.01.15.00-linux && \
    mkdir -p /usr/local/{bin,lib} && \
    cp bin/* /usr/local/bin/ && \
    cp lib/* /usr/local/lib/ && \
    chmod 755 /usr/local/bin/watchman && \
    rm -rf /tmp/watchman*

USER gitpod

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose ports
EXPOSE 8081 8082 19000 19001 5554 5555