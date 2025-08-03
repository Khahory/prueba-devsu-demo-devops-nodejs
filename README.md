# Demo DevOps Node.js

A simple REST API application with MariaDB database for DevOps testing and deployment practices.

## 🚀 Quick Start

### Prerequisites
- Node.js 18.15.0
- Docker & Docker Compose
- kubectl (for Kubernetes)
- Terraform (for infrastructure)
- AWS CLI (for AWS EKS)

## 💨 Running the Application

### 🐳 Local with Docker Compose
```bash
docker compose -f infrastructure/docker/docker-compose.yml down # Stop and remove existing containers
docker compose -f infrastructure/docker/docker-compose-mariadb.yml down # Stop and remove existing containers
./infrastructure/scripts/setup-env.sh # Generate random secrets
cp ./.env.dev infrastructure/docker/.env
docker compose -f infrastructure/docker/docker-compose.yml up -d --build
```

Access the health check at: [http://localhost:8000/health](http://localhost:8000/health)

### 🏗️ Local API and Docker Container for MariaDB
```bash
docker compose -f infrastructure/docker/docker-compose.yml down # Stop and remove existing containers
docker compose -f infrastructure/docker/docker-compose-mariadb.yml down # Stop and remove existing containers
./infrastructure/scripts/setup-env.sh # Generate random secrets
cp ./.env infrastructure/docker/.env
docker compose -f infrastructure/docker/docker-compose-mariadb.yml up -d --build # MariaDB only
npm install
npm run dev
```

Access the health check at: [http://localhost:8001/health](http://localhost:8001/health)

### 🏗️ Terraform (Infrastructure) - Create AWS EKS Cluster

**Prerequisites:**
- AWS CLI installed and authenticated (`aws configure`)
- Terraform Cloud account with access key and password configured

```bash
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
./scripts/get-aws-resources.sh # Fetch AWS resources and save to terraform.tfvars
terraform init
terraform login
terraform workspace new devsu-demo-prod # Create a new workspace for production
terraform workspace new devsu-demo-stage # Create a new workspace for staging
terraform plan
terraform apply
./infrastructure/k8s/scripts/init-staging.sh to-terraform
```

### ☸️ Kubernetes (Staging)
```bash
./infrastructure/scripts/setup-env.sh
./infrastructure/k8s/scripts/init-staging.sh
./infrastructure/scripts/build-and-push-docker-image.sh infrastructure/docker/Dockerfile
```

### ☸️ Kubernetes (Production)
```bash
./infrastructure/scripts/setup-env.sh
./infrastructure/k8s/scripts/init-prod.sh
./infrastructure/scripts/build-and-push-docker-image.sh infrastructure/docker/Dockerfile
```

### 🌐 Get Service DNS

After deploying to Kubernetes, you can get the DNS of the LoadBalancer service to test the application:

**Staging Environment:**
```bash
kubectl get service devsu-demo-service -n devsu-demo-staging -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

**Production Environment:**
```bash
kubectl get service devsu-demo-service -n devsu-demo-prod -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
Use the returned DNS URL to test the application endpoints (e.g., `http://<dns-url>/health`).

## 🧪 Testing

```bash
npm run test              # Unit tests
npm run test:coverage     # Tests with coverage
npm run lint             # Code linting
```

## 🗄️ Database

Uses **MariaDB** database. To connect and query:

```bash
mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
select * from users;
```

Access the API at: `http://<URL>/api/users`

### Features

These services can perform,

#### Create User

To create a user, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: POST
```

```json
{
    "dni": "dni",
    "name": "name"
}
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "error": "error"
}
```

#### Get Users

To get all users, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
[
    {
        "id": 1,
        "dni": "dni",
        "name": "name"
    }
]
```

#### Get User

To get an user, the endpoint **/api/users/<id>** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the user id does not exist, we will receive status 404 and the following message:

```json
{
    "error": "User not found: <id>"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "errors": [
        "error"
    ]
}
```

## 🔄 CI/CD Pipeline

The project includes automated GitHub Actions workflows:

### 🚀 Automatic Deployments

- **Staging**: Automatic deployment on every `main` branch push
- **Production**: Automatic deployment when creating version tags (format: `vYYYYMMDD-XX`)

### 📦 Deployment Process

1. **Push to `main`** → Build, test, deploy to staging
2. **Create tag** → Build, test, deploy to production automatically

```bash
# Create production release tag (automatic deployment)
./scripts/create-production-tag.sh

# Manual deployment to production (alternative)
gh workflow run "Deploy to Production" -f image_tag=v20240803-01 -f confirm_production=PRODUCTION
```

### 🏷️ Tag Format
- `v20240803-01` (vYYYYMMDD-XX)
- Automatically increments sequence number for same day
- Multi-architecture Docker images (AMD64/ARM64)

## 🛠️ Tech Stack

- **Runtime**: Node.js 18 with Express
- **Database**: MariaDB
- **Testing**: Jest with mocks
- **Infrastructure**: Terraform + AWS EKS
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes with auto-scaling

## 📁 Project Structure

```
├── infrastructure/
│   ├── docker/          # Docker configuration
│   ├── k8s/            # Kubernetes manifests
│   ├── terraform/      # Infrastructure as Code
│   └── scripts/        # Automation scripts
├── users/              # User API endpoints
├── shared/             # Database & middleware
└── .github/workflows/  # CI/CD pipelines
```

## License

Copyright © 2023 Devsu. All rights reserved.