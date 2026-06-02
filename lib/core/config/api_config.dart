/// Конфигурация API для разных окружений.
enum ApiEnvironment {
  development,
  staging,
  production,
}

/// Настройки API.
class ApiConfig {
  final ApiEnvironment environment;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final int maxRetries;

  const ApiConfig({
    required this.environment,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.maxRetries,
  });

  /// Конфигурация для development
  static const development = ApiConfig(
    environment: ApiEnvironment.development,
    baseUrl: 'http://localhost:3000/api/v1',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 30),
    enableLogging: true,
    maxRetries: 3,
  );

  /// Конфигурация для staging
  static const staging = ApiConfig(
    environment: ApiEnvironment.staging,
    baseUrl: 'https://staging-api.rechain.vc/api/v1',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 30),
    enableLogging: true,
    maxRetries: 3,
  );

  /// Конфигурация для production
  static const production = ApiConfig(
    environment: ApiEnvironment.production,
    baseUrl: 'https://api.rechain.vc/api/v1',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 20),
    enableLogging: false,
    maxRetries: 2,
  );

  /// Текущая конфигурация (можно менять через .env)
  static const current = production;

  /// Получить URL для endpoint
  String endpoint(String path) {
    return '$baseUrl$path';
  }

  @override
  String toString() => 'ApiConfig($environment, $baseUrl)';
}

/// Endpoints API.
abstract class Endpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User
  static const String userProfile = '/user/profile';
  static const String updateUser = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String userSettings = '/user/settings';

  // Learning
  static const String courses = '/learning/courses';
  static const String courseDetails = '/learning/courses/{id}';
  static const String enroll = '/learning/courses/{id}/enroll';
  static const String progress = '/learning/progress';
  static const String certificates = '/learning/certificates';

  // Portfolio
  static const String portfolio = '/portfolio';
  static const String assets = '/portfolio/assets';
  static const String portfolioTransactions = '/portfolio/transactions';
  static const String analytics = '/portfolio/analytics';

  // Projects
  static const String projects = '/projects';
  static const String projectDetails = '/projects/{id}';
  static const String createProject = '/projects';
  static const String updateProject = '/projects/{id}';
  static const String deleteProject = '/projects/{id}';

  // Investment
  static const String investments = '/investments';
  static const String investmentDetails = '/investments/{id}';
  static const String createInvestment = '/investments';
  static const String investmentRounds = '/investments/rounds';

  // Notifications
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/{id}/read';
  static const String preferences = '/notifications/preferences';

  // Blockchain
  static const String wallets = '/blockchain/wallets';
  static const String transactions = '/blockchain/transactions';
  static const String nfts = '/blockchain/nfts';
  static const String defi = '/blockchain/defi';

  // Governance
  static const String daoProposals = '/governance/proposals';
  static const String vote = '/governance/vote';
  static const String staking = '/governance/staking';
}
