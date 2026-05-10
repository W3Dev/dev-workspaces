# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Gitpod workspace Docker images for remote development environments. The repository contains specialized Dockerfiles for different development stacks including Android development, React Native, and general-purpose workspaces.

## Architecture

The repository is organized into specialized workspace directories:

- `@exps/` - Experimental Dockerfiles for Android development
- `@github/neondatabase/neon/` - Neon database workspace
- `gp-android-studio/` - Android Studio workspace
- `gp-react-native/` - React Native/Expo workspace  
- `gp-cloud/` - Cloud development workspace
- `gp-vlc/` - VLC workspace
- `workspace-full/` - Full workspace with CI/CD and snap support

All workspaces are based on Gitpod's base images (`gitpod/workspace-full` or `gitpod/workspace-full-vnc` for GUI applications).

## Common Development Commands

Since this is primarily a Docker image repository, common operations involve:

- **Building Docker images**: `docker build -t <image-name> -f <dockerfile-path> .`
- **Testing workspaces**: Use Gitpod's preview functionality or local Docker testing
- **Package management**: `npm test` (currently returns error - no tests specified)

## Key Configuration Files

- `.gitpod.yml` - Main Gitpod configuration with workspace settings
- `package.json` - Project metadata and basic npm scripts
- `ISSUES.md` - Known issues and troubleshooting for graphical applications

## Workspace Types

### Android Development (@exps/Dockerfile.android)
- Based on `gitpod/workspace-full-vnc`
- Includes Android SDK, multiple platform versions, build tools, and system images
- Supports Android development with Java 8

### Android Studio (gp-android-studio/Dockerfile)
- VNC-enabled workspace with Android Studio IDE
- Simplified setup for Android development

### React Native (gp-react-native/Dockerfile)
- Includes Expo CLI globally installed
- Planned features: Tailscale and Cloudflare Tunnel support

## Docker Image Publishing

Images are published to multiple registries:
- GitHub Container Registry
- GitLab Container Registry  
- Docker Hub
- Quay.io
- Harbor

## Gitpod Configuration

The workspace uses:
- Default image: `gitpod/workspace-full`
- Port 3000 exposed with preview mode
- Basic init and start scripts configured