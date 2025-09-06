# DevOps Guide - REChain VC Lab

## 🚀 DevOps Overview

This document outlines our comprehensive DevOps strategy for REChain VC Lab, covering infrastructure as code, CI/CD pipelines, deployment strategies, and operational excellence.

## 🏗️ Infrastructure as Code

### Terraform Configuration

#### Main Infrastructure
```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "rechain-vc-lab-${var.environment}"
  cidr = "10.0.0.0/16"
  
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Environment = var.environment
    Project     = "rechain-vc-lab"
  }
}

# EKS Cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "rechain-vc-lab-${var.environment}"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  node_groups = {
    main = {
      desired_capacity = 3
      max_capacity     = 10
      min_capacity     = 1
      
      instance_types = ["t3.medium"]
      
      k8s_labels = {
        Environment = var.environment
        NodeGroup   = "main"
      }
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = "rechain-vc-lab"
  }
}
```

#### Database Configuration
```hcl
# database.tf
resource "aws_db_instance" "postgres" {
  identifier = "rechain-vc-lab-${var.environment}"
  
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = var.environment == "production" ? "db.r6g.xlarge" : "db.t3.micro"
  
  allocated_storage     = 100
  max_allocated_storage = 1000
  storage_type          = "gp3"
  storage_encrypted     = true
  
  db_name  = "rechain_vc_lab"
  username = "postgres"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = var.environment != "production"
  
  tags = {
    Environment = var.environment
    Project     = "rechain-vc-lab"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "rechain-vc-lab-${var.environment}"
  subnet_ids = module.vpc.private_subnets
  
  tags = {
    Environment = var.environment
    Project     = "rechain-vc-lab"
  }
}
```

#### Redis Configuration
```hcl
# redis.tf
resource "aws_elasticache_subnet_group" "main" {
  name       = "rechain-vc-lab-${var.environment}"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "rechain-vc-lab-${var.environment}"
  description                = "Redis cluster for REChain VC Lab"
  
  node_type                  = var.environment == "production" ? "cache.r6g.large" : "cache.t3.micro"
  port                       = 6379
  parameter_group_name       = "default.redis7"
  
  num_cache_clusters         = var.environment == "production" ? 3 : 1
  automatic_failover_enabled = var.environment == "production"
  multi_az_enabled          = var.environment == "production"
  
  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  tags = {
    Environment = var.environment
    Project     = "rechain-vc-lab"
  }
}
```

### Kubernetes Configuration

#### Namespace
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: rechain-vc-lab
  labels:
    name: rechain-vc-lab
    environment: production
```

#### Deployment
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rechain-vc-lab-api
  namespace: rechain-vc-lab
  labels:
    app: rechain-vc-lab-api
    version: v1.0.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rechain-vc-lab-api
  template:
    metadata:
      labels:
        app: rechain-vc-lab-api
        version: v1.0.0
    spec:
      containers:
      - name: api
        image: rechain/vc-lab-api:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: redis-secret
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

#### Service
```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: rechain-vc-lab-api
  namespace: rechain-vc-lab
  labels:
    app: rechain-vc-lab-api
spec:
  selector:
    app: rechain-vc-lab-api
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  type: ClusterIP
```

#### Ingress
```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rechain-vc-lab-ingress
  namespace: rechain-vc-lab
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - api.rechain.network
    secretName: rechain-vc-lab-tls
  rules:
  - host: api.rechain.network
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rechain-vc-lab-api
            port:
              number: 80
```

## 🔄 CI/CD Pipelines

### GitHub Actions Workflow

#### Main CI/CD Pipeline
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Run linting
      run: npm run lint
      
    - name: Run tests
      run: npm run test
      
    - name: Run security audit
      run: npm audit --audit-level moderate
      
    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
      
    - name: Log in to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
        
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-
          type=raw,value=latest,enable={{is_default_branch}}
          
    - name: Build and push Docker image
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
        
    - name: Update kubeconfig
      run: aws eks update-kubeconfig --region us-east-1 --name rechain-vc-lab-production
      
    - name: Deploy to Kubernetes
      run: |
        kubectl set image deployment/rechain-vc-lab-api \
          api=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
          -n rechain-vc-lab
        kubectl rollout status deployment/rechain-vc-lab-api -n rechain-vc-lab
```

