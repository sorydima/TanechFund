# Architecture & Design Guide - REChain VC Lab

## 🏗️ Architecture Overview

This document outlines our comprehensive architecture and design strategy for REChain VC Lab, covering system architecture, design patterns, scalability, and technical excellence.

## 🎯 Architecture Principles

### Core Principles

#### 1. Scalability
- **Horizontal Scaling**: Scale out rather than up
- **Microservices**: Modular, independent services
- **Event-Driven**: Asynchronous, event-based architecture
- **Cloud-Native**: Designed for cloud environments

#### 2. Reliability
- **Fault Tolerance**: Graceful handling of failures
- **High Availability**: 99.9%+ uptime
- **Disaster Recovery**: Comprehensive backup and recovery
- **Circuit Breakers**: Prevent cascade failures

#### 3. Security
- **Zero Trust**: Never trust, always verify
- **Defense in Depth**: Multiple security layers
- **Encryption**: Data encryption at rest and in transit
- **Access Control**: Fine-grained permissions

#### 4. Performance
- **Low Latency**: Sub-second response times
- **High Throughput**: Handle millions of requests
- **Caching**: Multi-layer caching strategy
- **CDN**: Global content delivery

## 🏛️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Layer                             │
├─────────────────────────────────────────────────────────────┤
│  Web App  │  Mobile App  │  Desktop App  │  API Clients   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway Layer                         │
├─────────────────────────────────────────────────────────────┤
│  Load Balancer  │  Rate Limiting  │  Authentication  │  SSL │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Microservices Layer                        │
├─────────────────────────────────────────────────────────────┤
│  Web3 Service  │  Web4 Service  │  Web5 Service  │  Auth   │
│  User Service  │  Content Svc   │  ML Service    │  Notify │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Data Layer                                │
├─────────────────────────────────────────────────────────────┤
│  PostgreSQL  │  Redis  │  MongoDB  │  S3  │  Elasticsearch │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                Infrastructure Layer                        │
├─────────────────────────────────────────────────────────────┤
│  Kubernetes  │  Docker  │  Terraform  │  Monitoring  │  CI/CD │
└─────────────────────────────────────────────────────────────┘
```

### Microservices Architecture

#### 1. Service Decomposition
```yaml
# services/web3-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web3-service
  namespace: rechain-vc-lab
spec:
  selector:
    app: web3-service
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web3-service
  namespace: rechain-vc-lab
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web3-service
  template:
    metadata:
      labels:
        app: web3-service
    spec:
      containers:
      - name: web3-service
        image: rechain/web3-service:latest
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

#### 2. Service Communication
```typescript
// services/web3-service/src/controllers/blockchain.controller.ts
import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { BlockchainService } from './blockchain.service';
import { Web4Service } from '../clients/web4.service';
import { Web5Service } from '../clients/web5.service';

@Controller('blockchain')
export class BlockchainController {
  constructor(
    private readonly blockchainService: BlockchainService,
    private readonly web4Service: Web4Service,
    private readonly web5Service: Web5Service,
  ) {}

  @Get(':chainId/balance/:address')
  async getBalance(
    @Param('chainId') chainId: string,
    @Param('address') address: string,
  ) {
    return await this.blockchainService.getBalance(chainId, address);
  }

  @Post(':chainId/transaction')
  async sendTransaction(
    @Param('chainId') chainId: string,
    @Body() transactionData: TransactionData,
  ) {
    // Validate transaction
    const validation = await this.blockchainService.validateTransaction(transactionData);
    if (!validation.isValid) {
      throw new Error(validation.error);
    }

    // Send transaction
    const result = await this.blockchainService.sendTransaction(chainId, transactionData);

    // Notify other services
    await this.web4Service.notifyTransaction(result);
    await this.web5Service.notifyTransaction(result);

    return result;
  }

  @Get(':chainId/transactions/:address')
  async getTransactions(
    @Param('chainId') chainId: string,
    @Param('address') address: string,
  ) {
    return await this.blockchainService.getTransactions(chainId, address);
  }
}
```

### Event-Driven Architecture

#### 1. Event Bus
```typescript
// shared/events/event-bus.ts
import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Injectable()
export class EventBus {
  constructor(private eventEmitter: EventEmitter2) {}

  async publish(event: string, data: any): Promise<void> {
    await this.eventEmitter.emit(event, data);
  }

  async publishAsync(event: string, data: any): Promise<void> {
    await this.eventEmitter.emitAsync(event, data);
  }

  on(event: string, listener: (...args: any[]) => void): void {
    this.eventEmitter.on(event, listener);
  }

  once(event: string, listener: (...args: any[]) => void): void {
    this.eventEmitter.once(event, listener);
  }

  off(event: string, listener: (...args: any[]) => void): void {
    this.eventEmitter.off(event, listener);
  }
}
```

