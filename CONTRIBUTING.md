# Contributing to Dev Workspaces

Thank you for your interest in contributing to Dev Workspaces! This guide will help you get started with contributing to our multi-platform development environment repository.

## 🎯 Contribution Areas

We welcome contributions in the following areas:

1. **New Technology Stacks** - Add support for new languages/frameworks
2. **Version Updates** - Update existing stacks to newer versions
3. **Bug Fixes** - Fix issues in existing Dockerfiles
4. **Documentation** - Improve READMEs and guides
5. **CI/CD Improvements** - Enhance our automation workflows
6. **Security Updates** - Address vulnerabilities and security issues

## ⚡ Quick Example: Adding Flutter v3.33

Here's how easy it is to add a new version using our scripts:

```bash
# 1. Create the new version from the latest
./scripts/add-new-version.sh flutter v3.33

# 2. Update the core Dockerfile with new version
vim flutter/v3.33/core/Dockerfile
# Change: ENV FLUTTER_VERSION=3.33.0
# Change: LABEL org.opencontainers.image.version="v3.33"

# 3. Generate all variants automatically
./scripts/generate-variants.sh flutter v3.33

# 4. Test your work
docker build -t test-flutter flutter/v3.33/core/

# That's it! You now have:
# - flutter/v3.33/core/Dockerfile (your manual edit)
# - flutter/v3.33/gitpod/Dockerfile (auto-generated)
# - flutter/v3.33/code-server/Dockerfile (auto-generated)
# - flutter/v3.33/devcontainer/Dockerfile (auto-generated)
# - flutter/v3.33/devcontainer/devcontainer.json (auto-generated)
```

## 🚀 Getting Started

1. **Fork the Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/dev-workspaces.git
   cd dev-workspaces
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing structure and conventions
   - Use the templates in `/templates` directory
   - Test your changes locally

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add support for Ruby v3.3"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## 📋 Contribution Guidelines

### 🤖 Using Our Automation Scripts

We've automated Dockerfile generation to ensure consistency and reduce maintenance. **You only need to create the core Dockerfile** - our scripts will generate the rest!

#### Quick Start with Scripts

1. **Adding a new version to an existing stack**:
   ```bash
   # Automatically creates v3.33 based on the latest version
   ./scripts/add-new-version.sh flutter v3.33
   
   # Edit the core Dockerfile to update version-specific details
   vim flutter/v3.33/core/Dockerfile
   
   # Generate all variants (gitpod, code-server, devcontainer)
   ./scripts/generate-variants.sh flutter v3.33
   ```

2. **Regenerating variants after updating a core Dockerfile**:
   ```bash
   # For a specific stack/version
   ./scripts/generate-variants.sh nextjs v15
   
   # For all stacks (useful after major updates)
   ./scripts/generate-variants.sh all
   ```

3. **Testing your changes**:
   ```bash
   # Clean up existing variants
   ./scripts/cleanup-variants.sh
   
   # Regenerate everything
   ./scripts/generate-variants.sh all
   ```

### Adding a New Technology Stack

1. **Create the directory structure** (only core is required):
   ```
   stack-name/
   ├── README.md          # Stack overview (use templates/README-stack.md)
   └── v1.0/
       └── core/
           └── Dockerfile  # Only this is manually created!
   ```

2. **Create the core Dockerfile**:
   - Use minimal base image appropriate for the stack
   - Include essential tools and dependencies
   - Follow the pattern from existing core Dockerfiles
   - Include all required OCI labels:
     ```dockerfile
     LABEL org.opencontainers.image.source="https://github.com/W3Dev/dev-workspaces"
     LABEL org.opencontainers.image.description="Your Stack v1.0 core development environment"
     LABEL org.opencontainers.image.version="v1.0"
     ```

3. **Update the generation script** (if needed):
   - Edit `scripts/generate-variants.sh` to add stack-specific logic
   - Add extraction logic in `extract_core_info()`
   - Add generation logic in the variant functions

4. **Generate all variants**:
   ```bash
   ./scripts/generate-variants.sh stack-name v1.0
   ```

