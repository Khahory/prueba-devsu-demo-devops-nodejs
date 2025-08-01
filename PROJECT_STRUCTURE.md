# Project Structure

This document explains the organized structure of the Node.js application with infrastructure separation.

## 📁 Directory Structure

```
devsu-demo-devops-nodejs/
├── 📁 infrastructure/           # Infrastructure configuration
│   ├── 📁 docker/             # Docker files and compose
│   │   ├── Dockerfile         # Production Docker image
│   │   ├── Dockerfile.dev     # Development Docker image
│   │   ├── docker-compose.yml # Production environment
│   │   ├── docker-compose.dev.yml # Development environment
│   │   ├── docker-compose.staging.yml # Staging environment
│   │   ├── docker-compose.prod.yml # Production with secrets
│   │   └── .dockerignore      # Docker ignore file
│   ├── 📁 nginx/              # Nginx configuration
│   │   └── nginx.conf         # Reverse proxy config
│   ├── 📁 env/                # Environment templates
│   │   ├── env.example        # Production template
│   │   ├── env.dev.example    # Development template
│   │   └── env.staging.example # Staging template
│   ├── 📁 scripts/            # Infrastructure scripts
│   │   ├── setup-env.sh       # Environment setup
│   │   └── setup-secrets.sh   # Docker secrets setup
│   ├── 📁 secrets/            # Docker secrets (not in version control)
│   └── 📄 README.md           # Infrastructure documentation
├── 📁 shared/                  # Shared application code
│   ├── 📁 database/           # Database configuration
│   ├── 📁 middleware/         # Express middleware
│   └── 📁 schema/             # Validation schemas
├── 📁 users/                   # User-related modules
│   ├── controller.js          # User controller
│   ├── model.js              # User model
│   └── router.js             # User routes
├── 📁 docs/                    # Documentation
├── 📁 data/                    # SQLite database files
├── 📁 scripts/                 # Project scripts
│   └── docker.sh              # Docker management script
├── 📄 index.js                 # Application entry point
├── 📄 package.json            # Node.js dependencies
├── 📄 README.md               # Main documentation
└── 📄 PROJECT_STRUCTURE.md    # This file
```

## 🎯 Benefits of This Structure

### 1. **Separation of Concerns**
- **Application Code**: Core business logic in root
- **Infrastructure**: All deployment/config files in `infrastructure/`
- **Documentation**: Clear separation of docs

### 2. **Easy Navigation**
- Docker files grouped in `infrastructure/docker/`
- Environment templates in `infrastructure/env/`
- Scripts organized by purpose

### 3. **Security Best Practices**
- Secrets directory excluded from version control
- Environment files properly organized
- Clear separation of dev/staging/prod configs

### 4. **Maintainability**
- Modular structure
- Clear documentation
- Consistent naming conventions

## 🚀 Quick Commands

### Environment Setup
```bash
# Generate environment files
./infrastructure/scripts/setup-env.sh

# Generate Docker secrets
./infrastructure/scripts/setup-secrets.sh
```

### Docker Management
```bash
# Development
./scripts/docker.sh dev

# Staging
./scripts/docker.sh staging

# Production
./scripts/docker.sh prod

# Stop all
./scripts/docker.sh down

# View logs
./scripts/docker.sh logs dev
```

### Manual Docker (if needed)
```bash
# From project root
docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d
docker-compose -f infrastructure/docker/docker-compose.staging.yml up -d
docker-compose -f infrastructure/docker/docker-compose.yml --profile production up -d
```

## 📋 File Organization Principles

### **Infrastructure Directory**
- **Docker**: All containerization files
- **Nginx**: Reverse proxy configuration
- **Env**: Environment variable templates
- **Scripts**: Automation and setup scripts
- **Secrets**: Secure credential storage

### **Application Directory**
- **Root**: Main application files
- **Shared**: Reusable application components
- **Users**: Feature-specific modules
- **Scripts**: Project management scripts

### **Documentation**
- **README.md**: Main project documentation
- **infrastructure/README.md**: Infrastructure-specific docs
- **PROJECT_STRUCTURE.md**: This structure guide

## 🔧 Configuration Files

### **Environment Variables**
- `.env` - Production (generated from template)
- `.env.dev` - Development (generated from template)
- `.env.staging` - Staging (generated from template)

### **Docker Compose Files**
- `docker-compose.yml` - Production with Nginx
- `docker-compose.dev.yml` - Development with hot reload
- `docker-compose.staging.yml` - Staging environment
- `docker-compose.prod.yml` - Production with Docker secrets

### **Docker Images**
- `Dockerfile` - Production optimized image
- `Dockerfile.dev` - Development with nodemon

## 🛡️ Security Considerations

1. **Secrets Management**
   - Docker secrets for production
   - Environment files for dev/staging
   - Secrets directory in .gitignore

2. **Environment Separation**
   - Different configs per environment
   - Isolated databases per environment
   - Separate logging and monitoring

3. **Access Control**
   - Non-root user in containers
   - Proper file permissions
   - Network isolation

## 📊 Monitoring and Logs

### **Environment-Specific Logging**
```
[DEVELOPMENT] 📋 GET /api/users - Listing all users
[STAGING] ✅ User created successfully: John Doe (ID: 1)
[PRODUCTION] 🚀 Server running on port 8000
```

### **Health Checks**
- Application health: `/health`
- Database connectivity
- Container health checks

## 🔄 Deployment Workflow

1. **Development**: Local development with hot reload
2. **Staging**: Testing environment with production-like setup
3. **Production**: Full production with Nginx and secrets

This structure provides a clean, maintainable, and scalable foundation for the Node.js application with proper infrastructure separation. 