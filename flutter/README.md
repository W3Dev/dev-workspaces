# Flutter Development Environments

This directory contains Docker images for Flutter development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | Dart Version | Features |
|---------|--------|--------------|--------------|----------|
| v3.32 | Stable | Oct 2024 | 3.6 | Latest stable, improved performance |
| v3.29 | Stable | Aug 2024 | 3.5 | WebAssembly improvements |
| v3.24 | Stable | May 2024 | 3.4 | Flutter GPU preview, multi-view embedding |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with VNC for mobile preview
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/flutter:v3.32-gitpod
tasks:
  - init: flutter pub get
    command: flutter run -d web-server --web-port 3000
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/flutter:v3.32-core
docker run -it -p 9100:9100 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/flutter:v3.32-core
```

## Common Features

All Flutter images include:

- Flutter SDK (specified version)
- Dart SDK (bundled with Flutter)
- Git and essential build tools
- Android SDK (in gitpod variant)
- Chrome for web development
- Common Flutter ports exposed

## Image Variants

Each version offers four variants:

1. **core** - Minimal Flutter SDK setup
2. **gitpod** - Includes Android SDK and Chrome
3. **code-server** - VS Code in browser with Flutter extensions
4. **devcontainer** - Configured for GitHub Codespaces

## Platform Support

- ✅ Flutter Web
- ✅ Flutter Linux Desktop
- ✅ Flutter Android (gitpod variant)
- ⚠️ Flutter iOS (requires macOS)

## Building from Source

```bash
cd v3.32/core
docker build -t my-flutter-dev .
```

## Flutter Commands

```bash
# Check Flutter installation
flutter doctor

# Create new project
flutter create my_app

# Run on web
flutter run -d web-server --web-port 3000

# Run tests
flutter test

# Build for production
flutter build web
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Flutter-specific issues, refer to the [official Flutter documentation](https://flutter.dev/docs).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.