5. **Documentation Requirements**:
   - Complete stack README with all sections filled
   - The script will create all variant directories
   - Test all generated Dockerfiles locally

### Adding a New Version to Existing Stack

1. **Use the helper script**:
   ```bash
   ./scripts/add-new-version.sh python v3.14
   ```

2. **Update the core Dockerfile**:
   - Change version numbers
   - Add new features specific to this version
   - Remove deprecated features
   - Update any hardcoded package versions

3. **Generate variants**:
   ```bash
   ./scripts/generate-variants.sh python v3.14
   ```

4. **Update documentation**:
   - Add the new version to `stack/README.md`
   - Update main README.md if it's the latest version
   - Add migration notes from previous version

### Updating Existing Stacks

1. **Bug Fixes in Core Dockerfiles**:
   ```bash
   # Edit the core Dockerfile
   vim flutter/v3.32/core/Dockerfile
   
   # Regenerate all variants to apply the fix
   ./scripts/generate-variants.sh flutter v3.32
   ```

2. **Updating All Versions of a Stack**:
   ```bash
   # Make changes to each core Dockerfile
   for version in flutter/*/core/Dockerfile; do
     # Apply your changes
     vim "$version"
   done
   
   # Regenerate all Flutter variants
   for version in v3.32 v3.29 v3.24; do
     ./scripts/generate-variants.sh flutter "$version"
   done
   ```

### Important Notes About the Scripts

1. **Core Dockerfile Format**:
   - The script extracts information from specific patterns
   - Keep labels and ENV variables in standard format
   - Use comments like `# Flutter v3.32 Core Development Environment`

2. **What the Script Generates**:
   - **gitpod/Dockerfile**: Gitpod-optimized with cloud tools
   - **code-server/Dockerfile**: Includes VS Code in browser
   - **devcontainer/Dockerfile**: For GitHub Codespaces
   - **devcontainer/devcontainer.json**: VS Code configuration

3. **Customizing Generated Files**:
   - Don't edit generated files directly (they'll be overwritten)
   - Instead, update the generation logic in `scripts/generate-variants.sh`
   - Stack-specific logic goes in the case statements

4. **Testing Generated Dockerfiles**:
   ```bash
   # Build and test locally
   cd nextjs/v15/gitpod
   docker build -t test-nextjs-gitpod .
   docker run -it test-nextjs-gitpod
   ```

### Commit Message Format

We follow conventional commits:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

Examples:
```
feat(flutter): add support for Flutter v3.33
fix(python): correct pip installation in v3.12
docs(react-native): update setup instructions
```

## 🔄 Recommended Workflow

### For New Contributors

1. **Start with the core Dockerfile**:
   - Focus on creating a minimal, working core/Dockerfile
   - Don't worry about variants - the script handles those
   - Test your core Dockerfile thoroughly

2. **Use the scripts**:
   ```bash
   # After creating core/Dockerfile
   ./scripts/generate-variants.sh your-stack v1.0
   
   # Check the generated files
   ls your-stack/v1.0/
   # Output: core/ gitpod/ code-server/ devcontainer/
   ```

3. **Test all variants**:
   ```bash
   # Test each generated variant
   for variant in core gitpod code-server devcontainer; do
     echo "Testing $variant..."
     docker build -t test-$variant your-stack/v1.0/$variant/
   done
   ```

### Best Practices

1. **Core Dockerfile Guidelines**:
   - Keep it minimal - only essential tools
   - Use specific version tags (not :latest)
   - Include clear comments about the stack/version
   - Follow existing patterns from other stacks

2. **Version Naming**:
   - Always use 'v' prefix: v3.32, v1.0, v2.3
   - Match official version numbers when possible
   - Use semantic versioning for consistency

3. **Stack Naming**:
   - Use lowercase: flutter, nextjs, react-native
   - Use hyphens for multi-word: react-native
   - Keep names consistent with official branding

## 🧪 Testing

### Local Testing

1. **Test Core Dockerfile First**:
   ```bash
   cd stack-name/version/core
   docker build -t test-core .
   docker run -it test-core /bin/bash
   
   # Test stack-specific commands
   docker run --rm test-core flutter --version
   ```

