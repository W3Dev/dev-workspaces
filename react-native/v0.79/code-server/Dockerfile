# syntax=docker/dockerfile:1
# React Native v0.79 with Code-Server Development Environment
# VS Code in browser with React Native development tools

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="React Native v0.79 with code-server development environment"
LABEL org.opencontainers.image.version="v0.79"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=20
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    ca-certificates \
    gnupg \
    lsb-release \
    wget \
    unzip \
    openjdk-17-jdk \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

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

# Install React Native and related tools
RUN npm install -g react-native-cli expo-cli metro

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && \
    chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

# Configure code-server
RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0.7980\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

# Install VS Code extensions for React Native
RUN code-server --install-extension msjsdiag.vscode-react-native && \
    code-server --install-extension dsznajder.es7-react-js-snippets && \
    code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension esbenp.prettier-vscode

# Expose ports
EXPOSE 8080.7981 19000 19001

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0.7980", "/workspace"]