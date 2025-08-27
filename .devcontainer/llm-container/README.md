# LLM CLI Dev Container

This dev container is based on the default-container and includes Simon Willison's LLM CLI tool.

## What's Included

- **Go 1.25.0** - Same as default container
- **Python 3** with virtual environment
- **LLM CLI** - Simon Willison's command-line tool for working with Large Language Models
- **LLM Plugins**:
  - `llm-gpt4all` - Local models via GPT4All
  - `llm-claude-3` - Anthropic Claude models
  - `llm-gemini` - Google Gemini models
  - `llm-ollama` - Local models via Ollama
  - `llm-foundry` - Azure AI Foundry (formerly Azure AI Studio) models

## Getting Started

### 1. Check Installation
```bash
llm --help
llm models
```

### 2. Configure API Keys
```bash
# For OpenAI
llm keys set openai

# For Anthropic Claude
llm keys set claude

# For Google Gemini
llm keys set gemini

# For Azure AI Foundry
llm keys set foundry
```

### 3. Basic Usage
```bash
# Simple prompt
llm "What is the capital of France?"

# Using a specific model
llm -m gpt-4 "Explain quantum computing"

# Chat mode
llm chat

# Save conversation
llm "Tell me about Python" --save conversation1
```

### 4. Local Models with GPT4All
```bash
# Install a local model
llm install orca-mini-3b-gguf2-q4_0

# Use local model
llm -m orca-mini-3b-gguf2-q4_0 "Hello, how are you?"
```

### 5. Templates and Prompts
```bash
# Create a template
llm prompt edit explain-code

# Use template
llm -t explain-code < my-script.py
```

### 6. Azure AI Foundry Models
```bash
# List available Azure AI Foundry models
llm models list | grep foundry

# Use Azure AI Foundry model
llm -m foundry/gpt-4 "Explain machine learning"

# Configure Azure endpoint (if using custom endpoint)
llm keys set foundry
# Follow prompts to set endpoint URL and API key
```

## Documentation

- [LLM CLI Documentation](https://llm.datasette.io/)
- [Available Plugins](https://llm.datasette.io/en/stable/plugins/directory.html)
- [Simon Willison's Blog](https://simonwillison.net/tags/llm/)

## Environment

The LLM CLI is installed in a virtual environment at `/opt/llm-env` and is available system-wide.
