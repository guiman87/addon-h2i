#!/bin/bash

# Test if the H2I addon is accessible
echo "Testing connection to H2I addon..."
echo "Trying to connect to http://localhost:5005..."

# Basic connection test
curl -v http://localhost:5005 2>&1

echo -e "\n\nTrying to convert a simple HTML to image..."
curl -X POST \
  http://localhost:5005 \
  -H 'Content-Type: application/json' \
  -d '{"html": "<html><body><h1>Test Connection</h1></body></html>"}' \
  --output test.jpg

if [ -f "test.jpg" ]; then
  echo "Success! Image was created."
  ls -la test.jpg
else
  echo "Failed to create the image."
fi

# Try from within the network to ensure it's not a local access issue
echo -e "\n\nTrying to connect from Home Assistant container IP..."
IP_ADDRESS=$(ip addr show | grep -E "inet .* scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1)
echo "Local IP: $IP_ADDRESS"

curl -X POST \
  "http://$IP_ADDRESS:5005" \
  -H 'Content-Type: application/json' \
  -d '{"html": "<html><body><h1>Test Connection</h1></body></html>"}' \
  --output test_network.jpg

if [ -f "test_network.jpg" ]; then
  echo "Network test successful! Image was created."
  ls -la test_network.jpg
else
  echo "Network test failed to create the image."
fi
