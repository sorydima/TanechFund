import 'package:flutter/foundation.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Базовый класс для всех провайдеров приложения.
/// Устраняет дублирование _setLoading / _clearError.
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Выполняет async-операцию с автоматическим управлением состоянием loading/error.
  Future<T?> execute<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    String? errorPrefix,
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
      final message = '${errorPrefix ?? 'Ошибка'}: $e';
      AppLogger.error(message, e, st);
      setError(message);
      onError?.call(message);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Инициализация провайдера (может быть переопределена в подклассах).
  void initialize() {}

  @override
  void dispose() {
    AppLogger.debug('$runtimeType disposed');
    super.dispose();
  }
}
