#!/bin/bash

# Build script for Docker image
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building Docker image...${NC}"

# Build the image
docker build -t devsu-nodejs-api:latest .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully!${NC}"
    echo -e "${YELLOW}To run the container:${NC}"
    echo -e "  docker run -p 8000:8000 devsu-nodejs-api:latest"
    echo -e "${YELLOW}Or use docker-compose:${NC}"
    echo -e "  docker-compose up"
else
    echo -e "${RED}❌ Docker build failed!${NC}"
    exit 1
fi 