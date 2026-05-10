# Dockerfile Generation Scripts

This directory contains scripts to automate the generation of Dockerfile variants from core Dockerfiles.

## Overview

Instead of manually creating and maintaining 4 different Dockerfile variants for each stack/version combination, we only need to maintain the `core/Dockerfile` and let the script generate the other variants:

- **gitpod** - Optimized for Gitpod cloud development
- **code-server** - Includes VS Code in the browser
- **devcontainer** - For GitHub Codespaces and VS Code Remote Containers

## Usage

### Generate variants for a specific stack and version

```bash
./scripts/generate-variants.sh flutter v3.32
```

### Generate variants for multiple stack/version pairs

```bash
./scripts/generate-variants.sh nextjs v15 nextjs v14.2 flutter v3.32
```

### Generate variants for all stacks

```bash
./scripts/generate-variants.sh all
```

## How it Works

1. The script reads the `core/Dockerfile` for a given stack/version
2. Extracts key information (version numbers, environment variables, etc.)
3. Generates appropriate variants based on the stack type:
   - **gitpod**: Uses Gitpod base images, adds cloud-specific optimizations
   - **code-server**: Adds VS Code server with appropriate extensions
   - **devcontainer**: Creates both Dockerfile and devcontainer.json for Codespaces

## Adding a New Stack

1. Create the directory structure:
   ```bash
   mkdir -p newstack/v1.0/core
   ```

2. Create the core Dockerfile:
   ```bash
   # Create newstack/v1.0/core/Dockerfile with your base configuration
   ```

3. Run the generator:
   ```bash
   ./scripts/generate-variants.sh newstack v1.0
   ```

## Stack Configuration

The `stack-config.yaml` file contains metadata about each stack:
- Available versions
- Base images
- Port configurations
- VNC requirements

## Customization

To customize the generated Dockerfiles, modify the `generate-variants.sh` script:

1. Update the `extract_core_info()` function to parse stack-specific variables
2. Modify the generation functions (`generate_gitpod()`, `generate_code_server()`, `generate_devcontainer()`)
3. Add stack-specific logic in the case statements

## Benefits

- **Consistency**: All variants follow the same patterns
- **Maintainability**: Only need to update core Dockerfiles
- **Scalability**: Easy to add new versions or stacks
- **Reduced Errors**: Automated generation prevents copy-paste mistakes

## Example Workflow

When adding a new version of an existing stack:

```bash
# 1. Copy the latest core Dockerfile
cp flutter/v3.32/core/Dockerfile flutter/v3.33/core/Dockerfile

# 2. Update version numbers in the new core Dockerfile
sed -i '' 's/3.32/3.33/g' flutter/v3.33/core/Dockerfile

# 3. Generate all variants
./scripts/generate-variants.sh flutter v3.33

# 4. Verify the generated files
ls flutter/v3.33/
# Output: core/  gitpod/  code-server/  devcontainer/
```

## Troubleshooting

- **Script not found**: Make sure to run from the repository root
- **Permission denied**: Run `chmod +x scripts/generate-variants.sh`
- **Core Dockerfile not found**: Ensure the core Dockerfile exists before running
- **Syntax errors**: Check that the core Dockerfile follows the expected format