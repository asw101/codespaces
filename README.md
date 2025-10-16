# codespaces

Dev Container configurations for AI development with Go, Rust, Node.js, Java, and modern AI tools. Built on a flexible Just-based recipe system that lets you install tools on-demand or use fully prebuilt images.

## Containers

### AI - just:latest

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?template=false&quickstart=1&devcontainer_path=.devcontainer%2Fjust%2Fdevcontainer.json)

### AI - just:all

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?template=false&quickstart=1&devcontainer_path=.devcontainer%2Fjust-all%2Fdevcontainer.json)

### Go - default:latest

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces?template=false&quickstart=1&devcontainer_path=.devcontainer%2Fdefault%2Fdevcontainer.json)

## Running Outside of Dev Containers

Pre-built container images are automatically published to GitHub Container Registry via [GitHub Actions workflow](https://github.com/asw101/codespaces/actions). You can optionally clone this repository to use the included [`Justfile`](Justfile) recipes.

### Clone the repository (optional, for Justfile support)

```bash
git clone https://github.com/asw101/codespaces.git
cd codespaces
```

### Using Docker

Pull and run the container with Docker on any platform:

```bash
docker run --rm -it --memory 4g --cpus 2 -p 8080:8080 -v "$(pwd)":/pwd -w /pwd ghcr.io/asw101/codespaces/just:latest bash
```

### Using macOS Containers

Start the container system and run the container

```bash
container system start || true
```

Pull and run the container using macOS built-in containerization:

```bash
container run --rm -it --memory 4g --cpus 2 --publish 8080:8080 --volume "$(pwd)":/pwd --workdir /pwd ghcr.io/asw101/codespaces/just:latest bash
```

