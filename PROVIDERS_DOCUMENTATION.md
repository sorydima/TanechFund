# 🔧 REChain®️ VC Lab - Документация Провайдеров

## 🎯 Обзор

Документация всех провайдеров состояния в приложении REChain®️ VC Lab. Каждый провайдер отвечает за управление состоянием определенного функционального модуля.

## 📋 Список провайдеров

### 1. **AppProvider** - Основные настройки приложения
### 2. **AuthProvider** - Аутентификация и авторизация
### 3. **BlockchainProvider** - Блокчейн операции
### 4. **NotificationProvider** - Система уведомлений
### 5. **ChatProvider** - Чат система
### 6. **PaymentProvider** - Платежи и транзакции
### 7. **LearningProvider** - Обучение и курсы
### 8. **PortfolioProvider** - Портфолио проектов
### 9. **CompilerProvider** - Компилятор кода
### 10. **InvestmentProvider** - Инвестиции и раунды
### 11. **MentorshipProvider** - Менторство
### 12. **AnalyticsProvider** - Аналитика
### 13. **SocialNetworkProvider** - Социальная сеть
### 14. **MetaverseProvider** - Метавселенная
### 15. **AIMLProvider** - AI/ML функции
### 16. **BlockchainDeFiProvider** - DeFi операции
### 17. **NFTMarketplaceProvider** - NFT маркетплейс
### 18. **CrossChainBridgeProvider** - Cross-chain мосты
### 19. **DeFiAnalyticsProvider** - DeFi аналитика
### 20. **HardwareWalletProvider** - Аппаратные кошельки
### 21. **DEXTradingProvider** - DEX торговля
### 22. **YieldFarmingProvider** - Yield farming
### 23. **GovernanceDAOProvider** - Governance & DAO
### 24. **Web3IdentityProvider** - Web3 Identity
### 25. **Web3GamingProvider** - Web3 Gaming
### 26. **Web3EducationProvider** - Web3 Education
### 27. **Web3HealthcareProvider** - Web3 Healthcare
### 28. **IntroProvider** - Система интро

## 🔧 Детальная документация

### 1. **AppProvider** (`lib/providers/app_provider.dart`)

#### Назначение
Управление основными настройками приложения: тема, язык, валюта, первый запуск.

#### Основные модели
```dart
class AppSettings {
  final bool isDarkMode;
  final String language;
  final String currency;
  final bool notificationsEnabled;
  final bool biometricEnabled;
}
```

#### Ключевые методы
- `toggleTheme()` - переключение темы
- `setLanguage(String language)` - установка языка
- `setCurrency(String currency)` - установка валюты
- `setFirstLaunch(bool value)` - установка флага первого запуска

#### Состояние
- `_isDarkMode` - темная/светлая тема
- `_language` - текущий язык
- `_currency` - текущая валюта
- `_isFirstLaunch` - первый запуск приложения

---

### 2. **AuthProvider** (`lib/providers/auth_provider.dart`)

#### Назначение
Управление аутентификацией пользователей: вход, регистрация, управление сессиями.

#### Основные модели
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;
  final DateTime lastLogin;
}

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? token;
  final String? refreshToken;
}
```

#### Ключевые методы
- `login(String email, String password)` - вход пользователя
- `register(String email, String password, String name)` - регистрация
- `logout()` - выход пользователя
- `refreshToken()` - обновление токена
- `forgotPassword(String email)` - восстановление пароля

#### Состояние
- `_isAuthenticated` - статус аутентификации
- `_user` - данные пользователя
- `_token` - JWT токен
- `_refreshToken` - токен обновления

---

### 3. **BlockchainProvider** (`lib/providers/blockchain_provider.dart`)

#### Назначение
Базовые блокчейн операции: подключение к сетям, базовые транзакции.

#### Основные модели
```dart
class BlockchainNetwork {
  final String id;
  final String name;
  final String rpcUrl;
  final int chainId;
  final String currency;
  final String explorerUrl;
}

class BlockchainTransaction {
  final String hash;
  final String from;
  final String to;
  final String value;
  final String gasPrice;
  final String gasLimit;
  final String status;
}
```

#### Ключевые методы
- `connectToNetwork(BlockchainNetwork network)` - подключение к сети
- `getBalance(String address)` - получение баланса
- `sendTransaction(TransactionParams params)` - отправка транзакции
- `getTransactionStatus(String hash)` - статус транзакции

---

### 4. **NotificationProvider** (`lib/providers/notification_provider.dart`)

#### Назначение
Управление системой уведомлений: push-уведомления, in-app уведомления.

#### Основные модели
```dart
class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic> data;
}
```

#### Ключевые методы
- `sendNotification(Notification notification)` - отправка уведомления
- `markAsRead(String id)` - отметка как прочитанное
- `deleteNotification(String id)` - удаление уведомления
- `getUnreadCount()` - количество непрочитанных

---

### 5. **ChatProvider** (`lib/providers/chat_provider.dart`)

#### Назначение
Управление чат-системой: сообщения, чаты, уведомления.

#### Основные модели
```dart
class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
}

