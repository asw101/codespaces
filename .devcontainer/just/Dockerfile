# Dev container base image with Just pre-installed to orchestrate optional components
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TARGETARCH
ARG GO_VERSION=1.25.1
ARG JUST_RECIPE=""

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
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Prepare directories used by Just recipes when running as the vscode user
ENV CARGO_HOME=/home/vscode/.cargo
ENV RUSTUP_HOME=/home/vscode/.rustup
ENV PATH=/home/vscode/.npm-global/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/llm-env/bin:/usr/local/go/bin:${PATH}

# Configure system-wide PATH via /etc/environment for sudo sessions
RUN echo 'PATH="/home/vscode/.npm-global/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/llm-env/bin:/home/vscode/.cargo/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/environment

RUN mkdir -p ${CARGO_HOME} /home/vscode/.rustup /home/vscode/.npm-global \
    && chown -R vscode:vscode ${CARGO_HOME} /home/vscode/.rustup /home/vscode/.npm-global

WORKDIR /workspace
COPY Justfile ./
COPY Justfile /home/vscode/Justfile
COPY .devcontainer/just/mcp.json /opt/wassette/mcp.json

# Optionally run a just recipe during build (e.g., install-all)
RUN if [ -n "${JUST_RECIPE}" ]; then \
        echo "Building for TARGETARCH=${TARGETARCH}" && \
        echo "Running just recipe: ${JUST_RECIPE}" && \
        just ${JUST_RECIPE} && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    fi

CMD ["just", "--list"]
