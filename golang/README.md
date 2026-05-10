# Go Development Environments

This directory contains Docker images for Go (Golang) development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | Features |
|---------|--------|--------------|----------|
| v1.23 | Stable | Aug 2024 | Range-over-func, improved tooling |
| v1.22 | Stable | Feb 2024 | Enhanced performance, loop variable fix |
| v1.21 | Stable | Aug 2023 | Built-in functions, improved WASI support |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with Go workspace
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/golang:v1.23-core
tasks:
  - init: go mod download
    command: go run main.go
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/golang:v1.23-core
docker run -it -p 8080:8080 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/golang:v1.23-core
```

## Common Features

All Go images include:

- Go compiler and tools (specified version)
- Git and build essentials
- gopls (Go language server)
- delve debugger
- Common ports exposed (8080)

## Image Variants

Currently available variant:

1. **core** - Alpine-based minimal Go setup with essential tools

## Go Commands

```bash
# Initialize module
go mod init github.com/user/project

# Download dependencies
go mod download
go mod tidy

# Run program
go run main.go
go run .

# Build binary
go build
go build -o myapp

# Run tests
go test
go test ./...
go test -v -cover ./...

# Format code
go fmt ./...

# Lint code
go vet ./...

# Install tools
go install github.com/user/tool@latest
```

## Project Structure

```
myproject/
├── go.mod
├── go.sum
├── main.go
├── internal/
│   └── pkg/
├── pkg/
├── cmd/
│   └── myapp/
│       └── main.go
└── test/
```

## Development Tools

### Installed in images:
- **gopls** - Language server for IDE features
- **delve** - Debugger for Go

### Recommended tools:
```bash
# Linter
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Test coverage
go test -coverprofile=coverage.out
go tool cover -html=coverage.out

# Benchmarking
go test -bench=.

# Race detector
go test -race
```

## Environment Variables

```bash
# Go-specific
export GOPROXY=https://proxy.golang.org
export GOPRIVATE=github.com/mycompany/*
export CGO_ENABLED=0  # For static binaries

# Application
export PORT=8080
export DATABASE_URL=postgres://...
```

## Creating a Web Server

```go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, World!")
    })
    
    fmt.Println("Server starting on :8080")
    http.ListenAndServe(":8080", nil)
}
```

## Go Modules

```bash
# Create module
go mod init mymodule

# Add dependency
go get github.com/gin-gonic/gin

# Update dependencies
go get -u ./...

# Remove unused dependencies
go mod tidy

# Vendor dependencies
go mod vendor
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Go-specific issues, refer to the [official Go documentation](https://go.dev/doc/).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.