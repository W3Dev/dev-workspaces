# React Native Development Environments

This directory contains Docker images for React Native development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | React Version | Features |
|---------|--------|--------------|---------------|----------|
| v0.80 | Stable | Jun 2024 | 19.0 | API stability, TypeScript improvements |
| v0.79 | Stable | Apr 2024 | 18.3 | 3x faster Metro startup, exports field |
| v0.78 | Stable | Jan 2024 | 18.2 | Previous stable release |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with Android SDK and emulator
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/react-native:v0.80-gitpod
tasks:
  - init: npm install
    command: npm start
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/react-native:v0.80-core
docker run -it -p 8081:8081 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/react-native:v0.80-core
```

## Common Features

All React Native images include:

- Node.js 20 LTS
- React Native CLI
- Metro bundler
- Android SDK (gitpod variant)
- Java 17 for Android builds
- Watchman for file watching
- Common ports exposed (8081, 19000)

## Image Variants

Each version offers four variants:

1. **core** - Minimal React Native setup
2. **gitpod** - Includes Android SDK and emulator
3. **code-server** - VS Code in browser with RN extensions
4. **devcontainer** - Configured for GitHub Codespaces

## Platform Support

- ✅ React Native Android
- ✅ React Native Web (via react-native-web)
- ⚠️ React Native iOS (requires macOS)

## React Native Commands

```bash
# Create new project
npx react-native init MyApp

# Start Metro bundler
npm start

# Run on Android
npx react-native run-android

# Run on connected device
adb devices
npx react-native run-android --deviceId <device-id>

# Clean and rebuild
cd android && ./gradlew clean
```

## Troubleshooting

### Metro bundler issues
```bash
npx react-native start --reset-cache
```

### Android build issues
```bash
cd android
./gradlew clean
./gradlew assembleDebug
```

### Port conflicts
```bash
# Kill process on port 8081
lsof -ti:8081 | xargs kill -9
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For React Native-specific issues, refer to the [official React Native documentation](https://reactnative.dev/docs/getting-started).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.