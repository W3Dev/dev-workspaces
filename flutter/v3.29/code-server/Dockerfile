# syntax=docker/dockerfile:1
# Flutter v3.29 with Code-Server Development Environment
FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter v3.29 with code-server development environment"
LABEL org.opencontainers.image.version="v3.29"

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.29.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git sudo ca-certificates unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \
    tar xf flutter.tar.xz -C /opt && \
    rm flutter.tar.xz

RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /workspace && chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

RUN flutter config --no-analytics && flutter doctor

RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

RUN code-server --install-extension dart-code.flutter

EXPOSE 8080 9100
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]
