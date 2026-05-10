# Deno Development Environments

This directory contains Docker images for Deno runtime across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | Features |
|---------|--------|--------------|----------|
| v2.3 | Stable | 2025 | Latest features and improvements |
| v2.0 | Stable | Oct 2024 | Major release with Node/npm compatibility |
| v1.46 | Stable | Aug 2024 | Last 1.x release |

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
image: ghcr.io/w3dev/dev-workspaces/deno:v2.3-gitpod
tasks:
  - init: deno cache deps.ts
    command: deno run --allow-net server.ts
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/deno:v2.3-core
docker run -it -p 8000:8000 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/deno:v2.3-core
```

## Common Features

All Deno images include:

- Deno runtime (specified version)
- Git and essential build tools
- TypeScript support built-in
- Built-in formatter and linter
- Common ports exposed (8000, 8080, 3000)

## Image Variants

Each version offers four variants:

1. **core** - Minimal Deno runtime setup
2. **gitpod** - Optimized with pre-cached std library
3. **code-server** - VS Code in browser with Deno extension
4. **devcontainer** - Configured for GitHub Codespaces

## Deno Commands

```bash
# Run a file with permissions
deno run --allow-net --allow-read server.ts

# Format code
deno fmt

# Lint code
deno lint

# Run tests
deno test

# Bundle modules
deno bundle main.ts bundle.js

# Install a script
deno install --allow-net -n serve https://deno.land/std/http/file_server.ts

# Cache dependencies
deno cache deps.ts

# Type check
deno check main.ts
```

## Permissions

Deno is secure by default. Grant permissions explicitly:

- `--allow-read` - File system read access
- `--allow-write` - File system write access
- `--allow-net` - Network access
- `--allow-env` - Environment variables
- `--allow-run` - Subprocess execution
- `--allow-all` - All permissions (use with caution)

## Configuration

Create `deno.json` or `deno.jsonc`:

```json
{
  "tasks": {
    "dev": "deno run --watch --allow-net server.ts",
    "test": "deno test --allow-read"
  },
  "imports": {
    "@std/": "https://deno.land/std@0.224.0/"
  },
  "lint": {
    "exclude": ["dist/"]
  },
  "fmt": {
    "lineWidth": 100,
    "indentWidth": 2
  }
}
```

## Deno 2.0 Features

- **Node.js Compatibility**: Run npm packages
- **Workspace Support**: Monorepo management
- **JSR Support**: JavaScript Registry integration
- **Improved Performance**: Faster startup and execution

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Deno-specific issues, refer to the [official Deno documentation](https://deno.land/manual).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.