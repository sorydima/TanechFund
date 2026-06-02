import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Interceptor с retry logic, exponential backoff и circuit breaker.
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;
  final List<int> retryableStatuses;
  final Set<String> retryableMethods;

  int _consecutiveFailures = 0;
  static const int _circuitBreakerThreshold = 5;
  DateTime? _circuitBreakerResetTime;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.retryableStatuses = const [408, 429, 500, 502, 503, 504],
    this.retryableMethods = const {'GET', 'POST', 'PUT', 'DELETE'},
  });

  bool get _isCircuitOpen {
    if (_consecutiveFailures < _circuitBreakerThreshold) return false;
    if (_circuitBreakerResetTime == null) return true;
    return DateTime.now().isBefore(_circuitBreakerResetTime!);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Circuit breaker check
    if (_isCircuitOpen) {
      AppLogger.warning('Circuit breaker OPEN — rejecting request');
      handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: 'Circuit breaker is open',
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }

    final retryCount = requestOptions.extra['retryCount'] as int? ?? 0;

    if (!_shouldRetry(err, retryCount)) {
      _consecutiveFailures++;
      if (_consecutiveFailures >= _circuitBreakerThreshold) {
        _circuitBreakerResetTime = DateTime.now().add(const Duration(minutes: 1));
        AppLogger.error('Circuit breaker OPENED');
      }
      handler.next(err);
      return;
    }

    // Exponential backoff
    final delay = baseDelay * (1 << retryCount);
    AppLogger.info('Retrying request (${retryCount + 1}/$maxRetries) after ${delay.inSeconds}s');

    await Future.delayed(delay);

    try {
      requestOptions.extra['retryCount'] = retryCount + 1;
      final response = await Dio().fetch(requestOptions);
      _consecutiveFailures = 0;
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _consecutiveFailures = 0;
    handler.next(response);
  }

  bool _shouldRetry(DioException err, int retryCount) {
    if (retryCount >= maxRetries) return false;
    if (!retryableMethods.contains(err.requestOptions.method.toUpperCase())) return false;

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.error is SocketException ||
        (err.response?.statusCode != null &&
            retryableStatuses.contains(err.response!.statusCode));
  }
}
