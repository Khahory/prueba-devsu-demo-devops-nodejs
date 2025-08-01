#!/bin/bash

# Setup Docker secrets script for production
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up Docker secrets for production...${NC}"

# Function to generate secure random string
generate_secret() {
    openssl rand -base64 32 2>/dev/null || head -c 32 /dev/urandom | base64
}

# Create secrets directory
mkdir -p secrets

# Generate secrets
echo -e "${GREEN}Generating secure secrets...${NC}"

# Database password
echo "$(generate_secret)" > secrets/db_password.txt
chmod 600 secrets/db_password.txt

# JWT secret
echo "$(generate_secret)" > secrets/jwt_secret.txt
chmod 600 secrets/jwt_secret.txt

# Session secret
echo "$(generate_secret)" > secrets/session_secret.txt
chmod 600 secrets/session_secret.txt

echo -e "${GREEN}✅ Docker secrets created successfully!${NC}"
echo -e "${YELLOW}Important security notes:${NC}"
echo -e "  - Secrets are stored in ./secrets/ directory"
echo -e "  - Files have 600 permissions (owner read/write only)"
echo -e "  - Add ./secrets/ to .gitignore"
echo -e "  - Use different secrets for each environment"
echo -e "  - Rotate secrets regularly in production"
echo -e ""
echo -e "${GREEN}Files created:${NC}"
echo -e "  - secrets/db_password.txt"
echo -e "  - secrets/jwt_secret.txt"
echo -e "  - secrets/session_secret.txt"
echo -e ""
echo -e "${YELLOW}To use with Docker Compose:${NC}"
echo -e "  docker-compose -f docker-compose.prod.yml up -d"
echo -e ""
echo -e "${YELLOW}For Kubernetes:${NC}"
echo -e "  kubectl create secret generic app-secrets \\"
echo -e "    --from-file=db_password=secrets/db_password.txt \\"
echo -e "    --from-file=jwt_secret=secrets/jwt_secret.txt \\"
echo -e "    --from-file=session_secret=secrets/session_secret.txt" 