# AI Dev Container

This container image powers the **AI (Container)** devcontainer configuration under `.devcontainer/ai-container`.

## Building Locally

### Docker / Buildx

```bash
docker buildx build --platform linux/amd64,linux/arm64/v8 -f Dockerfile -t ghcr.io/your-org/ai:latest .
```

### macOS container CLI

On Apple Silicon hosts you can build a native arm64 variant with the macOS `container` CLI:

```bash
container build --build-arg TARGETARCH=arm64 --platform linux/arm64/v8 --file Dockerfile .
```

Adjust the tag or output options (`--tag`, `--output`) to suit your workflow.
