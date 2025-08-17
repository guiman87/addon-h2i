#!/usr/bin/env bashio

# Get configuration values
QUALITY=$(bashio::config 'quality')
WIDTH=$(bashio::config 'width')
HEIGHT=$(bashio::config 'height')
TIMEOUT=$(bashio::config 'timeout')
ALLOW_EXTERNAL=$(bashio::config 'allow_external_access')

# Set environment variables for h2i if not already set
export H2I_QUALITY=${QUALITY}
export H2I_DEFAULT_WIDTH=${WIDTH}
export H2I_DEFAULT_HEIGHT=${HEIGHT}
export H2I_TIMEOUT=${TIMEOUT}

# Print startup message
bashio::log.info "Starting HTML-to-Image service..."
bashio::log.info "Quality: ${QUALITY}"
bashio::log.info "Default Width: ${WIDTH}px"
bashio::log.info "Default Height: ${HEIGHT}px"
bashio::log.info "Timeout: ${TIMEOUT}ms"
bashio::log.info "Allow External Access: ${ALLOW_EXTERNAL}"

# Display basic system info
bashio::log.info "System information:"
uname -a || true
bashio::log.info "Node.js version:"
node --version || true
bashio::log.info "NPM version:"
npm --version || true

# Display network information for debugging
bashio::log.info "Network configuration:"
hostname -I || true
ip addr show || true

# Get the container's IP address (try different methods)
if command -v hostname >/dev/null 2>&1; then
    CONTAINER_IP=$(hostname -I | awk '{print $1}')
    bashio::log.info "Container IP (hostname): ${CONTAINER_IP}"
elif command -v ip >/dev/null 2>&1; then
    CONTAINER_IP=$(ip addr show | grep -E "inet .* scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1)
    bashio::log.info "Container IP (ip command): ${CONTAINER_IP}"
else
    bashio::log.warning "Could not determine container IP address"
fi

# Examine the base image to understand how it starts
bashio::log.info "Checking for original entrypoint:"
if [ -f "/app/index.js" ]; then
    bashio::log.info "Found /app/index.js"
    # Look at the package.json to see how the service is supposed to start
    if [ -f "/app/package.json" ]; then
        bashio::log.info "Found package.json, checking start command:"
        grep -A 5 '"scripts"' /app/package.json || true
    fi
else
    # Try to find the starting point
    bashio::log.info "Searching for index.js files:"
    find / -name "index.js" -type f 2>/dev/null | head -n 10 || true
    
    # Check for package.json files
    bashio::log.info "Searching for package.json files:"
    find / -name "package.json" -type f 2>/dev/null | head -n 10 || true
fi

# Look for docker-entrypoint.sh or similar
bashio::log.info "Searching for entrypoint scripts:"
find / -name "*entrypoint*" -type f 2>/dev/null | head -n 10 || true

# Try to determine the correct command to start the service
if [ -f "/app/index.js" ]; then
    bashio::log.info "Starting service with node /app/index.js"
    
    # We'll run with more verbose logging and catch any errors
    cd /app && node index.js 2>&1 | bashio::log.info
elif [ -f "/usr/src/app/index.js" ]; then
    bashio::log.info "Starting service with node /usr/src/app/index.js"
    
    cd /usr/src/app && node index.js 2>&1 | bashio::log.info
else
    # Try to find any default entrypoint in the container
    if [ -f "/docker-entrypoint.sh" ]; then
        bashio::log.info "Found /docker-entrypoint.sh, executing:"
        /docker-entrypoint.sh 2>&1 | bashio::log.info
    elif [ -f "/entrypoint.sh" ]; then
        bashio::log.info "Found /entrypoint.sh, executing:"
        /entrypoint.sh 2>&1 | bashio::log.info
    else
        bashio::log.error "Could not find a way to start the service"
        bashio::log.info "Contents of root directory:"
        ls -la / || true
        exit 1
    fi
fi

# If we get here, something went wrong
bashio::log.error "HTML-to-Image service exited unexpectedly"
exit 1
