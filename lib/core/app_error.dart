/// Базовый класс доменных ошибок приложения.
sealed class AppError {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppError(this.message, {this.code, this.stackTrace});

  @override
  String toString() => '[$runtimeType${code != null ? ' | $code' : ''}] $message';
}

/// Ошибки сети/соединения.
final class NetworkError extends AppError {
  const NetworkError(super.message, {super.code, super.stackTrace});
}

/// Ошибки хранилища (SharedPreferences, файлы).
final class StorageError extends AppError {
  const StorageError(super.message, {super.code, super.stackTrace});
}

/// Ошибки аутентификации/авторизации.
final class AuthError extends AppError {
  const AuthError(super.message, {super.code, super.stackTrace});
}

/// Ошибки валидации входных данных.
final class ValidationError extends AppError {
  const ValidationError(super.message, {super.code, super.stackTrace});
}

/// Неизвестные/непредвиденные ошибки.
final class UnknownError extends AppError {
  const UnknownError(super.message, {super.code, super.stackTrace});
}
