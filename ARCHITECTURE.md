# 🏗️ REChain®️ VC Lab — Архитектура приложения

## 📋 Обзор

REChain VC Lab — это масштабируемое Flutter-приложение для управления хакатонами, портфолио проектов и Web3 аутентификации.

## 🎯 Ключевые архитектурные решения

### 1. State Management — Provider Pattern

**Почему Provider:**
- ✅ Простота интеграции и использования
- ✅ Минимальный boilerplate код
- ✅ Отличная производительность для среднего размера приложений
- ✅ Легко тестировать

**Структура провайдеров:**
```
lib/providers/
├── app_provider.dart          # Глобальные настройки приложения
├── auth_provider.dart         # Аутентификация и авторизация
├── portfolio_provider.dart    # Управление проектами портфолио
├── notification_provider.dart # Уведомления
├── achievements_provider.dart # Достижения пользователей
└── ...                        # Другие провайдеры
```

### 2. Обработка ошибок — Result Pattern

**Реализация:**
```dart
// lib/core/result.dart
abstract class Result<T, E> {
  T? get value;
  E? get error;
  bool get isSuccess;
  bool get isFailure;
  
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  });
}

class Success<T, E> implements Result<T, E> { ... }
class Failure<T, E> implements Result<T, E> { ... }
```

**Преимущества:**
- ✅ Явное указание возможных ошибок в типе
- ✅ Нет неожиданных исключений
- ✅ Принудительная обработка ошибок
- ✅ Типобезопасность

**Пример использования:**
```dart
Future<Result<UserModel, AppError>> signInWithEmail(
  String email, 
  String password
) async {
  if (email == 'demo@rechain.com' && password == 'password') {
    return Success(user);
  } else {
    return Failure(AuthError('Invalid credentials'));
  }
}

// В UI:
final result = await authProvider.signInWithEmail(email, password);
if (result.isSuccess) {
  Navigator.pushNamed(context, '/main');
} else {
  showError(result.error?.message ?? 'Error');
}
```

### 3. Иерархия ошибок

```
lib/core/app_error.dart

AppError (базовый класс)
├── AuthError          # Ошибки аутентификации
├── NetworkError       # Сетевые ошибки
├── StorageError       # Ошибки хранения данных
├── ValidationError    # Ошибки валидации
├── PermissionError    # Ошибки разрешений
└── UnknownError       # Неизвестные ошибки
```

**Структура ошибки:**
```dart
class AppError {
  final String message;      // Сообщение для пользователя
  final String? code;        // Код ошибки для логирования
  final StackTrace? stackTrace;
  
  const AppError(this.message, {this.code, this.stackTrace});
}
```

### 4. Слой данных — Service Layer

**StorageService:**
- Абстракция над `SharedPreferences`
- Централизованная обработка ошибок
- Типобезопасный API
- Логирование всех операций

```dart
class StorageService {
  Result<T, AppError> get<T>(String key, T defaultValue);
  Future<Result<void, AppError>> set<T>(String key, T value);
  Future<Result<void, AppError>> remove(String key);
  Future<Result<void, AppError>> clear();
}
```

**ApiClient:**
- HTTP клиент с таймаутами
- Проверка соединения
- Автоматическая подстановка токена
- Обработка HTTP статусов

```dart
class ApiClient {
  Future<Result<T, AppError>> get<T>(String path, {...});
  Future<Result<T, AppError>> post<T>(String path, {...});
  Future<Result<T, AppError>> put<T>(String path, {...});
  Future<Result<T, AppError>> delete<T>(String path, {...});
}
```

### 5. Логирование — AppLogger

**Уровни логирования:**
- `debug` — Отладочная информация
- `info` — Важные события
- `warning` — Предупреждения
- `error` — Ошибки с стектрейсом

```dart
AppLogger.debug('Loading data...');
AppLogger.info('User logged in');
AppLogger.warning('Cache miss');
AppLogger.error('Failed to load', exception, stackTrace);
```

### 6. Модели данных

**Принципы:**
- ✅ Иммутабельность (все поля `final`)
- ✅ Метод `copyWith` для обновлений
- ✅ Сериализация `toJson`/`fromJson`
- ✅ Пустые состояния (`UserModel.empty`)

**Пример:**
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> permissions;
  
  const UserModel({...});
  
  static const empty = UserModel(
    id: '', name: '', email: '', role: '', permissions: []
  );
  
  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;
  
  UserModel copyWith({...});
  Map<String, dynamic> toJson();
  factory UserModel.fromJson(Map<String, dynamic> json);
}
```

## 📁 Структура проекта

```
lib/
├── core/                    # Ядро приложения
│   ├── result.dart         # Result pattern
│   ├── app_error.dart      # Классы ошибок
│   ├── logger.dart         # Логгер
│   └── error_handler.dart  # Глобальный обработчик ошибок
├── models/                  # Модели данных
│   ├── user_model.dart
│   ├── project_model.dart
│   └── ...
├── providers/               # State management
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   └── ...
├── services/                # Бизнес-логика
│   ├── storage_service.dart
│   └── api_client.dart
├── screens/                 # UI экраны
│   ├── home_screen.dart
│   ├── login_screen.dart
│   └── ...
├── widgets/                 # Переиспользуемые виджеты
│   └── ...
└── utils/                   # Утилиты
    └── theme.dart
