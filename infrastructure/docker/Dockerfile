# Multi-stage build for optimized production image
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY ../package.json ../package-lock.json* ./
RUN npm ci --only=production && npm cache clean --force

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY .. .

# Production image, copy all the files and run the app
FROM base AS runner
WORKDIR /app

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodeuser

# Create necessary directories with proper permissions
RUN mkdir -p /app/data /app/logs
RUN chown -R nodeuser:nodejs /app

# Copy package files
COPY --from=deps --chown=nodeuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodeuser:nodejs /app ./

# Set only non-sensitive environment variables
ENV NODE_ENV=production
ENV PORT=8000

# Switch to non-root user
USER nodeuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8000/api/users', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })" || exit 1

# Add labels for better image management
LABEL maintainer="Devsu Team - demo Angel"
LABEL version="1.0.0"
LABEL description="Node.js API with SQLite database"

# Create volume for persistent data
VOLUME ["/app/data", "/app/logs"]

# Use exec form for better signal handling
ENTRYPOINT ["node", "index.js"] 