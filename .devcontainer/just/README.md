# Just DevContainer

A flexible development container built with [Just](https://github.com/casey/just) for orchestrating optional development tools and components.

## Overview

This devcontainer provides a base Ubuntu environment with Just pre-installed, allowing you to selectively install development tools as needed. You can build either a minimal base image or a fully-loaded image with all components pre-installed.

## Quick Start

### Building the Container

**Base image (minimal, ~200MB):**

Docker:
```bash
just build-docker
```

macOS containers:
```bash
just build-macos-container
```

**Full image (all components pre-installed):**

Docker:
```bash
just build-docker-all
```

macOS containers:
```bash
just build-macos-container-all
```

### Running the Container

**Docker:**

Default port (8080):
```bash
just run-docker
```

Custom port:
```bash
PORT=8081 just run-docker
```

**macOS Containers:**

Default port (8080):
```bash
just run-macos-container
```

Custom port:
```bash
PORT=8081 just run-macos-container
```

### Managing Containers

```bash
# Stop all running containers based on the image
just stop-containers
```

## Available Components

### Core Languages & Runtimes

- **Go** (`install-go`) - Go 1.25.1 with architecture detection
- **Rust** (`install-rust`) - Rust stable toolchain via rustup
- **Node.js** (`install-node`) - Node.js LTS with npm
- **Java** (`install-java`) - OpenJDK 21
- **Maven** (`install-maven`) - Apache Maven 3.9.9 (requires Java)
- **Gradle** (`install-gradle`) - Gradle 8.11.1 (requires Java)

### CLI Tools

- **Azure CLI** (`install-azure-cli`) - Azure CLI with Bicep
- **GitHub CLI** (`install-github-cli`) - GitHub CLI (gh)
- **Homebrew** (`install-homebrew`) - Homebrew package manager for Linux

### Homebrew Packages

- **Codex** (`install-brew-codex`) - Codex CLI tool
- **OpenCode** (`install-brew-opencode`) - OpenCode from SST tap

### AI/ML Tools

- **LLM** (`install-llm`) - Simon Willison's LLM tool (core)
- **LLM Plugins** (`install-llm-plugins`) - Claude, Gemini, Ollama, Foundry plugins
- **LLM GPT4All** (`install-llm-gpt4all`) - GPT4All plugin (optional, may have compatibility issues)

### npm Global Packages

- **npm CLIs** (`install-cli-npm`) - Anthropic Claude, Google Gemini, Crush, GitHub Copilot

### WebAssembly & MCP

- **Wassette** (`install-wassette`) - Microsoft Wassette MCP server
- **Link Wassette** (`link-wassette`) - Symlink Wassette to system path

## Usage Patterns

### Install Everything

```bash
just install-all
```

This installs: Go, Rust, Node.js, Java, Maven, Gradle, Azure CLI, GitHub CLI, Homebrew, Codex, OpenCode, npm CLIs, LLM with plugins, and Wassette.

### Install Specific Components

```bash
# Just the languages
just install-go
just install-rust
just install-node
just install-java

# Java build tools
just install-maven
just install-gradle

# Just AI tools
just install-llm
just install-llm-plugins

# Just CLI tools
just install-azure-cli
just install-github-cli
```

### Sequential Installation

Install multiple components in order:
```bash
just run-sequential install-go install-rust install-node
```

### Custom Combinations

Create your own installation combinations by listing dependencies:
```bash
# Python-focused setup
just install-llm install-llm-plugins install-azure-cli

# JavaScript-focused setup
just install-node configure-npm-prefix install-cli-npm

# Java-focused setup
just install-java install-maven install-gradle
```

## Configuration

### Environment Variables

Override defaults by setting environment variables:

```bash
# Change Go version
GO_VERSION=1.24.0 just install-go

# Use different image name
JUST_IMAGE=mydev:latest just build-docker

# Use different container command
CONTAINER_CMD=zsh just run-docker

# Use different port
PORT=3000 just run-docker

# Target different architecture
TARGETARCH=arm64 just build-docker

# Use different Wassette version
WASSETTE_REF=v1.0.0 WASSETTE_REF_TYPE=tag just install-wassette
```

### Shell Completions

Enable tab completion for Just inside the container:
```bash
just setup-completions
```

Then restart your shell or source your config:

For bash:
```bash
source ~/.bashrc
```

For zsh:
```bash
source ~/.zshrc
```

## Architecture

### Variables
- `arch` - Auto-detected system architecture (amd64/arm64)
- `GO_VERSION` - Go version to install (default: 1.25.1)
- `TARGETARCH` - Target architecture for builds
- `IMAGE` - Container image name (default: just-dev:latest)
- `CONTAINER_CMD` - Command to run in container (default: bash)
- `PORT` - Port to expose (default: 8080)
- `WASSETTE_REF` - Wassette git reference (default: main)
- `WASSETTE_REF_TYPE` - Reference type: branch/tag (default: branch)

### Recipe Dependencies

Recipes automatically handle dependencies:
- `configure-npm-prefix` → `install-node`
- `install-cli-npm` → `configure-npm-prefix` → `install-node`
- `install-maven` → `install-java`
- `install-gradle` → `install-java`
- `install-brew-codex` → `install-homebrew`
- `install-llm-plugins` → `install-llm`
- `link-wassette` → `install-wassette`

## Tips & Best Practices

1. **Start minimal**: Build the base image and install only what you need
2. **Use the :all tag**: For CI/CD or shared environments, pre-build with `build-docker-all`
3. **Layer installations**: Install related tools together to optimize build cache
4. **Custom recipes**: Add your own recipes to the Justfile for project-specific setups
5. **Port conflicts**: Use `PORT=` to avoid conflicts when running multiple containers

## Troubleshooting

### Port Already in Use

Stop existing containers first:
```bash
just stop-containers
```

Or use a different port:
```bash
PORT=8081 just run-macos-container
```

### dpkg Not Found (macOS)
The Justfile uses `uname -m` for cross-platform architecture detection, so it works on both Linux and macOS.

### npm Command Not Found
Ensure dependencies are installed in order:
```bash
just install-node
just configure-npm-prefix
just install-cli-npm
```

### LLM GPT4All Errors
The GPT4All plugin may have shared library issues. Use the stable plugins instead:
```bash
just install-llm
just install-llm-plugins
```

## Image Variants

### Base Image (`just-dev:latest`)
- Ubuntu base
- Just command runner
- Essential system utilities
- ~200MB

### Full Image (`just-dev:all`)
- Everything from base
- All languages, runtimes, and tools pre-installed
- Ready for immediate use
- ~3-4GB (varies by components)

## Contributing

To add new components:

1. Create a new recipe in the Justfile
2. Follow the naming convention: `install-<component>`
3. Use recipe dependencies for prerequisites
4. Add proper error handling with `set -euxo pipefail`
5. Update `install-all` if the component should be included by default

## Building with GitHub Actions

The repository includes a GitHub Actions workflow for building devcontainer images. You can use it to build the just container with custom configurations.

### Triggering a Build

1. Go to the **Actions** tab in your GitHub repository
2. Select the **Build Single DevContainer** workflow
3. Click **Run workflow**
4. Configure the build:
   - **DevContainer to build**: Select `just`
   - **Image tag**: Specify the tag (e.g., `latest`, `all`, `v1.0.0`)
   - **Build arguments**: Optional build arguments (comma-separated, e.g., `INSTALL_ALL=true,GO_VERSION=1.24.0`)

### Build Examples

**Minimal just container:**
```
DevContainer: just
Image tag: latest
Build arguments: (empty)
```
Result: `ghcr.io/owner/repo/just:latest`

**Full just container with all components:**
```
DevContainer: just
Image tag: all
Build arguments: INSTALL_ALL=true
```
Result: `ghcr.io/owner/repo/just:all`

**Custom configuration:**
```
DevContainer: just
Image tag: go1.24-full
Build arguments: INSTALL_ALL=true,GO_VERSION=1.24.0,TARGETARCH=arm64
```
Result: `ghcr.io/owner/repo/just:go1.24-full` with Go 1.24.0 and all components

### Available Build Arguments

- `INSTALL_ALL` - Set to `true` to install all components during build (default: `false`)
- `GO_VERSION` - Go version to install (default: `1.25.1`)
- `TARGETARCH` - Target architecture: `amd64` or `arm64` (default: auto-detected)

### Multi-platform Builds

The GitHub Actions workflow automatically builds for both `linux/amd64` and `linux/arm64/v8` platforms, ensuring your images work on both x86_64 and ARM64 systems.

## License

See the [LICENSE](../../LICENSE) file in the repository root.
