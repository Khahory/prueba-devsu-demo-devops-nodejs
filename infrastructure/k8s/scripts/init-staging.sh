#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

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
    "MYSQL_ROOT_PASSWORD"
    "MYSQL_USER"
    "MYSQL_PASSWORD"
    "DATABASE_USER"
    "DATABASE_PASSWORD"
    "JWT_SECRET"
    "SESSION_SECRET"
)

for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "Error: Required environment variable $var is not set"
        exit 1
    fi
done

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

cat > "$TEMP_DIR/mariadb-secret.yaml" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: mariadb-secrets
  namespace: devsu-demo-staging
  labels:
    app: mariadb
    environment: staging
    component: database
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: $(echo -n "$MYSQL_ROOT_PASSWORD" | base64)
  MYSQL_USER: $(echo -n "$MYSQL_USER" | base64)
  MYSQL_PASSWORD: $(echo -n "$MYSQL_PASSWORD" | base64)
EOF

cat > "$TEMP_DIR/secret.yaml" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: devsu-demo-secrets
  namespace: devsu-demo-staging
  labels:
    app: devsu-demo
    environment: staging
    component: secrets
type: Opaque
data:
  DATABASE_USER: $(echo -n "$DATABASE_USER" | base64)
  DATABASE_PASSWORD: $(echo -n "$DATABASE_PASSWORD" | base64)
  JWT_SECRET: $(echo -n "$JWT_SECRET" | base64)
  SESSION_SECRET: $(echo -n "$SESSION_SECRET" | base64)
EOF

kubectl apply -f infrastructure/k8s/namespaces/namespaces.yaml

kubectl apply -f infrastructure/k8s/staging/configmap.yaml
kubectl apply -f infrastructure/k8s/staging/hpa.yaml
kubectl apply -f infrastructure/k8s/staging/mariadb-configmap.yaml
kubectl apply -f infrastructure/k8s/staging/mariadb-deployment.yaml
kubectl apply -f "$TEMP_DIR/mariadb-secret.yaml"
kubectl apply -f infrastructure/k8s/staging/mariadb-service.yaml
kubectl apply -f "$TEMP_DIR/secret.yaml"
kubectl apply -f infrastructure/k8s/staging/service.yaml 