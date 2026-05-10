# syntax=docker/dockerfile:1
# Android Studio Latest Gitpod Development Environment
# Full Android Studio in Gitpod with VNC

FROM gitpod/workspace-full-vnc:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Android Studio latest Gitpod development environment"
LABEL org.opencontainers.image.version="studio-latest"

# Set environment variables
ENV ANDROID_HOME=/home/gitpod/android-sdk
ENV ANDROID_SDK_ROOT=/home/gitpod/android-sdk
ENV ANDROID_STUDIO_HOME=/home/gitpod/android-studio
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${ANDROID_STUDIO_HOME}/bin:${PATH}"

USER root

# Install dependencies for Android Studio
RUN apt-get update && \
    apt-get install -y \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32z1 \
    libbz2-1.0:i386 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxext6 \
    libx11-6 \
    libxcb1 \
    libxau6 \
    libxdmcp6 \
    && rm -rf /var/lib/apt/lists/*

USER gitpod

# Install Android command line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Download and install Android Studio
RUN cd ~ && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.2.1.11/android-studio-2024.2.1.11-linux.tar.gz && \
    tar -xzf android-studio-2024.2.1.11-linux.tar.gz && \
    rm android-studio-2024.2.1.11-linux.tar.gz

# Accept licenses and install SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-34" \
    "platforms;android-33" \
    "build-tools;34.0.0" \
    "build-tools;33.0.2" \
    "system-images;android-34;google_apis;x86_64" \
    "emulator" \
    "extras;google;google_play_services" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Create Android Studio desktop entry
RUN mkdir -p ~/.local/share/applications && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Android Studio\nExec=${ANDROID_STUDIO_HOME}/bin/studio.sh\nIcon=${ANDROID_STUDIO_HOME}/bin/studio.png\nCategories=Development;IDE;\nTerminal=false\nStartupWMClass=jetbrains-studio" > ~/.local/share/applications/android-studio.desktop

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose ports
EXPOSE 5037 5554 5555 8554