# Next.js v14.0 Development Environments

This directory contains multiple Docker configurations for Next.js v14.0 development, each optimized for different use cases.

## Available Configurations

### 1. Core (`/core`)
- **Purpose**: Minimal Next.js v14.0 setup
- **Base Image**: `node:20-slim`
- **Use Case**: Lightweight development, CI/CD pipelines
- **Size**: ~200MB

### 2. Gitpod (`/gitpod`)
- **Purpose**: Optimized for Gitpod cloud development
- **Base Image**: `gitpod/workspace-full`
- **Use Case**: Cloud-based development with full IDE features
- **Features**: Pre-installed extensions, Git configuration, nvm

### 3. Code-Server (`/code-server`)
- **Purpose**: VS Code in the browser
- **Base Image**: `node:20`
- **Use Case**: Self-hosted cloud IDE
- **Access**: Port 8080 (default password: `changeme`)

### 4. Devcontainer (`/devcontainer`)
- **Purpose**: GitHub Codespaces & VS Code Remote Containers
- **Base Image**: `mcr.microsoft.com/devcontainers/javascript-node:20`
- **Use Case**: Standardized team development environments
- **Features**: Pre-configured extensions, Git, Docker-in-Docker

## Quick Start

### Using Core Image
```bash
docker build -t nextjs-v14.0-core ./core
docker run -it -p 3000:3000 -v $(pwd):/workspace nextjs-v14.0-core
```

### Using with Gitpod
Add to `.gitpod.yml`:
```yaml
image: ghcr.io/w3dev/dev-workspaces/nextjs:v14.0-gitpod
```

### Using Code-Server
```bash
docker build -t nextjs-v14.0-code-server ./code-server
docker run -d -p 8080:8080 -p 3000:3000 nextjs-v14.0-code-server
# Access VS Code at http://localhost:8080
```

### Using with Devcontainers
1. Copy the `/devcontainer` folder to your project root as `.devcontainer`
2. Open in VS Code with Remote-Containers extension
3. Click "Reopen in Container"

## What's Included

- **Next.js**: v14.0 (latest)
- **Node.js**: v20 LTS
- **Package Managers**: npm, pnpm
- **Global Tools**: create-next-app, turbo, vercel
- **Development Tools**: Git, curl, build essentials

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `development` | Node environment |
| `NEXT_TELEMETRY_DISABLED` | `1` | Disable Next.js telemetry |

## Ports

- `3000`: Next.js development server
- `3001`: Alternative port for multiple apps
- `8080`: Code-server web interface (code-server variant only)

## Creating a New Next.js App

```bash
# Using create-next-app
npx create-next-app@latest my-app

# With TypeScript
npx create-next-app@latest my-app --typescript

# With Tailwind CSS
npx create-next-app@latest my-app --tailwind

# With App Router (recommended)
npx create-next-app@latest my-app --app
```

## Next.js v14.0 Features

- React 19 support
- Improved Turbopack performance
- Enhanced App Router stability
- Better TypeScript support
- Improved error handling

## Troubleshooting

### Port already in use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Clear Next.js cache
```bash
rm -rf .next
```

### Node version issues
Ensure you're using Node.js 18.17 or later (v20 recommended)

## Additional Resources

- [Next.js v14.0 Documentation](https://nextjs.org/docs)
- [Next.js v14.0 Release Notes](https://nextjs.org/blog/next-15)
- [Migrating to v14.0](https://nextjs.org/docs/app/guides/upgrading/version-15)