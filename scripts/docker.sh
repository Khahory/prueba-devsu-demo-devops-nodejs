#!/bin/bash

# Docker management script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  $0 dev          # Start development environment"
    echo -e "  $0 staging      # Start staging environment"
    echo -e "  $0 prod         # Start production environment"
    echo -e "  $0 prod-secrets # Start production with Docker secrets"
    echo -e "  $0 down         # Stop all environments"
    echo -e "  $0 logs [env]   # Show logs for environment"
    echo -e "  $0 build [env]  # Build images for environment"
}

# Function to run docker-compose with correct context
run_docker_compose() {
    local compose_file=$1
    local command=$2
    
    echo -e "${GREEN}Running: docker-compose -f infrastructure/docker/$compose_file $command${NC}"
    docker-compose -f infrastructure/docker/$compose_file --project-directory . $command
}

# Function to build with correct context
build_image() {
    local dockerfile=$1
    local tag=$2
    
    echo -e "${GREEN}Building: docker build -f infrastructure/docker/$dockerfile -t $tag .${NC}"
    docker build -f infrastructure/docker/$dockerfile -t $tag .
}

case "$1" in
    "dev")
        echo -e "${YELLOW}Starting development environment...${NC}"
        run_docker_compose "docker-compose.dev.yml" "up -d"
        echo -e "${GREEN}✅ Development environment started${NC}"
        echo -e "${YELLOW}Access: http://localhost:8000${NC}"
        ;;
    "staging")
        echo -e "${YELLOW}Starting staging environment...${NC}"
        run_docker_compose "docker-compose.staging.yml" "up -d"
        echo -e "${GREEN}✅ Staging environment started${NC}"
        echo -e "${YELLOW}Direct access: http://localhost:8001${NC}"
        echo -e "${YELLOW}Reverse proxy: http://localhost:8080${NC}"
        ;;
    "prod")
        echo -e "${YELLOW}Starting production environment...${NC}"
        run_docker_compose "docker-compose.yml" "--profile production up -d"
        echo -e "${GREEN}✅ Production environment started${NC}"
        echo -e "${YELLOW}Direct access: http://localhost:8000${NC}"
        echo -e "${YELLOW}Reverse proxy: http://localhost:80${NC}"
        ;;
    "prod-secrets")
        echo -e "${YELLOW}Starting production with Docker secrets...${NC}"
        run_docker_compose "docker-compose.prod.yml" "up -d"
        echo -e "${GREEN}✅ Production with secrets started${NC}"
        echo -e "${YELLOW}Direct access: http://localhost:8000${NC}"
        echo -e "${YELLOW}Reverse proxy: http://localhost:80${NC}"
        ;;
    "down")
        echo -e "${YELLOW}Stopping all environments...${NC}"
        run_docker_compose "docker-compose.dev.yml" "down"
        run_docker_compose "docker-compose.staging.yml" "down"
        run_docker_compose "docker-compose.yml" "--profile production down"
        run_docker_compose "docker-compose.prod.yml" "down"
        echo -e "${GREEN}✅ All environments stopped${NC}"
        ;;
    "logs")
        case "$2" in
            "dev")
                run_docker_compose "docker-compose.dev.yml" "logs -f"
                ;;
            "staging")
                run_docker_compose "docker-compose.staging.yml" "logs -f"
                ;;
            "prod")
                run_docker_compose "docker-compose.yml" "--profile production logs -f"
                ;;
            *)
                echo -e "${RED}❌ Environment not specified. Use: dev, staging, or prod${NC}"
                ;;
        esac
        ;;
    "build")
        case "$2" in
            "dev")
                build_image "Dockerfile.dev" "devsu-nodejs-api:dev"
                ;;
            "prod")
                build_image "Dockerfile" "devsu-nodejs-api:latest"
                ;;
            *)
                echo -e "${RED}❌ Environment not specified. Use: dev or prod${NC}"
                ;;
        esac
        ;;
    *)
        show_usage
        exit 1
        ;;
esac 