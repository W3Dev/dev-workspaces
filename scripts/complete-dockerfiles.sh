#!/bin/bash
# Script to complete missing Dockerfile variants

set -euo pipefail

# Function to create missing code-server variant
create_code_server() {
    local stack=$1
    local version=$2
    local dir="${stack}/${version}/code-server"
    
    if [[ ! -f "${dir}/Dockerfile" ]]; then
        mkdir -p "${dir}"
        case $stack in
            "flutter")
                cat > "${dir}/Dockerfile" << 'EOF'
# syntax=docker/dockerfile:1
# Flutter CODE_SERVER_VERSION with Code-Server Development Environment
FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter CODE_SERVER_VERSION with code-server development environment"
LABEL org.opencontainers.image.version="CODE_SERVER_VERSION"

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=FLUTTER_VERSION_NUM
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
EOF
                # Replace placeholders
                sed -i '' "s/CODE_SERVER_VERSION/${version}/g" "${dir}/Dockerfile"
                sed -i '' "s/FLUTTER_VERSION_NUM/${version#v}.0/g" "${dir}/Dockerfile"
                ;;
            "golang")
                cat > "${dir}/Dockerfile" << 'EOF'
# syntax=docker/dockerfile:1
# Go CODE_SERVER_VERSION with Code-Server Development Environment
FROM golang:CODE_SERVER_VERSION_NUM

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go CODE_SERVER_VERSION with code-server development environment"
LABEL org.opencontainers.image.version="CODE_SERVER_VERSION"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git sudo && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /workspace && chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false' > ~/.config/code-server/config.yaml

RUN code-server --install-extension golang.go

EXPOSE 8080 8000
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]
EOF
                # Replace placeholders
                sed -i '' "s/CODE_SERVER_VERSION/${version}/g" "${dir}/Dockerfile"
                sed -i '' "s/CODE_SERVER_VERSION_NUM/${version#v}/g" "${dir}/Dockerfile"
                ;;
        esac
        echo "Created ${dir}/Dockerfile"
    fi
}

# Function to create missing devcontainer variant
create_devcontainer() {
    local stack=$1
    local version=$2
    local dir="${stack}/${version}/devcontainer"
    
    if [[ ! -f "${dir}/Dockerfile" ]]; then
        mkdir -p "${dir}"
        case $stack in
            "flutter")
                cat > "${dir}/Dockerfile" << 'EOF'
# syntax=docker/dockerfile:1
# Flutter DEVCONTAINER_VERSION Devcontainer Development Environment
FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Flutter DEVCONTAINER_VERSION devcontainer development environment"
LABEL org.opencontainers.image.version="DEVCONTAINER_VERSION"

ENV FLUTTER_VERSION=FLUTTER_VERSION_NUM
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
EOF
                # Replace placeholders
                sed -i '' "s/DEVCONTAINER_VERSION/${version}/g" "${dir}/Dockerfile"
                sed -i '' "s/FLUTTER_VERSION_NUM/${version#v}.0/g" "${dir}/Dockerfile"
                
                # Create devcontainer.json
                cat > "${dir}/devcontainer.json" << 'EOF'
{
  "name": "Flutter DEVCONTAINER_VERSION Development",
  "dockerFile": "Dockerfile",
  "forwardPorts": [9100, 9101],
  "postCreateCommand": "flutter pub get",
  "customizations": {
    "vscode": {
      "extensions": [
        "dart-code.dart-code",
        "dart-code.flutter"
      ]
    }
  },
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "remoteUser": "vscode"
}
EOF
                sed -i '' "s/DEVCONTAINER_VERSION/${version}/g" "${dir}/devcontainer.json"
                ;;
            "golang")
                cat > "${dir}/Dockerfile" << 'EOF'
# syntax=docker/dockerfile:1
# Go DEVCONTAINER_VERSION Devcontainer Development Environment
FROM mcr.microsoft.com/devcontainers/go:DEVCONTAINER_VERSION_NUM

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Go DEVCONTAINER_VERSION devcontainer development environment"
LABEL org.opencontainers.image.version="DEVCONTAINER_VERSION"

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

RUN git config --global init.defaultBranch main

USER vscode
WORKDIR /workspaces

EXPOSE 8080
CMD ["sleep", "infinity"]
EOF
                # Replace placeholders
                sed -i '' "s/DEVCONTAINER_VERSION/${version}/g" "${dir}/Dockerfile"
                sed -i '' "s/DEVCONTAINER_VERSION_NUM/${version#v}/g" "${dir}/Dockerfile"
                
                # Create devcontainer.json
                cat > "${dir}/devcontainer.json" << 'EOF'
{
  "name": "Go DEVCONTAINER_VERSION Development",
  "dockerFile": "Dockerfile",
  "forwardPorts": [8080],
  "postCreateCommand": "go mod download",
  "customizations": {
    "vscode": {
      "extensions": [
        "golang.go"
      ]
    }
  },
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "remoteUser": "vscode"
}
EOF
                sed -i '' "s/DEVCONTAINER_VERSION/${version}/g" "${dir}/devcontainer.json"
                ;;
        esac
        echo "Created ${dir}/Dockerfile and devcontainer.json"
    fi
}

# Complete Flutter variants
for version in v3.32 v3.29 v3.24; do
    create_code_server flutter $version
    create_devcontainer flutter $version
done

# Complete Go variants
for version in v1.23 v1.22 v1.21; do
    create_code_server golang $version
    create_devcontainer golang $version
done

# Complete Python variants
for version in v3.13 v3.12 v3.11; do
    create_code_server python $version
    create_devcontainer python $version
done

# Complete Android variants
for version in studio-latest sdk-v34 sdk-v33; do
    create_code_server android $version
    create_devcontainer android $version
done

# Complete Expo variants
for version in v53 v52 v51 v50; do
    create_code_server expo $version
    create_devcontainer expo $version
    # Also create gitpod variant for Expo
    mkdir -p "expo/${version}/gitpod"
    if [[ ! -f "expo/${version}/gitpod/Dockerfile" ]]; then
        cat > "expo/${version}/gitpod/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# Expo SDK ${version} Gitpod Development Environment
FROM gitpod/workspace-full:latest

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="Expo SDK ${version} Gitpod development environment"
LABEL org.opencontainers.image.version="${version}"

USER gitpod

RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    nvm install 20 && \
    nvm use 20 && \
    nvm alias default 20"

RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \
    npm install -g expo@~${version#v}.0.0 eas-cli @expo/ngrok"

WORKDIR /workspace
EXPOSE 19000 19001 19002
EOF
        echo "Created expo/${version}/gitpod/Dockerfile"
    fi
done

echo "All missing Dockerfile variants have been created!"