#### 2. Event Handlers
```typescript
// services/web4-service/src/events/transaction.event.ts
import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { MovementService } from '../services/movement.service';

@Injectable()
export class TransactionEventHandler {
  constructor(private movementService: MovementService) {}

  @OnEvent('transaction.completed')
  async handleTransactionCompleted(transaction: Transaction) {
    // Update movement progress based on transaction
    await this.movementService.updateProgress(transaction);
  }

  @OnEvent('transaction.failed')
  async handleTransactionFailed(transaction: Transaction) {
    // Handle failed transaction
    await this.movementService.handleFailedTransaction(transaction);
  }
}
```

## 🎨 Design Patterns

### 1. Repository Pattern

#### Repository Interface
```typescript
// shared/repositories/base.repository.ts
export interface BaseRepository<T> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  create(entity: T): Promise<T>;
  update(id: string, entity: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
  findWhere(conditions: Partial<T>): Promise<T[]>;
  count(conditions?: Partial<T>): Promise<number>;
}
```

#### Repository Implementation
```typescript
// services/web3-service/src/repositories/blockchain.repository.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BaseRepository } from '../../../shared/repositories/base.repository';
import { Blockchain } from '../entities/blockchain.entity';

@Injectable()
export class BlockchainRepository implements BaseRepository<Blockchain> {
  constructor(
    @InjectRepository(Blockchain)
    private repository: Repository<Blockchain>,
  ) {}

  async findById(id: string): Promise<Blockchain | null> {
    return await this.repository.findOne({ where: { id } });
  }

  async findAll(): Promise<Blockchain[]> {
    return await this.repository.find();
  }

  async create(blockchain: Blockchain): Promise<Blockchain> {
    const entity = this.repository.create(blockchain);
    return await this.repository.save(entity);
  }

  async update(id: string, blockchain: Partial<Blockchain>): Promise<Blockchain> {
    await this.repository.update(id, blockchain);
    return await this.findById(id);
  }

  async delete(id: string): Promise<void> {
    await this.repository.delete(id);
  }

  async findWhere(conditions: Partial<Blockchain>): Promise<Blockchain[]> {
    return await this.repository.find({ where: conditions });
  }

  async count(conditions?: Partial<Blockchain>): Promise<number> {
    return await this.repository.count(conditions);
  }
}
```

### 2. Factory Pattern

#### Factory Interface
```typescript
// shared/factories/blockchain.factory.ts
export interface BlockchainFactory {
  createBlockchain(type: BlockchainType): Blockchain;
  createWallet(type: WalletType): Wallet;
  createTransaction(type: TransactionType): Transaction;
}
```

#### Factory Implementation
```typescript
// services/web3-service/src/factories/blockchain.factory.ts
import { Injectable } from '@nestjs/common';
import { EthereumBlockchain } from '../blockchains/ethereum.blockchain';
import { PolygonBlockchain } from '../blockchains/polygon.blockchain';
import { BinanceBlockchain } from '../blockchains/binance.blockchain';
import { AvalancheBlockchain } from '../blockchains/avalanche.blockchain';
import { SolanaBlockchain } from '../blockchains/solana.blockchain';

@Injectable()
export class BlockchainFactory {
  createBlockchain(type: BlockchainType): Blockchain {
    switch (type) {
      case BlockchainType.ETHEREUM:
        return new EthereumBlockchain();
      case BlockchainType.POLYGON:
        return new PolygonBlockchain();
      case BlockchainType.BINANCE:
        return new BinanceBlockchain();
      case BlockchainType.AVALANCHE:
        return new AvalancheBlockchain();
      case BlockchainType.SOLANA:
        return new SolanaBlockchain();
      default:
        throw new Error(`Unsupported blockchain type: ${type}`);
    }
  }

  createWallet(type: WalletType): Wallet {
    switch (type) {
      case WalletType.ETHEREUM:
        return new EthereumWallet();
      case WalletType.SOLANA:
        return new SolanaWallet();
      default:
        throw new Error(`Unsupported wallet type: ${type}`);
    }
  }

  createTransaction(type: TransactionType): Transaction {
    switch (type) {
      case TransactionType.ETHEREUM:
        return new EthereumTransaction();
      case TransactionType.SOLANA:
        return new SolanaTransaction();
      default:
        throw new Error(`Unsupported transaction type: ${type}`);
    }
  }
}
```

