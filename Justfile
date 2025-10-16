set shell := ["bash", "-uc"]

arch := `uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'`
GO_VERSION := env_var_or_default("GO_VERSION", "1.25.1")
TARGETARCH := env_var_or_default("TARGETARCH", arch)
IMAGE := env_var_or_default("JUST_IMAGE", "just-dev:latest")
CONTAINER_CMD := env_var_or_default("JUST_CONTAINER_CMD", "bash")
WASSETTE_REF := env_var_or_default("WASSETTE_REF", "main")
WASSETTE_REF_TYPE := env_var_or_default("WASSETTE_REF_TYPE", "branch")
PORT := env_var_or_default("PORT", "8080")
CONTAINER_MEMORY := env_var_or_default("CONTAINER_MEMORY", "4g")
CONTAINER_CPUS := env_var_or_default("CONTAINER_CPUS", "2")

# Path to devcontainer just directory
DEVCONTAINER_JUST := ".devcontainer/just"

export CARGO_HOME := "/home/vscode/.cargo"
export RUSTUP_HOME := "/home/vscode/.rustup"

vscode := "sudo --preserve-env=PATH --set-home --login --user vscode"

alias default := list

list:
    just --list

run *recipes:
    #!/usr/bin/env bash
    set -euxo pipefail
    for recipe in {{recipes}}; do
        echo "Running recipe: $recipe"
        just "$recipe"
    done

setup-completions:
    #!/usr/bin/env bash
    set -euxo pipefail
    # Setup bash completion
    mkdir -p /etc/bash_completion.d
    just --completions bash > /etc/bash_completion.d/just
    # Setup zsh completion for vscode user
    mkdir -p /home/vscode/.zsh/completion
    just --completions zsh > /home/vscode/.zsh/completion/_just
    chown -R vscode:vscode /home/vscode/.zsh
    # Add to vscode's .zshrc if not already there
    if [ -f /home/vscode/.zshrc ]; then
        if ! grep -q "fpath=(.*\.zsh/completion" /home/vscode/.zshrc; then
            echo 'fpath=(~/.zsh/completion $fpath)' >> /home/vscode/.zshrc
            echo 'autoload -Uz compinit && compinit' >> /home/vscode/.zshrc
        fi
    else
        echo 'fpath=(~/.zsh/completion $fpath)' > /home/vscode/.zshrc
        echo 'autoload -Uz compinit && compinit' >> /home/vscode/.zshrc
        chown vscode:vscode /home/vscode/.zshrc
    fi
    echo "Completions installed. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"

# Update apt cache (idempotent - safe to call multiple times)
# Use force=true to bypass cache check: just apt-update force=true
apt-update force="false":
    #!/usr/bin/env bash
    set -euxo pipefail
    APT_CACHE_MARKER="/var/lib/apt/lists/lock"
    # Check if apt cache exists and force is not set
    if [ "{{force}}" != "true" ] && [ -f "$APT_CACHE_MARKER" ]; then
        echo "apt cache already updated (found $APT_CACHE_MARKER), skipping..."
        echo "Use 'just apt-update force=true' to force update"
        exit 0
    fi
    apt-get update