```

## 🔄 Поток данных

### Аутентификация
```
LoginScreen
    ↓
AuthProvider.signInWithEmail()
    ↓
StorageService (сохранение состояния)
    ↓
Result<UserModel, AuthError>
    ↓
UI обновление (Consumer<AuthProvider>)
```

### Загрузка проектов
```
PortfolioScreen
    ↓
PortfolioProvider.loadProjects()
    ↓
StorageService.get()
    ↓
List<ProjectModel>
    ↓
UI рендеринг
```

## 🧪 Тестирование

### Unit тесты
```dart
test('Success holds value', () {
  const result = Success<int, AppError>(42);
  expect(result.isSuccess, true);
  expect(result.value, 42);
});
```

### Integration тесты
```dart
test('should succeed with valid credentials', () async {
  final result = await authProvider.signInWithEmail(
    'demo@rechain.com',
    'password',
  );
  
  expect(result.isSuccess, true);
  expect(authProvider.isAuthenticated, true);
});
```

## 🔐 Безопасность

### Хранение данных
- Чувствительные данные (токены) шифруются
- Используем `flutter_secure_storage` для токенов
- `SharedPreferences` только для нечувствительных данных

### Аутентификация
- Поддержка Email/Password
- OAuth (Google, GitHub)
- Web3 (подключение кошелька)
- Refresh token механизм (в разработке)

## 📈 Производительность

### Оптимизации
- ✅ `IndexedStack` для сохранения состояния экранов
- ✅ Ленивая загрузка изображений
- ✅ Кэширование данных в памяти
- ✅ Debounce для поисковых запросов

### Метрики
- Время запуска: < 2 секунд
- FPS: стабильные 60
- Размер APK: ~15-20 MB

## 🔧 Расширенные компоненты (v1.0.2+)

### Circuit Breaker

Защита от каскадных сбоев API:

```dart
// lib/core/stability/circuit_breaker.dart
final circuitBreaker = CircuitBreaker(
  maxFailures: 5,
  resetTimeout: Duration(minutes: 1),
);

final result = await circuitBreaker.execute(() => apiCall());
```

**Состояния:**
- `closed` — нормальная работа
- `open` — сбой, запросы блокируются  
- `halfOpen` — тестирование восстановления

### Offline-First Manager

Менеджер offline-first стратегии с синхронизацией:

```dart
// lib/core/stability/offline_first_manager.dart
final offlineManager = OfflineFirstManager(networkManager, storage);
await offlineManager.initialize();

// Добавление операции в очередь
await offlineManager.queueOperation(
  operationId: 'create_project',
  endpoint: '/projects',
  method: 'POST',
  body: projectData,
);

// Автоматическая синхронизация при восстановлении сети
await offlineManager.sync();
```

### Cache Service

Кэширование с TTL поддержкой на базе Hive:

```dart
// lib/core/storage/cache_service.dart
final cache = CacheService();
await cache.initialize();

// Запись в кэш
await cache.set('user_profile', userData, 
  ttl: Duration(minutes: 30),
  tags: 'user',
);

// Чтение из кэша
final result = await cache.get<Map<String, dynamic>>('user_profile');

// Очистка по тегу
await cache.clearByTag('user');

// Статистика
final stats = cache.getStats();
print('Cache size: ${stats.sizeFormatted}');
```

### Rate Limiter

Защита от чрезмерных запросов:

```dart
// lib/core/stability/rate_limiter.dart
final limiter = RateLimiter(
  config: const RateLimitConfig(
    maxRequests: 100,
    windowDuration: Duration(minutes: 1),
    strategy: RateLimitStrategy.slidingWindow,
  ),
);

// Выполнение с rate limiting
final result = await limiter.execute(() => apiCall());

// Выполнение с ожиданием
final result = await limiter.executeWithWait(
  () => apiCall(),
  maxWait: Duration(seconds: 30),
);
```

### Health Check Service

Мониторинг здоровья приложения:

```dart
// lib/core/stability/health_check_service.dart
final healthCheck = HealthCheckService(
  networkManager,
  storageService,
  cacheService,
);

await healthCheck.initialize(checkInterval: Duration(minutes: 2));

// Получение статуса
final status = await healthCheck.checkHealth();
print('Overall: ${status.overallStatus}');
print('Healthy: ${status.healthyComponents}/${status.totalComponents}');

// Подписка на изменения
healthCheck.statusStream.listen((status) {
  print('Health status changed: ${status.overallStatus}');
});

// Кастомные чекеры
healthCheck.registerChecker('API', () async {
  final result = await apiClient.healthCheck();
  return HealthCheckResult(
    componentName: 'API',
    status: result.isSuccess ? ComponentStatus.healthy : ComponentStatus.unhealthy,
    responseTime: stopwatch.elapsed,
    timestamp: DateTime.now(),
  );
});
```

### Base API Repository

Базовый класс для API репозиториев с автоматической обработкой:

```dart
// lib/core/stability/base_api_repository.dart
class AuthApiRepository extends BaseApiRepository implements IAuthRepository {
  AuthApiRepository(Dio dio, NetworkManager networkManager)
    : super(dio, networkManager, basePath: '/api/v1/auth');

