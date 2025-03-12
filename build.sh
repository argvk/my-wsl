#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to handle errors
error_handler() {
    echo "Error occurred in script at line: ${1}"
    exit 1
}

# Trap errors and call the error_handler function
trap 'error_handler $LINENO' ERR

# Read the IMAGE variable from a file called IMAGE
IMAGE=$(<IMAGE)

# Import image for wsl
echo "Pulling $IMAGE ..."
curl -s -L $IMAGE | docker import - my-wsl-image:latest

# Build and export to wsl compatible tar
docker buildx build -o type=tar,dest=- . > my-wsl-image.wsl
