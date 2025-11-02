# Docker Deployment and Containerization Guide

This document provides comprehensive guidance on using Docker for the REChain VC Flutter project. It covers containerization strategies for development, testing, CI/CD, and production deployment of the Flutter web application and backend services.

## 🎯 Docker Strategy Overview

### Why Docker for Flutter Projects?
- **Consistent Development Environment:** Same container across local dev, CI, and production
- **Web Deployment:** Easy deployment of Flutter web builds to containerized hosting
- **Backend Services:** Containerize Node.js/Go/Rust backend APIs and blockchain services
- **CI/CD Integration:** Docker images for build environments and testing
- **Multi-Platform Support:** Cross-platform builds and deployments
- **Scalability:** Easy scaling of web services and microservices

### Supported Components
- **Flutter Web:** Static web hosting with CDN integration
- **Backend APIs:** Node.js/Express, Go, or Rust services
- **Blockchain Nodes:** Ethereum, IPFS, or custom blockchain services
- **Database:** PostgreSQL, MongoDB, Redis containers
- **Monitoring:** Prometheus, Grafana, ELK stack
- **CI/CD:** Docker-in-Docker for GitHub Actions

## 🐳 Docker Configuration Files

### Root Dockerfile (Multi-Stage Build)
**Dockerfile:**
```dockerfile
# Stage 1: Builder
FROM cirrusci/flutter:3.16.0 AS builder

WORKDIR /app

# Copy pubspec files and get dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy source code
COPY . .

# Build web release
RUN flutter build web --release \
    --dart-define=FLUTTER_ENV=prod \
    --dart-define=API_BASE_URL=https://api.rechain.vc \
    --dart-define=WEBSOCKET_URL=wss://ws.rechain.vc \
    --web-renderer canvaskit \
    --base-href "/"

# Stage 2: Production Web Server
FROM nginx:alpine AS production

# Copy Flutter web build
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# Copy service worker and manifest
COPY --from=builder /app/web/sw.js /usr/share/nginx/html/sw.js
COPY --from=builder /app/web/manifest.json /usr/share/nginx/html/manifest.json

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:80/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
```

### Backend Service Dockerfile (Node.js Example)
**backend/Dockerfile:**
```dockerfile
FROM node:18-alpine AS base

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build for production
RUN npm run build

# Production stage
FROM base AS production

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S rechain -u 1001

USER rechain

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node health-check.js || exit 1

CMD ["node", "dist/server.js"]
```

### Blockchain Node Dockerfile (Geth Example)
**blockchain/Dockerfile:**
```dockerfile
FROM ethereum/client-go:v1.13.5

# Custom configuration
COPY geth-config.json /config.json
COPY genesis.json /genesis.json

# Volume mounts
VOLUME ["/data", "/logs"]

# Expose ports
EXPOSE 8545 8546 30303 30304

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8545 || exit 1

# Entry point with custom flags
ENTRYPOINT ["geth", "--config", "/config.json", "--datadir", "/data", "--http", "--http.addr", "0.0.0.0"]
```

## 🏗️ Docker Compose Development Setup

### Development Environment (docker-compose.dev.yml)
```yaml
version: '3.8'

services:
  # Flutter Web Development Server
  flutter-web-dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8080:8080"
    volumes:
      - .:/app
      - /app/build
    environment:
      - FLUTTER_ENV=dev
      - API_BASE_URL=http://localhost:3000/api
      - WEBSOCKET_URL=ws://localhost:3001
    depends_on:
      - backend
    networks:
      - rechain-network

  # Backend API Server
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:pass@postgres:5432/rechain
      - REDIS_URL=redis://redis:6379
      - BLOCKCHAIN_RPC_URL=http://geth:8545
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - postgres
      - redis
      - geth
    networks:
      - rechain-network

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: rechain
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d rechain"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Ethereum Node (Geth)
  geth:
    build:
      context: ./blockchain
      dockerfile: Dockerfile
    ports:
      - "8545:8545"
      - "8546:8546"
      - "30303:30303"
    volumes:
      - geth_data:/data
    environment:
      - GENESIS_FILE=/genesis.json
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8545"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Monitoring (Prometheus + Grafana)
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    networks:
      - rechain-network

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana-provisioning:/etc/grafana/provisioning
    depends_on:
      - prometheus
    networks:
      - rechain-network

volumes:
  postgres_data:
  redis_data:
  geth_data:
  prometheus_data:
  grafana_data:

networks:
  rechain-network:
    driver: bridge
```

