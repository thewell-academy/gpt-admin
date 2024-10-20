#!/bin/bash

# Get the current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get the local IP address (ignoring loopback and other irrelevant addresses)
LOCAL_IP=$(ifconfig | grep -E 'inet (172\.)' | awk '{print $2}' | head -n 1)

# Fallback if no IP found in the range
if [ -z "$LOCAL_IP" ]; then
    echo "No valid local IP address found in the 172.x.x.x range. Defaulting to localhost."
    LOCAL_IP="127.0.0.1"
fi

# Define server URLs for each branch
LOCAL_URL="http://$LOCAL_IP:8000"
REMOTE_URL="https://your-remote-server.com"

CONFIG_FILE="web/config.js"

if [ "$BRANCH" == "develop" ]; then
    echo "Setting server URL to local environment for develop branch"
    echo "window.serverConfig = { serverUrl: '$LOCAL_URL' };" > $CONFIG_FILE
elif [ "$BRANCH" == "main" ]; then
    echo "Setting server URL to remote environment for main branch"
    echo "window.serverConfig = { serverUrl: '$REMOTE_URL' };" > $CONFIG_FILE
else
    echo "Branch not recognized. Using default server URL."
    echo "window.serverConfig = { serverUrl: '$LOCAL_URL' };" > $CONFIG_FILE
fi