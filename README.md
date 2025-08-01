# Demo Devops NodeJs

This is a simple application to be used in the technical test of DevOps.

## Project Structure

```
devsu-demo-devops-nodejs/
├── infrastructure/           # Infrastructure configuration
│   ├── docker/             # Docker files and compose
│   ├── nginx/              # Nginx configuration
│   ├── env/                # Environment templates
│   ├── scripts/            # Infrastructure scripts
│   └── secrets/            # Docker secrets (not in version control)
├── shared/                  # Shared application code
│   ├── database/           # Database configuration
│   ├── middleware/         # Express middleware
│   └── schema/             # Validation schemas
├── users/                   # User-related modules
│   ├── controller.js       # User controller
│   ├── model.js           # User model
│   └── router.js          # User routes
├── docs/                    # Documentation
├── data/                    # SQLite database files
├── index.js                 # Application entry point
├── package.json            # Node.js dependencies
└── README.md               # This file
```

## Getting Started

### Prerequisites

- Node.js 18.15.0
- Docker (optional, for containerized deployment)

### Quick Start with Scripts

We provide convenient scripts for managing the application:

```bash
# Setup environment variables
./infrastructure/scripts/setup-env.sh

# Start development environment
./scripts/docker.sh dev

# Start staging environment
./scripts/docker.sh staging

# Start production environment
./scripts/docker.sh prod

# Stop all environments
./scripts/docker.sh down

# View logs
./scripts/docker.sh logs dev
./scripts/docker.sh logs staging
./scripts/docker.sh logs prod
```

### Installation

Clone this repo.

```bash
git clone https://bitbucket.org/devsu/demo-devops-nodejs.git
```

Install dependencies.

```bash
npm i
```

### Database

The database is generated as a file in the main path when the project is first run, and its name is `dev.sqlite`.

Consider giving access permissions to the file for proper functioning.

## Usage

### Local Development

To run tests you can use this command.

```bash
npm run test
```

To run locally the project you can use this command.

```bash
npm run start
```

Open http://localhost:8000/api/users with your browser to see the result.

### Docker Deployment

#### Quick Start with Docker Compose

```bash
# Build and run with docker-compose
docker-compose up --build

# Run in background
docker-compose up -d

# Stop services
docker-compose down
```

#### Manual Docker Build

```bash
# Build the image
./scripts/build.sh

# Or manually
docker build -t devsu-nodejs-api:latest .

# Run the container
docker run -p 8000:8000 devsu-nodejs-api:latest
```

#### Development with Docker

```bash
# Run development environment with hot reload
docker-compose -f infrastructure/docker/docker-compose.dev.yml up --build

# Run in background
docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d
```

#### Staging Environment

```bash
# Setup staging environment
cp infrastructure/env/env.staging.example .env.staging

# Run staging environment
docker-compose -f infrastructure/docker/docker-compose.staging.yml up -d

# Access staging
curl http://localhost:8001/health  # Direct access
curl http://localhost:8080/health  # Through reverse proxy
```

#### Production Deployment with Nginx

```bash
# Setup secrets first
./infrastructure/scripts/setup-secrets.sh

# Run with Nginx reverse proxy and Docker secrets
docker-compose -f infrastructure/docker/docker-compose.prod.yml up -d
```

#### Reverse Proxy Testing

**Start the reverse proxy:**
```bash
# Start with Nginx reverse proxy
docker-compose --profile production up -d

# Verify containers are running
docker ps
```

**Test the reverse proxy:**
```bash
# Health check through reverse proxy
curl http://localhost/health

# API endpoints through reverse proxy
curl http://localhost/api/users

# Create user through reverse proxy
curl -X POST -H "Content-Type: application/json" \
  -d '{"name":"Test User","dni":"12345678"}' \
  http://localhost/api/users

# Verify security headers
curl -I http://localhost/api/users
```

**Compare direct access vs reverse proxy:**
```bash
# Direct access (port 8000)
curl http://localhost:8000/api/users

# Through reverse proxy (port 80)
curl http://localhost/api/users
```

**Test rate limiting:**
```bash
# Make multiple requests to test rate limiting
for i in {1..15}; do 
  curl -s -w "%{http_code}\n" http://localhost/api/users -o /dev/null
done
```

**Stop the reverse proxy:**
```bash
docker-compose --profile production down
```

#### Reverse Proxy Features

**Security Headers Added by Nginx:**
- `X-Frame-Options: SAMEORIGIN` - Prevents clickjacking
- `X-XSS-Protection: 1; mode=block` - XSS protection
- `X-Content-Type-Options: nosniff` - Prevents MIME type sniffing
- `Content-Security-Policy` - Content security policy
- `Referrer-Policy: no-referrer-when-downgrade` - Referrer policy

**Performance Optimizations:**
- Gzip compression for text-based responses
- Rate limiting (10 requests per second)
- Proxy caching configuration
- Optimized timeouts (60s connect/send/read)

**Network Configuration:**
- Isolated Docker network
- Reverse proxy on port 80/443
- Direct app access on port 8000
- Health check endpoint at `/health`

**Expected Response Headers:**
```bash
# Through reverse proxy
Server: nginx/1.29.0
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src 'self' http: https: data: blob: 'unsafe-inline'

# Direct access
X-Powered-By: Express
# (No security headers)
```

#### Troubleshooting

**Nginx container restarting:**
```bash
# Check Nginx logs
docker logs devsu-nginx

# Common issues:
# - Invalid nginx.conf syntax
# - Port conflicts
# - Missing upstream server
```

