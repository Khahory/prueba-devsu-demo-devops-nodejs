#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

cd "$PROJECT_ROOT"

if [[ ! -f .env ]]; then
    echo "Error: .env file not found in $PROJECT_ROOT"
    echo "Please create .env file based on env.example"
    exit 1
fi

set -a
source .env
set +a

REQUIRED_VARS=(
    "DOCKER_REGISTRY"
    "DOCKER_IMAGE_NAME"
)

for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "Error: Required environment variable $var is not set"
        exit 1
    fi
done

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
STAGING_TAG="staging-${TIMESTAMP}"
FULL_IMAGE_NAME="${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${STAGING_TAG}"

echo "Building Docker image: $FULL_IMAGE_NAME"

docker build -t "$FULL_IMAGE_NAME" .

if [[ $? -eq 0 ]]; then
    echo "Pushing Docker image to registry..."
    docker push "$FULL_IMAGE_NAME"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Docker image built and pushed successfully!"
        echo "Image: $FULL_IMAGE_NAME"
        echo "Tag: $STAGING_TAG"
    else
        echo "❌ Docker push failed!"
        exit 1
    fi
else
    echo "❌ Docker build failed!"
    exit 1
fi 