class Chat {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastActivity;
  final ChatType type;
}
```

#### Ключевые методы
- `sendMessage(String chatId, String content)` - отправка сообщения
- `createChat(List<String> participants)` - создание чата
- `markAsRead(String chatId)` - отметка как прочитанное
- `getChatHistory(String chatId)` - история чата

---

### 6. **PaymentProvider** (`lib/providers/payment_provider.dart`)

#### Назначение
Управление платежами: создание, обработка, история транзакций.

#### Основные модели
```dart
class Payment {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final String description;
}

class PaymentMethod {
  final String id;
  final String type;
  final String name;
  final String last4;
  final bool isDefault;
}
```

#### Ключевые методы
- `createPayment(PaymentRequest request)` - создание платежа
- `processPayment(String paymentId)` - обработка платежа
- `getPaymentHistory()` - история платежей
- `addPaymentMethod(PaymentMethod method)` - добавление метода

---

### 7. **LearningProvider** (`lib/providers/learning_provider.dart`)

#### Назначение
Управление системой обучения: курсы, уроки, прогресс.

#### Основные модели
```dart
class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final List<String> lessons;
  final CourseLevel level;
  final int duration;
  final double price;
}

class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int order;
  final int duration;
  final List<String> resources;
}
```

#### Ключевые методы
- `enrollInCourse(String courseId)` - запись на курс
- `completeLesson(String lessonId)` - завершение урока
- `getProgress(String courseId)` - прогресс по курсу
- `getRecommendedCourses()` - рекомендуемые курсы

---

### 8. **PortfolioProvider** (`lib/providers/portfolio_provider.dart`)

#### Назначение
Управление портфолио проектов: создание, редактирование, аналитика.

#### Основные модели
```dart
class Project {
  final String id;
  final String name;
  final String description;
  final String category;
  final ProjectStatus status;
  final DateTime createdAt;
  final List<String> tags;
  final Map<String, dynamic> metadata;
}

class ProjectMetrics {
  final String projectId;
  final double valuation;
  final double roi;
  final int investors;
  final double fundingRaised;
}
```

#### Ключевые методы
- `createProject(Project project)` - создание проекта
- `updateProject(String id, Project updates)` - обновление проекта
- `getProjectMetrics(String id)` - метрики проекта
- `searchProjects(String query)` - поиск проектов

---

### 9. **CompilerProvider** (`lib/providers/compiler_provider.dart`)

#### Назначение
Компиляция и выполнение кода: поддержка различных языков программирования.

#### Основные модели
```dart
class CodeExecution {
  final String id;
  final String code;
  final String language;
  final String output;
  final ExecutionStatus status;
  final DateTime executedAt;
  final int executionTime;
}

class SupportedLanguage {
  final String name;
  final String extension;
  final String version;
  final bool isEnabled;
}
```

#### Ключевые методы
- `executeCode(String code, String language)` - выполнение кода
- `getSupportedLanguages()` - поддерживаемые языки
- `getExecutionHistory()` - история выполнения
- `validateCode(String code, String language)` - валидация кода

---

### 10. **InvestmentProvider** (`lib/providers/investment_provider.dart`)

#### Назначение
Управление инвестициями: раунды, сделки, портфолио.

#### Основные модели
```dart
class InvestmentRound {
  final String id;
  final String projectId;
  final RoundType type;
  final double targetAmount;
  final double raisedAmount;
  final DateTime startDate;
  final DateTime endDate;
  final RoundStatus status;
}

class Investment {
  final String id;
  final String roundId;
  final String investorId;
  final double amount;
  final DateTime investedAt;
  final InvestmentStatus status;
}
```

#### Ключевые методы
- `createInvestmentRound(InvestmentRound round)` - создание раунда
- `invest(String roundId, double amount)` - инвестирование
- `getInvestmentHistory()` - история инвестиций
- `getRoundDetails(String roundId)` - детали раунда

---

## 🔄 Взаимодействие провайдеров

### 1. **Иерархия провайдеров**
```
MultiProvider
├── AppProvider (глобальные настройки)
├── AuthProvider (аутентификация)
├── BlockchainProvider (блокчейн)
├── NotificationProvider (уведомления)
├── [Специализированные провайдеры]
└── IntroProvider (система интро)
```

### 2. **Зависимости между провайдерами**
- **AuthProvider** → все остальные провайдеры (проверка аутентификации)
- **AppProvider** → все UI провайдеры (тема, язык)
- **NotificationProvider** → все провайдеры (уведомления о событиях)

### 3. **Общие паттерны**
- Все провайдеры наследуются от `ChangeNotifier`
- Используют `SharedPreferences` для локального хранения
- Имеют методы `initialize()` для инициализации
- Поддерживают `toJson()` и `fromJson()` для сериализации

## 🎯 Лучшие практики

### 1. **Управление состоянием**
- Используйте `Consumer` для подписки на изменения
- Минимизируйте количество `notifyListeners()` вызовов
- Группируйте связанные изменения состояния

### 2. **Производительность**
- Кэшируйте часто используемые данные
- Используйте `lazy loading` для больших списков
- Оптимизируйте `build` методы

### 3. **Тестирование**
- Создавайте моки для внешних зависимостей
- Тестируйте бизнес-логику отдельно от UI
- Используйте `TestWidgetsFlutterBinding` для тестов

---

*Документация создана: ${DateTime.now().toString()}*  
*Версия: 1.0*  
*Статус: В разработке 🔄*
