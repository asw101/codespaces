# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TARGETARCH=amd64
ENV GO_VERSION=1.25.0

# Install Go
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

# Install Node.js (required for OpenAI Codex CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && apt-get install -y nodejs

# Install Azure CLI and Bicep
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az bicep install

# Install OpenAI Codex CLI globally
RUN npm install -g @openai/codex

# [Optional] Set environment variables specific to your container
ENV OPENAI_API_KEY=""

# [Optional] Define a default command if you want the container to do something specific on startup
CMD ["bash"]