#### Security Scanning Pipeline
```yaml
# .github/workflows/security.yml
name: Security Scanning

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    - cron: '0 2 * * 1' # Weekly on Monday at 2 AM

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'
        format: 'sarif'
        output: 'trivy-results.sarif'
        
    - name: Upload Trivy scan results
      uses: github/codeql-action/upload-sarif@v3
      with:
        sarif_file: 'trivy-results.sarif'
        
    - name: Run CodeQL Analysis
      uses: github/codeql-action/analyze@v3
      with:
        languages: javascript,typescript
```

### Docker Configuration

#### Multi-stage Dockerfile
```dockerfile
# Dockerfile
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine AS runtime
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy built application
COPY --from=build --chown=nextjs:nodejs /app/dist ./dist
COPY --from=build --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nextjs:nodejs /app/package.json ./package.json

USER nextjs

EXPOSE 8080

ENV NODE_ENV=production
ENV PORT=8080

CMD ["node", "dist/index.js"]
```

#### Docker Compose for Development
```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:password@postgres:5432/rechain_vc_lab
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    volumes:
      - .:/app
      - /app/node_modules

  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=rechain_vc_lab
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - api

volumes:
  postgres_data:
  redis_data:
```

## 🚀 Deployment Strategies

### Blue-Green Deployment

#### Blue-Green Script
```bash
#!/bin/bash
# blue-green-deploy.sh

set -e

# Configuration
NAMESPACE="rechain-vc-lab"
SERVICE_NAME="rechain-vc-lab-api"
NEW_VERSION=$1
CURRENT_COLOR=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.selector.color}')

if [ "$CURRENT_COLOR" = "blue" ]; then
    NEW_COLOR="green"
else
    NEW_COLOR="blue"
fi

echo "Current color: $CURRENT_COLOR"
echo "New color: $NEW_COLOR"
echo "New version: $NEW_VERSION"

# Deploy new version
kubectl set image deployment/$SERVICE_NAME-$NEW_COLOR \
    api=rechain/vc-lab-api:$NEW_VERSION \
    -n $NAMESPACE

# Wait for rollout
kubectl rollout status deployment/$SERVICE_NAME-$NEW_COLOR -n $NAMESPACE

# Test new version
kubectl port-forward service/$SERVICE_NAME-$NEW_COLOR 8080:80 -n $NAMESPACE &
PORT_FORWARD_PID=$!

sleep 10

# Health check
if curl -f http://localhost:8080/health; then
    echo "Health check passed"
    
    # Switch traffic
    kubectl patch service $SERVICE_NAME -n $NAMESPACE -p '{"spec":{"selector":{"color":"'$NEW_COLOR'"}}}'
    
    echo "Traffic switched to $NEW_COLOR"
    
    # Wait and clean up old version
    sleep 30
    kubectl scale deployment $SERVICE_NAME-$CURRENT_COLOR --replicas=0 -n $NAMESPACE
    
    echo "Old version scaled down"
else
    echo "Health check failed, rolling back"
    kubectl rollout undo deployment/$SERVICE_NAME-$NEW_COLOR -n $NAMESPACE
    exit 1
fi

# Clean up
kill $PORT_FORWARD_PID
```

### Canary Deployment

#### Canary Configuration
```yaml
# canary-deployment.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: rechain-vc-lab-api
  namespace: rechain-vc-lab
spec:
  replicas: 5
  strategy:
    canary:
      steps:
      - setWeight: 20
      - pause: {duration: 10m}
      - setWeight: 40
      - pause: {duration: 10m}
      - setWeight: 60
      - pause: {duration: 10m}
      - setWeight: 80
      - pause: {duration: 10m}
      canaryService: rechain-vc-lab-api-canary
      stableService: rechain-vc-lab-api-stable
      trafficRouting:
        nginx:
          stableIngress: rechain-vc-lab-api-stable
          annotationPrefix: nginx.ingress.kubernetes.io
  selector:
    matchLabels:
      app: rechain-vc-lab-api
  template:
    metadata:
      labels:
        app: rechain-vc-lab-api
    spec:
      containers:
      - name: api
        image: rechain/vc-lab-api:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

## 📊 Monitoring and Observability

### Prometheus Configuration

#### Prometheus Config
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: kubernetes_pod_name
```

