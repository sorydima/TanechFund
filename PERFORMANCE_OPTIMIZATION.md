# Performance Optimization Guide - REChain VC Lab

## ⚡ Performance Overview

This document outlines our comprehensive performance optimization strategy for REChain VC Lab, covering frontend, backend, database, and infrastructure optimization techniques.

## 🎯 Performance Principles

### Core Principles

#### 1. Speed First
- **Sub-second Response**: API responses under 200ms
- **Instant UI**: UI interactions under 16ms (60fps)
- **Fast Loading**: Initial page load under 2 seconds
- **Smooth Scrolling**: 60fps scrolling performance

#### 2. Efficiency
- **Resource Optimization**: Minimize CPU, memory, and network usage
- **Caching Strategy**: Multi-layer caching for optimal performance
- **Code Splitting**: Load only what's needed when needed
- **Lazy Loading**: Defer non-critical resources

#### 3. Scalability
- **Horizontal Scaling**: Scale out rather than up
- **Load Distribution**: Distribute load across multiple instances
- **Database Optimization**: Optimize queries and indexing
- **CDN Usage**: Global content delivery

#### 4. Monitoring
- **Real-time Metrics**: Continuous performance monitoring
- **Alerting**: Proactive performance issue detection
- **Profiling**: Regular performance profiling and optimization
- **User Experience**: Monitor real user performance

## 🚀 Frontend Performance

### 1. React Performance Optimization

#### Component Optimization
```typescript
// components/optimized/BlockchainList.tsx
import React, { memo, useMemo, useCallback } from 'react';
import { VirtualizedList } from 'react-virtualized';
import { BlockchainItem } from './BlockchainItem';

interface BlockchainListProps {
  blockchains: Blockchain[];
  onSelect: (blockchain: Blockchain) => void;
  searchTerm: string;
}

export const BlockchainList = memo<BlockchainListProps>(({
  blockchains,
  onSelect,
  searchTerm
}) => {
  // Memoize filtered blockchains
  const filteredBlockchains = useMemo(() => {
    if (!searchTerm) return blockchains;
    
    return blockchains.filter(blockchain =>
      blockchain.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      blockchain.symbol.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [blockchains, searchTerm]);

  // Memoize callback to prevent unnecessary re-renders
  const handleSelect = useCallback((blockchain: Blockchain) => {
    onSelect(blockchain);
  }, [onSelect]);

  // Memoize row renderer for virtualized list
  const rowRenderer = useCallback(({ index, key, style }) => {
    const blockchain = filteredBlockchains[index];
    return (
      <div key={key} style={style}>
        <BlockchainItem
          blockchain={blockchain}
          onSelect={handleSelect}
        />
      </div>
    );
  }, [filteredBlockchains, handleSelect]);

  return (
    <VirtualizedList
      height={600}
      rowCount={filteredBlockchains.length}
      rowHeight={80}
      rowRenderer={rowRenderer}
      overscanRowCount={5}
    />
  );
});

BlockchainList.displayName = 'BlockchainList';
```

