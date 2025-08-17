#!/usr/bin/env bashio

# This script is designed to diagnose the bybetas/h2i image structure
# and find out how to properly run it as a Home Assistant addon

bashio::log.info "H2I Diagnostics - Examining container structure"

# Basic system info
bashio::log.info "=== System Information ==="
uname -a || true
bashio::log.info "Node.js: $(node --version 2>/dev/null || echo 'not found')"
bashio::log.info "NPM: $(npm --version 2>/dev/null || echo 'not found')"

# Directory structure
bashio::log.info "=== Directory Structure ==="
bashio::log.info "Root directory:"
ls -la / || true

# Check common app directories
for dir in /app /usr/src/app /opt/app /home/node/app; do
    if [ -d "$dir" ]; then
        bashio::log.info "Directory $dir exists:"
        ls -la "$dir" || true
        
        # Check for package.json
        if [ -f "$dir/package.json" ]; then
            bashio::log.info "Found package.json in $dir:"
            cat "$dir/package.json" || true
        fi
    fi
done

# Look for entrypoint scripts
bashio::log.info "=== Entrypoint Scripts ==="
find / -name "*entrypoint*" -type f 2>/dev/null | while read -r file; do
    bashio::log.info "Found entrypoint script: $file"
    cat "$file" || true
done

# Find index.js files
bashio::log.info "=== index.js Files ==="
find / -name "index.js" -type f 2>/dev/null | head -n 10 || true

# Check environment variables
bashio::log.info "=== Environment Variables ==="
env || true

# Check running processes
bashio::log.info "=== Running Processes ==="
ps -ef || true

# Network configuration
bashio::log.info "=== Network Configuration ==="
ip addr show || true
netstat -tulpn || true

# Check if any HTTP service is running
bashio::log.info "=== HTTP Service Check ==="
if command -v curl >/dev/null 2>&1; then
    curl -v http://localhost:80 2>&1 || true
elif command -v wget >/dev/null 2>&1; then
    wget -O - http://localhost:80 2>&1 || true
else
    bashio::log.warning "No curl or wget available for HTTP check"
fi

bashio::log.info "H2I Diagnostics Complete"
