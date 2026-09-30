#!/usr/bin/env bash
# Stable entry point; implementation lives with the maintenance tools.
set -euo pipefail
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$REPO_DIR/scripts/install.py" "$@"