#### State Management Optimization
```typescript
// stores/optimized/blockchain.store.ts
import { create } from 'zustand';
import { subscribeWithSelector } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

interface BlockchainState {
  blockchains: Blockchain[];
  selectedBlockchain: Blockchain | null;
  loading: boolean;
  error: string | null;
  // Actions
  setBlockchains: (blockchains: Blockchain[]) => void;
  selectBlockchain: (blockchain: Blockchain) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  // Computed values
  getBlockchainById: (id: string) => Blockchain | undefined;
  getActiveBlockchains: () => Blockchain[];
}

export const useBlockchainStore = create<BlockchainState>()(
  subscribeWithSelector(
    immer((set, get) => ({
      blockchains: [],
      selectedBlockchain: null,
      loading: false,
      error: null,

      setBlockchains: (blockchains) =>
        set((state) => {
          state.blockchains = blockchains;
        }),

      selectBlockchain: (blockchain) =>
        set((state) => {
          state.selectedBlockchain = blockchain;
        }),

      setLoading: (loading) =>
        set((state) => {
          state.loading = loading;
        }),

      setError: (error) =>
        set((state) => {
          state.error = error;
        }),

      getBlockchainById: (id) => {
        const state = get();
        return state.blockchains.find(b => b.id === id);
      },

      getActiveBlockchains: () => {
        const state = get();
        return state.blockchains.filter(b => b.isActive);
      },
    }))
  )
);

// Selector hooks for optimized re-renders
export const useBlockchains = () => useBlockchainStore(state => state.blockchains);
export const useSelectedBlockchain = () => useBlockchainStore(state => state.selectedBlockchain);
export const useBlockchainLoading = () => useBlockchainStore(state => state.loading);
export const useBlockchainError = () => useBlockchainStore(state => state.error);
```

### 2. Bundle Optimization

#### Webpack Configuration
```javascript
// webpack.config.js
const path = require('path');
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');
const CompressionPlugin = require('compression-webpack-plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = {
  mode: 'production',
  entry: './src/index.tsx',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[contenthash].js',
    chunkFilename: '[name].[contenthash].chunk.js',
    clean: true,
  },
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
        common: {
          name: 'common',
          minChunks: 2,
          chunks: 'all',
          enforce: true,
        },
        react: {
          test: /[\\/]node_modules[\\/](react|react-dom)[\\/]/,
          name: 'react',
          chunks: 'all',
        },
        blockchain: {
          test: /[\\/]src[\\/]blockchain[\\/]/,
          name: 'blockchain',
          chunks: 'all',
        },
      },
    },
    usedExports: true,
    sideEffects: false,
    minimize: true,
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          compress: {
            drop_console: true,
            drop_debugger: true,
          },
        },
      }),
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production'),
    }),
    new CompressionPlugin({
      algorithm: 'gzip',
      test: /\.(js|css|html|svg)$/,
      threshold: 8192,
      minRatio: 0.8,
    }),
    new BundleAnalyzerPlugin({
      analyzerMode: 'static',
      openAnalyzer: false,
    }),
  ],
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: [
              ['@babel/preset-env', { targets: '> 1%, not dead' }],
              '@babel/preset-react',
              '@babel/preset-typescript',
            ],
            plugins: [
              '@babel/plugin-syntax-dynamic-import',
              '@babel/plugin-proposal-optional-chaining',
              '@babel/plugin-proposal-nullish-coalescing-operator',
            ],
          },
        },
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
    alias: {
      '@': path.resolve(__dirname, 'src'),
      '@components': path.resolve(__dirname, 'src/components'),
      '@utils': path.resolve(__dirname, 'src/utils'),
      '@hooks': path.resolve(__dirname, 'src/hooks'),
      '@stores': path.resolve(__dirname, 'src/stores'),
    },
  },
};
```

#### Code Splitting
```typescript
// components/lazy/BlockchainExplorer.tsx
import { lazy, Suspense } from 'react';
import { LoadingSpinner } from '../ui/LoadingSpinner';

// Lazy load heavy components
const BlockchainChart = lazy(() => import('./BlockchainChart'));
const TransactionList = lazy(() => import('./TransactionList'));
const WalletManager = lazy(() => import('./WalletManager'));

export const BlockchainExplorer = () => {
  return (
    <div className="blockchain-explorer">
      <h1>Blockchain Explorer</h1>
      
      <Suspense fallback={<LoadingSpinner />}>
        <BlockchainChart />
      </Suspense>
      
      <Suspense fallback={<LoadingSpinner />}>
        <TransactionList />
      </Suspense>
      
      <Suspense fallback={<LoadingSpinner />}>
        <WalletManager />
      </Suspense>
    </div>
  );
};
```

### 3. Image Optimization

