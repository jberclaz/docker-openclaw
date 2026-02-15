# OpenClaw Docker

[![Docker Image Size](https://img.shields.io/docker/image-size/yourusername/docker-openclaw/latest?style=flat)](https://github.com/yourusername/docker-openclaw/pkgs/container/docker-openclaw)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/yourusername/docker-openclaw.svg)](https://github.com/yourusername/docker-openclaw/issues)

Run [OpenClaw](https://github.com/openclaw/openclaw) in a Docker container for enhanced security and isolation.

## Quick Start (One-Liner)

The image is automatically built and pushed to GitHub Container Registry on every commit. Run:

```bash
docker run -d -p 18789:18789 --name openclaw ghcr.io/yourusername/docker-openclaw:latest
```

Then configure:

```bash
docker exec -it openclaw openclaw configure
```

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed

### Quick Start

1. **Clone this repository**

   ```bash
   git clone https://github.com/yourusername/docker-openclaw.git
   cd docker-openclaw
   ```

2. **Build the container**

   ```bash
   docker compose build
   ```

3. **Start OpenClaw**

   ```bash
   docker compose up -d
   ```

4. **Connect to the container**

   ```bash
   docker compose exec app bash
   ```

5. **Configure OpenClaw**

   Inside the container, configure OpenClaw:

   ```bash
   openclaw configure
   ```

   Follow the prompts to set up your API keys and preferences.

6. **Access OpenClaw**

   OpenClaw runs on port 18789. Connect your OpenClaw client to:
   ```
   ws://localhost:18789
   ```

### Configuration

After initial setup, your configuration is stored in the Docker volume. To modify settings:

```bash
docker compose exec app bash
cd ~/.openclaw
 nano openclaw.json
```

### Required Services

To use OpenClaw, you'll need to register for the following services:

#### 1. LLM Provider

OpenClaw requires an LLM API for reasoning and task execution. Options include:

- **OpenAI** - [Get API key](https://platform.openai.com/api-keys)
- **Anthropic** (Claude) - [Get API key](https://console.anthropic.com/)
- **OpenRouter** - [Get API key](https://openrouter.ai/keys) (aggregates many providers)
- **Ollama** - [Run locally](https://ollama.com/) (no API key needed)

#### 2. Brave Search API

Required for web search capabilities:

1. Visit [brave.com/api](https://brave.com/api/)
2. Sign up for a free account
3. Create an API key

#### 3. Telegram Bot (Optional)

To interact with OpenClaw via Telegram:

1. Message [@BotFather](https://t.me/BotFather) on Telegram
2. Use `/newbot` to create a new bot
3. Copy the bot token
4. Start a chat with your new bot and visit `https://t.me/YOUR_BOT_NAME` to activate it

### Stopping OpenClaw

```bash
docker compose down
```

To stop and remove the data volume (including all configuration):

```bash
docker compose down -v
```

## Data Persistence

This setup uses a Docker named volume (`openclaw_data`) to persist:
- OpenClaw configuration (`~/.openclaw/`)
- Browser profile data
- Any workspace files

The volume persists across container restarts and removals.

## Security Benefits

Running OpenClaw in Docker provides:
- **Isolation**: OpenClaw runs in an isolated environment
- **No host system pollution**: All dependencies are contained
- **Easy cleanup**: Remove the container and volume to cleanly uninstall
- **Resource control**: Limit CPU/memory usage if needed

## Ports

| Port | Description |
|------|-------------|
| 18789 | OpenClaw gateway WebSocket |

## Updating OpenClaw

To update OpenClaw to the latest version, rebuild the container with a new cachebust value:

```bash
CACHEBUST=$(date +%s) docker compose build
docker compose up -d
```

The `CACHEBUST` argument forces Docker to re-execute the `npm i -g openclaw` step, installing the latest version.

## Troubleshooting

### Check container logs

```bash
docker compose logs
```

### Check if Chrome is running

```bash
docker compose exec app curl http://127.0.0.1:9222/json/version
```

### Rebuild from scratch

```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

## File Structure

```
.
├── Dockerfile           # Container image definition
├── docker-compose.yml  # Container orchestration
├── start.sh           # Container startup script
├── LICENSE            # MIT License
└── README.md          # This file
```