#### Grafana Dashboard
```json
{
  "dashboard": {
    "title": "REChain VC Lab - System Overview",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "sum(rate(http_requests_total[5m])) by (service)",
            "legendFormat": "{{service}}"
          }
        ]
      },
      {
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{status=~\"5..\"}[5m])) by (service)",
            "legendFormat": "{{service}} errors"
          }
        ]
      }
    ]
  }
}
```

### Logging Configuration

#### Fluentd Configuration
```yaml
# fluentd-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
  namespace: rechain-vc-lab
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*rechain-vc-lab*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      format json
      time_key time
      time_format %Y-%m-%dT%H:%M:%S.%NZ
    </source>
    
    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>
    
    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch.logging.svc.cluster.local
      port 9200
      index_name rechain-vc-lab
      type_name _doc
    </match>
```

## 🔧 Infrastructure Management

### Ansible Playbooks

#### Server Setup
```yaml
# playbooks/setup-servers.yml
---
- name: Setup REChain VC Lab servers
  hosts: all
  become: yes
  vars:
    app_user: rechain
    app_dir: /opt/rechain-vc-lab
    
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
        
    - name: Install required packages
      apt:
        name:
          - docker.io
          - docker-compose
          - nginx
          - certbot
          - python3-certbot-nginx
        state: present
        
    - name: Start and enable Docker
      systemd:
        name: docker
        state: started
        enabled: yes
        
    - name: Create application user
      user:
        name: "{{ app_user }}"
        system: yes
        shell: /bin/bash
        home: "{{ app_dir }}"
        
    - name: Create application directory
      file:
        path: "{{ app_dir }}"
        state: directory
        owner: "{{ app_user }}"
        group: "{{ app_user }}"
        mode: '0755'
        
    - name: Configure Nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/sites-available/rechain-vc-lab
        owner: root
        group: root
        mode: '0644'
      notify: restart nginx
      
    - name: Enable Nginx site
      file:
        src: /etc/nginx/sites-available/rechain-vc-lab
        dest: /etc/nginx/sites-enabled/rechain-vc-lab
        state: link
      notify: restart nginx
      
    - name: Configure SSL with Let's Encrypt
      command: certbot --nginx -d {{ domain }} --non-interactive --agree-tos --email {{ ssl_email }}
      when: ssl_email is defined
      
  handlers:
    - name: restart nginx
      systemd:
        name: nginx
        state: restarted
```

#### Application Deployment
```yaml
# playbooks/deploy-app.yml
---
- name: Deploy REChain VC Lab application
  hosts: app_servers
  become: yes
  vars:
    app_dir: /opt/rechain-vc-lab
    app_user: rechain
    app_version: "{{ lookup('env', 'APP_VERSION') }}"
    
  tasks:
    - name: Stop application
      systemd:
        name: rechain-vc-lab
        state: stopped
      ignore_errors: yes
      
    - name: Pull latest Docker image
      docker_image:
        name: rechain/vc-lab-api
        tag: "{{ app_version }}"
        source: pull
        
    - name: Update docker-compose.yml
      template:
        src: docker-compose.yml.j2
        dest: "{{ app_dir }}/docker-compose.yml"
        owner: "{{ app_user }}"
        group: "{{ app_user }}"
        mode: '0644'
        
    - name: Start application
      docker_compose:
        project_src: "{{ app_dir }}"
        state: present
        
    - name: Wait for application to be ready
      uri:
        url: "http://localhost:8080/health"
        method: GET
        status_code: 200
      retries: 30
      delay: 10
      
    - name: Enable and start application service
      systemd:
        name: rechain-vc-lab
        enabled: yes
        state: started
```