#### Image Component
```typescript
// components/optimized/OptimizedImage.tsx
import React, { useState, useCallback } from 'react';
import { LazyLoadImage } from 'react-lazy-load-image-component';
import 'react-lazy-load-image-component/src/effects/blur.css';

interface OptimizedImageProps {
  src: string;
  alt: string;
  width?: number;
  height?: number;
  className?: string;
  placeholder?: string;
  effect?: 'blur' | 'black-and-white' | 'opacity';
}

export const OptimizedImage: React.FC<OptimizedImageProps> = ({
  src,
  alt,
  width,
  height,
  className,
  placeholder,
  effect = 'blur'
}) => {
  const [isLoaded, setIsLoaded] = useState(false);
  const [hasError, setHasError] = useState(false);

  const handleLoad = useCallback(() => {
    setIsLoaded(true);
  }, []);

  const handleError = useCallback(() => {
    setHasError(true);
  }, []);

  // Generate responsive image sources
  const generateSrcSet = (baseSrc: string) => {
    const sizes = [320, 640, 768, 1024, 1280, 1536];
    return sizes
      .map(size => `${baseSrc}?w=${size}&q=80 ${size}w`)
      .join(', ');
  };

  if (hasError) {
    return (
      <div 
        className={`image-placeholder ${className}`}
        style={{ width, height }}
      >
        <span>Image failed to load</span>
      </div>
    );
  }

  return (
    <LazyLoadImage
      src={src}
      srcSet={generateSrcSet(src)}
      alt={alt}
      width={width}
      height={height}
      className={className}
      effect={effect}
      placeholderSrc={placeholder}
      onLoad={handleLoad}
      onError={handleError}
      loading="lazy"
      threshold={100}
    />
  );
};
```

## 🏗️ Backend Performance

### 1. API Optimization

#### Response Caching
```typescript
// services/blockchain.service.ts
import { Injectable } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject, CACHE_MANAGER } from '@nestjs/common';
import { Cache } from 'cache-manager';

@Injectable()
export class BlockchainService {
  constructor(
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
    private blockchainRepository: BlockchainRepository,
  ) {}

  async getBlockchains(): Promise<Blockchain[]> {
    const cacheKey = 'blockchains:all';
    let blockchains = await this.cacheManager.get<Blockchain[]>(cacheKey);
    
    if (!blockchains) {
      blockchains = await this.blockchainRepository.findAll();
      await this.cacheManager.set(cacheKey, blockchains, 300); // 5 minutes
    }
    
    return blockchains;
  }

  async getBlockchainById(id: string): Promise<Blockchain | null> {
    const cacheKey = `blockchain:${id}`;
    let blockchain = await this.cacheManager.get<Blockchain>(cacheKey);
    
    if (!blockchain) {
      blockchain = await this.blockchainRepository.findById(id);
      if (blockchain) {
        await this.cacheManager.set(cacheKey, blockchain, 600); // 10 minutes
      }
    }
    
    return blockchain;
  }

  async getBlockchainStats(): Promise<BlockchainStats> {
    const cacheKey = 'blockchain:stats';
    let stats = await this.cacheManager.get<BlockchainStats>(cacheKey);
    
    if (!stats) {
      stats = await this.blockchainRepository.getStats();
      await this.cacheManager.set(cacheKey, stats, 60); // 1 minute
    }
    
    return stats;
  }
}
```

