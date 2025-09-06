# Code Quality Standards - REChain VC Lab

## 📋 Code Quality Overview

This document outlines our comprehensive code quality standards for REChain VC Lab, covering coding standards, best practices, code review processes, and quality metrics.

## 🎯 Quality Principles

### Core Principles

#### 1. Consistency
- **Uniform Style**: Consistent coding style across all projects
- **Naming Conventions**: Clear and descriptive naming conventions
- **Code Organization**: Well-organized and structured code
- **Documentation**: Comprehensive code documentation

#### 2. Readability
- **Clear Intent**: Code should clearly express its intent
- **Self-Documenting**: Code should be self-explanatory
- **Comments**: Meaningful comments where necessary
- **Formatting**: Proper code formatting and indentation

#### 3. Maintainability
- **Modular Design**: Modular and loosely coupled code
- **DRY Principle**: Don't Repeat Yourself
- **SOLID Principles**: Follow SOLID design principles
- **Refactoring**: Regular code refactoring

#### 4. Reliability
- **Error Handling**: Comprehensive error handling
- **Input Validation**: Validate all inputs
- **Testing**: Comprehensive test coverage
- **Performance**: Optimized for performance

## 📝 Coding Standards

### 1. TypeScript/JavaScript Standards

#### Naming Conventions
```typescript
// Variables and functions: camelCase
const userName = 'john_doe';
const isAuthenticated = true;

function calculateTotalPrice(items: Item[]): number {
  return items.reduce((total, item) => total + item.price, 0);
}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.rechain.network';

// Classes: PascalCase
class UserService {
  private readonly apiClient: ApiClient;
  
  constructor(apiClient: ApiClient) {
    this.apiClient = apiClient;
  }
  
  async getUserById(id: string): Promise<User> {
    return await this.apiClient.get(`/users/${id}`);
  }
}

// Interfaces: PascalCase with 'I' prefix
interface IUserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// Enums: PascalCase
enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
  MODERATOR = 'moderator'
}

// Types: PascalCase
type UserStatus = 'active' | 'inactive' | 'pending';
```

#### Function Standards
```typescript
// Function should be pure and focused
function calculateTax(amount: number, taxRate: number): number {
  if (amount < 0) {
    throw new Error('Amount cannot be negative');
  }
  
  if (taxRate < 0 || taxRate > 1) {
    throw new Error('Tax rate must be between 0 and 1');
  }
  
  return amount * taxRate;
}

// Use arrow functions for simple operations
const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount);
};

// Use async/await for asynchronous operations
async function fetchUserData(userId: string): Promise<UserData> {
  try {
    const response = await fetch(`/api/users/${userId}`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Error fetching user data:', error);
    throw error;
  }
}
```

#### Class Standards
```typescript
// Use dependency injection
class BlockchainService {
  constructor(
    private readonly httpClient: HttpClient,
    private readonly logger: Logger,
    private readonly config: Config
  ) {}
  
  async getBlockchainInfo(chainId: string): Promise<BlockchainInfo> {
    this.logger.info(`Fetching blockchain info for chain: ${chainId}`);
    
    try {
      const response = await this.httpClient.get<BlockchainInfo>(
        `${this.config.apiBaseUrl}/blockchains/${chainId}`
      );
      
      this.logger.info(`Successfully fetched blockchain info for chain: ${chainId}`);
      return response;
    } catch (error) {
      this.logger.error(`Failed to fetch blockchain info for chain: ${chainId}`, error);
      throw new BlockchainServiceError(
        `Failed to fetch blockchain info for chain: ${chainId}`,
        error
      );
    }
  }
}

// Use abstract classes for common functionality
abstract class BaseRepository<T> {
  constructor(protected readonly db: Database) {}
  
  abstract findById(id: string): Promise<T | null>;
  abstract save(entity: T): Promise<T>;
  abstract delete(id: string): Promise<void>;
  
  protected validateEntity(entity: T): void {
    if (!entity) {
      throw new Error('Entity cannot be null or undefined');
    }
  }
}
```

### 2. Flutter/Dart Standards

