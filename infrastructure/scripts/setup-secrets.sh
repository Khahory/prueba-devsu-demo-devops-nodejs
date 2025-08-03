#!/bin/bash

# Script to setup Docker secrets for production
# This script creates the necessary secret files for production deployment

set -e

echo "🔐 Setting up Docker secrets for production..."

# Function to generate secure random string
generate_secret() {
    openssl rand -base64 32 2>/dev/null || head -c 32 /dev/urandom | base64
}

# Function to create secret file
create_secret_file() {
    local secret_name=$1
    local secret_value=$2
    local secret_file="secrets/${secret_name}.txt"
    
    # Create secrets directory if it doesn't exist
    mkdir -p secrets
    
    if [ -f "$secret_file" ]; then
        echo "⚠️  Secret file $secret_file already exists. Skipping..."
        return
    fi
    
    echo "$secret_value" > "$secret_file"
    chmod 600 "$secret_file"
    echo "✅ Created $secret_file"
}

# Change to infrastructure/docker directory
cd "$(dirname "$0")/../docker"

# Create secrets directory
mkdir -p secrets

echo "📁 Setting up secrets in $(pwd)/secrets..."

# Generate and create secret files
echo "🔑 Generating secure secrets..."

# Database password
DB_PASSWORD=$(generate_secret)
create_secret_file "db_password" "$DB_PASSWORD"

# JWT secret
JWT_SECRET=$(generate_secret)
create_secret_file "jwt_secret" "$JWT_SECRET"

# Session secret
SESSION_SECRET=$(generate_secret)
create_secret_file "session_secret" "$SESSION_SECRET"

echo ""
echo "🎉 Docker secrets setup complete!"
echo ""
echo "📝 Created secret files:"
echo "   - secrets/db_password.txt"
echo "   - secrets/jwt_secret.txt"
echo "   - secrets/session_secret.txt"
echo ""
echo "🔒 Security notes:"
echo "   - Secret files have 600 permissions (owner read/write only)"
echo "   - Never commit secret files to version control"
echo "   - Add 'secrets/' to .gitignore if not already there"