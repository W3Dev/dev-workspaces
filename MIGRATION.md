# Migration Guide - Dev Workspaces Repository Restructuring

## Overview

This document tracks the migration from a Gitpod-only repository to a multi-platform development environment repository supporting Gitpod, GitHub Codespaces (Devcontainers), and OpenAI Codex.

## Migration Status

### Phase 1: Structure Setup ✅
- [x] Create legacy directory for existing files
- [x] Backup all existing Dockerfiles and configurations
- [x] Create new directory structure with v-prefixed versions
- [x] Create template files for consistency

### Phase 2: Documentation 🚧
- [x] Update main README.md with new structure
- [x] Create MIGRATION.md (this file)
- [ ] Create CONTRIBUTING.md
- [ ] Create stack-level README files
- [ ] Create version-specific README files

### Phase 3: Dockerfile Migration 📋
- [ ] Migrate Android Dockerfiles
  - [ ] Android Studio Latest
  - [ ] Android SDK v34
  - [ ] Android SDK v33
- [ ] Migrate React Native Dockerfile
  - [ ] v0.80
  - [ ] v0.79
  - [ ] v0.78
- [ ] Create new Dockerfiles for:
  - [ ] Flutter (v3.32, v3.29, v3.24)
  - [ ] Next.js (v15, v14.2, v14.0)
  - [ ] Bun (v1.2, v1.1, v1.0)
  - [ ] Deno (v2.3, v2.0, v1.46)
  - [ ] Python (v3.13, v3.12, v3.11)
  - [ ] Go (v1.23, v1.22, v1.21)

### Phase 4: CI/CD Implementation 📋
- [ ] Create Dockerfile validation workflow
- [ ] Create build and test workflow
- [ ] Create multi-registry publishing workflow
  - [ ] GitHub Container Registry (GHCR)
  - [ ] Docker Hub
  - [ ] GitLab Container Registry
  - [ ] Quay.io
  - [ ] Harbor

### Phase 5: Testing & Validation 📋
- [ ] Test all Dockerfiles locally
- [ ] Validate Gitpod compatibility
- [ ] Validate Devcontainers compatibility
- [ ] Test CI/CD pipelines
- [ ] Security scanning setup

## Directory Mapping

### Old Structure → New Structure

| Old Path | New Path | Status |
|----------|----------|--------|
| `@exps/Dockerfile.android` | `android/sdk-v29/Dockerfile` | Pending |
| `@exps/Dockerfile.android1` | `android/studio-latest/Dockerfile` | Pending |
| `gp-android-studio/Dockerfile` | `android/studio-latest/Dockerfile` | Pending |
| `gp-react-native/Dockerfile` | `react-native/v0.79/Dockerfile` | Pending |
| `@github/neondatabase/neon/Dockerfile` | `databases/neon/latest/Dockerfile` | Pending |
| `workspace-full/Dockerfile.ci-cd` | `tools/ci-cd/latest/Dockerfile` | Pending |

## Version Naming Convention

All versions now use the "v" prefix for consistency:
- `3.32` → `v3.32`
- `0.80` → `v0.80`
- `1.22` → `v1.22`

## Image Naming Convention

New image naming follows this pattern:
```
ghcr.io/w3dev/dev-workspaces/{stack}:{version}
```

Examples:
- `ghcr.io/w3dev/dev-workspaces/flutter:v3.32`
- `ghcr.io/w3dev/dev-workspaces/python:v3.13`
- `ghcr.io/w3dev/dev-workspaces/android:studio-latest`

## Breaking Changes

### For Existing Users

1. **Image Names**: All image references need to be updated to the new naming scheme
2. **Gitpod Configuration**: Update `.gitpod.yml` files to use new image paths
3. **Directory Structure**: Custom builds referencing old paths need updates

### Migration Commands

```bash
# Update .gitpod.yml
sed -i 's|gitpod/workspace-full-vnc|ghcr.io/w3dev/dev-workspaces/base:latest|g' .gitpod.yml

# Update docker-compose.yml
sed -i 's|w3dev/gitpod-workspaces|ghcr.io/w3dev/dev-workspaces|g' docker-compose.yml
```

## Timeline

- **Week 1**: Structure setup and documentation ✅
- **Week 2**: Android and React Native migration
- **Week 3**: New stack Dockerfiles (Flutter, Next.js, Bun, Deno)
- **Week 4**: Programming languages (Python, Go) and remaining stacks
- **Week 5**: CI/CD implementation and testing
- **Week 6**: Final validation and go-live

## How to Contribute

1. Check the migration status above
2. Pick an uncompleted task
3. Follow the templates in `/templates` directory
4. Submit a PR with your changes
5. Update this file to mark the task as complete

## Support

For questions or issues during migration:
- Open an issue with the `migration` label
- Contact maintainers at dev@w3dev.io
- Check the legacy directory for reference

---

Last Updated: [Current Date]
Migration Lead: [@maintainer]