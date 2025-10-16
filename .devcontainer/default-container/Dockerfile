# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TARGETARCH=amd64
ENV GO_VERSION=1.25.1

# Install any project-specific tools not available as Dev Container Features
# Example: Installing a specific version of a tool

# Install the tooling required to run the Justfile and fetch artifacts
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        just \
        sudo \
        ca-certificates \
        curl \
        wget \
        gnupg \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install latest Go version
RUN case "${TARGETARCH}" in \
        amd64) GO_ARCH=amd64 ;; \
        arm64) GO_ARCH=arm64 ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && wget -q -O go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# [Optional] Copy project files if your setup requires it (Codespaces usually mounts your repo)
# COPY . /workspaces/your-project-name

# [Optional] Set environment variables specific to your container
# ENV MY_CUSTOM_VAR="hello"

# [Optional] Define a default command if you want the container to do something specific on startup
# CMD ["bash"]
