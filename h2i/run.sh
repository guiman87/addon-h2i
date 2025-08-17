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

# Display network information for debugging
bashio::log.info "Network configuration:"
ip addr show

# Test if we can reach Home Assistant
bashio::log.info "Testing connection to Home Assistant:"
if ping -c 1 homeassistant.local &> /dev/null; then
    bashio::log.info "Successfully pinged homeassistant.local"
else
    bashio::log.warning "Could not ping homeassistant.local - trying supervisor"
    if ping -c 1 supervisor &> /dev/null; then
        bashio::log.info "Successfully pinged supervisor"
    else
        bashio::log.warning "Could not ping supervisor either"
    fi
fi

# Get the container's IP address
CONTAINER_IP=$(ip addr show | grep -E "inet .* scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1)
bashio::log.info "Container IP: ${CONTAINER_IP}"

# Start the HTML-to-Image service
bashio::log.info "Starting the HTML-to-Image service..."

# Check if the original entrypoint script exists
if [ -f "/app/index.js" ]; then
    bashio::log.info "Found /app/index.js - starting service"
    
    # We'll run with more verbose logging and catch any errors
    node /app/index.js 2>&1 | bashio::log.info
else
    bashio::log.error "Could not find /app/index.js"
    # Let's try to list what's in the app directory
    bashio::log.info "Contents of /app directory:"
    ls -la /app
    
    # Try to find any index.js files
    bashio::log.info "Searching for index.js files:"
    find / -name "index.js" -type f 2>/dev/null | head -n 10
    
    # If we still can't find it, exit with an error
    exit 1
fi

# If we get here, something went wrong
bashio::log.error "HTML-to-Image service exited unexpectedly"
exit 1
