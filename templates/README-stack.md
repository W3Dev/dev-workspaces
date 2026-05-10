# {STACK_NAME} Development Environments

This directory contains Docker images for {STACK_NAME} development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | End of Support |
|---------|--------|--------------|----------------|
| {VERSION_1} | Stable | {DATE_1} | {EOL_1} |
| {VERSION_2} | Stable | {DATE_2} | {EOL_2} |
| {VERSION_3} | Stable | {DATE_3} | {EOL_3} |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with VNC for GUI applications where applicable
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}
```

### Using with Devcontainers

Add this to your `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}",
  "features": {}
}
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}
docker run -it ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}
```

## Common Features

All {STACK_NAME} images include:

- {FEATURE_1}
- {FEATURE_2}
- {FEATURE_3}
- Development tools (Git, curl, wget, etc.)
- Optimized for cloud development environments

## Version-Specific Information

See the README in each version directory for detailed information about:
- Specific features and tools included
- Breaking changes from previous versions
- Migration guides
- Known issues and workarounds

## Building from Source

Each version directory contains a Dockerfile that can be built locally:

```bash
cd {version}
docker build -t my-{stack_name}-dev .
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For {STACK_NAME}-specific issues, refer to the official {STACK_NAME} documentation and community resources.

## Contributing

See the main [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines on contributing to this project.