#### Database Query Optimization
```typescript
// repositories/optimized-blockchain.repository.ts
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

  async findWithPagination(
    page: number = 1,
    limit: number = 20,
    filters?: BlockchainFilters
  ): Promise<{ data: Blockchain[]; total: number; page: number; limit: number }> {
    const query = this.repository
      .createQueryBuilder('blockchain')
      .leftJoinAndSelect('blockchain.transactions', 'transactions')
      .leftJoinAndSelect('blockchain.wallets', 'wallets');

    // Apply filters
    if (filters?.type) {
      query.andWhere('blockchain.type = :type', { type: filters.type });
    }
    
    if (filters?.isActive !== undefined) {
      query.andWhere('blockchain.isActive = :isActive', { isActive: filters.isActive });
    }
    
    if (filters?.search) {
      query.andWhere(
        '(blockchain.name ILIKE :search OR blockchain.symbol ILIKE :search)',
        { search: `%${filters.search}%` }
      );
    }

    // Get total count
    const total = await query.getCount();

    // Apply pagination
    const data = await query
      .orderBy('blockchain.priority', 'ASC')
      .addOrderBy('blockchain.name', 'ASC')
      .skip((page - 1) * limit)
      .take(limit)
      .cache(true)
      .getMany();

    return {
      data,
      total,
      page,
      limit
    };
  }

  async findPopularBlockchains(limit: number = 10): Promise<Blockchain[]> {
    return await this.repository
      .createQueryBuilder('blockchain')
      .leftJoin('blockchain.transactions', 'transactions')
      .select('blockchain')
      .addSelect('COUNT(transactions.id)', 'transactionCount')
      .where('blockchain.isActive = :isActive', { isActive: true })
      .groupBy('blockchain.id')
      .orderBy('transactionCount', 'DESC')
      .addOrderBy('blockchain.priority', 'ASC')
      .limit(limit)
      .cache(true)
      .getMany();
  }

  async findBlockchainsByUser(userId: string): Promise<Blockchain[]> {
    return await this.repository
      .createQueryBuilder('blockchain')
      .leftJoin('blockchain.userBlockchains', 'userBlockchains')
      .where('userBlockchains.userId = :userId', { userId })
      .andWhere('blockchain.isActive = :isActive', { isActive: true })
      .orderBy('userBlockchains.createdAt', 'DESC')
      .cache(true)
      .getMany();
  }
}
```

### 2. Connection Pooling

#### Database Connection Pool
```typescript
// config/database.config.ts
import { TypeOrmModuleOptions } from '@nestjs/typeorm';

export const databaseConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  extra: {
    // Connection pool settings
    max: 20, // Maximum number of connections
    min: 5,  // Minimum number of connections
    acquire: 30000, // Maximum time to acquire connection
    idle: 10000,    // Maximum idle time
    evict: 1000,    // Eviction run interval
    handleDisconnects: true,
    // Connection pool monitoring
    pool: {
      afterCreate: (conn: any, done: any) => {
        console.log('New database connection created');
        done();
      },
      beforeDestroy: (conn: any, done: any) => {
        console.log('Database connection destroyed');
        done();
      },
    },
  },
};
```

#### Redis Connection Pool
```typescript
// config/redis.config.ts
import { RedisModuleOptions } from '@nestjs/redis';

export const redisConfig: RedisModuleOptions = {
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT),
  password: process.env.REDIS_PASSWORD,
  db: parseInt(process.env.REDIS_DB),
  retryDelayOnFailover: 100,
  enableReadyCheck: false,
  maxRetriesPerRequest: 3,
  lazyConnect: true,
  keepAlive: 30000,
  family: 4,
  // Connection pool settings
  pool: {
    min: 2,
    max: 10,
    acquireTimeoutMillis: 30000,
    createTimeoutMillis: 30000,
    destroyTimeoutMillis: 5000,
    idleTimeoutMillis: 30000,
    reapIntervalMillis: 1000,
    createRetryIntervalMillis: 200,
  },
};
```

## 🗄️ Database Performance

### 1. Indexing Strategy

