# OpenAI Codex CLI devcontainer

This variant uses the same universal dev container image and installs the official OpenAI Codex CLI (`@openai/codex`) during container creation.

Quick start (Codespaces):
1. Create a new Codespace and select the `.devcontainer/codex/` configuration.
2. Wait for the post-create step to finish installing the CLI.
3. Provide your API key via a Codespaces secret `OPENAI_API_KEY` or export it in the terminal.
4. Verify the CLI:
   ```bash
   codex --help
   ```
5. Check the version:
   ```bash
   codex --version
   ```

Guide:
- Getting started: https://help.openai.com/en/articles/11096431-openai-codex-cli-getting-started