### Production Docker Compose (docker-compose.prod.yml)
```yaml
version: '3.8'

services:
  # Load Balancer (Nginx)
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/prod.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - flutter-web
      - backend
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Flutter Web Production
  flutter-web:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - FLUTTER_ENV=prod
      - API_BASE_URL=https://api.rechain.vc
    volumes:
      - web_static:/usr/share/nginx/html:ro
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Backend API (Multiple Replicas)
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:${POSTGRES_PASSWORD}@postgres:5432/rechain
      - REDIS_URL=redis://redis:6379
      - BLOCKCHAIN_RPC_URL=http://geth:8545
    volumes:
      - ./backend:/app:ro
    depends_on:
      - postgres
      - redis
      - geth
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    networks:
      - rechain-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # PostgreSQL Production
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: rechain
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_prod_data:/var/lib/postgresql/data
      - ./backups:/backups
    networks:
      - rechain-network
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 2G
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d rechain"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Production
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_prod_data:/data
    networks:
      - rechain-network
    deploy:
      resources:
        limits:
          memory: 512M
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Ethereum Node Production
  geth:
    build:
      context: ./blockchain
      dockerfile: Dockerfile
    environment:
      - GENESIS_FILE=/genesis.json
    volumes:
      - geth_prod_data:/data
      - ./keystore:/keystore:ro
    networks:
      - rechain-network
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8545"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_prod_data:
  redis_prod_data:
  geth_prod_data:
  web_static:

networks:
  rechain-network:
    driver: bridge
```

## 🔧 Development Workflow with Docker

### Starting Development Environment
```bash
# Clone repository
git clone https://github.com/REChainVC/rechain-vc.git
cd rechain-vc

# Copy environment file
cp .env.example .env

# Edit environment variables
nano .env

# Start development services
docker-compose -f docker-compose.dev.yml up -d

# In separate terminal, start Flutter web dev
flutter run -d web-server --web-port=8080 --dart-define=FLUTTER_ENV=dev
```

### Building and Testing
```bash
# Build Docker images
docker-compose build

# Run tests in container
docker-compose run flutter-web-dev flutter test

# Run integration tests
docker-compose run backend npm test

# Check service health
docker-compose ps

# View logs
docker-compose logs -f backend
```

### Hot Reload with Docker
**Dockerfile.dev:**
```dockerfile
FROM cirrusci/flutter:3.16.0

WORKDIR /app

# Install additional tools
RUN flutter config --enable-web
RUN dart pub global activate webdev

EXPOSE 8080 9100

# Volume for hot reload
VOLUME ["/app"]

CMD ["sh", "-c", "flutter packages pub run build_runner watch & flutter run -d web-server --web-port=8080 --hot"]
```

## 🏭 CI/CD with Docker

### GitHub Actions Docker Integration
**.github/workflows/docker.yml:**
```yaml
name: Docker Build and Push

on:
  push:
    tags: [ 'v*.*.*' ]
  release:
    types: [published]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata for Docker
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}/flutter-web
          ghcr.io/${{ github.repository }}/backend
          ghcr.io/${{ github.repository }}/geth
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}

      - name: Build and push Flutter Web
        uses: docker/build-push-action@v5
        with:
          context: .
          file: Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build and push Backend
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          file: ./backend/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build and push Geth
        uses: docker/build-push-action@v5
        with:
          context: ./blockchain
          file: ./blockchain/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Update Kubernetes manifests
        run: |
          # Update image tags in k8s manifests
          sed -i "s|image:.*|image: ghcr.io/${{ github.repository }}/flutter-web:${{ github.sha }}|" k8s/flutter-web-deployment.yaml
          sed -i "s|image:.*|image: ghcr.io/${{ github.repository }}/backend:${{ github.sha }}|" k8s/backend-deployment.yaml
          
          # Commit updated manifests
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add k8s/
          git commit -m "Update Docker images to ${{ github.sha }} [skip ci]" || exit 0
          git push

      - name: Notify deployment
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          fields: repo,message,commit,author,action,eventName,ref,workflow,job,took
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## ☁️ Production Deployment

### Kubernetes Deployment (k8s/flutter-web-deployment.yaml)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flutter-web
  labels:
    app: rechain-vc-web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rechain-vc-web
  template:
    metadata:
      labels:
        app: rechain-vc-web
    spec:
      containers:
        - name: flutter-web
          image: ghcr.io/REChainVC/rechain-vc/flutter-web:latest
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "512Mi"
          env:
            - name: FLUTTER_ENV
              value: "prod"
            - name: API_BASE_URL
              value: "https://api.rechain.vc"
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
          volumeMounts:
            - name: web-config
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
      volumes:
        - name: web-config
          configMap:
            name: web-nginx-config
---
apiVersion: v1
kind: Service
metadata:
  name: flutter-web-service
spec:
  selector:
    app: rechain-vc-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flutter-web-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
    - hosts:
        - rechain.vc
      secretName: rechain-vc-tls
  rules:
    - host: rechain.vc
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: flutter-web-service
                port:
                  number: 80
```

