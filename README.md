# Demo DevOps Node.js

A simple REST API application with MariaDB database for DevOps testing and deployment practices.

## 🚀 Quick Start

### Prerequisites
- Node.js 18.15.0
- Docker & Docker Compose
- kubectl (for Kubernetes)
- Terraform (for infrastructure)

### 🐳 Local with Docker Compose
```bash
./infrastructure/scripts/setup-env.sh
cp ./.env.dev infrastructure/docker/.env
docker compose -f infrastructure/docker/docker-compose.yml up -d
```

### 🏗️ Local with Docker Container
```bash
./infrastructure/scripts/setup-env.sh
npm install
docker compose -f infrastructure/docker/docker-compose.yml up -d  # MariaDB only
npm run dev
```

### ☸️ Kubernetes (Staging)
```bash
./infrastructure/scripts/setup-env.sh
./infrastructure/k8s/scripts/init-staging.sh
./infrastructure/scripts/build-and-push-docker-image.sh infrastructure/docker/Dockerfile
```

### 🏗️ Terraform (Infrastructure)
```bash
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
./scripts/get-aws-resources.sh
terraform init
terraform plan
terraform apply
./infrastructure/k8s/scripts/init-staging.sh to-terraform
```

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

Access the API at: `http://localhost:8000/api/users`

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

- **CI/CD Pipeline**: Automatic build, test, and deployment to staging on `main` push
- **Production Deployment**: Manual deployment with confirmation required
- **Multi-architecture**: Docker images built for AMD64 and ARM64

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