### 3. Observer Pattern

#### Observer Interface
```typescript
// shared/observers/observer.ts
export interface Observer<T> {
  update(data: T): void;
}
```

#### Observable Implementation
```typescript
// services/web3-service/src/observables/blockchain.observable.ts
import { Injectable } from '@nestjs/common';
import { Observer } from '../../../shared/observers/observer';

@Injectable()
export class BlockchainObservable {
  private observers: Observer<BlockchainEvent>[] = [];

  addObserver(observer: Observer<BlockchainEvent>): void {
    this.observers.push(observer);
  }

  removeObserver(observer: Observer<BlockchainEvent>): void {
    const index = this.observers.indexOf(observer);
    if (index > -1) {
      this.observers.splice(index, 1);
    }
  }

  notifyObservers(event: BlockchainEvent): void {
    this.observers.forEach(observer => observer.update(event));
  }
}
```

## 🔧 Design System

### 1. Component Architecture

#### Component Structure
```
components/
├── atoms/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.stories.tsx
│   │   ├── Button.test.tsx
│   │   └── index.ts
│   ├── Input/
│   │   ├── Input.tsx
│   │   ├── Input.stories.tsx
│   │   ├── Input.test.tsx
│   │   └── index.ts
│   └── Icon/
│       ├── Icon.tsx
│       ├── Icon.stories.tsx
│       ├── Icon.test.tsx
│       └── index.ts
├── molecules/
│   ├── SearchBox/
│   │   ├── SearchBox.tsx
│   │   ├── SearchBox.stories.tsx
│   │   ├── SearchBox.test.tsx
│   │   └── index.ts
│   └── Card/
│       ├── Card.tsx
│       ├── Card.stories.tsx
│       ├── Card.test.tsx
│       └── index.ts
├── organisms/
│   ├── Header/
│   │   ├── Header.tsx
│   │   ├── Header.stories.tsx
│   │   ├── Header.test.tsx
│   │   └── index.ts
│   └── Sidebar/
│       ├── Sidebar.tsx
│       ├── Sidebar.stories.tsx
│       ├── Sidebar.test.tsx
│       └── index.ts
└── templates/
    ├── Dashboard/
    │   ├── Dashboard.tsx
    │   ├── Dashboard.stories.tsx
    │   ├── Dashboard.test.tsx
    │   └── index.ts
    └── Auth/
        ├── Auth.tsx
        ├── Auth.stories.tsx
        ├── Auth.test.tsx
        └── index.ts
```

#### Component Example
```typescript
// components/atoms/Button/Button.tsx
import React from 'react';
import { ButtonProps } from './Button.types';
import { StyledButton } from './Button.styles';

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
  onClick,
  ...props
}) => {
  return (
    <StyledButton
      variant={variant}
      size={size}
      disabled={disabled || loading}
      onClick={onClick}
      {...props}
    >
      {loading ? 'Loading...' : children}
    </StyledButton>
  );
};
```

### 2. Design Tokens

#### Design Token System
```typescript
// design-tokens/tokens.ts
export const designTokens = {
  colors: {
    primary: {
      50: '#f0f9ff',
      100: '#e0f2fe',
      200: '#bae6fd',
      300: '#7dd3fc',
      400: '#38bdf8',
      500: '#0ea5e9',
      600: '#0284c7',
      700: '#0369a1',
      800: '#075985',
      900: '#0c4a6e',
    },
    secondary: {
      50: '#f0fdf4',
      100: '#dcfce7',
      200: '#bbf7d0',
      300: '#86efac',
      400: '#4ade80',
      500: '#22c55e',
      600: '#16a34a',
      700: '#15803d',
      800: '#166534',
      900: '#14532d',
    },
    neutral: {
      50: '#fafafa',
      100: '#f4f4f5',
      200: '#e4e4e7',
      300: '#d4d4d8',
      400: '#a1a1aa',
      500: '#71717a',
      600: '#52525b',
      700: '#3f3f46',
      800: '#27272a',
      900: '#18181b',
    },
  },
  typography: {
    fontFamily: {
      sans: ['Inter', 'system-ui', 'sans-serif'],
      mono: ['JetBrains Mono', 'monospace'],
    },
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
    },
    fontWeight: {
      normal: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
    },
    lineHeight: {
      tight: '1.25',
      normal: '1.5',
      relaxed: '1.75',
    },
  },
  spacing: {
    0: '0',
    1: '0.25rem',
    2: '0.5rem',
    3: '0.75rem',
    4: '1rem',
    5: '1.25rem',
    6: '1.5rem',
    8: '2rem',
    10: '2.5rem',
    12: '3rem',
    16: '4rem',
    20: '5rem',
    24: '6rem',
    32: '8rem',
  },
  borderRadius: {
    none: '0',
    sm: '0.125rem',
    base: '0.25rem',
    md: '0.375rem',
    lg: '0.5rem',
    xl: '0.75rem',
    '2xl': '1rem',
    '3xl': '1.5rem',
    full: '9999px',
  },
  shadows: {
    sm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
    base: '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
    md: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
    lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
    xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
  },
  breakpoints: {
    sm: '640px',
    md: '768px',
    lg: '1024px',
    xl: '1280px',
    '2xl': '1536px',
  },
};
```