2. **Test Generated Variants**:
   ```bash
   # Generate all variants
   ./scripts/generate-variants.sh stack-name version
   
   # Test Gitpod variant
   cd stack-name/version/gitpod
   docker build -t test-gitpod .
   docker run --rm -u gitpod test-gitpod whoami
   
   # Test code-server variant
   cd ../code-server
   docker build -t test-code-server .
   docker run -d -p 8080:8080 test-code-server
   # Visit http://localhost:8080
   
   # Test devcontainer
   # Best tested in VS Code with Remote-Containers extension
   ```

3. **Automated Testing**:
   ```bash
   # Our CI will automatically:
   # - Validate Dockerfile syntax
   # - Build all variants
   # - Run security scans
   # - Check for required labels
   ```

### CI/CD Testing

Our GitHub Actions will automatically:
- Validate Dockerfile syntax with Hadolint
- Build and test images
- Run security scans with Trivy
- Check for required labels and structure

## 📝 Documentation Standards

### Stack README Structure
- Overview and supported versions
- Platform compatibility table
- Quick start examples for each platform
- Common features list
- Links to version-specific docs

### Version README Structure
- Exact version information
- Included tools and features
- Platform-specific configurations
- Environment variables
- Build instructions
- Migration guide from previous version
- Known issues

## 🔒 Security Guidelines

1. **Base Images**
   - Use official base images when possible
   - Pin specific versions (avoid `:latest`)
   - Regularly update base images

2. **Package Installation**
   - Verify package signatures
   - Use specific versions
   - Clean up package managers after installation

3. **User Permissions**
   - Don't run as root in production
   - Support multiple user contexts
   - Set appropriate file permissions

4. **Secrets**
   - Never include secrets in Dockerfiles
   - Use build arguments for sensitive data
   - Document required environment variables

## 🎨 Code Style

### Dockerfile Best Practices
- One instruction per line for readability
- Group related commands with `&&`
- Clean up in the same layer
- Order from least to most frequently changing
- Use meaningful comments

### Shell Scripts
- Use `set -euo pipefail` for safety
- Quote variables: `"${VAR}"`
- Use meaningful variable names
- Add error handling

## 🤝 Review Process

1. **Automated Checks**
   - All CI checks must pass
   - No security vulnerabilities
   - Dockerfile validation successful

2. **Manual Review**
   - Code quality and best practices
   - Documentation completeness
   - Testing evidence
   - Multi-platform compatibility

3. **Merge Requirements**
   - At least one approving review
   - All conversations resolved
   - Branch up to date with main

## 🔧 Troubleshooting Script Issues

### Common Problems and Solutions

1. **Script not generating variants**:
   ```bash
   # Error: Core Dockerfile not found
   # Solution: Ensure core/Dockerfile exists
   ls stack-name/version/core/Dockerfile
   ```

2. **Generated Dockerfile has wrong versions**:
   ```bash
   # The script extracts versions from ENV and LABEL lines
   # Ensure your core Dockerfile has:
   ENV FLUTTER_VERSION=3.32.0  # For version-specific tools
   LABEL org.opencontainers.image.version="v3.32"  # For image version
   ```

3. **Custom stack not working with script**:
   ```bash
   # Add your stack logic to scripts/generate-variants.sh:
   # 1. In extract_core_info() function
   # 2. In each generate_* function's case statement
   ```

4. **Need to customize generated output**:
   - Don't edit generated files
   - Modify the template in `generate-variants.sh`
   - Re-run the script to apply changes

### Script Debugging

```bash
# Run with bash debugging
bash -x ./scripts/generate-variants.sh stack version

# Check what the script extracted
grep -E "ENV|LABEL|FROM" stack/version/core/Dockerfile
```

## 📮 Communication

- **Issues**: Report bugs or request features
- **Discussions**: Ask questions or propose ideas
- **Pull Requests**: Submit your contributions
- **Email**: dev@w3dev.io for private concerns

## 🙏 Recognition

Contributors will be:
- Listed in our README (via contrib.rocks)
- Mentioned in release notes
- Given credit in commit messages

Thank you for helping make Dev Workspaces better for everyone!