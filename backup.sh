#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p backups
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
# Stop briefly for consistent SQLite copy; restart even after failure.
docker compose stop agenttube
trap 'docker compose start agenttube' EXIT
tar --exclude='*.tmp' -czf "backups/agenttube-${STAMP}.tar.gz" data uploads output .env
chmod 600 "backups/agenttube-${STAMP}.tar.gz"
echo "Backup saved: backups/agenttube-${STAMP}.tar.gz"
