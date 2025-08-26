# OpenAI Codex CLI Devcontainer (Docker-based)

This devcontainer includes:
- Go 1.25.0
- Node.js (LTS)
- Azure CLI with Bicep support
- OpenAI Codex CLI (installed via npm during Docker build)

## Usage

1. The OpenAI Codex CLI is pre-installed in the container image
2. Add your `OPENAI_API_KEY` as a Codespaces secret for full functionality
3. The container will display your Codex CLI version on startup

## Extensions Included

- Go extension
- Azure Bicep tools
- Azure Resource Groups
- GitHub Copilot