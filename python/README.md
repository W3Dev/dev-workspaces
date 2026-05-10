# Python Development Environments

This directory contains Docker images for Python development across multiple versions, optimized for use with Gitpod, GitHub Codespaces (via Devcontainers), and OpenAI Codex.

## Available Versions

| Version | Status | Release Date | End of Support | Features |
|---------|--------|--------------|----------------|----------|
| v3.13 | Stable | Oct 2024 | Oct 2029 | Latest features, improved performance |
| v3.12 | Stable | Oct 2023 | Oct 2028 | Type parameter syntax, per-interpreter GIL |
| v3.11 | Stable | Oct 2022 | Oct 2027 | Exception groups, task groups |

## Platform Compatibility

All images in this directory are compatible with:

- ✅ **Gitpod** - Full support with pyenv for version management
- ✅ **GitHub Codespaces** - Via Devcontainers specification
- ✅ **OpenAI Codex** - Optimized for AI-assisted development
- ✅ **Local Docker** - Standard Docker/Docker Compose workflows

## Quick Start

### Using with Gitpod

Add this to your `.gitpod.yml`:

```yaml
image: ghcr.io/w3dev/dev-workspaces/python:v3.13-gitpod
tasks:
  - init: pip install -r requirements.txt
    command: python app.py
```

### Using with Docker

```bash
docker pull ghcr.io/w3dev/dev-workspaces/python:v3.13-core
docker run -it -p 8000:8000 -v $(pwd):/workspace ghcr.io/w3dev/dev-workspaces/python:v3.13-core
```

## Common Features

All Python images include:

- Python (specified version)
- pip, setuptools, wheel (latest)
- pipenv and poetry for dependency management
- virtualenv for environment isolation
- Git and build essentials
- Common development tools

## Image Variants

Each version offers:

1. **core** - Minimal Python setup with essential tools
2. **gitpod** - Includes pyenv, black, flake8, mypy, pytest

## Python Commands

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Install with pipenv
pipenv install
pipenv shell

# Install with poetry
poetry install
poetry shell

# Run scripts
python script.py

# Start development server (Flask)
flask run

# Start development server (Django)
python manage.py runserver

# Run tests
pytest
# or
python -m unittest
```

## Package Management

### pip (Traditional)
```bash
pip install package
pip freeze > requirements.txt
pip install -r requirements.txt
```

### pipenv (Recommended)
```bash
pipenv install package
pipenv install --dev pytest  # dev dependency
pipenv lock
pipenv sync
```

### poetry (Modern)
```bash
poetry add package
poetry add --dev pytest  # dev dependency
poetry lock
poetry install
```

## Development Tools Included

- **black** - Code formatter
- **flake8** - Linter
- **mypy** - Type checker
- **pytest** - Testing framework
- **ipython** - Enhanced interactive shell

## Creating Projects

```bash
# Flask project
pip install flask
flask init-app

# Django project
pip install django
django-admin startproject myproject

# FastAPI project
pip install fastapi uvicorn
# Create main.py manually
```

## Environment Variables

Use `.env` files with python-dotenv:

```python
from dotenv import load_dotenv
load_dotenv()
```

## Support and Issues

For issues specific to these Docker images, please open an issue in this repository.
For Python-specific issues, refer to the [official Python documentation](https://docs.python.org/).

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.