### Docker Swarm Production Stack
**docker-stack.yml:**
```yaml
version: '3.8'

services:
  flutter-web:
    image: ghcr.io/REChainVC/rechain-vc/flutter-web:latest
    deploy:
      replicas: 5
      update_config:
        parallelism: 2
        delay: 10s
        order: start-first
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    ports:
      - "80:80"
      - "443:443"
    environment:
      - FLUTTER_ENV=prod
    configs:
      - source: nginx-config
        target: /etc/nginx/nginx.conf
    networks:
      - webnet
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

configs:
  nginx-config:
    external: true

networks:
  webnet:
    external: true
```

## 🔍 Docker Security Configuration

### Docker Security Best Practices
**Dockerfile Security:**
```dockerfile
# Use specific base image versions
FROM node:18.17.1-alpine3.18 AS base

# Run as non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S rechain -u 1001 && \
    chown -R rechain:nodejs /app

USER rechain

# Use multi-stage builds to reduce attack surface
FROM base AS production

# Scan for vulnerabilities during build
COPY --from=scan /app/package-lock.json /app/
RUN npm audit --audit-level high

# Use .dockerignore
# .dockerignore file
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
.nyc_output
```

### Docker Content Trust
**.docker/config.json:**
```json
{
  "credsStore": "desktop",
  "contentTrust": true,
  "delegates": {
    "ghcr.io/REChainVC/rechain-vc": [
      "docker.io/rechain-dev-team"
    ]
  }
}
```

### Security Scanning in CI
**.github/workflows/docker-security.yml:**
```yaml
name: Docker Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 3 * * 0'  # Weekly on Sunday

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker images
        run: |
          docker-compose build

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'ghcr.io/${{ github.repository }}/**'
          format: 'sarif'
          output: 'trivy-results.sarif'
          scan-type: 'image'

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Docker Scout Analysis
        uses: docker/scout-action@v1
        with:
          image-ref: 'ghcr.io/${{ github.repository }}/flutter-web'
          token: ${{ secrets.DOCKER_SCOUT_TOKEN }}
          local-image: false
          analyze: true
          only-critical: false

      - name: Notify security issues
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: failure
          text: "🚨 Docker security vulnerabilities found! Review Trivy results."
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 📊 Monitoring and Logging

### Docker Logging Configuration
**docker-compose.logging.yml:**
```yaml
version: '3.8'

services:
  flutter-web:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        compress: "true"
        mode: non-blocking

  backend:
    logging:
      driver: "fluentd"
      options:
        fluentd-address: "localhost:24224"
        tag: "backend.{{.Name}}"

  postgres:
    logging:
      driver: "local"
      options:
        max-size: "20m"
        max-file: "5"

volumes:
  postgres_data:
  redis_data:
  geth_data:
```

### Prometheus Monitoring for Docker
**prometheus.yml:**
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'flutter-web'
    static_configs:
      - targets: ['flutter-web:9113']
    metrics_path: '/metrics'
    
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:3000']
    metrics_path: '/metrics'
    
  - job_name: 'docker'
    static_configs:
      - targets: ['/var/run/docker.sock']
    metrics_path: '/metrics'
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 15s
```

### Docker Stats Dashboard (Grafana)
**grafana-provisioning/dashboards/docker-stats.json:**
```json
{
  "dashboard": {
    "title": "Docker Container Stats",
    "panels": [
      {
        "title": "CPU Usage",
        "type": "stat",
        "targets": [
          {
            "expr": "rate(container_cpu_usage_seconds_total{container=~\"flutter-web|backend\"}[5m]) * 100",
            "legendFormat": "{{container}}"
          }
        ]
      },
      {
        "title": "Memory Usage",
        "type": "stat",
        "targets": [
          {
            "expr": "100 - (container_memory_usage_bytes{container=~\"flutter-web|backend\"} / container_spec_memory_limit_bytes{container=~\"flutter-web|backend\"}) * 100",
            "legendFormat": "{{container}}"
          }
        ]
      }
    ],
    "time": {
      "from": "now-6h",
      "to": "now"
    }
  }
}
```

## 🚀 Deployment Commands

