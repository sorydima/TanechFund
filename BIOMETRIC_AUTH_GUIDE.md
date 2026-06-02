# 🔐 Biometric Authentication Guide

## Обзор

REChain®️ VC Lab поддерживает биометрическую аутентификацию через:
- **Face ID** (iOS)
- **Touch ID** (iOS)
- **Fingerprint** (Android)
- **Iris Scanner** (Android)
- **Device PIN/Pattern** (fallback)

---

## 📦 Компоненты

### 1. BiometricAuthService

**Файл:** `lib/core/security/biometric_auth.dart`

```dart
final biometricAuth = BiometricAuthService();

// Проверка доступности
final isAvailable = await biometricAuth.isAvailable;

// Типы биометрии
final types = await biometricAuth.availableTypes;
// [BiometricType.face, BiometricType.fingerprint]

// Аутентификация
final result = await biometricAuth.authenticate(
  localizedReason: 'Войдите в приложение',
);

if (result.isSuccess) {
  print('Аутентификация успешна');
}
```

### 2. AuthProviderV2

**Файл:** `lib/providers/auth_provider_v2.dart`

```dart
final authProvider = context.watch<AuthProviderV2>();

// Проверка доступности биометрии
if (authProvider.isBiometricEnabled) {
  // Показать кнопку биометрии
}

// Вход через биометрию
final result = await authProvider.signInWithBiometric();

// Включение биометрии
await authProvider.enableBiometric();

// Выключение биометрии
await authProvider.disableBiometric();
```

### 3. SecuritySettingsScreen

**Файл:** `lib/screens/security_settings_screen.dart`

Экран настроек безопасности:
- Проверка доступности биометрии
- Включение/выключение биометрии
- Отображение доступных типов биометрии
- Советы по безопасности

**Навигация:**
```dart
Navigator.pushNamed(context, '/security-settings');
```

---

## 🎨 UI Компоненты

### LoginScreen — Biometric Button

```dart
if (_isBiometricAvailable)
  SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton.icon(
      onPressed: _signInWithBiometric,
      icon: const Icon(Icons.fingerprint),
      label: const Text('Войти по отпечатку'),
    ),
  )
```

---

## 🔧 Настройка платформ

### iOS (Info.plist)

```xml
<key>NSFaceIDUsageDescription</key>
<string>REChain VC Lab использует Face ID для безопасного входа в приложение</string>
```

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

---

## 📊 User Flow

### Первый вход с биометрией

```
1. Пользователь входит через email/password
2. Переходит в Настройки → Безопасность
3. Включает биометрию
4. Подтверждает биометрией
5. В следующий раз может войти через биометрию
```

### Быстрый вход

```
1. Пользователь открывает приложение
2. Нажимает "Войти по отпечатку"
3. Подтверждает биометрией
4. Автоматический вход
```

---

## 🔒 Безопасность

### Хранение данных

| Данные | Хранение |
|--------|----------|
| Токены | FlutterSecureStorage (AES_GCM) |
| Biometric flag | SharedPreferences |
| Пользователь | SecureStorage (encrypted) |

### Защита от атак

1. **Rate Limiting** — 5 попыток аутентификации
2. **Circuit Breaker** — блокировка на 1 минуту после 5 неудачных попыток
3. **Fallback** — PIN/пароль при недоступности биометрии
4. **Session Timeout** — автоматический выход через 24 часа

---

## 🧪 Тестирование

### Эмуляция биометрии (iOS Simulator)

```
Simulator → Features → Face ID/Touch ID → Enrolled
Simulator → Features → Face ID/Touch ID → Matching/Failing
```

### Эмуляция биометрии (Android Emulator)

```
Settings → Security → Fingerprint → Add fingerprint
Extended controls → Fingerprint → Touch/Fail
```

### Unit тесты

```dart
test('biometric auth successful', () async {
  when(() => biometricAuth.authenticate())
      .thenAnswer((_) async => const Success(true));

  final result = await authProvider.signInWithBiometric();
  expect(result.isSuccess, true);
});

test('biometric unavailable', () async {
  when(() => biometricAuth.isAvailable)
      .thenAnswer((_) async => false);

  final result = await authProvider.signInWithBiometric();
  expect(result.isFailure, true);
  expect(result.error?.code, 'biometric_unavailable');
});
```

---

## 🎯 Best Practices

### 1. Проверяйте доступность

```dart
final isAvailable = await biometricAuth.isAvailable;
if (!isAvailable) {
  // Скрыть кнопку биометрии
}
```

### 2. Показывайте понятные сообщения

```dart
localizedReason: 'Войдите в REChain VC Lab для доступа к портфолио'
```

### 3. Обрабатывайте ошибки

```dart
final result = await biometricAuth.authenticate();
if (result.isFailure) {
  final error = result.error;
  switch (error?.code) {
    case 'biometric_cancelled':
      // Пользователь отменил
      break;
    case 'biometric_unavailable':
      // Биометрия недоступна
      break;
    case 'biometric_error':
      // Ошибка системы
      break;
  }
}
```

### 4. Предлагайте fallback

```dart
if (!_isBiometricAvailable) {
  // Показать email/password форму
}
```

---

## 🚀 Интеграция

### 1. Добавить в main_v2.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices(); // Включая DI
  runApp(const REChainAppV2());
}
```

### 2. Запустить приложение

```bash
flutter run -t lib/main_v2.dart
```

### 3. Протестировать на устройстве

Биометрия **не работает** в эмуляторе без дополнительной настройки.

---

## 📈 Метрики

| Компонент | Строк кода | Файлов |
|-----------|------------|--------|
| **BiometricAuthService** | 180 | 1 |
| **SecuritySettingsScreen** | 280 | 1 |
| **AuthProviderV2 update** | 60 | 1 |
| **LoginScreen update** | 40 | 1 |
| **DI update** | 10 | 1 |
| **Итого** | **570** | **5** |

---

## 🔮 Расширения

### Planned Features

1. **Multi-factor authentication** — биометрия + SMS
2. **Biometric for transactions** — подтверждение платежей
3. **Face recognition** — распознавание лица для входа
4. **Voice authentication** — голосовая аутентификация

---

## 📚 Ресурсы

- [local_auth package](https://pub.dev/packages/local_auth)
- [Flutter Security](https://flutter.dev/docs/development/security)
- [iOS Face ID](https://developer.apple.com/documentation/localauthentication/authenticating_a_user_with_face_id)
- [Android Biometrics](https://developer.android.com/training/sign-in/biometric-auth)

---

**REChain®️ VC Lab — Biometric Authentication**

*Secure. Fast. User-Friendly.*
