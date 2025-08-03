#!/bin/bash

# Setup environment variables script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up environment variables...${NC}"

# Function to generate secure random string
generate_secret() {
    openssl rand -base64 32 2>/dev/null || head -c 32 /dev/urandom | base64
}

# Check if .env file exists
if [ -f ".env" ]; then
    echo -e "${YELLOW}Warning: .env file already exists. Backing up to .env.backup${NC}"
    cp .env .env.backup
fi

# Create production .env file
echo -e "${GREEN}Creating .env file for production...${NC}"
cat > .env << EOF
# Database Configuration
DATABASE_USER=admin
DATABASE_PASSWORD=$(generate_secret)
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_NAME=devsu_demo

# Application Configuration
PORT=8000
LOG_LEVEL=info

# Security Configuration
JWT_SECRET=$(generate_secret)
SESSION_SECRET=$(generate_secret)

# Database Sync Configuration
FORCE_SYNC=false

# AWS Configuration for Terraform
AWS_ACCESS_KEY=<your_aws_access_key_here>
AWS_SECRET_KEY=<your_aws_secret_key_here>

# External Services
# DATABASE_URL=localhost:3306

# Other Configuration
DOCKER_USERNAME=
DOCKER_PASSWORD=
SNYK_TOKEN=
EOF

# Check if .env.dev file exists
if [ -f ".env.dev" ]; then
    echo -e "${YELLOW}Warning: .env.dev file already exists. Backing up to .env.dev.backup${NC}"
    cp .env.dev .env.dev.backup
fi

# Create development .env file
echo -e "${GREEN}Creating .env.dev file for development...${NC}"
cat > .env.dev << EOF
# Database Configuration (Development)
DATABASE_USER=admin
DATABASE_PASSWORD=dev_password_123
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_NAME=devsu_demo

# Application Configuration
PORT=8000
LOG_LEVEL=debug

# Security Configuration (Development - use strong secrets in production)
JWT_SECRET=dev_jwt_secret_change_in_production
SESSION_SECRET=dev_session_secret_change_in_production

# Database Sync Configuration
FORCE_SYNC=false

# AWS Configuration for Terraform
AWS_ACCESS_KEY=<your_aws_access_key_here>
AWS_SECRET_KEY=<your_aws_secret_key_here>

# External Services
# DATABASE_URL=localhost:3306

# Other Configuration
DOCKER_USERNAME=
DOCKER_PASSWORD=
SNYK_TOKEN=
EOF

# Check if .env.staging file exists
if [ -f ".env.staging" ]; then
    echo -e "${YELLOW}Warning: .env.staging file already exists. Backing up to .env.staging.backup${NC}"
    cp .env.staging .env.staging.backup
fi

# Create staging .env file
echo -e "${GREEN}Creating .env.staging file for staging...${NC}"
cat > .env.staging << EOF
# Database Configuration (Staging)
DATABASE_USER=admin
DATABASE_PASSWORD=staging_password_123
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_NAME=devsu_demo

# Application Configuration
PORT=8000
LOG_LEVEL=info
NODE_ENV=staging

# Security Configuration (Staging - use strong secrets in production)
JWT_SECRET=staging_jwt_secret_change_in_production
SESSION_SECRET=staging_session_secret_change_in_production

# Database Sync Configuration
FORCE_SYNC=false

# AWS Configuration for Terraform
AWS_ACCESS_KEY=<your_aws_access_key_here>
AWS_SECRET_KEY=<your_aws_secret_key_here>

# External Services
# DATABASE_URL=localhost:3306

# Other Configuration
DOCKER_USERNAME=
DOCKER_PASSWORD=
SNYK_TOKEN=
EOF

echo -e "${GREEN}✅ Environment files created successfully!${NC}"
echo -e "${YELLOW}Important security notes:${NC}"
echo -e "  - .env files are in .gitignore and .dockerignore"
echo -e "  - Never commit .env files to version control"
echo -e "  - Use strong, unique secrets in production"
echo -e "  - Consider using Docker secrets or Kubernetes secrets for production"
echo -e ""
echo -e "${GREEN}Files created:${NC}"
echo -e "  - .env (production)"
echo -e "  - .env.dev (development)"
echo -e "  - .env.staging (staging)"
echo -e ""
echo -e "${GREEN}📊 Database Initialization:${NC}"
echo -e "  - The application will automatically create the 'users' table on first startup"
echo -e "  - To manually initialize the database, run: node scripts/init-database.js"
echo -e "  - To force recreate all tables, run: node scripts/init-database.js --force"
echo -e "  - Set FORCE_SYNC=true in your .env file to force sync on every startup"
