# Base devcontainer image
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TARGETARCH=amd64
ENV GO_VERSION=1.25.0

# Install Go (match default-container)
RUN case "${TARGETARCH}" in \
        amd64) GO_ARCH=amd64 ;; \
        arm64) GO_ARCH=arm64 ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && wget -q -O go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install prerequisites and Wassette (without using the CLI installer)
ARG DEBIAN_FRONTEND=noninteractive
ARG WASSETTE_VERSION=v0.2.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl tar git; \
    rm -rf /var/lib/apt/lists/*; \
    case "${TARGETARCH}" in \
      amd64) cpu="amd64" ;; \
      arm64) cpu="arm64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
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

# Default command
CMD ["bash"]

# Provide a default MCP config inside the image for VS Code
# The devcontainer.json will copy this into the workspace's .vscode on create if missing
COPY mcp.json /opt/wassette/mcp.json
