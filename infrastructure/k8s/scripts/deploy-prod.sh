#!/bin/bash

# Script to deploy the application in production environment
set -e

echo "🚀 Deploying application in production environment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed"
    exit 1
fi

# Check if Minikube is running
if ! minikube status | grep -q "Running"; then
    echo "⚠️  Minikube is not running. Starting Minikube..."
    minikube start
fi

# Enable ingress addon
echo "📦 Enabling ingress addon..."
minikube addons enable ingress

# Create namespace if it doesn't exist
echo "🏗️  Creating namespace devsu-demo-prod..."
kubectl apply -f ../namespaces/namespaces.yaml

# Apply ConfigMap and Secret
echo "🔧 Applying ConfigMap and Secret..."
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml

# Apply Deployment
echo "📦 Applying Deployment..."
kubectl apply -f deployment.yaml

# Apply Service
echo "🌐 Applying Service..."
kubectl apply -f service.yaml

# Apply Ingress
echo "🚪 Applying Ingress..."
kubectl apply -f ingress.yaml

# Apply HPA
echo "⚖️  Applying HorizontalPodAutoscaler..."
kubectl apply -f hpa.yaml

# Wait for pods to be ready
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=devsu-demo -l environment=production --timeout=300s

# Show deployment information
echo "✅ Deployment completed!"
echo ""
echo "📊 Deployment status:"
kubectl get pods -n devsu-demo-prod
echo ""
echo "🌐 Services:"
kubectl get services -n devsu-demo-prod
echo ""
echo "🚪 Ingress:"
kubectl get ingress -n devsu-demo-prod
echo ""
echo "⚖️  HPA:"
kubectl get hpa -n devsu-demo-prod
echo ""
echo "🔗 To access the application:"
echo "   - Add 'devsu-demo-prod.local' to your /etc/hosts file"
echo "   - URL: http://devsu-demo-prod.local"
echo ""
echo "📝 Useful commands:"
echo "   - View logs: kubectl logs -f deployment/devsu-demo-app -n devsu-demo-prod"
echo "   - View pods: kubectl get pods -n devsu-demo-prod"
echo "   - View services: kubectl get services -n devsu-demo-prod" 