## 📊 Performance Architecture

### 1. Caching Strategy

#### Multi-Layer Caching
```typescript
// shared/cache/cache.service.ts
import { Injectable } from '@nestjs/common';
import { Redis } from 'ioredis';
import { MemoryCache } from './memory-cache.service';

@Injectable()
export class CacheService {
  constructor(
    private redis: Redis,
    private memoryCache: MemoryCache,
  ) {}

  async get<T>(key: string): Promise<T | null> {
    // L1: Memory cache
    let value = await this.memoryCache.get<T>(key);
    if (value) {
      return value;
    }

    // L2: Redis cache
    value = await this.redis.get(key);
    if (value) {
      const parsedValue = JSON.parse(value);
      await this.memoryCache.set(key, parsedValue, 300); // 5 minutes
      return parsedValue;
    }

    return null;
  }

  async set<T>(key: string, value: T, ttl: number = 3600): Promise<void> {
    // Set in both caches
    await Promise.all([
      this.memoryCache.set(key, value, Math.min(ttl, 300)), // Max 5 minutes in memory
      this.redis.setex(key, ttl, JSON.stringify(value)),
    ]);
  }

  async del(key: string): Promise<void> {
    await Promise.all([
      this.memoryCache.del(key),
      this.redis.del(key),
    ]);
  }

  async invalidatePattern(pattern: string): Promise<void> {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}
```

### 2. Database Optimization

#### Query Optimization
```typescript
// services/web3-service/src/repositories/optimized-blockchain.repository.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { Blockchain } from '../entities/blockchain.entity';

@Injectable()
export class OptimizedBlockchainRepository {
  constructor(
    @InjectRepository(Blockchain)
    private repository: Repository<Blockchain>,
  ) {}

  async findByIdWithRelations(id: string): Promise<Blockchain | null> {
    return await this.repository
      .createQueryBuilder('blockchain')
      .leftJoinAndSelect('blockchain.transactions', 'transactions')
      .leftJoinAndSelect('blockchain.wallets', 'wallets')
      .where('blockchain.id = :id', { id })
      .cache(true)
      .getOne();
  }

  async findActiveBlockchains(): Promise<Blockchain[]> {
    return await this.repository
      .createQueryBuilder('blockchain')
      .where('blockchain.isActive = :isActive', { isActive: true })
      .orderBy('blockchain.priority', 'ASC')
      .cache(true)
      .getMany();
  }

  async findBlockchainsByType(type: string): Promise<Blockchain[]> {
    return await this.repository
      .createQueryBuilder('blockchain')
      .where('blockchain.type = :type', { type })
      .andWhere('blockchain.isActive = :isActive', { isActive: true })
      .cache(true)
      .getMany();
  }

  async getBlockchainStats(): Promise<BlockchainStats> {
    const result = await this.repository
      .createQueryBuilder('blockchain')
      .select('blockchain.type', 'type')
      .addSelect('COUNT(blockchain.id)', 'count')
      .addSelect('AVG(blockchain.transactionCount)', 'avgTransactions')
      .groupBy('blockchain.type')
      .cache(true)
      .getRawMany();

    return result.reduce((stats, row) => {
      stats[row.type] = {
        count: parseInt(row.count),
        avgTransactions: parseFloat(row.avgTransactions),
      };
      return stats;
    }, {});
  }
}
```

## 🔒 Security Architecture

