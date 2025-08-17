#!/bin/bash

# Test if the H2I addon is accessible
echo "Testing connection to H2I addon..."
echo "Trying to connect to http://localhost:80..."

# Basic connection test using wget if available
if command -v wget >/dev/null 2>&1; then
    echo "Using wget for testing..."
    wget -q -O - http://localhost:80 || echo "Failed to connect with wget"
else
    echo "wget not available. Skipping basic connection test."
fi

echo -e "\n\nTrying to convert a simple HTML to image..."
# Check if we have curl
if command -v curl >/dev/null 2>&1; then
    echo "Using curl for testing..."
    curl -X POST \
      http://localhost:80 \
      -H 'Content-Type: application/json' \
      -d '{"html": "<html><body><h1>Test Connection</h1></body></html>"}' \
      --output test.jpg
    
    if [ -f "test.jpg" ]; then
      echo "Success! Image was created."
      ls -la test.jpg
    else
      echo "Failed to create the image."
    fi
else
    echo "curl not available. Cannot test image conversion."
fi

# Try to determine the container's IP address
echo -e "\n\nTrying to get container IP address..."
if command -v hostname >/dev/null 2>&1; then
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    echo "Container IP (hostname): ${IP_ADDRESS}"
elif command -v ip >/dev/null 2>&1; then
    IP_ADDRESS=$(ip addr show | grep -E "inet .* scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1)
    echo "Container IP (ip command): ${IP_ADDRESS}"
else
    echo "Could not determine container IP address"
    IP_ADDRESS="localhost"
fi

echo "Local IP: $IP_ADDRESS"

# Try with wget if available
if command -v wget >/dev/null 2>&1; then
    echo "Testing with wget..."
    TEMP_FILE=$(mktemp)
    echo '{"html": "<html><body><h1>Test Connection</h1></body></html>"}' > $TEMP_FILE
    wget --header="Content-Type: application/json" \
      --post-file=$TEMP_FILE \
      -O test_network.jpg \
      http://$IP_ADDRESS:80/ || echo "Failed to use wget for POST request"
    rm $TEMP_FILE
    
    if [ -f "test_network.jpg" ]; then
      echo "Network test successful! Image was created."
      ls -la test_network.jpg
    else
      echo "Network test failed to create the image."
    fi
else
    echo "wget not available for network test."
fi
