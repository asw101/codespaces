# Dev container base image with Just pre-installed to orchestrate optional components
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TARGETARCH
ARG GO_VERSION=1.25.1
ARG INSTALL_ALL=false

ENV TARGETARCH=${TARGETARCH}
ENV GO_VERSION=${GO_VERSION}

# Install the tooling required to run the Justfile and fetch artifacts
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        just \
        sudo \
        ca-certificates \
        curl \
        wget \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Prepare directories used by Just recipes when running as the vscode user
ENV CARGO_HOME=/home/vscode/.cargo
ENV RUSTUP_HOME=/home/vscode/.rustup
ENV PATH=/home/vscode/.npm-global/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/llm-env/bin:/usr/local/go/bin:${PATH}

RUN mkdir -p ${CARGO_HOME} /home/vscode/.rustup /home/vscode/.npm-global \
    && chown -R vscode:vscode ${CARGO_HOME} /home/vscode/.rustup /home/vscode/.npm-global

WORKDIR /workspace
COPY Justfile ./
COPY mcp.json /opt/wassette/mcp.json

# Optionally install all components during build
RUN if [ "${INSTALL_ALL}" = "true" ]; then \
        echo "Building for TARGETARCH=${TARGETARCH}" && \
        just install-all; \
    fi

CMD ["just", "--list"]
