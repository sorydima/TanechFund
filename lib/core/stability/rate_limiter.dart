import 'dart:async';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Ошибка превышения лимита запросов.
class RateLimitExceededError implements Exception {
  final Duration retryAfter;
  final String message;
  final String? code;

  const RateLimitExceededError({
    required this.retryAfter,
    this.message = 'Превышен лимит запросов',
    this.code = 'rate_limit_exceeded',
  });

  @override
  String toString() => 'RateLimitExceededError: $message (retry after ${retryAfter.inSeconds}s)';
}

/// Стратегия rate limiting.
enum RateLimitStrategy {
  /// Фиксированное окно: N запросов за фиксированный период
  fixedWindow,

  /// Скользящее окно: N запросов за скользящий период
  slidingWindow,

  /// Token bucket: запросы потребляют токены, которые пополняются со временем
  tokenBucket,
}

/// Конфигурация rate limiter.
class RateLimitConfig {
  final int maxRequests;
  final Duration windowDuration;
  final RateLimitStrategy strategy;

  const RateLimitConfig({
    required this.maxRequests,
    required this.windowDuration,
    this.strategy = RateLimitStrategy.fixedWindow,
  });

  /// Предустановленная конфигурация для API запросов.
  static const apiDefault = RateLimitConfig(
    maxRequests: 100,
    windowDuration: Duration(minutes: 1),
    strategy: RateLimitStrategy.slidingWindow,
  );

  /// Предустановленная конфигурация для тяжёлых операций.
  static const heavyOperations = RateLimitConfig(
    maxRequests: 10,
    windowDuration: Duration(minutes: 1),
    strategy: RateLimitStrategy.tokenBucket,
  );

  /// Предустановленная конфигурация для аутентификации.
  static const auth = RateLimitConfig(
    maxRequests: 5,
    windowDuration: Duration(minutes: 5),
    strategy: RateLimitStrategy.fixedWindow,
  );
}

/// Запись о запросе в скользящем окне.
class _RequestRecord {
  final DateTime timestamp;

  const _RequestRecord(this.timestamp);
}

/// Rate limiter для защиты от чрезмерных запросов.
/// 
/// Пример использования:
/// ```dart
/// final limiter = RateLimiter(
///   config: const RateLimitConfig(
///     maxRequests: 100,
///     windowDuration: Duration(minutes: 1),
///   ),
/// );
/// 
/// // Выполнение с rate limiting
/// final result = await limiter.execute(() => apiCall());
/// 
/// // Проверка доступности
/// if (limiter.canExecute) {
///   await apiCall();
/// }
/// 
/// // Получение оставшихся запросов
/// print('Remaining: ${limiter.remainingRequests}');
/// ```
class RateLimiter {
  final RateLimitConfig _config;
  final String _identifier;

  final List<_RequestRecord> _requestRecords = [];
  double _tokenBucketCapacity;
  DateTime _lastRefillTime;

  Timer? _cleanupTimer;

  /// Оставшееся количество запросов в текущем окне.
  int get remainingRequests {
    switch (_config.strategy) {
      case RateLimitStrategy.fixedWindow:
      case RateLimitStrategy.slidingWindow:
        _cleanupExpiredRecords();
        return _config.maxRequests - _requestRecords.length;
      case RateLimitStrategy.tokenBucket:
        return _tokenBucketCapacity.floor();
    }
  }

  /// Можно ли выполнить запрос.
  bool get canExecute => remainingRequests > 0;

  /// Время до следующего доступного запроса (если лимит исчерпан).
  Duration get retryAfter {
    if (canExecute) return Duration.zero;

    switch (_config.strategy) {
      case RateLimitStrategy.fixedWindow:
        if (_requestRecords.isEmpty) return Duration.zero;
        final oldestRecord = _requestRecords.first;
        final windowEnd = oldestRecord.timestamp.add(_config.windowDuration);
        return windowEnd.difference(DateTime.now());

      case RateLimitStrategy.slidingWindow:
        if (_requestRecords.isEmpty) return Duration.zero;
        final oldestRecord = _requestRecords.first;
        return oldestRecord.timestamp.add(_config.windowDuration).difference(DateTime.now());

      case RateLimitStrategy.tokenBucket:
        final tokensNeeded = 1 - _tokenBucketCapacity;
        if (tokensNeeded <= 0) return Duration.zero;
        final refillRate = _config.maxRequests / _config.windowDuration.inSeconds;
        return Duration(seconds: (tokensNeeded / refillRate).ceil());
    }
  }

