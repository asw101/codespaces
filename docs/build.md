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

### Container Commands

#### `just build-ai-container [tag="latest"]`
Builds the ai-container devcontainer locally with the specified tag.

```bash
# Build with default tag (latest)
just build-ai-container

# Build with custom tag
just build-ai-container v1.0.0
```

#### `just test-ai-container [tag="latest"]`
Runs the ai-container interactively for testing purposes.

```bash
just test-ai-container
```

#### `just run-ai-container [tag="latest"]`
Starts the ai-container as a background service (similar to how VS Code would run it).

```bash
just run-ai-container
```

#### `just stop-ai-container`
Stops and removes the background ai-container service.

```bash
just stop-ai-container
```

### Development Workflow Commands

#### `just build-and-test-ai [tag="latest"]`
Builds and then tests the ai-container in one command.

```bash
just build-and-test-ai
```

#### `just test-tools [tag="latest"]`
Tests all the installed tools inside the container to verify they're working correctly.

```bash
just test-tools
```

This will test:
- Go version
- Rust version (rustc and cargo)
- Node.js and npm versions
- Azure CLI
- GitHub CLI
- Wassette
- NPM global packages

### Cleanup Commands

#### `just clean`
Cleans up Docker images and containers related to the project.

```bash
just clean
```

## Example Workflow

Here's a typical development workflow using just:

1. **Build the container:**
   ```bash
   just build-ai-container
   ```

2. **Test that all tools work:**
   ```bash
   just test-tools
   ```

3. **Run interactive testing:**
   ```bash
   just test-ai-container
   ```

4. **Clean up when done:**
   ```bash
   just clean
   ```

## Justfile Location

The justfile is located in the root of the repository and contains all the command definitions. You can examine it to see exactly what each command does or to add your own custom commands.