  @override
  Future<Result<UserModel, AppError>> signInWithEmail(
    String email, 
    String password
  ) async {
    return await post<Map<String, dynamic>>('/signin', data: {
      'email': email,
      'password': password,
    });
  }
}
```

**Автоматическая обработка:**
- ✅ Retry с exponential backoff (3 попытки)
- ✅ Circuit breaker защита
- ✅ Маппинг HTTP ошибок в AppError
- ✅ Проверка сети перед запросом
- ✅ Логирование всех операций

### Debounce & Throttle

Оптимизация производительности UI:

```dart
// lib/core/performance/debounce_throttle.dart

// Debounce для поиска
final debouncer = Debouncer(delay: Duration(milliseconds: 300));
searchController.addListener(() {
  debouncer.run(() => search(query));
});

// Throttle для скролла
final throttler = Throttler(delay: Duration(milliseconds: 200));
scrollController.addListener(() {
  throttler.run(() => loadMoreItems());
});

// Batch processor для аналитики
final batchProcessor = BatchProcessor<AnalyticsEvent>(
  maxBatchSize: 10,
  flushInterval: Duration(seconds: 5),
  processor: (events) => sendToServer(events),
);
batchProcessor.add(event);
```

### Result Extensions

Расширения для удобной работы с Result:

```dart
// lib/core/utils/result_extensions.dart

// Цепочка обработки
result
  .tap((user) => print('Welcome, ${user.name}'))
  .handleNetworkError((e) => showSnackBar('Нет подключения'))
  .handleAuthError((e) => navigateToLogin())
  .handleValidationError((e) => showFormErrors(e));

// Получение значения с дефолтом
final user = result.getOrElse((_) => UserModel.empty);

// Комбинирование результатов
final combined = result1.zip(result2);

// Преобразование списка
final results = [result1, result2, result3];
final allSuccess = results.sequence(); // Result<List<T>, E>
```

## 📁 Обновлённая структура проекта

```
lib/
├── core/
│   ├── base/               # Базовые классы (BaseProvider)
│   ├── config/             # Конфигурация приложения
│   ├── network/            # DioClient, NetworkManager
│   ├── performance/        # PerformanceMonitor, MemoryOptimizer
│   │   └── debounce_throttle.dart
│   ├── security/           # BiometricAuth, SecureStorage
│   ├── stability/          # CircuitBreaker, RateLimiter
│   │   ├── circuit_breaker.dart
│   │   ├── offline_first_manager.dart
│   │   ├── rate_limiter.dart
│   │   ├── health_check_service.dart
│   │   └── base_api_repository.dart
│   ├── storage/            # CacheService, SecureStorage
│   ├── utils/              # ResultExtensions
│   ├── app_error.dart      # Классы ошибок
│   ├── error_handler.dart  # Глобальный обработчик
│   ├── logger.dart         # Логгер
│   └── result.dart         # Result pattern
├── data/
│   ├── repositories/       # Реализации репозиториев
│   └── services/           # API сервисы
├── domain/
│   └── repositories/       # Абстракции репозиториев
├── di/
│   ├── injection.dart      # DI настройка
│   └── register_module.dart # DI регистрация
├── models/                 # Модели данных
├── providers/              # State management
├── screens/                # UI экраны
├── services/               # Бизнес-логика
├── widgets/                # Переиспользуемые виджеты
└── main.dart               # Точка входа
```

## 🚀 Roadmap

### Реализовано (v1.0.2+)
- ✅ Circuit Breaker для защиты API
- ✅ Offline-First стратегия с синхронизацией
- ✅ Cache Service с TTL поддержкой
- ✅ Rate Limiter для защиты от чрезмерных запросов
- ✅ Health Check Service для мониторинга
- ✅ Base API Repository с retry логикой
- ✅ Debounce/Throttle утилиты
- ✅ Result Extensions для удобной обработки
- ✅ Биометрическая аутентификация
- ✅ Secure Storage для токенов

### В разработке
- [ ] Push notifications (FCM)
- [ ] GraphQL API интеграция
- [ ] Real-time обновления (WebSocket)
- [ ] Локализация (RU/EN)
- [ ] Deep links
- [ ] Background sync

### Планируется
- [ ] Unit тесты покрытие >80%
- [ ] Integration тесты
- [ ] E2E тесты (Patrol)
- [ ] CI/CD пайплайн
- [ ] Performance мониторинг
- [ ] Crashlytics интеграция

## 📚 Дополнительные ресурсы

- [Provider Documentation](https://pub.dev/packages/provider)
- [Result Pattern](https://www.google.com/search?q=Result+pattern+Dart)
- [Circuit Breaker Pattern](https://microservices.io/patterns/reliability/circuit-breaker.html)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Hive Database](https://pub.dev/packages/hive)
