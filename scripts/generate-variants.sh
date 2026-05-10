#!/bin/bash
# Script to generate Dockerfile variants (gitpod, code-server, devcontainer) from core Dockerfile

set -euo pipefail

# Configuration for each stack
# Note: Using regular variables instead of associative array for compatibility

# Base images for different variants
GITPOD_BASE="gitpod/workspace-full:latest"
GITPOD_VNC_BASE="gitpod/workspace-full-vnc:latest"
CODE_SERVER_BASE="ubuntu:22.04"
DEVCONTAINER_NODE_BASE="mcr.microsoft.com/devcontainers/javascript-node:20"
DEVCONTAINER_PYTHON_BASE="mcr.microsoft.com/devcontainers/python:3"
DEVCONTAINER_GO_BASE="mcr.microsoft.com/devcontainers/go:1"
DEVCONTAINER_BASE="mcr.microsoft.com/devcontainers/base:ubuntu"

# Function to extract information from core Dockerfile
extract_core_info() {
    local dockerfile=$1
    local stack=$2
    local version=$3
    
    # Extract key information
    STACK_NAME=$(grep -m1 "^# .* Development Environment" "$dockerfile" | sed 's/# \(.*\) Development Environment/\1/' | sed 's/ Core//' || echo "$stack")
    STACK_VERSION=$(grep -m1 "LABEL org.opencontainers.image.version=" "$dockerfile" | cut -d'"' -f2 || echo "$version")
    
    # Extract stack-specific environment variables and commands
    case $stack in
        flutter)
            FLUTTER_VERSION=$(grep "ENV FLUTTER_VERSION=" "$dockerfile" | cut -d'=' -f2 || echo "3.32.0")
            ;;
        nextjs|react-native|expo)
            NODE_VERSION=$(grep "FROM node:" "$dockerfile" | cut -d':' -f2 | cut -d'-' -f1 || echo "20")
            ;;
        python)
            PYTHON_VERSION=$(echo "$version" | sed 's/v//')
            ;;
        golang)
            GO_VERSION=$(echo "$version" | sed 's/v//')
            ;;
        bun)
            BUN_VERSION=$(grep "ENV BUN_VERSION=" "$dockerfile" | cut -d'=' -f2 || echo "1.2.18")
            ;;
        deno)
            DENO_VERSION=$(grep "ENV DENO_VERSION=" "$dockerfile" | cut -d'=' -f2 || echo "2.3.3")
            ;;
    esac
}

# Function to generate Gitpod variant
generate_gitpod() {
    local stack=$1
    local version=$2
    local core_dockerfile=$3
    local output_dir="${stack}/${version}/gitpod"
    
    mkdir -p "$output_dir"
    
    case $stack in
        flutter)
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development with Android SDK

