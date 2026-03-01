#!/bin/bash
set -e

PUID=${PUID:-99}
PGID=${PGID:-100}

# Create group if it doesn't exist
if ! getent group javsp > /dev/null 2>&1; then
    groupadd -g "$PGID" javsp
fi

# Create user if it doesn't exist
if ! getent passwd javsp > /dev/null 2>&1; then
    useradd -u "$PUID" -g "$PGID" -d /app -s /bin/bash javsp
fi

# Fix ownership of working directories
chown -R "$PUID:$PGID" /app

# If /video exists, ensure it's accessible
if [ -d /video ]; then
    chown "$PUID:$PGID" /video 2>/dev/null || true
fi

# If /config exists, ensure it's accessible
if [ -d /config ]; then
    chown -R "$PUID:$PGID" /config 2>/dev/null || true
fi

# Run javsp as the specified user
exec gosu "$PUID:$PGID" /app/.venv/bin/javsp "$@"
