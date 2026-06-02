import 'dart:async';
import 'package:rechain_vc_lab/core/logger.dart';

/// Реализация паттерна Circuit Breaker для защиты от каскадных сбоев.
/// 
/// Состояния:
/// - [CircuitState.closed] - нормальная работа, запросы проходят
/// - [CircuitState.open] - сбой, запросы блокируются
/// - [CircuitState.halfOpen] - тестирование восстановления
class CircuitBreaker {
  final Duration failureThreshold;
  final Duration resetTimeout;
  final int maxFailures;

  int _failures = 0;
  DateTime? _lastFailureTime;
  CircuitState _state = CircuitState.closed;
  Timer? _resetTimer;

  CircuitState get state => _state;
  bool get isOpen => _state == CircuitState.open;
  bool get isClosed => _state == CircuitState.closed;
  bool get isHalfOpen => _state == CircuitState.halfOpen;

  int get failureCount => _failures;
  DateTime? get lastFailureTime => _lastFailureTime;

  CircuitBreaker({
    this.failureThreshold = const Duration(seconds: 30),
    this.resetTimeout = const Duration(minutes: 1),
    this.maxFailures = 5,
  });

  /// Выполняет операцию с защитой circuit breaker.
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitState.open) {
      if (_shouldAttemptReset()) {
        _enterHalfOpen();
      } else {
        throw CircuitBreakerOpenException('Circuit breaker is open');
      }
    }

    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e, st) {
      _onFailure();
      rethrow;
    }
  }

  /// Сброс circuit breaker в начальное состояние.
  void reset() {
    _resetTimer?.cancel();
    _failures = 0;
    _lastFailureTime = null;
    _state = CircuitState.closed;
    AppLogger.info('CircuitBreaker reset to closed state');
  }

  void dispose() {
    _resetTimer?.cancel();
  }

  bool _shouldAttemptReset() {
    if (_lastFailureTime == null) return false;
    return DateTime.now().difference(_lastFailureTime!) >= resetTimeout;
  }

  void _enterHalfOpen() {
    _state = CircuitState.halfOpen;
    AppLogger.info('CircuitBreaker entered half-open state');
  }

  void _onSuccess() {
    _failures = 0;
    if (_state == CircuitState.halfOpen) {
      _state = CircuitState.closed;
      AppLogger.info('CircuitBreaker closed after successful operation');
    }
  }

  void _onFailure() {
    _failures++;
    _lastFailureTime = DateTime.now();

    if (_failures >= maxFailures) {
      _state = CircuitState.open;
      AppLogger.warning('CircuitBreaker opened after $_failures failures');
      
      _resetTimer?.cancel();
      _resetTimer = Timer(resetTimeout, () {
        _enterHalfOpen();
      });
    }
  }
}

/// Состояния circuit breaker.
enum CircuitState {
  /// Нормальная работа
  closed,
  
  /// Сбой, запросы блокируются
  open,
  
  /// Тестирование восстановления
  halfOpen,
}

/// Исключение при открытом circuit breaker.
class CircuitBreakerOpenException implements Exception {
  final String message;
  CircuitBreakerOpenException(this.message);
  
  @override
  String toString() => 'CircuitBreakerOpenException: $message';
}
