# syntax=docker/dockerfile:1
# Flutter v3.32 Devcontainer Development Environment
FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter v3.32 devcontainer development environment"
LABEL org.opencontainers.image.version="v3.32"

ENV FLUTTER_VERSION=3.32.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \
    tar xf flutter.tar.xz -C /opt && \
    rm flutter.tar.xz

RUN flutter config --no-analytics && flutter doctor && flutter precache

RUN git config --global init.defaultBranch main

RUN mkdir -p /workspaces && chown -R vscode:vscode /workspaces

USER vscode
WORKDIR /workspaces

EXPOSE 9100 9101
CMD ["sleep", "infinity"]
