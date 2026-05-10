# Next.js Development Environments

This directory contains Docker images for Next.js development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | Features |
|---------|--------|--------------|----------|
| v15 | Stable | Oct 2024 | React 19, Turbopack stable, improved caching |
| v14.2 | Stable | Apr 2024 | Performance improvements, Turbopack updates |
| v14.0 | Stable | Oct 2023 | App Router stable, Server Actions |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with workspace-full base
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/nextjs:v15-gitpod
tasks:
  - init: npm install
    command: npm run dev
```

### Using with Devcontainers

Add this to your `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/w3dev/dev-workspaces/nextjs:v15-devcontainer",
  "forwardPorts": [3000]
}
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/nextjs:v15-core
docker run -it -p 3000:3000 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/nextjs:v15-core
```

## Common Features

All Next.js images include:

- Node.js 20 LTS
- pnpm, npm, and yarn package managers
- Git and essential build tools
- Pre-configured for hot reload
- TypeScript support
- Common Next.js ports exposed (3000, 3001)

## Image Variants

Each version offers four variants:

1. **core** - Minimal setup for lightweight development
2. **gitpod** - Optimized for Gitpod with pre-installed extensions
3. **code-server** - Includes VS Code in the browser
4. **devcontainer** - Configured for GitHub Codespaces

## Version-Specific Information

See the README in each version directory for:
- Specific features and breaking changes
- Migration guides from previous versions
- Version-specific configuration options
- Known issues and workarounds

## Building from Source

Each version directory contains Dockerfiles that can be built locally:

```bash
cd v15/core
docker build -t my-nextjs-dev .
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Next.js-specific issues, refer to the [official Next.js documentation](https://nextjs.org/docs).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.