FROM ${GITPOD_VNC_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

# Set environment variables
ENV FLUTTER_VERSION=${FLUTTER_VERSION}
ENV FLUTTER_HOME=/home/gitpod/flutter
ENV ANDROID_HOME=/home/gitpod/android-sdk
ENV PATH="\${FLUTTER_HOME}/bin:\${ANDROID_HOME}/cmdline-tools/latest/bin:\${ANDROID_HOME}/platform-tools:\${PATH}"

USER gitpod

# Install Flutter
RUN cd ~ && \\
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\${FLUTTER_VERSION}-stable.tar.xz && \\
    tar xf flutter_linux_\${FLUTTER_VERSION}-stable.tar.xz && \\
    rm flutter_linux_\${FLUTTER_VERSION}-stable.tar.xz

# Install Android SDK
RUN cd ~ && \\
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \\
    mkdir -p \${ANDROID_HOME}/cmdline-tools && \\
    unzip -q commandlinetools-linux-11076708_latest.zip -d \${ANDROID_HOME}/cmdline-tools && \\
    mv \${ANDROID_HOME}/cmdline-tools/cmdline-tools \${ANDROID_HOME}/cmdline-tools/latest && \\
    rm commandlinetools-linux-11076708_latest.zip

# Install Android SDK components
RUN yes | sdkmanager --licenses && \\
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "emulator" "system-images;android-34;google_apis;x86_64"

# Configure Flutter
RUN flutter config --no-analytics && \\
    flutter config --android-sdk \${ANDROID_HOME} && \\
    flutter doctor --android-licenses && \\
    flutter doctor && \\
    flutter precache

# Install Chrome for web development
USER root
RUN apt-get update && \\
    apt-get install -y google-chrome-stable && \\
    rm -rf /var/lib/apt/lists/*
USER gitpod

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose Flutter ports
EXPOSE 9100 9101 5037
EOF
            ;;
            
        nextjs|react-native|expo)
            local base_image=$GITPOD_BASE
            if [[ $stack == "react-native" ]]; then
                base_image=$GITPOD_VNC_BASE
            fi
            
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM ${base_image}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

# Set environment variables
ENV NODE_ENV=development

USER gitpod

# Install Node.js ${NODE_VERSION} via nvm
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \\
    nvm install ${NODE_VERSION} && \\
    nvm use ${NODE_VERSION} && \\
    nvm alias default ${NODE_VERSION}"

# Install global packages
RUN bash -c ". /home/gitpod/.nvm/nvm.sh && \\
    npm install -g pnpm@latest"
EOF
            
            # Add stack-specific packages
            case $stack in
                nextjs)
                    echo "RUN bash -c \". /home/gitpod/.nvm/nvm.sh && \\
    npm install -g next@${version#v} create-next-app@latest turbo vercel\"" >> "$output_dir/Dockerfile"
                    ;;
                react-native)
                    echo "ENV ANDROID_HOME=/home/gitpod/android-sdk" >> "$output_dir/Dockerfile"
                    echo "ENV PATH=\"\${ANDROID_HOME}/cmdline-tools/latest/bin:\${ANDROID_HOME}/platform-tools:\${PATH}\"" >> "$output_dir/Dockerfile"
                    echo "" >> "$output_dir/Dockerfile"
                    echo "# Install React Native tools" >> "$output_dir/Dockerfile"
                    echo "RUN bash -c \". /home/gitpod/.nvm/nvm.sh && \\
    npm install -g react-native-cli expo-cli eas-cli metro\"" >> "$output_dir/Dockerfile"
                    ;;
                expo)
                    echo "RUN bash -c \". /home/gitpod/.nvm/nvm.sh && \\
    npm install -g expo@~${version#v}.0.0 eas-cli @expo/ngrok\"" >> "$output_dir/Dockerfile"
                    ;;
            esac
            
            echo "" >> "$output_dir/Dockerfile"
            echo "# Pre-configure Git" >> "$output_dir/Dockerfile"
            echo "RUN git config --global pull.rebase false && \\" >> "$output_dir/Dockerfile"
            echo "    git config --global init.defaultBranch main" >> "$output_dir/Dockerfile"
            echo "" >> "$output_dir/Dockerfile"
            echo "# Create workspace directory" >> "$output_dir/Dockerfile"
            echo "RUN mkdir -p /workspace" >> "$output_dir/Dockerfile"
            echo "" >> "$output_dir/Dockerfile"
            echo "WORKDIR /workspace" >> "$output_dir/Dockerfile"
            echo "" >> "$output_dir/Dockerfile"
            echo "# Expose ports" >> "$output_dir/Dockerfile"
            
            case $stack in
                nextjs)
                    echo "EXPOSE 3000 3001" >> "$output_dir/Dockerfile"
                    ;;
                react-native)
                    echo "EXPOSE 8081 8082 19000 19001" >> "$output_dir/Dockerfile"
                    ;;
                expo)
                    echo "EXPOSE 19000 19001 19002" >> "$output_dir/Dockerfile"
                    ;;
            esac
            ;;
            
        python)
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM ${GITPOD_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

USER gitpod

RUN pyenv install ${PYTHON_VERSION} && \\
    pyenv global ${PYTHON_VERSION} && \\
    pip install --upgrade pip setuptools wheel && \\
    pip install pipenv poetry virtualenv black flake8 mypy pytest

WORKDIR /workspace
EOF
            ;;
            
        golang)
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM ${GITPOD_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

USER gitpod

# Install Go ${GO_VERSION}
RUN bash -c "go install golang.org/dl/go${GO_VERSION}@latest && \\
    ~/go/bin/go${GO_VERSION} download && \\
    echo 'export PATH=~/sdk/go${GO_VERSION}/bin:\$PATH' >> ~/.bashrc"

# Install Go tools
RUN bash -c "source ~/.bashrc && \\
    go install golang.org/x/tools/gopls@latest && \\
    go install github.com/go-delve/delve/cmd/dlv@latest"

WORKDIR /workspace
EXPOSE 8080
EOF
            ;;
            
        bun)
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM ${GITPOD_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

# Set environment variables
ENV BUN_VERSION=${BUN_VERSION}
ENV BUN_INSTALL=/home/gitpod/.bun
ENV PATH="\${BUN_INSTALL}/bin:\${PATH}"

USER gitpod

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v\${BUN_VERSION}"

# Install common global packages with Bun
RUN bun install -g typescript @types/bun prettier eslint

# Pre-configure Git
RUN git config --global pull.rebase false && \\
    git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose common ports
EXPOSE 3000 4000 5173 8080
EOF
            ;;
            
        deno)
            cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Gitpod Development Environment
# Optimized for Gitpod cloud development

FROM ${GITPOD_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} Gitpod development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

# Set environment variables
ENV DENO_VERSION=${DENO_VERSION}
ENV DENO_INSTALL=/home/gitpod/.deno
ENV PATH="\${DENO_INSTALL}/bin:\${PATH}"

USER gitpod

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v\${DENO_VERSION}

# Pre-cache common Deno dependencies
RUN deno install -f --allow-read --allow-write --allow-env --allow-net --allow-run \\
    https://deno.land/x/denon/denon.ts && \\
    deno cache https://deno.land/std@0.224.0/http/server.ts

# Pre-configure Git
RUN git config --global pull.rebase false && \\
    git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace

# Expose common ports
EXPOSE 8000 8080 3000 4000
EOF
            ;;
    esac
    
    echo "Generated $output_dir/Dockerfile"
}

# Function to generate code-server variant
generate_code_server() {
    local stack=$1
    local version=$2
    local core_dockerfile=$3
    local output_dir="${stack}/${version}/code-server"
    
    mkdir -p "$output_dir"
    
    # Common code-server setup
    cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} with Code-Server Development Environment
# VS Code in browser with ${STACK_NAME}

FROM ${CODE_SERVER_BASE}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} with code-server development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \\
    apt-get install -y --no-install-recommends \\
    curl \\
    git \\
    sudo \\
    ca-certificates \\
    gnupg \\
    lsb-release \\
    wget \\
    build-essential \\
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

EOF

    # Add stack-specific installations
    case $stack in
        flutter)
            cat >> "$output_dir/Dockerfile" << EOF
# Flutter specific
ENV FLUTTER_VERSION=${FLUTTER_VERSION}
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="\${FLUTTER_HOME}/bin:\${PATH}"

RUN apt-get update && \\
    apt-get install -y --no-install-recommends \\
    unzip xz-utils zip libglu1-mesa \\
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \\
    tar xf flutter.tar.xz -C /opt && \\
    rm flutter.tar.xz

RUN flutter config --no-analytics && flutter doctor
EOF
            ;;
            
        nextjs|react-native|expo)
            cat >> "$output_dir/Dockerfile" << EOF
# Node.js specific
ENV NODE_VERSION=${NODE_VERSION}

RUN curl -fsSL https://deb.nodesource.com/setup_\${NODE_VERSION}.x | bash - && \\
    apt-get install -y nodejs && \\
    rm -rf /var/lib/apt/lists/*
EOF
            # Add stack-specific packages
            case $stack in
                nextjs)
                    echo "RUN npm install -g pnpm@latest next@${version#v} create-next-app@latest turbo vercel" >> "$output_dir/Dockerfile"
                    ;;
                react-native)
                    echo "RUN npm install -g react-native-cli expo-cli metro" >> "$output_dir/Dockerfile"
                    ;;
                expo)
                    echo "RUN npm install -g expo@~${version#v}.0.0 eas-cli @expo/ngrok" >> "$output_dir/Dockerfile"
                    ;;
            esac
            ;;
            
        python)
            cat >> "$output_dir/Dockerfile" << EOF
# Python specific
RUN apt-get update && \\
    apt-get install -y --no-install-recommends \\
    python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-pip \\
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \\
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

RUN pip install --no-cache-dir pipenv poetry virtualenv
EOF
            ;;
            
        golang)
            cat >> "$output_dir/Dockerfile" << EOF
# Go specific
ENV GO_VERSION=${GO_VERSION}

RUN wget -q https://go.dev/dl/go\${GO_VERSION}.linux-amd64.tar.gz && \\
    tar -C /usr/local -xzf go\${GO_VERSION}.linux-amd64.tar.gz && \\
    rm go\${GO_VERSION}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:\${PATH}"

RUN go install golang.org/x/tools/gopls@latest && \\
    go install github.com/go-delve/delve/cmd/dlv@latest
EOF
            ;;
            
        bun)
            cat >> "$output_dir/Dockerfile" << EOF
# Bun specific
ENV BUN_VERSION=${BUN_VERSION}
ENV BUN_INSTALL=/usr/local
ENV PATH="\${BUN_INSTALL}/bin:\${PATH}"

RUN apt-get update && \\
    apt-get install -y --no-install-recommends unzip \\
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v\${BUN_VERSION}"

RUN bun install -g typescript @types/bun prettier eslint
EOF
            ;;
            
        deno)
            cat >> "$output_dir/Dockerfile" << EOF
# Deno specific
ENV DENO_VERSION=${DENO_VERSION}
ENV DENO_INSTALL=/usr/local
ENV PATH="\${DENO_INSTALL}/bin:\${PATH}"

RUN apt-get update && \\
    apt-get install -y --no-install-recommends unzip \\
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v\${DENO_VERSION}
EOF
            ;;
    esac
    
    # Common footer
    cat >> "$output_dir/Dockerfile" << EOF

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo coder && \\
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory
RUN mkdir -p /workspace && \\
    chown -R coder:coder /workspace

USER coder
WORKDIR /workspace

# Configure code-server
RUN mkdir -p ~/.config/code-server && \\
    echo 'bind-addr: 0.0.0.0:8080\\nauth: password\\npassword: changeme\\ncert: false' > ~/.config/code-server/config.yaml

# Install VS Code extensions
EOF

    # Add stack-specific extensions
    case $stack in
        flutter)
            echo "RUN code-server --install-extension dart-code.dart-code && \\" >> "$output_dir/Dockerfile"
            echo "    code-server --install-extension dart-code.flutter" >> "$output_dir/Dockerfile"
            ;;
        nextjs|react-native|expo)
            echo "RUN code-server --install-extension dbaeumer.vscode-eslint && \\" >> "$output_dir/Dockerfile"
            echo "    code-server --install-extension esbenp.prettier-vscode && \\" >> "$output_dir/Dockerfile"
            echo "    code-server --install-extension dsznajder.es7-react-js-snippets" >> "$output_dir/Dockerfile"
            ;;
        python)
            echo "RUN code-server --install-extension ms-python.python && \\" >> "$output_dir/Dockerfile"
            echo "    code-server --install-extension ms-python.vscode-pylance" >> "$output_dir/Dockerfile"
            ;;
        golang)
            echo "RUN code-server --install-extension golang.go" >> "$output_dir/Dockerfile"
            ;;
        bun|deno)
            echo "RUN code-server --install-extension dbaeumer.vscode-eslint && \\" >> "$output_dir/Dockerfile"
            echo "    code-server --install-extension esbenp.prettier-vscode" >> "$output_dir/Dockerfile"
            if [[ $stack == "deno" ]]; then
                echo "RUN code-server --install-extension denoland.vscode-deno" >> "$output_dir/Dockerfile"
            fi
            ;;
    esac
    
    # Final footer
    cat >> "$output_dir/Dockerfile" << EOF

# Expose ports
EXPOSE 8080

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]
EOF
    
    echo "Generated $output_dir/Dockerfile"
}

# Function to generate devcontainer variant
generate_devcontainer() {
    local stack=$1
    local version=$2
    local core_dockerfile=$3
    local output_dir="${stack}/${version}/devcontainer"
    
    mkdir -p "$output_dir"
    
    # Select appropriate base image
    local base_image=$DEVCONTAINER_BASE
    case $stack in
        nextjs|react-native|expo|bun)
            base_image=$DEVCONTAINER_NODE_BASE
            ;;
        python)
            base_image="${DEVCONTAINER_PYTHON_BASE}:${PYTHON_VERSION}"
            ;;
        golang)
            base_image="${DEVCONTAINER_GO_BASE}:${GO_VERSION}"
            ;;
    esac
    
    # Generate Dockerfile
    cat > "$output_dir/Dockerfile" << EOF
# syntax=docker/dockerfile:1
# ${STACK_NAME} Devcontainer Development Environment
# Optimized for GitHub Codespaces and VS Code Remote Containers

FROM ${base_image}

LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
LABEL org.opencontainers.image.description="${STACK_NAME} devcontainer development environment"
LABEL org.opencontainers.image.version="${STACK_VERSION}"

EOF

    # Add stack-specific setup
    case $stack in
        flutter)
            cat >> "$output_dir/Dockerfile" << EOF
ENV FLUTTER_VERSION=${FLUTTER_VERSION}
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="\${FLUTTER_HOME}/bin:\${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \\
    && apt-get -y install --no-install-recommends \\
    curl git unzip xz-utils zip libglu1-mesa \\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_\${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \\
    tar xf flutter.tar.xz -C /opt && \\
    rm flutter.tar.xz

RUN flutter config --no-analytics && flutter doctor && flutter precache
EOF
            ;;
            
        nextjs)
            cat >> "$output_dir/Dockerfile" << EOF
# Install global Node packages
RUN su node -c "npm install -g pnpm@latest next@${version#v} create-next-app@latest turbo vercel serve"
EOF
            ;;
            
        react-native)
            cat >> "$output_dir/Dockerfile" << EOF
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="\${ANDROID_HOME}/cmdline-tools/latest/bin:\${ANDROID_HOME}/platform-tools:\${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \\
    && apt-get -y install --no-install-recommends \\
    openjdk-17-jdk python3 unzip \\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN su node -c "npm install -g react-native-cli expo-cli eas-cli metro"
EOF
            ;;
            
        expo)
            cat >> "$output_dir/Dockerfile" << EOF
RUN su node -c "npm install -g expo@~${version#v}.0.0 eas-cli @expo/ngrok"
EOF
            ;;
            
        bun)
            cat >> "$output_dir/Dockerfile" << EOF
ENV BUN_VERSION=${BUN_VERSION}
ENV BUN_INSTALL=/usr/local
ENV PATH="\${BUN_INSTALL}/bin:\${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \\
    && apt-get -y install --no-install-recommends \\
    build-essential python3 unzip \\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v\${BUN_VERSION}"

RUN bun install -g typescript @types/bun prettier eslint nodemon
EOF
            ;;
            
        deno)
            cat >> "$output_dir/Dockerfile" << EOF
ENV DENO_VERSION=${DENO_VERSION}
ENV DENO_INSTALL=/usr/local
ENV PATH="\${DENO_INSTALL}/bin:\${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \\
    && apt-get -y install --no-install-recommends \\
    build-essential python3 unzip \\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deno.land/x/install/install.sh | sh -s v\${DENO_VERSION}
EOF
            ;;
    esac
    
    # Common footer
    cat >> "$output_dir/Dockerfile" << EOF

# Configure Git
RUN git config --global init.defaultBranch main

# Create workspace directory with proper permissions
RUN mkdir -p /workspaces && \\
    chown -R $([ "$stack" = "python" ] || [ "$stack" = "golang" ] && echo "vscode" || echo "node"):$([ "$stack" = "python" ] || [ "$stack" = "golang" ] && echo "vscode" || echo "node") /workspaces

# Switch to non-root user
USER $([ "$stack" = "python" ] || [ "$stack" = "golang" ] && echo "vscode" || echo "node")

# Set working directory
WORKDIR /workspaces

# Expose common ports
EOF

    # Add stack-specific ports
    case $stack in
        nextjs)
            echo "EXPOSE 3000 3001 4000 5000" >> "$output_dir/Dockerfile"
            ;;
        react-native|expo)
            echo "EXPOSE 8081 8082 19000 19001" >> "$output_dir/Dockerfile"
            ;;
        flutter)
            echo "EXPOSE 9100 9101" >> "$output_dir/Dockerfile"
            ;;
        golang)
            echo "EXPOSE 8080" >> "$output_dir/Dockerfile"
            ;;
        python)
            echo "EXPOSE 8000 5000" >> "$output_dir/Dockerfile"
            ;;
        bun|deno)
            echo "EXPOSE 3000 4000 5173 8080" >> "$output_dir/Dockerfile"
            ;;
    esac
    
    echo "" >> "$output_dir/Dockerfile"
    echo "# Keep container running" >> "$output_dir/Dockerfile"
    echo "CMD [\"sleep\", \"infinity\"]" >> "$output_dir/Dockerfile"
    
    # Generate devcontainer.json
    local ports=""
    local postCommand=""
    local extensions=""
    
    # Set ports based on stack
    case $stack in
        nextjs) ports="3000, 3001" ;;
        react-native|expo) ports="8081, 19000, 19001" ;;
        flutter) ports="9100, 9101" ;;
        golang) ports="8080" ;;
        python) ports="8000, 5000" ;;
        bun|deno) ports="3000, 4000, 5173, 8080" ;;
    esac
    
    # Set post command based on stack
    case $stack in
        nextjs|react-native|expo) postCommand="npm install" ;;
        flutter) postCommand="flutter pub get" ;;
        golang) postCommand="go mod download" ;;
        python) postCommand="pip install -r requirements.txt" ;;
        bun) postCommand="bun install" ;;
        deno) postCommand="deno cache deps.ts 2>/dev/null || true" ;;
    esac
    
    # Set extensions based on stack
    case $stack in
        flutter) extensions='
        "dart-code.dart-code",
        "dart-code.flutter"' ;;
        nextjs|react-native|expo) extensions='
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode",
        "dsznajder.es7-react-js-snippets",
        "christian-kohler.npm-intellisense"' ;;
        python) extensions='
        "ms-python.python",
        "ms-python.vscode-pylance"' ;;
        golang) extensions='
        "golang.go"' ;;
        bun) extensions='
        "oven.bun-vscode",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"' ;;
        deno) extensions='
        "denoland.vscode-deno",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"' ;;
    esac
    
    cat > "$output_dir/devcontainer.json" << EOF
{
  "name": "${STACK_NAME} Development",
  "dockerFile": "Dockerfile",
  "forwardPorts": [$ports],
  "postCreateCommand": "$postCommand",
  "customizations": {
    "vscode": {
      "extensions": [$extensions
      ]
    }
  },
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "remoteUser": "$([[ "$stack" == "python" ]] || [[ "$stack" == "golang" ]] && echo "vscode" || echo "node")"
}
EOF
    
    echo "Generated $output_dir/Dockerfile and devcontainer.json"
}

# Main function
generate_variants() {
    local stack=$1
    local version=$2
    local core_dockerfile="${stack}/${version}/core/Dockerfile"
    
    if [[ ! -f "$core_dockerfile" ]]; then
        echo "Error: Core Dockerfile not found at $core_dockerfile"
        return 1
    fi
    
    echo "Generating variants for ${stack}/${version}..."
    
    # Extract information from core Dockerfile
    extract_core_info "$core_dockerfile" "$stack" "$version"
    
    # Generate each variant
    generate_gitpod "$stack" "$version" "$core_dockerfile"
    generate_code_server "$stack" "$version" "$core_dockerfile"
    generate_devcontainer "$stack" "$version" "$core_dockerfile"
    
    echo "Completed generating variants for ${stack}/${version}"
}

# Process command line arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <stack> <version> [stack version ...]"
    echo "       $0 all"
    echo ""
    echo "Examples:"
    echo "  $0 flutter v3.32"
    echo "  $0 nextjs v15 nextjs v14.2"
    echo "  $0 all"
    exit 1
fi

if [[ "$1" == "all" ]]; then
    # Process all stacks
    for stack_dir in */; do
        stack=$(basename "$stack_dir")
        if [[ "$stack" =~ ^(nextjs|flutter|react-native|python|golang|bun|deno|expo|android)$ ]]; then
            for version_dir in "$stack_dir"*/; do
                version=$(basename "$version_dir")
                if [[ "$version" =~ ^v[0-9] ]] || [[ "$version" == "studio-latest" ]] || [[ "$version" =~ ^sdk-v[0-9] ]]; then
                    generate_variants "$stack" "$version"
                fi
            done
        fi
    done
else
    # Process specified stacks and versions
    while [[ $# -gt 0 ]]; do
        stack=$1
        version=$2
        if [[ -z "$version" ]]; then
            echo "Error: Version required for stack $stack"
            exit 1
        fi
        generate_variants "$stack" "$version"
        shift 2
    done
fi

echo "Done!"