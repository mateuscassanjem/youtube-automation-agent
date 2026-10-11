#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p backups
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
# SQLite consistency: stop writers before archiving; auto restart on exit.
docker compose stop agenttube
trap 'docker compose start agenttube' EXIT
tar -czf "backups/agenttube-${STAMP}.tar.gz" data config uploads output logs .env
chmod 600 "backups/agenttube-${STAMP}.tar.gz"
echo "Backup saved: backups/agenttube-${STAMP}.tar.gz"
