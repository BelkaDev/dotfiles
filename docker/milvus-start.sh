#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MILVUS_DATA_DIR="${MILVUS_DATA_DIR:-$HOME/.local/share/claude-context}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed" >&2
  exit 1
fi

mkdir -p "$MILVUS_DATA_DIR/etcd" "$MILVUS_DATA_DIR/minio" "$MILVUS_DATA_DIR/milvus"
docker compose -f "$DOTFILES_DIR/docker/docker-compose.claude-context.yml" up -d --remove-orphans
