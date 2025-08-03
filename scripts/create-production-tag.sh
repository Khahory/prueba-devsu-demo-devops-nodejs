#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo -e "${BLUE}🚀 Production Release Tag Creator${NC}"
echo "======================================"

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_error "You must be on the 'main' branch to create a production tag"
    print_info "Current branch: $CURRENT_BRANCH"
    print_info "Run: git checkout main"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean. Please commit or stash your changes."
    git status --short
    exit 1
fi

# Pull latest changes
print_info "Pulling latest changes from origin/main..."
git pull origin main

# Generate tag name with format: vYYYYMMDD-XX
DATE=$(date +"%Y%m%d")
EXISTING_TAGS=$(git tag -l "v${DATE}-*" | wc -l)
SEQUENCE=$(printf "%02d" $((EXISTING_TAGS + 1)))
TAG_NAME="v${DATE}-${SEQUENCE}"

# Show current status
echo ""
print_info "Repository Status:"
echo "  Branch: $CURRENT_BRANCH"
echo "  Latest commit: $(git log -1 --oneline)"
echo "  Proposed tag: $TAG_NAME"
echo ""

# Confirmation
read -p "$(echo -e ${YELLOW}Create and push tag \"$TAG_NAME\" to trigger production deployment? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Tag creation cancelled"
    exit 0
fi

# Create and push tag
print_info "Creating tag: $TAG_NAME"
git tag -a "$TAG_NAME" -m "Production release $TAG_NAME

Automatic production deployment will be triggered.

Commit: $(git rev-parse HEAD)
Date: $(date)
"

print_info "Pushing tag to origin..."
git push origin "$TAG_NAME"

print_status "Production tag created and pushed successfully!"
echo ""
print_info "🔄 GitHub Actions will now:"
print_info "  1. Build and test the application"
print_info "  2. Create Docker image with tag: $TAG_NAME"
print_info "  3. Deploy automatically to production EKS cluster"
print_info "  4. Run health checks"
print_info ""
print_info "🌐 Monitor the deployment at:"
print_info "  https://github.com/$(git config --get remote.origin.url | sed 's/.*://; s/.git$//')/actions"
print_info ""
print_warning "Note: Production deployment requires approval if protection rules are enabled."