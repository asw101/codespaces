# Use a minimal base image designed for dev containers
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Go (match default-container)
RUN wget -q -O go.tar.gz https://go.dev/dl/go1.25.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Python 3 and pip (required for LLM CLI)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        build-essential \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment for LLM CLI
RUN python3 -m venv /opt/llm-env
ENV PATH="/opt/llm-env/bin:${PATH}"

# Install Simon Willison's LLM CLI tool
RUN /opt/llm-env/bin/pip install --upgrade pip \
    && /opt/llm-env/bin/pip install llm

# Install additional LLM plugins that are commonly useful
RUN /opt/llm-env/bin/llm install llm-gpt4all \
    && /opt/llm-env/bin/llm install llm-claude-3 \
    && /opt/llm-env/bin/llm install llm-gemini \
    && /opt/llm-env/bin/llm install llm-ollama \
    && /opt/llm-env/bin/llm install llm-foundry

# Set up bash completion for LLM (optional)
RUN echo 'eval "$(_LLM_COMPLETE=bash_source llm)"' >> /home/vscode/.bashrc

# Set default command
CMD ["bash"]