#### Widget Standards
```dart
// Use const constructors when possible
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  
  const UserCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}

// Use StatefulWidget for stateful components
class BlockchainList extends StatefulWidget {
  const BlockchainList({Key? key}) : super(key: key);
  
  @override
  State<BlockchainList> createState() => _BlockchainListState();
}

class _BlockchainListState extends State<BlockchainList> {
  List<Blockchain> _blockchains = [];
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadBlockchains();
  }
  
  Future<void> _loadBlockchains() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final blockchains = await BlockchainService.getBlockchains();
      setState(() {
        _blockchains = blockchains;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadBlockchains,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _blockchains.length,
      itemBuilder: (context, index) {
        final blockchain = _blockchains[index];
        return BlockchainTile(blockchain: blockchain);
      },
    );
  }
}
```

#### Service Standards
```dart
// Use singleton pattern for services
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  final Dio _dio = Dio();
  
  void initialize() {
    _dio.options.baseUrl = 'https://api.rechain.network';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(AuthInterceptor());
  }
  
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
  
  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data);
  }
}

// Use repository pattern
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
}

class ApiUserRepository implements UserRepository {
  final ApiService _apiService;
  
  ApiUserRepository(this._apiService);
  
  @override
  Future<List<User>> getUsers() async {
    final response = await _apiService.get<List<dynamic>>('/users');
    return response.data!.map((json) => User.fromJson(json)).toList();
  }
  
  @override
  Future<User?> getUserById(String id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>('/users/$id');
      return User.fromJson(response.data!);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }
  
  @override
  Future<User> createUser(User user) async {
    final response = await _apiService.post<Map<String, dynamic>>('/users', data: user.toJson());
    return User.fromJson(response.data!);
  }
  
  @override
  Future<User> updateUser(User user) async {
    final response = await _apiService.put<Map<String, dynamic>>('/users/${user.id}', data: user.toJson());
    return User.fromJson(response.data!);
  }
  
  @override
  Future<void> deleteUser(String id) async {
    await _apiService.delete('/users/$id');
  }
}
```

### 3. Python Standards

#### Function Standards
```python
# Use type hints
def calculate_compound_interest(
    principal: float,
    rate: float,
    time: int,
    compound_frequency: int = 12
) -> float:
    """
    Calculate compound interest.
    
    Args:
        principal: The principal amount
        rate: The annual interest rate (as a decimal)
        time: The time period in years
        compound_frequency: Number of times interest is compounded per year
        
    Returns:
        The compound interest amount
        
    Raises:
        ValueError: If any of the parameters are invalid
    """
    if principal < 0:
        raise ValueError("Principal cannot be negative")
    
    if rate < 0 or rate > 1:
        raise ValueError("Rate must be between 0 and 1")
    
    if time < 0:
        raise ValueError("Time cannot be negative")
    
    if compound_frequency <= 0:
        raise ValueError("Compound frequency must be positive")
    
    amount = principal * (1 + rate / compound_frequency) ** (compound_frequency * time)
    return amount - principal

# Use dataclasses for data structures
from dataclasses import dataclass
from typing import Optional, List
from datetime import datetime

@dataclass
class User:
    id: str
    name: str
    email: str
    created_at: datetime
    is_active: bool = True
    roles: List[str] = None
    
    def __post_init__(self):
        if self.roles is None:
            self.roles = []
    
    def has_role(self, role: str) -> bool:
        """Check if user has a specific role."""
        return role in self.roles
    
    def add_role(self, role: str) -> None:
        """Add a role to the user."""
        if role not in self.roles:
            self.roles.append(role)
    
    def remove_role(self, role: str) -> None:
        """Remove a role from the user."""
        if role in self.roles:
            self.roles.remove(role)
```

