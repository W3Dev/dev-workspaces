# Bun Development Environments

This directory contains Docker images for Bun JavaScript runtime across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | Features |
|---------|--------|--------------|----------|
| v1.2 | Stable | 2024 | Windows support, S3/Postgres native, 3x faster Express |
| v1.1 | Stable | Apr 2024 | Cross-platform shell, WebSocket client |
| v1.0 | Stable | Sep 2023 | First stable release |

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
image: ghcr.io/w3dev/dev-workspaces/bun:v1.2-gitpod
tasks:
  - init: bun install
    command: bun run dev
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/bun:v1.2-core
docker run -it -p 3000:3000 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/bun:v1.2-core
```

## Common Features

All Bun images include:

- Bun runtime (specified version)
- Git and essential build tools
- TypeScript support built-in
- Native SQLite support
- Common ports exposed (3000, 4000, 5173, 8080)

## Image Variants

Each version offers four variants:

1. **core** - Minimal Bun runtime setup
2. **gitpod** - Optimized for cloud development
3. **code-server** - VS Code in browser with Bun support
4. **devcontainer** - Configured for GitHub Codespaces

## Bun Commands

```bash
# Run a file
bun run index.ts

# Install dependencies
bun install

# Add a package
bun add express

# Run scripts from package.json
bun run dev

# Bundle for production
bun build ./index.ts --outdir ./dist

# Run tests
bun test

# Start a server
bun --hot run server.ts
```

## Bun vs Node.js

- **Speed**: Up to 3x faster than Node.js
- **TypeScript**: Native support, no transpilation needed
- **Package Manager**: Built-in, faster than npm/yarn/pnpm
- **Bundler**: Built-in bundler and transpiler
- **Test Runner**: Built-in test runner
- **Node.js Compatibility**: Aims for drop-in compatibility

## Creating a Bun Project

```bash
# Create new project
bun init

# Create with template
bun create react-app my-app
bun create next-app my-app

# From existing package.json
bun install
```

## Environment Variables

Bun automatically loads from `.env` files:
- `.env`
- `.env.local`
- `.env.production`
- `.env.development`

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Bun-specific issues, refer to the [official Bun documentation](https://bun.sh/docs).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.