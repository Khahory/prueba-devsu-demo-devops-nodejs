# 🚀 Production Deployment Guide

## 📋 Overview

The project now supports **automatic production deployment** when creating version tags on the `main` branch.

## 🏷️ Creating Production Tags

### Option 1: Automated Script (Recommended)
```bash
./scripts/create-production-tag.sh
```

This script will:
- ✅ Check you're on `main` branch
- ✅ Verify clean working directory
- ✅ Pull latest changes
- ✅ Generate tag name (format: `vYYYYMMDD-XX`)
- ✅ Create and push tag
- ✅ Trigger automatic deployment

### Option 2: Manual Tag Creation
```bash
# Format: vYYYYMMDD-XX (e.g., v20240803-01)
git tag -a v20240803-01 -m "Production release v20240803-01"
git push origin v20240803-01
```

## 🔧 Troubleshooting

### Common Issues

1. **Tag format error**: Use format `vYYYYMMDD-XX`
2. **Image not found**: Verify Docker Hub push succeeded
3. **Health check fails**: Check MariaDB is running
4. **Timeout**: Production deployments have 10-minute timeout

### Debug Commands
```bash
# Check production pods
kubectl get pods -n devsu-demo-prod

# Check deployment status
kubectl describe deployment devsu-demo-app -n devsu-demo-prod

# View logs
kubectl logs -n devsu-demo-prod -l app=devsu-demo --tail=50

# Check external access
kubectl get service devsu-demo-service -n devsu-demo-prod
```
