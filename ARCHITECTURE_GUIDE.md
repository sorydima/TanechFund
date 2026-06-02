# 🏗️ REChain®️ VC Lab — Architecture Guide v2

## 📋 Обзор архитектуры

Приложение следует **Clean Architecture** с элементами **Domain-Driven Design**.

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │   Screens   │  │   Widgets    │  │  Providers   │   │
│  └─────────────┘  └──────────────┘  └──────────────┘   │
│                          ↓                              │
│              ┌─────────────────────┐                    │
│              │   Use Cases (UC)    │                    │
│              └─────────────────────┘                    │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                         │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │  Entities   │  │ Repositories │  │   Value Objs │   │
│  └─────────────┘  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                     DATA LAYER                          │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │ API Sources │  │Local Sources │  │  Repos Impl  │   │
│  └─────────────┘  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 🗂️ Структура проекта

```
lib/
├── core/                    # Ядро приложения
│   ├── base/               # Базовые классы
│   │   ├── base_provider.dart
│   │   └── api_result.dart
│   ├── config/             # Конфигурация
│   │   └── api_config.dart # API окружения
│   ├── network/            # Сетевой слой
│   │   ├── dio_client.dart
│   │   ├── network_manager.dart
│   │   └── retry_interceptor.dart
│   ├── storage/            # Хранение данных
│   │   ├── cache_manager.dart
│   │   └── secure_storage.dart
│   ├── app_error.dart      # Типы ошибок
│   ├── error_handler.dart  # Глобальный обработчик
│   ├── logger.dart         # Логирование
│   └── result.dart         # Result pattern
│
├── domain/                  # Бизнес-логика (чистая)
│   ├── repositories/       # Абстракции репозиториев
│   └── usecases/           # Бизнес-правила
│
├── data/                    # Реализация данных
│   ├── models/dto/         # DTO модели
│   │   ├── auth_dto.dart
│   │   └── api_response_dto.dart
│   ├── services/api/       # API сервисы
│   │   ├── api_client.dart
│   │   ├── auth_api_service.dart
│   │   └── user_api_service.dart
│   └── repositories/       # Реализации репозиториев
│
├── di/                      # Dependency Injection
│   ├── injection.dart
│   └── register_module.dart
│
├── models/                  # Модели данных
│   ├── user_model.dart
│   └── project_model.dart
│
├── providers/               # State Management (Provider)
│   ├── auth_provider_v2.dart
│   ├── app_provider.dart
│   └── ...
│
├── screens/                 # UI экраны
│   └── ...
│
├── services/                # Сервисы
│   ├── api_client.dart
│   └── storage_service.dart
│
└── utils/                   # Утилиты
    └── theme.dart
```

---

## 🔧 Dependency Injection

### GetIt + Injectable

```dart
// lib/di/injection.dart
final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

### Регистрация зависимостей

```dart
// lib/di/register_module.dart
@module
abstract class RegisterModule {
  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  ISecureStorage secureStorage(FlutterSecureStorage storage) =>
      SecureStorage(storage: storage);

  @singleton
  CacheManager get cacheManager => CacheManager();
}
```

### Использование в Provider

```dart
@singleton
class AuthProviderV2 extends BaseProvider {
  final IAuthRepository _authRepository;

  AuthProviderV2(this._authRepository);
}
```

---

## 🛡️ Security

### Secure Storage для токенов

```dart
final ISecureStorage _secureStorage;

// Сохранение токена
await _secureStorage.write('auth_token', token);

// Чтение токена
final tokenResult = await _secureStorage.read('auth_token');
```

### Обычное Storage для нефункциональных данных

```dart
final StorageService _storage;
await _storage.set<String>('user_data', jsonEncode(user.toJson()));
```

---

## 🌐 Network Layer

### API Configuration

```dart
// lib/core/config/api_config.dart
ApiConfig.setEnvironment(ApiEnvironment.staging);

// Доступ к конфигурации
print(ApiConfig.current.baseUrl);  // https://staging-api.rechain.vc/v1
```

### API Services

```dart
// lib/data/services/api/auth_api_service.dart
class AuthApiService {
  final Dio _dio;
  
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return _parseResponse(response, (data) => AuthResponse.fromJson(data));
  }
}
```

### API Client Factory

```dart
// lib/data/services/api/api_client.dart
@singleton
class ApiClient {
  final Dio _dio;
  final ISecureStorage _secureStorage;

  late final AuthApiService authApi;
  late final UserApiService userApi;

  ApiClient(this._dio, this._secureStorage) {
    _setupInterceptors();
    _setupServices();
  }
}
```

### DTO Models

```dart
// lib/data/models/dto/auth_dto.dart
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final bool? rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

### API Response Format

```dart
// lib/data/models/dto/api_response_dto.dart
@JsonSerializable()
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? errorCode;
  final Map<String, dynamic>? errorDetails;
  final String? requestId;
  final DateTime? timestamp;

  Result<R, ApiError> toResult<R>(R Function(T?) fromJson) {
    if (success) {
      return Success(fromJson(data));
    } else {
      return Failure(ApiError(
        message: message ?? 'Unknown error',
        code: errorCode ?? 'unknown',
      ));
    }
  }
}
```

### Dio Client с Retry

```dart
class DioClient {
  late final Dio dio;

  DioClient(this._secureStorage) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.current.baseUrl,
      connectTimeout: ApiConfig.current.connectTimeout,
      receiveTimeout: ApiConfig.current.receiveTimeout,
    ));

    dio.interceptors.add(RetryInterceptor(
      maxRetries: ApiConfig.current.maxRetries,
      baseDelay: const Duration(seconds: 1),
    ));
  }
}
```

