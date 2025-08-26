# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Go
# Install latest Go version
RUN wget -q -O go.tar.gz https://go.dev/dl/go1.25.0.linux-amd64.tar.gz \
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