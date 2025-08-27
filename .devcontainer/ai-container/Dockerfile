# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Go (match default-container)
RUN wget -q -O go.tar.gz https://go.dev/dl/go1.25.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Rust (rustup with latest stable, system-wide)
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:${PATH}
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable \
    && rustc --version && cargo --version

# Install Node.js LTS (required for CLIs)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && apt-get install -y nodejs

# Install Azure CLI and Bicep (similar to codex-container)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az bicep install

# Install Claude Code and Gemini CLI globally via npm
RUN npm install -g @anthropic-ai/claude-code @google/gemini-cli

# Install prerequisites and Wassette (without using the CLI installer)
ARG DEBIAN_FRONTEND=noninteractive
ARG WASSETTE_VERSION=v0.2.0
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl tar git; \
    rm -rf /var/lib/apt/lists/*; \
    arch="$(uname -m)"; \
    case "$arch" in \
      x86_64|amd64) cpu="amd64" ;; \
      aarch64|arm64) cpu="arm64" ;; \
      *) echo "Unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    ver="${WASSETTE_VERSION#v}"; \
    asset="wassette_${ver}_linux_${cpu}.tar.gz"; \
    url="https://github.com/microsoft/wassette/releases/download/${WASSETTE_VERSION}/${asset}"; \
    echo "Downloading $url"; \
    curl -fsSL "$url" -o /tmp/wassette.tgz; \
    tar -xzf /tmp/wassette.tgz -C /tmp; \
    bin_path="$(find /tmp -maxdepth 2 -type f -name 'wassette' | head -n1)"; \
    install -m 0755 "$bin_path" /usr/local/bin/wassette; \
    rm -rf /tmp/wassette*; \
    wassette --version || true

# Provide a default MCP config inside the image for VS Code
COPY mcp.json /opt/wassette/mcp.json

# Default command
CMD ["bash"]
