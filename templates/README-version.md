# {STACK_NAME} {VERSION} Development Environment

Docker image for {STACK_NAME} {VERSION} development, compatible with Gitpod, GitHub Codespaces, and OpenAI Codex.

## Image Details

- **Base Image**: `{BASE_IMAGE}`
- **{STACK_NAME} Version**: {VERSION}
- **Image Size**: ~{SIZE}
- **Build Time**: ~{BUILD_TIME}

## Included Tools and Features

### Core {STACK_NAME} Components
- {COMPONENT_1}
- {COMPONENT_2}
- {COMPONENT_3}

### Development Tools
- Git {GIT_VERSION}
- Node.js {NODE_VERSION} (if applicable)
- Python {PYTHON_VERSION} (if applicable)
- Common build tools (make, gcc, etc.)

### Platform-Specific Features

#### Gitpod
- Preconfigured workspace settings
- Automatic port forwarding
- VNC support for GUI applications (if applicable)

#### Devcontainers
- VS Code extensions recommendations
- Customizable features via devcontainer.json
- Integrated terminal configuration

#### OpenAI Codex
- Optimized for AI code completion
- Includes common libraries and frameworks
- Documentation and examples readily available

## Usage

### Pull the Image

```bash
docker pull ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}
```

### Run Locally

```bash
# Basic usage
docker run -it ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}

# With volume mounting
docker run -it -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}

# With port forwarding
docker run -it -p 8080:8080 ghcr.io/w3dev/dev-workspaces/{stack_name}:{version}
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `{VAR_1}` | `{DEFAULT_1}` | {DESC_1} |
| `{VAR_2}` | `{DEFAULT_2}` | {DESC_2} |

## Building from Source

```bash
docker build -t custom-{stack_name}-{version} .

# With build arguments
docker build --build-arg {ARG_NAME}={VALUE} -t custom-{stack_name}-{version} .
```

## Version-Specific Notes

### What's New in {VERSION}
- {NEW_FEATURE_1}
- {NEW_FEATURE_2}
- {NEW_FEATURE_3}

### Breaking Changes from {PREVIOUS_VERSION}
- {BREAKING_CHANGE_1}
- {BREAKING_CHANGE_2}

### Migration Guide

If migrating from {PREVIOUS_VERSION}, note the following changes:

1. {MIGRATION_STEP_1}
2. {MIGRATION_STEP_2}
3. {MIGRATION_STEP_3}

## Known Issues

- {ISSUE_1}
- {ISSUE_2}

## Examples

### Basic {STACK_NAME} Project

```bash
# Example commands for getting started
{EXAMPLE_COMMANDS}
```

## Additional Resources

- [Official {STACK_NAME} Documentation]({DOCS_URL})
- [{STACK_NAME} {VERSION} Release Notes]({RELEASE_NOTES_URL})
- [Community Forums]({COMMUNITY_URL})

## License

This Docker image is provided under the same license as the base image and installed software.
See individual component licenses for details.