## 🔄 Backup and Disaster Recovery

### Backup Strategy

#### Database Backup
```bash
#!/bin/bash
# backup-database.sh

set -e

# Configuration
DB_HOST="postgres.rechain.network"
DB_NAME="rechain_vc_lab"
DB_USER="postgres"
BACKUP_DIR="/backups/postgres"
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Generate backup filename
BACKUP_FILE="rechain_vc_lab_$(date +%Y%m%d_%H%M%S).sql"

# Create database backup
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_DIR/$BACKUP_FILE

# Compress backup
gzip $BACKUP_DIR/$BACKUP_FILE

# Upload to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE.gz s3://rechain-vc-lab-backups/postgres/

# Clean up old backups
find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "Database backup completed: $BACKUP_FILE.gz"
```

#### Application Backup
```bash
#!/bin/bash
# backup-application.sh

set -e

# Configuration
APP_DIR="/opt/rechain-vc-lab"
BACKUP_DIR="/backups/application"
RETENTION_DAYS=7

# Create backup directory
mkdir -p $BACKUP_DIR

# Generate backup filename
BACKUP_FILE="rechain_vc_lab_app_$(date +%Y%m%d_%H%M%S).tar.gz"

# Create application backup
tar -czf $BACKUP_DIR/$BACKUP_FILE -C $APP_DIR .

# Upload to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://rechain-vc-lab-backups/application/

# Clean up old backups
find $BACKUP_DIR -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "Application backup completed: $BACKUP_FILE"
```

### Disaster Recovery

#### Recovery Script
```bash
#!/bin/bash
# disaster-recovery.sh

set -e

# Configuration
DB_HOST="postgres.rechain.network"
DB_NAME="rechain_vc_lab"
DB_USER="postgres"
BACKUP_S3_BUCKET="rechain-vc-lab-backups"
APP_DIR="/opt/rechain-vc-lab"

# Function to restore database
restore_database() {
    local backup_file=$1
    
    echo "Restoring database from $backup_file..."
    
    # Download backup from S3
    aws s3 cp s3://$BACKUP_S3_BUCKET/postgres/$backup_file /tmp/
    
    # Extract backup
    gunzip /tmp/$backup_file
    
    # Restore database
    psql -h $DB_HOST -U $DB_USER -d $DB_NAME < /tmp/${backup_file%.gz}
    
    echo "Database restored successfully"
}

# Function to restore application
restore_application() {
    local backup_file=$1
    
    echo "Restoring application from $backup_file..."
    
    # Download backup from S3
    aws s3 cp s3://$BACKUP_S3_BUCKET/application/$backup_file /tmp/
    
    # Extract backup
    tar -xzf /tmp/$backup_file -C $APP_DIR
    
    # Restart application
    systemctl restart rechain-vc-lab
    
    echo "Application restored successfully"
}

# Main recovery process
main() {
    local db_backup=$1
    local app_backup=$2
    
    if [ -z "$db_backup" ] || [ -z "$app_backup" ]; then
        echo "Usage: $0 <db_backup_file> <app_backup_file>"
        exit 1
    fi
    
    echo "Starting disaster recovery process..."
    
    restore_database $db_backup
    restore_application $app_backup
    
    echo "Disaster recovery completed successfully"
}

main "$@"
```

## 📞 Contact Information

### DevOps Team
- **Email**: devops@rechain.network
- **Phone**: +1-555-DEVOPS
- **Slack**: #devops channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Infrastructure Team
- **Email**: infrastructure@rechain.network
- **Phone**: +1-555-INFRASTRUCTURE
- **Slack**: #infrastructure channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Platform Team
- **Email**: platform@rechain.network
- **Phone**: +1-555-PLATFORM
- **Slack**: #platform channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**DevOps is the foundation of reliable software! 🚀**

*This DevOps guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**DevOps Guide Version**: 1.0.0
