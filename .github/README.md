# CI/CD Pipeline

This directory contains GitHub Actions workflows to automate the continuous integration and deployment process.

## Workflows

### 🚀 CI/CD Pipeline (`ci-cd.yml`)

Main pipeline that executes all quality steps and automatic deployment:

#### Triggers:
- **Push to `main`** → Runs complete pipeline and deploys to **stage**
- **Pull Request to `main`** → Runs complete pipeline and deploys to **stage**  
- **Tag on `main` (format: v[YYYYMMDD]-XX)** → Runs complete pipeline and deploys to **production**

#### Included Jobs:

1. **🔨 Build** - Code compilation
2. **🧪 Unit Tests** - Unit test execution with Jest
3. **🔍 Code Analysis** - Static analysis with ESLint and Prettier
4. **📊 Code Coverage** - Code coverage measurement
5. **🔒 Security Scan** - Vulnerability scanning with npm audit and Snyk
6. **🐳 Docker Build & Push** - Docker image building and publishing
7. **🚀 Deploy** - Automatic deployment using existing actions

### 🚀 Manual Deployment (`deploy.yml`)

Workflow for controlled manual deployments:

#### Triggers:
- **workflow_dispatch** - Manual deployment from GitHub UI

#### Functionality:
- Allows environment selection (stage/production)
- Allows specifying version to deploy
- Uses the same deployment actions

## Environment Logic

The pipeline uses the existing `set-env` action that determines the environment based on:

- **Tag with format `v[YYYYMMDD]-XX`** → `production`
- **Push to main or PR** → `stage`
- **Other events** → `stage`

## Configuration

### Required Secrets in GitHub:
1. `DOCKER_PASSWORD` - Docker Hub password
2. `SNYK_TOKEN` - Snyk token (optional)

### Required Variables in GitHub:
1. `DOCKER_USERNAME` - Docker Hub username

### Environment Variables:
- `NODE_VERSION` - Node.js version (default: 18)
- `DOCKER_IMAGE` - Docker image name

## Workflow

### Automatic:
1. **Development**: Developers work on feature branches
2. **Pull Request**: Create a PR to `main`
3. **CI**: All quality jobs are executed
4. **CD**: If all checks pass, merge and deploy automatically
5. **Release**: When creating a tag, deploy to production

### Manual:
1. Go to Actions → Manual Deployment
2. Select environment and version
3. Execute workflow manually

## Customization

### Adding new jobs:
1. Create the job in `ci-cd.yml`
2. Define dependencies with `needs:`
3. Configure appropriate triggers

### Modifying deployment:
Edit the actions in `.github/actions/deploy/` to customize the deployment process. 