  RateLimiter({
    required RateLimitConfig config,
    String identifier = 'default',
  })  : _config = config,
        _identifier = identifier,
        _tokenBucketCapacity = config.maxRequests.toDouble(),
        _lastRefillTime = DateTime.now() {
    _startCleanupTimer();
  }

  /// Выполняет операцию с rate limiting.
  Future<Result<T, RateLimitExceededError>> execute<T>(Future<T> Function() operation) async {
    if (!canExecute) {
      final retryAfter = this.retryAfter;
      AppLogger.warning('RateLimiter [$_identifier]: Limit exceeded, retry after ${retryAfter.inSeconds}s');
      return Failure(RateLimitExceededError(retryAfter: retryAfter));
    }

    _recordRequest();

    try {
      final result = await operation();
      return Success(result);
    } catch (e, st) {
      AppLogger.error('RateLimiter [$_identifier]: Operation failed', e, st);
      rethrow;
    }
  }

  /// Выполняет операцию с ожиданием при необходимости.
  Future<Result<T, RateLimitExceededError>> executeWithWait<T>(
    Future<T> Function() operation, {
    Duration? maxWait,
  }) async {
    if (!canExecute && maxWait != null) {
      final waitTime = retryAfter;
      if (waitTime <= maxWait) {
        AppLogger.debug('RateLimiter [$_identifier]: Waiting ${waitTime.inSeconds}s before execution');
        await Future.delayed(waitTime);
      } else {
        return Failure(RateLimitExceededError(retryAfter: waitTime));
      }
    }

    return execute(operation);
  }

  /// Сброс лимитера.
  void reset() {
    _requestRecords.clear();
    _tokenBucketCapacity = _config.maxRequests.toDouble();
    _lastRefillTime = DateTime.now();
    AppLogger.debug('RateLimiter [$_identifier]: Reset');
  }

  /// Очистка ресурсов.
  void dispose() {
    _cleanupTimer?.cancel();
  }

  // Private

  void _recordRequest() {
    final now = DateTime.now();

    switch (_config.strategy) {
      case RateLimitStrategy.fixedWindow:
      case RateLimitStrategy.slidingWindow:
        _requestRecords.add(_RequestRecord(now));
        break;

      case RateLimitStrategy.tokenBucket:
        _refillTokens(now);
        _tokenBucketCapacity = (_tokenBucketCapacity - 1).clamp(0, _config.maxRequests.toDouble());
        break;
    }
  }

  void _cleanupExpiredRecords() {
    final now = DateTime.now();
    final cutoff = now.subtract(_config.windowDuration);

    _requestRecords.removeWhere((record) => record.timestamp.isBefore(cutoff));
  }

  void _refillTokens(DateTime now) {
    final elapsed = now.difference(_lastRefillTime).inSeconds;
    final refillRate = _config.maxRequests / _config.windowDuration.inSeconds;
    final tokensToAdd = elapsed * refillRate;

    _tokenBucketCapacity = (_tokenBucketCapacity + tokensToAdd)
        .clamp(0, _config.maxRequests.toDouble());
    _lastRefillTime = now;
  }

  void _startCleanupTimer() {
    // Очистка каждые 10 секунд для sliding window
    if (_config.strategy == RateLimitStrategy.slidingWindow) {
      _cleanupTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        _cleanupExpiredRecords();
      });
    }

    // Refill timer для token bucket
    if (_config.strategy == RateLimitStrategy.tokenBucket) {
      _cleanupTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _refillTokens(DateTime.now());
      });
    }
  }
}

/// Менеджер rate limiter'ов для разных endpoints/операций.
class RateLimiterManager {
  final Map<String, RateLimiter> _limiters = {};

  /// Получение или создание лимитера для ключа.
  RateLimiter getLimiter(String key, RateLimitConfig config) {
    return _limiters.putIfAbsent(key, () => RateLimiter(config: config, identifier: key));
  }

  /// Удаление лимитера.
  void removeLimiter(String key) {
    final limiter = _limiters.remove(key);
    limiter?.dispose();
  }

  /// Очистка всех лимитеров.
  void dispose() {
    for (final limiter in _limiters.values) {
      limiter.dispose();
    }
    _limiters.clear();
  }
}