#### Database Indexes
```sql
-- blockchain_optimization.sql

-- Primary indexes
CREATE INDEX CONCURRENTLY idx_blockchains_id ON blockchains(id);
CREATE INDEX CONCURRENTLY idx_blockchains_type ON blockchains(type);
CREATE INDEX CONCURRENTLY idx_blockchains_is_active ON blockchains(is_active);

-- Composite indexes
CREATE INDEX CONCURRENTLY idx_blockchains_type_active 
ON blockchains(type, is_active) WHERE is_active = true;

CREATE INDEX CONCURRENTLY idx_blockchains_priority_active 
ON blockchains(priority, is_active) WHERE is_active = true;

-- Text search indexes
CREATE INDEX CONCURRENTLY idx_blockchains_name_gin 
ON blockchains USING gin(to_tsvector('english', name));

CREATE INDEX CONCURRENTLY idx_blockchains_symbol_gin 
ON blockchains USING gin(to_tsvector('english', symbol));

-- Partial indexes
CREATE INDEX CONCURRENTLY idx_blockchains_active_priority 
ON blockchains(priority) WHERE is_active = true;

-- Covering indexes
CREATE INDEX CONCURRENTLY idx_blockchains_covering 
ON blockchains(type, is_active) INCLUDE (id, name, symbol, priority);

-- Foreign key indexes
CREATE INDEX CONCURRENTLY idx_transactions_blockchain_id 
ON transactions(blockchain_id);

CREATE INDEX CONCURRENTLY idx_wallets_blockchain_id 
ON wallets(blockchain_id);

-- Time-based indexes
CREATE INDEX CONCURRENTLY idx_transactions_created_at 
ON transactions(created_at);

CREATE INDEX CONCURRENTLY idx_transactions_created_at_blockchain 
ON transactions(created_at, blockchain_id);

-- Hash indexes for exact matches
CREATE INDEX CONCURRENTLY idx_blockchains_symbol_hash 
ON blockchains USING hash(symbol);
```

### 2. Query Optimization

#### Optimized Queries
```typescript
// repositories/query-optimized.repository.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, QueryRunner } from 'typeorm';
import { Blockchain } from '../entities/blockchain.entity';

@Injectable()
export class QueryOptimizedRepository {
  constructor(
    @InjectRepository(Blockchain)
    private repository: Repository<Blockchain>,
  ) {}

  async findBlockchainsWithStats(): Promise<BlockchainWithStats[]> {
    // Use raw SQL for complex queries
    const query = `
      SELECT 
        b.id,
        b.name,
        b.symbol,
        b.type,
        b.is_active,
        b.priority,
        COUNT(t.id) as transaction_count,
        COUNT(DISTINCT w.id) as wallet_count,
        COALESCE(AVG(t.amount), 0) as avg_transaction_amount,
        MAX(t.created_at) as last_transaction_at
      FROM blockchains b
      LEFT JOIN transactions t ON b.id = t.blockchain_id
      LEFT JOIN wallets w ON b.id = w.blockchain_id
      WHERE b.is_active = true
      GROUP BY b.id, b.name, b.symbol, b.type, b.is_active, b.priority
      ORDER BY b.priority ASC, transaction_count DESC
    `;

    return await this.repository.query(query);
  }

  async findBlockchainsByUserOptimized(userId: string): Promise<Blockchain[]> {
    // Use EXISTS for better performance than JOIN
    return await this.repository
      .createQueryBuilder('blockchain')
      .where('blockchain.isActive = :isActive', { isActive: true })
      .andWhere(
        'EXISTS (SELECT 1 FROM user_blockchains ub WHERE ub.blockchain_id = blockchain.id AND ub.user_id = :userId)',
        { userId }
      )
      .orderBy('blockchain.priority', 'ASC')
      .cache(true)
      .getMany();
  }

  async bulkUpdateBlockchainStats(updates: BlockchainStatsUpdate[]): Promise<void> {
    const queryRunner = this.repository.manager.connection.createQueryRunner();
    
    await queryRunner.connect();
    await queryRunner.startTransaction();
    
    try {
      for (const update of updates) {
        await queryRunner.query(
          'UPDATE blockchains SET transaction_count = $1, last_updated = NOW() WHERE id = $2',
          [update.transactionCount, update.blockchainId]
        );
      }
      
      await queryRunner.commitTransaction();
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
```

