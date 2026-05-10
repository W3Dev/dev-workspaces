# Dev Workspaces - Multi-Platform Development Environments

> 🚀 **Repository Restructuring in Progress** - We're expanding from Gitpod-only to support multiple platforms!

This repository provides optimized Docker images for various development stacks, compatible with:
- **Gitpod** - Cloud development environments
- **GitHub Codespaces** - Via Devcontainers specification  
- **OpenAI Codex** - AI-assisted development
- **Local Docker** - Traditional development workflows

## 📦 Available Stacks

| Stack | Versions | Status | Image |
|-------|----------|--------|-------|
| Flutter | v3.32, v3.29, v3.24 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/flutter:v3.32` |
| React Native | v0.80, v0.79, v0.78 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/react-native:v0.80` |
| Next.js | v15, v14.2, v14.0 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/nextjs:v15` |
| Bun | v1.2, v1.1, v1.0 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/bun:v1.2` |
| Deno | v2.3, v2.0, v1.46 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/deno:v2.3` |
| Python | v3.13, v3.12, v3.11 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/python:v3.13` |
| Go | v1.23, v1.22, v1.21 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/golang:v1.23` |
| Android | Studio Latest, SDK v34, SDK v33 | ✅ Stable | `ghcr.io/w3dev/dev-workspaces/android:studio-latest` |

## 🚀 Quick Start

### Using with Gitpod

1. Add to `.gitpod.yml`:
```yaml
image: ghcr.io/w3dev/dev-workspaces/flutter:v3.32
tasks:
  - init: flutter doctor
    command: flutter run
```

2. Open your repository in Gitpod: `https://gitpod.io/#https://github.com/YOUR_REPO`

### Using with GitHub Codespaces

1. Create `.devcontainer/devcontainer.json`:
```json
{
  "image": "ghcr.io/w3dev/dev-workspaces/react-native:v0.80",
  "features": {},
  "postCreateCommand": "npm install",
  "forwardPorts": [3000, 8081]
}
```

2. Open in Codespaces from your GitHub repository

### Using with Docker Locally

```bash
# Pull and run
docker pull ghcr.io/w3dev/dev-workspaces/python:v3.13
docker run -it -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/python:v3.13

# With port forwarding
docker run -it -p 8000:8000 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/python:v3.13
```

## 📁 Repository Structure

```
dev-workspaces/
├── flutter/           # Flutter development environments
│   ├── v3.32/
│   ├── v3.29/
│   └── v3.24/
├── react-native/      # React Native + Expo environments
├── nextjs/           # Next.js full-stack environments
├── bun/              # Bun JavaScript runtime
├── deno/             # Deno JavaScript runtime
├── python/           # Python development environments
├── golang/           # Go development environments
├── android/          # Android SDK and Studio
├── templates/        # Reusable templates
├── legacy/           # Previous Gitpod-only images
└── .github/
    └── workflows/    # CI/CD automation
```

## 🔄 CI/CD & Publishing

Images are automatically built, tested, and published to multiple registries:

- **GitHub Container Registry** (Primary): `ghcr.io/w3dev/dev-workspaces/*`
- **Docker Hub**: `docker.io/w3dev/dev-workspaces/*`
- **GitLab Container Registry**: `registry.gitlab.com/w3dev/dev-workspaces/*`
- **Quay.io**: `quay.io/w3dev/dev-workspaces/*`
- **Harbor**: Custom enterprise registry

## 🛠️ Building Custom Images

Each stack directory contains a Dockerfile that can be customized:

```bash
cd flutter/v3.32
docker build -t my-flutter-dev .
```

## 📚 Documentation

- Each stack has its own README with detailed information
- Version-specific documentation in each version directory
- [Migration Guide](MIGRATION.md) for transitioning from old structure
- [Contributing Guidelines](CONTRIBUTING.md) for contributors

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for:
- Adding new technology stacks
- Updating existing images
- Improving documentation
- Reporting issues

## 🔐 Security

- All images are regularly scanned for vulnerabilities
- Base images are updated weekly
- Security patches are applied promptly
- Report security issues to: security@w3dev.io

## 📄 License

This repository is licensed under the MIT License. Individual software packages included in the images are subject to their own licenses.

## 🙏 Acknowledgments

Built on top of excellent base images from:
- [Gitpod](https://github.com/gitpod-io/workspace-images)
- Official language/framework images
- Community contributions

## ✨ Contributors

Thanks to all the amazing contributors who have helped make this project better!

<a href="https://github.com/W3Dev/dev-workspaces/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=W3Dev/dev-workspaces&max=100&columns=10" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

---

> **Note**: This repository was previously focused solely on Gitpod workspaces. Legacy images are preserved in the `/legacy` directory for backward compatibility.