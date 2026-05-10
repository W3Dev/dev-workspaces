# Expo Development Environments

This directory contains Docker images for Expo (React Native) development across multiple SDK versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | React Native | Features |
|---------|--------|--------------|--------------|----------|
| v53 | Stable | Jan 2025 | 0.79 | Latest SDK, improved performance |
| v52 | Stable | Dec 2024 | 0.78 | New architecture support |
| v51 | Stable | Sep 2024 | 0.77 | Expo Router v3 |
| v50 | Stable | Jun 2024 | 0.76 | SDK 50 milestone release |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with Expo Go via tunnel
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/expo:v53-gitpod
tasks:
  - init: npm install
    command: npx expo start --tunnel
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/expo:v53-core
docker run -it -p 19000:19000 -p 19001:19001 -p 19002:19002 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/expo:v53-core
```

## Common Features

All Expo images include:

- Node.js 20 LTS
- Expo CLI (version-specific)
- EAS CLI for building
- React Native CLI
- Git and essential build tools
- Ngrok for tunneling
- Common Expo ports exposed

## Image Variants

Each version offers four variants:

1. **core** - Minimal Expo SDK setup
2. **gitpod** - Optimized for cloud development
3. **code-server** - VS Code in browser with RN extensions
4. **devcontainer** - Configured for GitHub Codespaces

## Development Workflow

```bash
# Create new Expo app
npx create-expo-app my-app

# Start development server
npx expo start

# Start with tunnel (for cloud environments)
npx expo start --tunnel

# Run on web
npx expo start --web

# Build with EAS
eas build --platform android
```

## Expo Ports

- `19000` - Expo DevTools
- `19001` - Metro Bundler
- `19002` - Expo Dev Server

## Using Expo Go

1. Install Expo Go on your mobile device
2. Start expo with tunnel: `npx expo start --tunnel`
3. Scan the QR code with Expo Go

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Expo-specific issues, refer to the [official Expo documentation](https://docs.expo.dev).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.