#### Class Standards
```python
# Use abstract base classes
from abc import ABC, abstractmethod
from typing import List, Optional

class Repository(ABC):
    """Abstract base class for repositories."""
    
    @abstractmethod
    def find_by_id(self, id: str) -> Optional[object]:
        """Find an entity by its ID."""
        pass
    
    @abstractmethod
    def find_all(self) -> List[object]:
        """Find all entities."""
        pass
    
    @abstractmethod
    def save(self, entity: object) -> object:
        """Save an entity."""
        pass
    
    @abstractmethod
    def delete(self, id: str) -> None:
        """Delete an entity by its ID."""
        pass

class UserRepository(Repository):
    """Repository for User entities."""
    
    def __init__(self, db_connection):
        self.db_connection = db_connection
    
    def find_by_id(self, id: str) -> Optional[User]:
        """Find a user by ID."""
        query = "SELECT * FROM users WHERE id = %s"
        result = self.db_connection.execute(query, (id,)).fetchone()
        
        if result:
            return User(
                id=result['id'],
                name=result['name'],
                email=result['email'],
                created_at=result['created_at'],
                is_active=result['is_active']
            )
        return None
    
    def find_all(self) -> List[User]:
        """Find all users."""
        query = "SELECT * FROM users WHERE is_active = TRUE"
        results = self.db_connection.execute(query).fetchall()
        
        return [
            User(
                id=row['id'],
                name=row['name'],
                email=row['email'],
                created_at=row['created_at'],
                is_active=row['is_active']
            )
            for row in results
        ]
    
    def save(self, user: User) -> User:
        """Save a user."""
        if user.id:
            # Update existing user
            query = """
                UPDATE users 
                SET name = %s, email = %s, is_active = %s 
                WHERE id = %s
            """
            self.db_connection.execute(
                query, 
                (user.name, user.email, user.is_active, user.id)
            )
        else:
            # Insert new user
            query = """
                INSERT INTO users (name, email, is_active, created_at) 
                VALUES (%s, %s, %s, %s)
            """
            result = self.db_connection.execute(
                query, 
                (user.name, user.email, user.is_active, user.created_at)
            )
            user.id = result.lastrowid
        
        return user
    
    def delete(self, id: str) -> None:
        """Delete a user by ID."""
        query = "UPDATE users SET is_active = FALSE WHERE id = %s"
        self.db_connection.execute(query, (id,))
```

## 🧪 Testing Standards

### 1. Unit Testing

#### TypeScript/JavaScript Testing
```typescript
// user.service.test.ts
import { UserService } from './user.service';
import { UserRepository } from './user.repository';
import { User } from './user.model';

describe('UserService', () => {
  let userService: UserService;
  let mockUserRepository: jest.Mocked<UserRepository>;
  
  beforeEach(() => {
    mockUserRepository = {
      findById: jest.fn(),
      save: jest.fn(),
      delete: jest.fn(),
    } as jest.Mocked<UserRepository>;
    
    userService = new UserService(mockUserRepository);
  });
  
  describe('getUserById', () => {
    it('should return user when found', async () => {
      // Arrange
      const userId = '123';
      const expectedUser: User = {
        id: userId,
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: new Date(),
        isActive: true,
      };
      
      mockUserRepository.findById.mockResolvedValue(expectedUser);
      
      // Act
      const result = await userService.getUserById(userId);
      
      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
    });
    
    it('should throw error when user not found', async () => {
      // Arrange
      const userId = '123';
      mockUserRepository.findById.mockResolvedValue(null);
      
      // Act & Assert
      await expect(userService.getUserById(userId)).rejects.toThrow('User not found');
    });
  });
  
  describe('createUser', () => {
    it('should create user successfully', async () => {
      // Arrange
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
      };
      
      const expectedUser: User = {
        id: '123',
        ...userData,
        createdAt: new Date(),
        isActive: true,
      };
      
      mockUserRepository.save.mockResolvedValue(expectedUser);
      
      // Act
      const result = await userService.createUser(userData);
      
      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockUserRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(userData)
      );
    });
  });
});
```

