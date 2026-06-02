# API Integration Guide

## Обзор

Реализована полноценная интеграция REST API с Clean Architecture, автоматическим обновлением токенов, retry логикой и offline-first подходом.

## Архитектура API Layer

```
lib/
├── core/config/api_config.dart          # Конфигурация окружений
├── data/
│   ├── models/dto/
│   │   ├── auth_dto.dart                # DTO для auth endpoints
│   │   └── api_response_dto.dart        # Унифицированный формат ответа
│   └── services/api/
│       ├── api_client.dart              # Фабрика API клиентов
│       ├── auth_api_service.dart        # Auth endpoints
│       └── user_api_service.dart        # User endpoints
└── di/
    ├── injection.dart                   # Точка входа DI
    ├── register_module.dart             # Регистрация зависимостей
    └── injection.config.dart            # Сгенерированный DI
```

## Конфигурация Окружений

```dart
// Переключение окружения
ApiConfig.setEnvironment(ApiEnvironment.staging);

// Доступ к текущей конфигурации
print(ApiConfig.current.baseUrl);  // https://staging-api.rechain.vc/v1
```

| Окружение | Base URL | Таймаут | Retry |
|-----------|----------|---------|-------|
| dev | http://localhost:8080/v1 | 15s | 3 |
| staging | https://staging-api.rechain.vc/v1 | 30s | 5 |
| production | https://api.rechain.vc/v1 | 60s | 5 |

## API Client

```dart
// Получение API клиента через DI
final apiClient = getIt<ApiClient>();

// Auth API
final response = await apiClient.authApi.login(
  LoginRequest(email: 'user@example.com', password: 'password'),
);

// User API
final profile = await apiClient.userApi.getProfile();
```

## DTO Models

### Auth DTOs

```dart
// Login
final loginRequest = LoginRequest(
  email: 'user@example.com',
  password: 'password',
  rememberMe: true,
);

// Register
final registerRequest = RegisterRequest(
  email: 'user@example.com',
  password: 'password',
  name: 'John Doe',
  phone: '+1234567890',
);

// Auth Response
final authResponse = AuthResponse(
  user: UserResponse(...),
  tokens: AuthTokens(
    accessToken: '...',
    refreshToken: '...',
    expiresIn: 3600,
    tokenType: 'Bearer',
  ),
);
```

### API Response Format

```json
{
  "success": true,
  "message": "Operation completed",
  "data": { ... },
  "error_code": null,
  "error_details": null,
  "request_id": "req_123",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## Interceptors

### 1. Auth Interceptor
- Автоматически добавляет Bearer токен
- Обновляет токен при 401
- Очищает данные при неудаче refresh

### 2. Retry Interceptor
- Exponential backoff (1s, 2s, 4s)
- Circuit breaker pattern
- Настраиваемое количество попыток

### 3. Logging Interceptor
- Pretty Dio Logger для debug
- Логирование request/response body
- Только в dev/staging окружениях

## Обработка Ошибок

```dart
final response = await apiClient.authApi.login(request);

if (response.success) {
  final user = response.data!.user;
  final tokens = response.data!.tokens;
} else {
  final error = ApiError(
    message: response.message!,
    code: response.errorCode!,
    details: response.errorDetails,
    requestId: response.requestId,
  );
}
```

## Result Pattern

```dart
// Конвертация ApiResponse в Result
final result = response.toResult((data) => User.fromDto(data));

switch (result) {
  case Success(value: final user):
    print('User: $user');
  case Failure(error: final error):
    print('Error: ${error.message}');
}
```

## Endpoints

### Authentication
- `POST /auth/login` — Вход
- `POST /auth/register` — Регистрация
- `POST /auth/refresh` — Обновление токена
- `POST /auth/logout` — Выход
- `POST /auth/reset-password` — Сброс пароля
- `GET /auth/verify-email` — Подтверждение email

### User
- `GET /user/profile` — Профиль
- `PUT /user/profile` — Обновление профиля
- `POST /user/avatar` — Загрузка аватара
- `POST /user/change-password` — Изменение пароля
- `GET /user/settings` — Настройки
- `PUT /user/settings` — Обновление настроек

## Использование в Provider

```dart
class AuthProviderV2 extends BaseProvider {
  final ApiClient _apiClient;

  Future<void> signIn(String email, String password) async {
    await handleAsync(() async {
      final response = await _apiClient.authApi.login(
        LoginRequest(email: email, password: password),
      );

      if (!response.success) {
        throw ApiException(response.message ?? 'Login failed');
      }

      // Сохраняем токены
      await _secureStorage.write('auth_token', response.data!.tokens.accessToken);
      await _secureStorage.write('refresh_token', response.data!.tokens.refreshToken);

      _user = response.data!.user;
      notifyListeners();
    });
  }
}
```

## Тестирование

```dart
// Мок API сервиса
class MockAuthApiService extends Mock implements AuthApiService {}

// Тест
final mockAuthApi = MockAuthApiService();
when(mockAuthApi.login(any)).thenAnswer(
  (_) async => ApiResponse(success: true, data: mockAuthResponse),
);
```

## Безопасность

1. **Токены** — хранятся в FlutterSecureStorage
2. **HTTPS** — обязателен для production
3. **Certificate Pinning** — рекомендуется для production
4. **Request Signing** — можно добавить HMAC подпись
5. **Rate Limiting** — обрабатывается на клиенте

## Добавление Нового Endpoint

1. Создать DTO в `lib/data/models/dto/`
2. Добавить метод в `ApiService`
3. Зарегистрировать в `ApiClient` (если нужен новый сервис)
4. Использовать через DI

Пример:
```dart
// В новом сервисе
class InvestmentApiService {
  final Dio _dio;
  InvestmentApiService(this._dio);

  Future<ApiResponse<List<Investment>>> getInvestments() async {
    final response = await _dio.get('/investments');
    return _parseResponse(
      response,
      (data) => (data as List).map((e) => Investment.fromJson(e)).toList(),
    );
  }
}
```

## Рекомендации

1. Всегда используйте `ApiResponse` для типизации ответов
2. Обрабатывайте ошибки через `toResult()`
3. Используйте `handleAsync()` в Provider для统一ной обработки
4. Логируйте запросы только в dev/staging
5. Не храните sensitive data в обычном SharedPreferences
