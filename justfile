# justfile for building and testing devcontainers locally

# Default recipe - show available commands
default:
    @just --list

# Build the ai-container devcontainer locally
build-ai-container tag="latest":
    #!/usr/bin/env bash
    echo "Building ai-container devcontainer..."
    if docker build \
        -t codespaces-ai:{{tag}} \
        -t ghcr.io/asw101/codespaces/ai:{{tag}} \
        .devcontainer/ai-container/; then
        echo "✅ Built ai-container as codespaces-ai:{{tag}}"
    else
        echo "❌ Build failed for ai-container"
        exit 1
    fi

# Run the ai-container interactively for testing
test-ai-container tag="latest":
    #!/usr/bin/env bash
    echo "Starting ai-container for testing..."
    docker run -it --rm \
        -v $(pwd):/workspace \
        -w /workspace \
        --name test-ai-container \
        codespaces-ai:{{tag}} \
        bash

# Run the ai-container as a background service (like VS Code would)
run-ai-container tag="latest":
    #!/usr/bin/env bash
    echo "Starting ai-container in background..."
    docker run -d \
        -v $(pwd):/workspace \
        -w /workspace \
        -p 8080:8080 \
        --name ai-container-service \
        codespaces-ai:{{tag}} \
        tail -f /dev/null
    echo "✅ ai-container running as 'ai-container-service'"
    echo "Use 'just exec-ai-container' to get a shell"

# Stop the background ai-container service
stop-ai-container:
    #!/usr/bin/env bash
    echo "Stopping ai-container service..."
    docker stop ai-container-service || true
    docker rm ai-container-service || true
    echo "✅ ai-container service stopped"

# Build and test ai-container in one command
build-and-test-ai tag="latest":
    just build-ai-container {{tag}}
    just test-ai-container {{tag}}

# Clean up Docker images and containers
clean:
    #!/usr/bin/env bash
    echo "Cleaning up Docker resources..."
    docker stop ai-container-service 2>/dev/null || true
    docker rm ai-container-service 2>/dev/null || true
    docker rmi codespaces-ai:latest 2>/dev/null || true
    docker rmi ghcr.io/asw101/codespaces/ai:latest 2>/dev/null || true
    echo "✅ Cleanup complete"

# Test specific tools inside the container
test-tools tag="latest":
    #!/usr/bin/env bash
    echo "Testing tools in ai-container..."
    docker run --rm codespaces-ai:{{tag}} bash -c "
        echo '=== Go version ==='
        go version
        echo
        echo '=== Rust version ==='
        rustc --version
        cargo --version
        echo
        echo '=== Node.js version ==='
        node --version
        npm --version
        echo
        echo '=== Azure CLI ==='
        az --version | head -1
        echo
        echo '=== GitHub CLI ==='
        gh --version
        echo
        echo '=== Wassette ==='
        wassette --version
        echo
        echo '=== NPM global packages ==='
        npm list -g --depth=0
    "