## 📊 Performance Monitoring

### 1. Real-time Monitoring

#### Performance Metrics
```typescript
// monitoring/performance.monitor.ts
import { Injectable } from '@nestjs/common';
import { PrometheusService } from './prometheus.service';

@Injectable()
export class PerformanceMonitor {
  constructor(private prometheusService: PrometheusService) {}

  // API Response Time
  recordApiResponseTime(endpoint: string, method: string, duration: number) {
    this.prometheusService.recordHistogram('api_response_time', duration, {
      endpoint,
      method,
    });
  }

  // Database Query Time
  recordDatabaseQueryTime(query: string, duration: number) {
    this.prometheusService.recordHistogram('database_query_time', duration, {
      query: query.substring(0, 50), // Truncate long queries
    });
  }

  // Cache Hit Rate
  recordCacheHit(cacheKey: string) {
    this.prometheusService.incrementCounter('cache_hits_total', {
      cache_key: cacheKey,
    });
  }

  recordCacheMiss(cacheKey: string) {
    this.prometheusService.incrementCounter('cache_misses_total', {
      cache_key: cacheKey,
    });
  }

  // Memory Usage
  recordMemoryUsage(service: string, usage: number) {
    this.prometheusService.recordGauge('memory_usage_bytes', usage, {
      service,
    });
  }

  // CPU Usage
  recordCpuUsage(service: string, usage: number) {
    this.prometheusService.recordGauge('cpu_usage_percent', usage, {
      service,
    });
  }

  // Error Rate
  recordError(endpoint: string, errorType: string) {
    this.prometheusService.incrementCounter('errors_total', {
      endpoint,
      error_type: errorType,
    });
  }
}
```

#### Performance Interceptor
```typescript
// interceptors/performance.interceptor.ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { PerformanceMonitor } from '../monitoring/performance.monitor';

@Injectable()
export class PerformanceInterceptor implements NestInterceptor {
  constructor(private performanceMonitor: PerformanceMonitor) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const response = context.switchToHttp().getResponse();
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const duration = Date.now() - startTime;
        const endpoint = request.route?.path || request.url;
        const method = request.method;

        this.performanceMonitor.recordApiResponseTime(endpoint, method, duration);
      }),
    );
  }
}
```

### 2. Performance Testing

#### Load Testing
```typescript
// tests/performance/load.test.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';

describe('Performance Tests', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('API Performance', () => {
    it('should respond to /blockchains within 200ms', async () => {
      const startTime = Date.now();
      
      await request(app.getHttpServer())
        .get('/blockchains')
        .expect(200);
      
      const duration = Date.now() - startTime;
      expect(duration).toBeLessThan(200);
    });

    it('should handle 100 concurrent requests', async () => {
      const requests = Array(100).fill(null).map(() =>
        request(app.getHttpServer())
          .get('/blockchains')
          .expect(200)
      );

      const startTime = Date.now();
      await Promise.all(requests);
      const duration = Date.now() - startTime;

      expect(duration).toBeLessThan(5000); // 5 seconds max
    });

    it('should handle database queries efficiently', async () => {
      const startTime = Date.now();
      
      await request(app.getHttpServer())
        .get('/blockchains/stats')
        .expect(200);
      
      const duration = Date.now() - startTime;
      expect(duration).toBeLessThan(100);
    });
  });
});
```

## 📞 Contact Information

### Performance Team
- **Email**: performance@rechain.network
- **Phone**: +1-555-PERFORMANCE
- **Slack**: #performance channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Frontend Team
- **Email**: frontend@rechain.network
- **Phone**: +1-555-FRONTEND
- **Slack**: #frontend channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Backend Team
- **Email**: backend@rechain.network
- **Phone**: +1-555-BACKEND
- **Slack**: #backend channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Optimizing for maximum performance! ⚡**

*This performance optimization guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Performance Optimization Guide Version**: 1.0.0
