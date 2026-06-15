#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/codex-install.sh
bash /tmp/codex-install.sh <<< ""