### Local Development
```bash
# Start all services
docker-compose -f docker-compose.dev.yml up -d

# Build and run specific service
docker-compose build backend
docker-compose up backend

# Run one-off commands
docker-compose run --rm backend npm run db:migrate

# Stop services
docker-compose down

# Clean up volumes (careful!)
docker-compose down -v
```

### Production Deployment
```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy to production
docker stack deploy -c docker-stack.yml rechain-vc

# Update specific service
docker service update --image ghcr.io/REChainVC/rechain-vc/flutter-web:latest rechain-vc_flutter-web

# Scale services
docker service scale rechain-vc_backend=5

# View service status
docker service ls
docker service ps rechain-vc_flutter-web
```

### Kubernetes Deployment
```bash
# Apply manifests
kubectl apply -f k8s/

# Deploy Flutter web
kubectl apply -f k8s/flutter-web-deployment.yaml

# Scale deployment
kubectl scale deployment/flutter-web --replicas=5

# Update image
kubectl set image deployment/flutter-web flutter-web=ghcr.io/REChainVC/rechain-vc/flutter-web:v1.2.0

# View logs
kubectl logs -f deployment/flutter-web

# Monitor resources
kubectl top pods
kubectl top deployment
```

## 🔧 Troubleshooting

### Common Docker Issues

#### Build Failures
```
Error: Flutter SDK not found
Solution: Ensure cirrusci/flutter base image is used with correct version
```

```
Error: Permission denied on volume mount
Solution: Add user permissions or use named volumes
```

#### Runtime Issues
```
Error: Port already in use
Solution: Check docker ps and stop conflicting containers
```

```
Error: Database connection refused
Solution: Check health checks and service dependencies
```

#### Performance Issues
```
Issue: Slow Flutter web builds
Solution: Use multi-stage builds and .dockerignore
```

```
Issue: High memory usage
Solution: Set resource limits in docker-compose.yml
```

### Debugging Commands
```bash
# View container logs
docker logs rechain-vc_flutter-web_1 -f

# Inspect running container
docker inspect rechain-vc_backend_1

# Execute shell in container
docker exec -it rechain-vc_postgres_1 psql -U user -d rechain

# Check resource usage
docker stats

# Network inspection
docker network inspect rechain-network

# Image analysis
docker image inspect ghcr.io/REChainVC/rechain-vc/flutter-web:latest
```

## 📱 Flutter-Specific Docker Tips

### Flutter Web Optimization
```dockerfile
# Optimize for production web
RUN flutter build web --release \
    --web-renderer canvaskit \
    --split-debug-info=/tmp/debug-info \
    --obfuscate \
    --no-tree-shake-icons

# Pre-compress assets
RUN find /usr/share/nginx/html -type f -name "*.js" -o -name "*.css" | \
    xargs gzip -k -9 && \
    find /usr/share/nginx/html -type f -name "*.gz" | \
    xargs nginx -t
```

### Hot Reload in Docker
```bash
# Use volume mounts for hot reload
docker run -it --rm \
  -v $(pwd):/app \
  -p 8080:8080 \
  -p 9100:9100 \
  cirrusci/flutter:3.16.0 \
  sh -c "cd /app && flutter run -d web-server --web-port=8080 --hot"
```

### Multi-Platform Builds
```yaml
# GitHub Actions for multi-arch builds
- name: Build Multi-Arch Image
  uses: docker/build-push-action@v5
  with:
    context: .
    file: Dockerfile
    platforms: linux/amd64,linux/arm64
    push: true
    tags: ghcr.io/REChainVC/rechain-vc/flutter-web:latest
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

## 🔗 Related Documentation

- **[ENVIRONMENT.md](ENVIRONMENT.md)** - Docker environment variables and secrets
- **[WORKFLOW.md](WORKFLOW.md)** - CI/CD workflows including Docker builds
- **[.github/workflows/docker.yml](.github/workflows/docker.yml)** - Docker build and push workflow
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development setup with Docker instructions
- **[SECURITY.md](SECURITY.md)** - Docker security best practices and scanning

## 🚀 Next Steps

1. **Review and test** Docker configurations locally
2. **Configure GitHub secrets** for Docker registry access
3. **Set up CI/CD** for automated Docker builds
4. **Test production deployment** in staging environment
5. **Configure monitoring** for Docker containers
6. **Document customizations** in team knowledge base

---

*Last updated: September 2024*

For Docker-related issues, see [CONTRIBUTING.md](CONTRIBUTING.md#development-setup) or create an issue using the [documentation template](.github/ISSUE_TEMPLATE/documentation.md).