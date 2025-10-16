# Build Documentation

This project uses [just](https://github.com/casey/just) as a command runner to simplify common development tasks.

## Installing Just

### Via Cargo (Recommended)

If you have Rust installed, you can install `just` using cargo:

```bash
cargo install just
```

### Other Installation Methods

- **macOS (Homebrew)**: `brew install just`
- **Ubuntu/Debian**: `sudo apt install just`
- **Arch Linux**: `pacman -S just`
- **Windows (Scoop)**: `scoop install just`
- **Windows (Chocolatey)**: `choco install just`

For more installation options, see the [just installation guide](https://github.com/casey/just#installation).

## Available Commands

Run `just` or `just --list` to see all available commands:

```bash
just --list
```

## Tool Installation Commands

These recipes install development tools inside the container:

### Language Runtimes

- `just install-go` - Install Go (configurable via `GO_VERSION`)
- `just install-rust` - Install Rust toolchain via rustup
- `just install-node` - Install Node.js via nvm
- `just install-java` - Install Java Development Kit

### Build Tools

- `just install-maven` - Install Apache Maven (requires Java)
- `just install-gradle` - Install Gradle (requires Java)

### Package Managers

- `just install-homebrew` - Install Homebrew (linuxbrew) for Linux containers

### CLI Tools

- `just install-github-cli` - Install GitHub CLI (`gh`)
- `just install-azure-cli` - Install Azure CLI (script-based method)
- `just install-brew-azure-cli` - Install Azure CLI via Homebrew (more reliable)

### Homebrew-Based Installs

- `just install-brew-codex` - Install codex via Homebrew
- `just install-brew-opencode` - Install opencode via Homebrew
- `just install-brew-wassette` - Install Wassette MCP server via Homebrew

### AI CLI Tools (via npm)

- `just install-cli-claude` - Install Claude CLI
- `just install-cli-gemini` - Install Gemini CLI
- `just install-cli-crush` - Install Crush CLI
- `just install-cli-copilot` - Install GitHub Copilot CLI
- `just install-cli-npm` - Install all AI CLI tools at once

### LLM Tools

- `just install-llm` - Install Simon Willison's llm tool
- `just install-llm-plugins` - Install llm plugins (gpt4all, sentence-transformers, embed-jina, cluster)

### Wassette MCP Server

- `just install-wassette` - Build Wassette from source using cargo
- `just install-wassette-link` - Symlink Wassette binary to `/usr/local/bin`

### Configuration

- `just setup-mcp-config` - Copy MCP configuration to `.vscode/mcp.json`
- `just configure-npm-prefix` - Configure npm global prefix for vscode user

### Install Everything

- `just install-all` - Install all tools (Go, Rust, Node, Java, Maven, Gradle, GitHub CLI, Homebrew tools, Azure CLI, AI CLIs, LLM)

## Container Commands (macOS)

These commands work with macOS Container CLI (`container` command):

### Build

- `just macos-build-container` - Build container image with default settings
- `just macos-build-container-all` - Build container image with `JUST_RECIPE=install-all`

### Run & Manage

- `just macos-run-container` - Run container interactively with port 8080 published
- `just macos-stop-containers` - Stop all running containers
- `just macos-restart-containers` - Restart all containers
- `just macos-list-containers` - List containers (formatted)
- `just macos-list-containers-json` - List containers (JSON format)
- `just macos-clean-containers` - Remove all containers and images

## Container Commands (Docker)

These commands work with standard Docker:

### Build

- `just docker-build` - Build Docker image with default settings
- `just docker-build-all` - Build Docker image with `JUST_RECIPE=install-all`

### Run & Manage

- `just docker-run` - Run Docker container interactively with port 8080 published
- `just docker-stop` - Stop the running container
- `just docker-restart` - Restart the container
- `just docker-list` - List running containers
- `just docker-clean` - Remove containers and images

## Configuration Variables

The Justfile uses several configurable variables:

- `GO_VERSION` - Go version to install (default: `1.23.2`)
- `TARGETARCH` - Target architecture (default: `arm64`)
- `IMAGE` - Container image name (default: `ghcr.io/asw101/codespaces/just`)
- `CONTAINER_NAME` - Container name (default: `codespaces-just`)
- `DEVCONTAINER_JUST` - Path to just devcontainer directory
- `WASSETTE_REF_TYPE` - Wassette reference type (`branch` or `tag`)
- `WASSETTE_REF` - Wassette git reference (commit, branch, or tag)

## Example Workflows

### Quick Start in Codespaces

The container comes with just preinstalled. Install tools on-demand:

```bash
# Install Go
just install-go

# Install Azure CLI via Homebrew
just install-brew-azure-cli

# Install all AI CLI tools
just install-cli-npm
```

### Full Installation

Install everything at once:

```bash
just install-all
```

### Local Development (macOS)

Build and run the container locally using macOS Container CLI:

```bash
# Build the container
just macos-build-container

# Run it interactively
just macos-run-container

# List running containers
just macos-list-containers

# Clean up when done
just macos-clean-containers
```

### Local Development (Docker)

Build and run using Docker:

```bash
# Build the image
just docker-build

# Run it interactively
just docker-run

# Stop the container
just docker-stop

# Clean up
just docker-clean
```

### Build with All Tools Preinstalled

Create a fully-loaded image:

```bash
# Using macOS Container CLI
just macos-build-container-all

# Using Docker
just docker-build-all
```

## Justfile Location

The Justfile is located in the root of the repository. You can examine it to see exactly what each command does or add your own custom recipes.
