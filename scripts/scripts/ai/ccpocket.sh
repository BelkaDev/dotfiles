#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${CCPOCKET_LOG_DIR:-/tmp/ccpocket/logs}"
PID_FILE="${CCPOCKET_PID_FILE:-/tmp/ccpocket/bridge.pid}"
LOG_FILE="$LOG_DIR/bridge.log"
PORT="${BRIDGE_PORT:-8765}"
ENV_FILE="${CCPOCKET_ENV_FILE:-$HOME/.ccpocket/bridge.env}"

mkdir -p "$HOME/.ccpocket" "$LOG_DIR"

if [[ -f "$PID_FILE" ]]; then
  existing_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
    existing_cmd="$(ps -p "$existing_pid" -o command= 2>/dev/null || true)"
    if [[ "$existing_cmd" == *"ccpocket"* ]]; then
      echo "CC Pocket bridge already running (pid $existing_pid)"
      exit 0
    fi
  fi
  rm -f "$PID_FILE"
fi

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

if [[ -z "${BRIDGE_API_KEY:-}" ]]; then
  BRIDGE_API_KEY="$(node -e "console.log(require('crypto').randomBytes(24).toString('hex'))")"
  umask 077
  printf 'BRIDGE_API_KEY=%q\n' "$BRIDGE_API_KEY" > "$ENV_FILE"
fi

while IFS='=' read -r env_name _; do
  case "$env_name" in
    BASH_FUNC_*%%)
      fn="${env_name#BASH_FUNC_}"
      fn="${fn%??}"
      unset -f "$fn" 2>/dev/null || true
      ;;
  esac
done < <(env)
unset rvm_version 2>/dev/null || true

export BRIDGE_PORT="$PORT"
export BRIDGE_HOST="${BRIDGE_HOST:-0.0.0.0}"
export BRIDGE_API_KEY
export BRIDGE_ALLOWED_DIRS="${BRIDGE_ALLOWED_DIRS:-/workspaces,$HOME}"
export BRIDGE_DISABLE_MDNS="${BRIDGE_DISABLE_MDNS:-1}"

CODEX_HOME_DIR="${CCPOCKET_CODEX_HOME:-$HOME/.codex}"
if [[ -d "$CODEX_HOME_DIR" ]]; then
  export CODEX_HOME="$(cd "$CODEX_HOME_DIR" && pwd)"
fi

if [[ -n "${BRIDGE_PUBLIC_WS_URL:-}" ]]; then
  export BRIDGE_PUBLIC_WS_URL
fi

echo "Starting CC Pocket bridge"
echo "  port: $BRIDGE_PORT"
echo "  public websocket: ${BRIDGE_PUBLIC_WS_URL:-not set}"

if command -v ccpocket-bridge >/dev/null 2>&1; then
  nohup ccpocket-bridge > "$LOG_FILE" 2>&1 &
else
  nohup npx --yes @ccpocket/bridge@latest > "$LOG_FILE" 2>&1 &
fi

pid="$!"
printf '%s\n' "$pid" > "$PID_FILE"

echo "Started CC Pocket bridge (pid $pid)"
echo "Log: $LOG_FILE"
