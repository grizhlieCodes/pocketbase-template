#!/bin/sh
set -e

# Defaults (can be overridden by environment variables)
PORT="${PORT:-8080}"
DATA_DIR="${DATA_DIR:-/data}"

# Ensure data directory exists and has correct ownership
mkdir -p "${DATA_DIR}"
chown -R pocketbase:pocketbase "${DATA_DIR}"

# Auto-create superuser if SUPERUSER_EMAIL and SUPERUSER_PASSWORD are set
if [ -n "$SUPERUSER_EMAIL" ] && [ -n "$SUPERUSER_PASSWORD" ]; then
    echo "Creating superuser..."
    su-exec pocketbase /usr/local/bin/pocketbase superuser upsert "$SUPERUSER_EMAIL" "$SUPERUSER_PASSWORD" --dir="${DATA_DIR}" || true
fi

# Drop privileges and run PocketBase
exec su-exec pocketbase /usr/local/bin/pocketbase serve \
    --http="0.0.0.0:${PORT}" \
    --dir="${DATA_DIR}"
