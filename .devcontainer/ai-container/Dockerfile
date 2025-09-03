# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Go (match default-container)
RUN wget -q -O go.tar.gz https://go.dev/dl/go1.25.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Rust (rustup with latest stable, system-wide)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# --- Cargo ---
ENV CARGO_HOME=/home/vscode/.cargo
ENV RUSTUP_HOME=/home/vscode/.rustup
ENV PATH=${CARGO_HOME}/bin:${PATH}

RUN mkdir -p ${CARGO_HOME} /home/vscode/.rustup \
    && chown -R vscode:vscode ${CARGO_HOME} /home/vscode/.rustup

# Install Rust as the vscode user
USER vscode
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable \
    && . "$HOME/.cargo/env" \
    && rustc --version && cargo --version
USER root

# Install Node.js LTS (required for CLIs)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Azure CLI and Bicep (similar to codex-container)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az bicep install

# Install GitHub CLI (gh) from official repo
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl ca-certificates gnupg; \
    mkdir -p -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg; \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends gh; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Install prerequisites for Homebrew (Linuxbrew)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential procps curl file git \
    && rm -rf /var/lib/apt/lists/*

## Configure a user-scoped npm global prefix for the vscode user to avoid EACCES
## when running `npm install -g` inside Codespaces.
RUN mkdir -p /home/vscode/.npm-global \
    && chown -R vscode:vscode /home/vscode/.npm-global

# Ensure the user npm bin is on PATH for interactive shells and Docker execs
ENV PATH="/home/vscode/.npm-global/bin:${PATH}"
RUN printf 'export PATH="/home/vscode/.npm-global/bin:$PATH"\n' > /etc/profile.d/npm-global.sh

# Switch to vscode and set npm prefix for that user
USER vscode
RUN npm config set prefix ~/.npm-global

# Install Homebrew (Linuxbrew) as vscode user and add to PATH; then install Codex via brew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.bashrc \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew update \
    && brew install codex \
    && brew install sst/tap/opencode
USER root
RUN printf 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"\n' > /etc/profile.d/homebrew.sh
USER vscode

# Install Claude Code, Gemini CLI, and Crush globally via npm as vscode user
# (Codex is installed via Homebrew to avoid npm/ripgrep download issues)
RUN npm install -g @anthropic-ai/claude-code @google/gemini-cli @charmland/crush
USER root

# Install Wassette from source using Cargo
ARG DEBIAN_FRONTEND=noninteractive
ARG WASSETTE_REF=main
ARG WASSETTE_REF_TYPE=branch
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl git build-essential pkg-config libssl-dev; \
    rm -rf /var/lib/apt/lists/*

# Install Wassette from GitHub source as vscode user (since Rust is installed for vscode user)
USER vscode
RUN . "$HOME/.cargo/env" \
    && echo "Installing Wassette MCP Server with cargo..." \
    && cargo install --git https://github.com/microsoft/wassette --${WASSETTE_REF_TYPE} ${WASSETTE_REF} wassette-mcp-server \
    && echo "Listing cargo bin directory:" \
    && ls -la "$HOME/.cargo/bin/" \
    && echo "Testing wassette command:" \
    && wassette --version
USER root

# Make wassette available system-wide by creating a symlink
RUN ln -s /home/vscode/.cargo/bin/wassette /usr/local/bin/wassette \
    && ls -la /usr/local/bin/wassette

# Provide a default MCP config inside the image for VS Code
COPY mcp.json /opt/wassette/mcp.json

# Default command
CMD ["bash"]
