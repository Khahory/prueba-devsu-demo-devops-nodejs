#!/bin/bash

# Script to clean up all Kubernetes resources
set -e

echo "🧹 Cleaning up Kubernetes resources..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed"
    exit 1
fi

# Function to clean up a namespace
cleanup_namespace() {
    local namespace=$1ß
    echo "🗑️  Cleaning up namespace: $namespace"
    
    # Delete all resources in the namespace
    kubectl delete deployment,service,ingress,hpa,configmap,secret --all -n $namespace --ignore-not-found=true
    
    # Delete the namespace
    kubectl delete namespace $namespace --ignore-not-found=true
    
    echo "✅ Namespace $namespace cleaned up"
}

# Clean up all application namespaces
echo "📋 Deleting application resources..."

cleanup_namespace "devsu-demo-staging"
cleanup_namespace "devsu-demo-prod"

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "📝 To verify that everything was deleted correctly:"
echo "   kubectl get namespaces | grep devsu-demo"
echo "   kubectl get all --all-namespaces | grep devsu-demo" 