#!/usr/bin/env bash
# Manual previews; automated checks are documented in docs/TESTING.md.
set -euo pipefail
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$REPO_DIR/scripts/preview.py" "$@"
