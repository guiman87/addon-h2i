#!/bin/bash

# Define minimal logging functions
function echo_info() { echo "[INFO] $*"; }
function echo_error() { echo "[ERROR] $*"; }
function echo_warning() { echo "[WARNING] $*"; }

echo_info "H2I Diagnostics - Examining container structure"

# Basic system info
echo_info "=== System Information ==="
uname -a || true
echo_info "Node.js: $(node --version 2>/dev/null || echo 'not found')"
echo_info "NPM: $(npm --version 2>/dev/null || echo 'not found')"
echo_info "User ID: $(id -u 2>/dev/null || echo 'not found')"
echo_info "User Name: $(id -un 2>/dev/null || echo 'not found')"

# Directory structure
echo_info "=== Directory Structure ==="
echo_info "Root directory:"
ls -la / || true

# Check common app directories
for dir in /app /usr/src/app /opt/app /home/node/app; do
    if [ -d "$dir" ]; then
        echo_info "Directory $dir exists:"
        ls -la "$dir" || true
        
        # Check for package.json
        if [ -f "$dir/package.json" ]; then
            echo_info "Found package.json in $dir:"
            cat "$dir/package.json" || true
        fi
    fi
done

# Look for entrypoint scripts
echo_info "=== Entrypoint Scripts ==="
find / -name "*entrypoint*" -type f 2>/dev/null | while read -r file; do
    echo_info "Found entrypoint script: $file"
    cat "$file" || true
done

# Find index.js files
echo_info "=== index.js Files ==="
find / -name "index.js" -type f 2>/dev/null | head -n 10 || true

# Check environment variables
echo_info "=== Environment Variables ==="
env || true

# Check running processes
echo_info "=== Running Processes ==="
ps -ef || true

# Network configuration
echo_info "=== Network Configuration ==="
ip addr show || true
netstat -tulpn 2>/dev/null || true

# Check Dockerfile if available
if [ -f "/Dockerfile" ]; then
    echo_info "=== Dockerfile Content ==="
    cat /Dockerfile || true
fi

echo_info "H2I Diagnostics Complete"