#### Flutter/Dart Testing
```dart
// user_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'user_service.dart';
import 'user_repository.dart';
import 'user.dart';

@GenerateMocks([UserRepository])
void main() {
  group('UserService', () {
    late UserService userService;
    late MockUserRepository mockUserRepository;
    
    setUp(() {
      mockUserRepository = MockUserRepository();
      userService = UserService(mockUserRepository);
    });
    
    group('getUserById', () {
      test('should return user when found', () async {
        // Arrange
        const userId = '123';
        final expectedUser = User(
          id: userId,
          name: 'John Doe',
          email: 'john@example.com',
          createdAt: DateTime.now(),
          isActive: true,
        );
        
        when(mockUserRepository.findById(userId)).thenAnswer((_) async => expectedUser);
        
        // Act
        final result = await userService.getUserById(userId);
        
        // Assert
        expect(result, equals(expectedUser));
        verify(mockUserRepository.findById(userId)).called(1);
      });
      
      test('should throw exception when user not found', () async {
        // Arrange
        const userId = '123';
        when(mockUserRepository.findById(userId)).thenAnswer((_) async => null);
        
        // Act & Assert
        expect(
          () => userService.getUserById(userId),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });
    
    group('createUser', () {
      test('should create user successfully', () async {
        // Arrange
        final userData = UserData(
          name: 'John Doe',
          email: 'john@example.com',
        );
        
        final expectedUser = User(
          id: '123',
          name: userData.name,
          email: userData.email,
          createdAt: DateTime.now(),
          isActive: true,
        );
        
        when(mockUserRepository.save(any)).thenAnswer((_) async => expectedUser);
        
        // Act
        final result = await userService.createUser(userData);
        
        // Assert
        expect(result, equals(expectedUser));
        verify(mockUserRepository.save(any)).called(1);
      });
    });
  });
}
```

### 2. Integration Testing

#### API Integration Testing
```typescript
// user.integration.test.ts
import request from 'supertest';
import { app } from '../app';
import { Database } from '../database';

describe('User API Integration Tests', () => {
  let database: Database;
  
  beforeAll(async () => {
    database = new Database();
    await database.connect();
  });
  
  afterAll(async () => {
    await database.disconnect();
  });
  
  beforeEach(async () => {
    await database.clear();
  });
  
  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
      };
      
      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);
      
      expect(response.body).toMatchObject({
        id: expect.any(String),
        name: userData.name,
        email: userData.email,
        isActive: true,
        createdAt: expect.any(String),
      });
    });
    
    it('should return 400 for invalid user data', async () => {
      const invalidUserData = {
        name: '',
        email: 'invalid-email',
      };
      
      const response = await request(app)
        .post('/api/users')
        .send(invalidUserData)
        .expect(400);
      
      expect(response.body).toHaveProperty('errors');
    });
  });
  
  describe('GET /api/users/:id', () => {
    it('should return user by id', async () => {
      // Create a user first
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
      };
      
      const createResponse = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);
      
      const userId = createResponse.body.id;
      
      // Get the user
      const response = await request(app)
        .get(`/api/users/${userId}`)
        .expect(200);
      
      expect(response.body).toMatchObject({
        id: userId,
        name: userData.name,
        email: userData.email,
      });
    });
    
    it('should return 404 for non-existent user', async () => {
      const response = await request(app)
        .get('/api/users/non-existent-id')
        .expect(404);
      
      expect(response.body).toHaveProperty('message', 'User not found');
    });
  });
});
```

## 📊 Code Quality Metrics

### 1. Code Coverage

#### Coverage Configuration
```json
// jest.config.js
module.exports = {
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.{ts,tsx}',
    '!src/**/*.test.{ts,tsx}',
    '!src/**/*.spec.{ts,tsx}',
  ],
};
```

#### Flutter Coverage
```yaml
# test_coverage.yaml
coverage:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
    - '**/*.mocks.dart'
    - '**/generated/**'
    - '**/test/**'
    - '**/integration_test/**'
  
  minimum_coverage: 80
  
  branches: 80
  functions: 80
  lines: 80
  statements: 80
```

### 2. Code Quality Tools

#### ESLint Configuration
```json
// .eslintrc.json
{
  "extends": [
    "@typescript-eslint/recommended",
    "prettier",
    "prettier/@typescript-eslint"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2020,
    "sourceType": "module"
  },
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-non-null-assertion": "warn",
    "prefer-const": "error",
    "no-var": "error",
    "no-console": "warn",
    "eqeqeq": "error",
    "curly": "error"
  }
}
```

#### Prettier Configuration
```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
```

## 📞 Contact Information

### Code Quality Team
- **Email**: code-quality@rechain.network
- **Phone**: +1-555-CODE-QUALITY
- **Slack**: #code-quality channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Development Team
- **Email**: development@rechain.network
- **Phone**: +1-555-DEVELOPMENT
- **Slack**: #development channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Testing Team
- **Email**: testing@rechain.network
- **Phone**: +1-555-TESTING
- **Slack**: #testing channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Maintaining the highest code quality standards! 📋**

*This code quality standards guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Code Quality Standards Guide Version**: 1.0.0
