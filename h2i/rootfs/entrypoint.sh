#!/bin/sh
set -e

# Skip s6 overlay entirely and call the base image's entrypoint directly.
# This avoids chmod permission issues when running as non-root user.

# Set environment variables for h2i configuration
export H2I_QUALITY=${H2I_QUALITY:-80}
export H2I_DEFAULT_WIDTH=${H2I_DEFAULT_WIDTH:-800}
export H2I_DEFAULT_HEIGHT=${H2I_DEFAULT_HEIGHT:-600}
export H2I_TIMEOUT=${H2I_TIMEOUT:-30000}

echo "[entrypoint] Starting H2I service via base image entrypoint"
echo "[entrypoint] H2I_QUALITY=${H2I_QUALITY}"
echo "[entrypoint] H2I_DEFAULT_WIDTH=${H2I_DEFAULT_WIDTH}"
echo "[entrypoint] H2I_DEFAULT_HEIGHT=${H2I_DEFAULT_HEIGHT}"
echo "[entrypoint] H2I_TIMEOUT=${H2I_TIMEOUT}"

# Change to the app directory where h2i.js is located
cd /app

# Execute the base image's docker-entrypoint.sh with the original CMD arguments
if [ -f "/usr/local/bin/docker-entrypoint.sh" ]; then
    echo "[entrypoint] Executing /usr/local/bin/docker-entrypoint.sh with pm2-runtime from /app"
    exec /usr/local/bin/docker-entrypoint.sh pm2-runtime start h2i.js --name h2i-app -i 4
elif [ -f "/docker-entrypoint.sh" ]; then
    echo "[entrypoint] Executing /docker-entrypoint.sh with pm2-runtime from /app"
    exec /docker-entrypoint.sh pm2-runtime start h2i.js --name h2i-app -i 4
else
    echo "[entrypoint] No docker-entrypoint found, trying to start service directly"
    # Try to start the service directly
    if [ -f "/app/h2i.js" ]; then
        echo "[entrypoint] Starting pm2-runtime with h2i.js from /app"
        exec pm2-runtime start h2i.js --name h2i-app -i 4
    elif [ -f "/app/index.js" ]; then
        echo "[entrypoint] Starting node /app/index.js"
        exec node index.js
    else
        echo "[entrypoint] Could not find service entry point"
        exit 1
    fi
fi
