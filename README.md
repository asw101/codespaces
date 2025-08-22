# codespaces

## Default

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?quickstart=1)

Quickstart

## Docker

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?template=false&quickstart=1&devcontainer_path=.devcontainer%2Fdocker%2Fdevcontainer.json)

Quickstart, no template.

## Wassette CLI

Use the Wassette variant of the devcontainer to auto-install the CLI.

[![Open Wassette in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?template=false&quickstart=1&devcontainer_path=.devcontainer%2Fwassette%2Fdevcontainer.json)

- Verify: `wassette --version`
- Run MCP server over stdio: `wassette serve --stdio`
- Add to VS Code Copilot (optional):
  `code --add-mcp '{"name":"Wassette","command":"wassette","args":["serve","--stdio"]}'`

Docs: https://github.com/microsoft/wassette
