# Android Development Environments

This directory contains Docker images for Android development, including Android Studio and SDK-only configurations, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Type | Description | Includes |
|---------|------|-------------|----------|
| studio-latest | IDE | Latest Android Studio | Full IDE, SDK, Emulator |
| sdk-v34 | SDK | Android SDK API 34 | SDK tools, no IDE |
| sdk-v33 | SDK | Android SDK API 33 | SDK tools, no IDE |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with VNC for Android Studio
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod (Android Studio)

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/android:studio-latest-gitpod
ports:
  - port: 5900
    onOpen: ignore
  - port: 6080
    onOpen: open-browser
vscode:
  extensions:
    - msjsdiag.vscode-react-native
```

### Using with Docker (SDK only)

```bash
docker pull ghcr.io/w3dev/dev-workspaces/android:sdk-v34-core
docker run -it -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/android:sdk-v34-core
```

## Common Features

All Android images include:

- Java 17 (required for modern Android)
- Android SDK command-line tools
- Platform tools (adb, fastboot)
- Build tools
- Git and essential development tools

### Studio images additionally include:
- Android Studio IDE
- Android Emulator
- System images for virtual devices
- VNC server (Gitpod variant)

## Image Variants

Each version offers:

1. **core** - Minimal SDK setup for CI/CD
2. **gitpod** - Full Android Studio with VNC

## Android SDK Commands

```bash
# List installed packages
sdkmanager --list

# Install platform and build tools
sdkmanager "platforms;android-34" "build-tools;34.0.0"

# Accept licenses
yes | sdkmanager --licenses

# Create AVD (Android Virtual Device)
avdmanager create avd -n test -k "system-images;android-34;google_apis;x86_64"

# List devices
adb devices

# Install APK
adb install app.apk

# Logcat
adb logcat
```

## Gradle Commands

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Run tests
./gradlew test

# Clean build
./gradlew clean

# Install on device
./gradlew installDebug
```

## Environment Variables

```bash
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
```

## Creating Android Projects

```bash
# Using command line (requires templates)
# It's recommended to use Android Studio for project creation

# Or use existing project templates
git clone https://github.com/android/template-project
```

## Emulator Usage (Gitpod)

In Gitpod with VNC:

1. Open VNC viewer on port 6080
2. Start Android Studio from applications menu
3. Create/start AVD from AVD Manager
4. Note: Emulation may be slow in containers

## Building Without IDE

```bash
# Using Gradle wrapper
./gradlew build

# Generate signed APK
./gradlew assembleRelease \
  -Pandroid.injected.signing.store.file=$KEYSTORE \
  -Pandroid.injected.signing.store.password=$STORE_PASSWORD \
  -Pandroid.injected.signing.key.alias=$KEY_ALIAS \
  -Pandroid.injected.signing.key.password=$KEY_PASSWORD
```

## Troubleshooting

### License Issues
```bash
yes | sdkmanager --licenses
```

### Build Issues
```bash
./gradlew clean
./gradlew --stop
rm -rf ~/.gradle/caches/
```

### ADB Connection
```bash
adb kill-server
adb start-server
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Android-specific issues, refer to the [official Android documentation](https://developer.android.com/docs).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.