### 1. Authentication & Authorization

#### JWT Authentication
```typescript
// shared/auth/jwt-auth.service.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';

@Injectable()
export class JwtAuthService {
  constructor(
    private jwtService: JwtService,
    private userService: UserService,
  ) {}

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.userService.findByEmail(email);
    if (user && await this.userService.validatePassword(user, password)) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }

  async login(user: any) {
    const payload = { 
      email: user.email, 
      sub: user.id,
      roles: user.roles,
      permissions: user.permissions
    };
    
    return {
      access_token: this.jwtService.sign(payload),
      refresh_token: this.jwtService.sign(payload, { expiresIn: '7d' }),
      user: {
        id: user.id,
        email: user.email,
        roles: user.roles,
        permissions: user.permissions
      }
    };
  }

  async refreshToken(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken);
      const user = await this.userService.findById(payload.sub);
      
      if (!user) {
        throw new UnauthorizedException();
      }

      const newPayload = { 
        email: user.email, 
        sub: user.id,
        roles: user.roles,
        permissions: user.permissions
      };

      return {
        access_token: this.jwtService.sign(newPayload),
        refresh_token: this.jwtService.sign(newPayload, { expiresIn: '7d' }),
      };
    } catch (error) {
      throw new UnauthorizedException();
    }
  }
}
```

#### RBAC Authorization
```typescript
// shared/auth/rbac.guard.ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from './decorators/roles.decorator';
import { PERMISSIONS_KEY } from './decorators/permissions.decorator';

@Injectable()
export class RbacGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles && !requiredPermissions) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();
    
    if (!user) {
      return false;
    }

    // Check roles
    if (requiredRoles) {
      const hasRole = requiredRoles.some(role => user.roles?.includes(role));
      if (!hasRole) {
        return false;
      }
    }

    // Check permissions
    if (requiredPermissions) {
      const hasPermission = requiredPermissions.some(permission => 
        user.permissions?.includes(permission)
      );
      if (!hasPermission) {
        return false;
      }
    }

    return true;
  }
}
```

### 2. Data Encryption

#### Encryption Service
```typescript
// shared/encryption/encryption.service.ts
import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

@Injectable()
export class EncryptionService {
  private readonly algorithm = 'aes-256-gcm';
  private readonly keyLength = 32;
  private readonly ivLength = 16;
  private readonly tagLength = 16;

  private getKey(): Buffer {
    const key = process.env.ENCRYPTION_KEY;
    if (!key) {
      throw new Error('ENCRYPTION_KEY environment variable is required');
    }
    return crypto.scryptSync(key, 'salt', this.keyLength);
  }

  encrypt(text: string): string {
    const key = this.getKey();
    const iv = crypto.randomBytes(this.ivLength);
    const cipher = crypto.createCipher(this.algorithm, key);
    cipher.setAAD(Buffer.from('additional-data'));

    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    const tag = cipher.getAuthTag();
    
    return iv.toString('hex') + ':' + tag.toString('hex') + ':' + encrypted;
  }

  decrypt(encryptedText: string): string {
    const key = this.getKey();
    const [ivHex, tagHex, encrypted] = encryptedText.split(':');
    
    const iv = Buffer.from(ivHex, 'hex');
    const tag = Buffer.from(tagHex, 'hex');
    
    const decipher = crypto.createDecipher(this.algorithm, key);
    decipher.setAAD(Buffer.from('additional-data'));
    decipher.setAuthTag(tag);
    
    let decrypted = decipher.update(encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    
    return decrypted;
  }

  hash(text: string): string {
    return crypto.createHash('sha256').update(text).digest('hex');
  }

  generateSalt(): string {
    return crypto.randomBytes(16).toString('hex');
  }

  hashWithSalt(text: string, salt: string): string {
    return crypto.pbkdf2Sync(text, salt, 10000, 64, 'sha512').toString('hex');
  }
}
```

## 📞 Contact Information

### Architecture Team
- **Email**: architecture@rechain.network
- **Phone**: +1-555-ARCHITECTURE
- **Slack**: #architecture channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Design Team
- **Email**: design@rechain.network
- **Phone**: +1-555-DESIGN
- **Slack**: #design channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Platform Team
- **Email**: platform@rechain.network
- **Phone**: +1-555-PLATFORM
- **Slack**: #platform channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Building scalable and maintainable systems! 🏗️**

*This architecture and design guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Architecture & Design Guide Version**: 1.0.0
