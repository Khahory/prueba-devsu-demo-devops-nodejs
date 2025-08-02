# Multi-stage build for optimized production image
# Support for both AMD64 and ARM64 architectures
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --only=production && npm cache clean --force

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Production image, copy all the files and run the app
FROM base AS runner
WORKDIR /app

# 👉 Instala sqlite3 aquí
RUN apk add --no-cache sqlite

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodeuser

# Create necessary directories with proper permissions
RUN mkdir -p /app/data /app/logs
RUN chown -R nodeuser:nodejs /app

# Copy package files
COPY --from=deps --chown=nodeuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodeuser:nodejs /app ./

ENV NODE_ENV=production
ENV PORT=8000

USER nodeuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8000/api/users', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })" || exit 1

LABEL maintainer="Devsu Team - demo Angel"
LABEL version="1.0.0"
LABEL description="Node.js API with SQLite database"
LABEL architecture="arm64"

VOLUME ["/app/data", "/app/logs"]

ENTRYPOINT ["node", "index.js"]