### Network Manager

```dart
final networkManager = getIt<NetworkManager>();
await networkManager.initialize();

// Проверка состояния
if (networkManager.isOnline) {
  // Online операции
} else {
  // Offline fallback
}

// Подписка на изменения
networkManager.stateStream.listen((state) {
  print('Network state: ${state.name}');
});
```

---

## 💾 Cache Management

### Cache-Aside Pattern

```dart
final cacheManager = getIt<CacheManager>();

// Получить из кэша или загрузить
final result = await cacheManager.getOrFetch(
  'user_profile',
  () => api.fetchUserProfile(),
  ttl: const Duration(minutes: 5),
);
```

### TTL Support

```dart
await cacheManager.put(
  'cached_data',
  data,
  ttl: const Duration(hours: 1),
);

final cached = cacheManager.get('cached_data');
// null если TTL истёк
```

---

## 📊 State Management

### BaseProvider

```dart
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  Future<T?> execute<T>(
    Future<T> Function() operation, {
    void Function(T result)? onSuccess,
    void Function(String error)? onError,
  }) async {
    setLoading(true);
    clearError();

    try {
      final result = await operation();
      onSuccess?.call(result);
      return result;
    } catch (e, st) {
      setError('Ошибка: $e');
      onError?.call(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }
}
```

### AuthProviderV2

```dart
@singleton
class AuthProviderV2 extends BaseProvider {
  final IAuthRepository _authRepository;

  Future<Result<UserModel, AppError>> signInWithEmail(
    String email,
    String password,
  ) async {
    final result = await _authRepository.signInWithEmail(email, password);

    if (result.isSuccess) {
      _user = result.value!;
      _isAuthenticated = true;
      notifyListeners();
    } else {
      setError(result.error.message);
    }

    return result;
  }
}
```

---

## 🧪 Testing

### Unit Tests

```dart
test('successful sign in updates state', () async {
  const user = UserModel(id: 'user_001', name: 'Test', ...);

  when(mockRepo.signInWithEmail(any, any))
      .thenAnswer((_) async => const Success(user));

  final result = await authProvider.signInWithEmail(
    'test@example.com',
    'password',
  );

  expect(result.isSuccess, true);
  expect(authProvider.isAuthenticated, true);
});
```

### Integration Tests

```dart
test('getOrFetch uses cache on second call', () async {
  var fetchCount = 0;
  Future<String> fetch() async {
    fetchCount++;
    return 'data';
  }

  await cacheManager.getOrFetch('key', fetch);
  await cacheManager.getOrFetch('key', fetch);

  expect(fetchCount, 1); // fetch вызван только 1 раз
});
```

---

## 🔄 Migration Guide

### Обновление провайдеров

**Было:**
```dart
class AuthProvider extends ChangeNotifier {
  Future<Result<UserModel, AppError>> signInWithEmail(...) async {
    // Прямая работа с StorageService
    // Дублирование _setLoading/_clearError
  }
}
```

**Стало:**
```dart
class AuthProviderV2 extends BaseProvider {
  final IAuthRepository _authRepository;

  Future<Result<UserModel, AppError>> signInWithEmail(...) async {
    final result = await _authRepository.signInWithEmail(...);
    // Автоматическое управление состоянием
    return result;
  }
}
```

### Обновление main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices(); // DI, Network, Cache
  runApp(const REChainAppV2());
}
```

---

## 📈 Преимущества архитектуры

| Аспект | До | После |
|--------|-----|-------|
| **DI** | Ручное создание | GetIt + Injectable |
| **Security** | SharedPreferences | SecureStorage для токенов |
| **Network** | HttpClient + retry вручную | Dio + RetryInterceptor |
| **Cache** | Нет | Hive с TTL |
| **State** | Дублирование кода | BaseProvider |
| **Testing** | Сложно тестировать | Mock репозиториев |
| **Offline** | Нет | NetworkManager + Cache |
| **Error Handling** | Ручная обработка | Result pattern |

---

## 🎯 Best Practices

### 1. Используйте Result pattern

```dart
Future<Result<UserModel, AppError>> operation() async {
  try {
    final data = await fetchData();
    return Success(data);
  } catch (e, st) {
    return Failure(NetworkError('Ошибка: $e'));
  }
}
```

### 2. Абстрагируйте репозитории

```dart
abstract class IAuthRepository {
  Future<Result<UserModel, AppError>> signInWithEmail(...);
}

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  // Реализация
}
```

### 3. Используйте BaseProvider

```dart
class MyProvider extends BaseProvider {
  Future<void> loadData() async {
    await execute(
      () => repository.fetchData(),
      onSuccess: (data) => _data = data,
    );
  }
}
```

### 4. Кэшируйте с TTL

```dart
await cacheManager.put('api_response', data, ttl: Duration(minutes: 5));
```

### 5. Проверяйте сеть

```dart
if (networkManager.isOffline) {
  // Использовать кэш
}
```

---

## 🚀 Запуск

```bash
# 1. Установить зависимости
flutter pub get

# 2. Сгенерировать DI код
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Запустить приложение
flutter run -t lib/main_v2.dart
```

---

## 📚 Ресурсы

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetIt](https://pub.dev/packages/get_it)
- [Injectable](https://pub.dev/packages/injectable)
- [Dio](https://pub.dev/packages/dio)
- [Hive](https://pub.dev/packages/hive)

---

**REChain®️ VC Lab — Architecture v2**