# Clean up apt cache to save space
apt-cleanup:
    #!/usr/bin/env bash
    set -euxo pipefail
    rm -rf /var/lib/apt/lists/*

install-go: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    GO_ARCH="$(case "{{TARGETARCH}}" in \
        amd64) echo amd64 ;; \
        arm64|arm64v8) echo arm64 ;; \
        *) echo "Unsupported TARGETARCH: {{TARGETARCH}}" >&2; exit 1 ;; \
    esac)"
    apt-get install -y --no-install-recommends wget tar
    rm -rf /usr/local/go
    wget -q -O /tmp/go.tar.gz "https://go.dev/dl/go{{GO_VERSION}}.linux-${GO_ARCH}.tar.gz"
    tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    /usr/local/go/bin/go version

install-rust: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    # Check if Rust is already installed
    if {{vscode}} bash -lc 'command -v rustc && command -v cargo' &>/dev/null; then
        echo "Rust is already installed, skipping..."
        {{vscode}} bash -lc 'rustc --version && cargo --version'
        exit 0
    fi
    apt-get install -y --no-install-recommends ca-certificates curl
    mkdir -p {{CARGO_HOME}} {{RUSTUP_HOME}}
    chown -R vscode:vscode {{CARGO_HOME}} {{RUSTUP_HOME}}
    {{vscode}} bash -lc 'curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable'
    {{vscode}} bash -lc '. "$HOME/.cargo/env" && rustc --version && cargo --version'

install-node:
    #!/usr/bin/env bash
    set -euxo pipefail
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y --no-install-recommends nodejs
    node --version
    npm --version

install-java: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    apt-get install -y --no-install-recommends openjdk-21-jdk
    java -version
    javac -version

install-maven: install-java apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    MAVEN_VERSION="3.9.9"
    apt-get install -y --no-install-recommends wget tar
    wget -q -O /tmp/maven.tar.gz "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
    tar -C /opt -xzf /tmp/maven.tar.gz
    ln -sf "/opt/apache-maven-${MAVEN_VERSION}/bin/mvn" /usr/local/bin/mvn
    rm /tmp/maven.tar.gz
    mvn --version

install-gradle: install-java apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    GRADLE_VERSION="8.11.1"
    apt-get install -y --no-install-recommends wget unzip
    wget -q -O /tmp/gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
    unzip -q /tmp/gradle.zip -d /opt
    ln -sf "/opt/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle
    rm /tmp/gradle.zip
    gradle --version

configure-npm-prefix: install-node
    #!/usr/bin/env bash
    set -euxo pipefail
    mkdir -p /home/vscode/.npm-global
    chown -R vscode:vscode /home/vscode/.npm-global
    printf 'export PATH="/home/vscode/.npm-global/bin:$PATH"\n' > /etc/profile.d/npm-global.sh
    {{vscode}} bash -lc 'npm config set prefix ~/.npm-global'

install-azure-cli:
    #!/usr/bin/env bash
    set -euxo pipefail
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    az version
    az bicep install

install-github-cli: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    apt-get install -y --no-install-recommends curl ca-certificates gnupg
    mkdir -p -m 0755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list
    apt-get update
    apt-get install -y --no-install-recommends gh
    gh --version

install-homebrew: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    apt-get install -y --no-install-recommends build-essential procps curl file git
    {{vscode}} bash -lc 'if [ ! -d /home/linuxbrew/.linuxbrew ]; then NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi'
    {{vscode}} bash -lc 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew update'
    printf 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"\n' > /etc/profile.d/homebrew.sh
    {{vscode}} bash -lc 'if ! grep -q "brew shellenv" ~/.bashrc; then echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> ~/.bashrc; fi'

install-brew-codex: install-homebrew
    {{vscode}} bash -lc 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install codex'

install-brew-opencode: install-homebrew
    {{vscode}} bash -lc 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install sst/tap/opencode'

install-cli-claude: configure-npm-prefix
    {{vscode}} bash -lc 'npm install -g @anthropic-ai/claude-code'

install-cli-gemini: configure-npm-prefix
    {{vscode}} bash -lc 'npm install -g @google/gemini-cli'

install-cli-crush: configure-npm-prefix
    {{vscode}} bash -lc 'npm install -g @charmland/crush'

install-cli-copilot: configure-npm-prefix
    {{vscode}} bash -lc 'npm install -g @github/copilot'

install-cli-npm: install-cli-claude install-cli-gemini install-cli-crush install-cli-copilot
    @echo "All AI CLI tools installed"

install-llm: apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    apt-get install -y --no-install-recommends python3 python3-venv python3-pip python3-dev build-essential curl git
    python3 -m venv /opt/llm-env
    chown -R vscode:vscode /opt/llm-env
    {{vscode}} bash -lc '/opt/llm-env/bin/pip install --upgrade pip'
    {{vscode}} bash -lc '/opt/llm-env/bin/pip install llm'

install-llm-plugins: install-llm
    #!/usr/bin/env bash
    set -euxo pipefail
    {{vscode}} bash -lc '/opt/llm-env/bin/pip install llm-claude-3 llm-gemini llm-ollama llm-foundry'

install-llm-gpt4all: install-llm
    #!/usr/bin/env bash
    set -euxo pipefail
    # Note: gpt4all may have shared library dependencies issues on some systems
    {{vscode}} bash -lc '/opt/llm-env/bin/pip install llm-gpt4all'

install-wassette: install-rust apt-update
    #!/usr/bin/env bash
    set -euxo pipefail
    apt-get install -y --no-install-recommends ca-certificates curl git build-essential pkg-config libssl-dev
    {{vscode}} bash -lc '. "$HOME/.cargo/env" && CARGO_BUILD_JOBS=1 CARGO_PROFILE_RELEASE_LTO=off cargo install --git https://github.com/microsoft/wassette --{{WASSETTE_REF_TYPE}} {{WASSETTE_REF}} wassette-mcp-server && wassette --version'

link-wassette: install-wassette
    #!/usr/bin/env bash
    set -euxo pipefail
    ln -sf /home/vscode/.cargo/bin/wassette /usr/local/bin/wassette
    ls -la /usr/local/bin/wassette

setup-mcp-config:
    #!/usr/bin/env bash
    set -euxo pipefail
    mkdir -p .vscode
    [ -f .vscode/mcp.json ] || cp /opt/wassette/mcp.json .vscode/mcp.json
    echo "MCP config installed to .vscode/mcp.json"

install-all: install-go install-rust install-node install-java install-maven install-gradle configure-npm-prefix install-github-cli install-homebrew install-brew-codex install-brew-opencode install-cli-npm install-llm install-llm-plugins install-wassette link-wassette
    @echo "All components installed"

macos-build-container:
    #!/usr/bin/env bash
    set -euxo pipefail
    # Build a container image using the container command
    container system start || true
    container build -t {{IMAGE}} -f {{DEVCONTAINER_JUST}}/Dockerfile --build-arg TARGETARCH={{TARGETARCH}} --build-arg GO_VERSION={{GO_VERSION}} .

macos-build-container-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    # Build a container image with all components installed
    container system start || true
    IMAGE_BASE="$(echo {{IMAGE}} | cut -d: -f1)"
    container build -t "${IMAGE_BASE}:all" -f {{DEVCONTAINER_JUST}}/Dockerfile --build-arg TARGETARCH={{TARGETARCH}} --build-arg GO_VERSION={{GO_VERSION}} --build-arg INSTALL_ALL=true .

macos-stop-containers:
    #!/usr/bin/env bash
    set -eux
    # Stop all running containers matching the configured image
    container ps -q -f ancestor={{IMAGE}} | xargs -r container stop || true
    docker ps -q -f ancestor={{IMAGE}} | xargs -r docker stop || true

macos-restart-containers:
    #!/usr/bin/env bash
    set -eux
    # Restart the macOS container system
    container system stop
    container system start

macos-list-containers-json:
    #!/usr/bin/env bash
    set -eux
    # List containers in JSON format, filtering by the configured image
    container ls --format json | jq -c '.[] | select(.configuration.image.reference | contains("{{IMAGE}}")?)' 2>/dev/null || echo "No containers found or error parsing JSON"

macos-list-containers:
    #!/usr/bin/env bash
    set -eux
    # Output container IDs matching the image (can be piped to container rm/kill)
    container ls --format json | jq -r '.[] | select(.configuration.image.reference | contains("{{IMAGE}}")) | .configuration.id' 2>/dev/null

macos-clean-containers:
    #!/usr/bin/env bash
    set -eux
    # Kill all containers, then remove them
    just macos-list-containers | xargs -r container kill || true
    just macos-list-containers | xargs -r container rm -f || true

# Docker container recipes (Linux/cross-platform)

docker-build:
    docker build -t {{IMAGE}} -f {{DEVCONTAINER_JUST}}/Dockerfile --build-arg TARGETARCH={{TARGETARCH}} --build-arg GO_VERSION={{GO_VERSION}} .

docker-build-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    IMAGE_BASE="$(echo {{IMAGE}} | cut -d: -f1)"
    docker build -t "${IMAGE_BASE}:all" -f {{DEVCONTAINER_JUST}}/Dockerfile --build-arg TARGETARCH={{TARGETARCH}} --build-arg GO_VERSION={{GO_VERSION}} --build-arg INSTALL_ALL=true .

docker-run:
    docker run --rm -it \
        --memory {{CONTAINER_MEMORY}} \
        --cpus {{CONTAINER_CPUS}} \
        -p {{PORT}}:8080 \
        -v "$(pwd)":/pwd \
        -w /pwd \
        {{IMAGE}} {{CONTAINER_CMD}}

docker-stop:
    #!/usr/bin/env bash
    set -eux
    # Stop all running containers matching the configured image
    docker ps -q -f ancestor={{IMAGE}} | xargs -r docker stop || true

docker-restart:
    #!/usr/bin/env bash
    set -eux
    # Restart Docker daemon
    docker restart || true

docker-list:
    #!/usr/bin/env bash
    set -eux
    # List all containers matching the configured image
    docker ps -a -f ancestor={{IMAGE}}

docker-clean:
    #!/usr/bin/env bash
    set -eux
    # Kill and remove all containers matching the configured image
    docker ps -a -q -f ancestor={{IMAGE}} | xargs -r docker rm -f || true