**Application not accessible through proxy:**
```bash
# Check if app container is running
docker ps | grep devsu-nodejs-api

# Check app logs
docker logs devsu-nodejs-api

# Verify network connectivity
docker exec devsu-nginx ping app
```

**Rate limiting issues:**
```bash
# Check current rate limit status
curl -I http://localhost/api/users

# If getting 429 errors, wait and retry
sleep 1 && curl http://localhost/api/users
```

**SSL/TLS Configuration (for production):**
```bash
# Add SSL certificates to ./ssl/ directory
# Update nginx.conf to include SSL server block
# Restart containers
docker-compose --profile production restart nginx
```

#### Quick Commands Reference

**Development:**
```bash
# Start development environment
docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d

# View development logs
docker-compose -f infrastructure/docker/docker-compose.dev.yml logs -f
```

**Staging:**
```bash
# Start staging environment
docker-compose -f infrastructure/docker/docker-compose.staging.yml up -d

# View staging logs
docker-compose -f infrastructure/docker/docker-compose.staging.yml logs -f
```

**Production:**
```bash
# Start with reverse proxy
docker-compose -f infrastructure/docker/docker-compose.yml --profile production up -d

# Start with Docker secrets
docker-compose -f infrastructure/docker/docker-compose.prod.yml up -d

# View production logs
docker-compose -f infrastructure/docker/docker-compose.yml --profile production logs -f
```

**Testing:**
```bash
# Health check
curl http://localhost/health

# API test
curl http://localhost/api/users

# Create user
curl -X POST -H "Content-Type: application/json" \
  -d '{"name":"Test","dni":"123456"}' \
  http://localhost/api/users

# Check headers
curl -I http://localhost/api/users
```

**Management:**
```bash
# Stop all services
docker-compose --profile production down

# Rebuild and restart
docker-compose --profile production up --build -d

# View running containers
docker ps

# Clean up
docker system prune -f
```

#### Security Best Practices

**Environment Variables:**
- ✅ Never hardcode secrets in Dockerfile
- ✅ Use separate .env files for different environments
- ✅ Generate secure random secrets
- ✅ Use Docker secrets for production

**Docker Security:**
- ✅ Non-root user execution
- ✅ Minimal base image (Alpine)
- ✅ Multi-stage build for smaller attack surface
- ✅ Health checks for monitoring
- ✅ Proper file permissions

**Network Security:**
- ✅ Isolated networks
- ✅ Reverse proxy with security headers
- ✅ Rate limiting
- ✅ SSL/TLS support (configure certificates)

#### Environment Variables (Security Best Practices)

**⚠️ IMPORTANT: Never commit .env files to version control!**

Setup environment variables securely:

```bash
# Generate secure environment files
./infrastructure/scripts/setup-env.sh

# Or manually create .env files based on examples:
cp infrastructure/env/env.example .env
cp infrastructure/env/env.dev.example .env.dev
```

**Security Features:**
- ✅ `.env` files are in `.gitignore` and `.dockerignore`
- ✅ Sensitive variables are not hardcoded in Dockerfile
- ✅ Separate files for development and production
- ✅ Secure random secrets generation
- ✅ Environment-specific configurations

**Available environment variables:**
- `PORT`: Application port (default: 8000)
- `NODE_ENV`: Environment (development/production)
- `DATABASE_USER`: Database username
- `DATABASE_PASSWORD`: Database password (use strong passwords)
- `DATABASE_NAME`: Database file path
- `LOG_LEVEL`: Logging level
- `JWT_SECRET`: JWT signing secret (auto-generated)
- `SESSION_SECRET`: Session secret (auto-generated)
- `FORCE_SYNC`: Database sync mode (true/false, default: false)

**Production Security:**
- Use Docker secrets or Kubernetes secrets for production
- Rotate secrets regularly
- Use strong, unique passwords
- Consider using external secret management services

#### Database Management

**Database Sync Modes:**
- `FORCE_SYNC=false` (default): Uses `alter: true` - preserves data, updates schema
- `FORCE_SYNC=true`: Uses `force: true` - drops and recreates all tables (⚠️ **DESTROYS DATA**)

**Best Practices:**
```bash
# Development (preserve data)
FORCE_SYNC=false npm start

# Reset database (⚠️ destroys all data)
FORCE_SYNC=true npm start

# Docker with preserved data
docker-compose up -d

# Docker with reset database
FORCE_SYNC=true docker-compose up -d
```

**Database File Location:**
- SQLite database: `./data/test-db.sqlite`
- Data persists between container restarts
- Volume mounted in Docker for data persistence

#### Environment-Specific Logging

**Log Format:**
```
[ENVIRONMENT] 📋 GET /api/users - Listing all users
[ENVIRONMENT] ✅ Found 3 users
[ENVIRONMENT] ➕ POST /api/users - Creating new user: John Doe (DNI: 12345678)
[ENVIRONMENT] ✅ User created successfully: John Doe (ID: 1)
```

**Available Environments:**
- `[DEVELOPMENT]` - Development environment
- `[STAGING]` - Staging environment  
- `[PRODUCTION]` - Production environment

**Environment Setup:**
```bash
# Development
NODE_ENV=development npm start

# Staging
NODE_ENV=staging npm start

# Production
NODE_ENV=production npm start
```

#### Health Check

The application includes a health check endpoint:

```bash
curl http://localhost:8000/health
```

Response:
```json
{
    "status": "healthy",
    "timestamp": "2024-01-01T00:00:00.000Z",
    "uptime": 123.456
}
```



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

## License

Copyright © 2023 Devsu. All rights reserved.
# prueba-devsu-demo-devops-nodejs
