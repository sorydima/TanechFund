import 'package:dio/dio.dart';
import 'package:rechain_vc_lab/core/base/api_result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/stability/circuit_breaker.dart';

/// Базовый репозиторий для API операций.
/// 
/// Обеспечивает:
/// - Унифицированную обработку ошибок
/// - Circuit breaker для защиты от сбоев
/// - Retry logic через Dio interceptor
/// - Type-safe результаты через ApiResult
abstract class BaseApiRepository {
  final Dio _dio;
  final CircuitBreaker? _circuitBreaker;

  BaseApiRepository(this._dio, {CircuitBreaker? circuitBreaker})
      : _circuitBreaker = circuitBreaker;

  /// GET запрос с обработкой ошибок.
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _executeWithCircuitBreaker(
        () => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

      return ApiResult.success(response.data as T);
    } on DioException catch (e, st) {
      AppLogger.error('GET $path failed', e, st);
      return _handleDioException(e);
    } catch (e, st) {
      AppLogger.error('GET $path unexpected error', e, st);
      return ApiResult.error(UnknownError('Unexpected error: $e', stackTrace: st));
    }
  }

  /// POST запрос с обработкой ошибок.
  Future<ApiResult<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _executeWithCircuitBreaker(
        () => _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

      return ApiResult.success(response.data as T);
    } on DioException catch (e, st) {
      AppLogger.error('POST $path failed', e, st);
      return _handleDioException(e);
    } catch (e, st) {
      AppLogger.error('POST $path unexpected error', e, st);
      return ApiResult.error(UnknownError('Unexpected error: $e', stackTrace: st));
    }
  }

  /// PUT запрос с обработкой ошибок.
  Future<ApiResult<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _executeWithCircuitBreaker(
        () => _dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

      return ApiResult.success(response.data as T);
    } on DioException catch (e, st) {
      AppLogger.error('PUT $path failed', e, st);
      return _handleDioException(e);
    } catch (e, st) {
      AppLogger.error('PUT $path unexpected error', e, st);
      return ApiResult.error(UnknownError('Unexpected error: $e', stackTrace: st));
    }
  }

  /// DELETE запрос с обработкой ошибок.
  Future<ApiResult<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _executeWithCircuitBreaker(
        () => _dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

      return ApiResult.success(response.data as T);
    } on DioException catch (e, st) {
      AppLogger.error('DELETE $path failed', e, st);
      return _handleDioException(e);
    } catch (e, st) {
      AppLogger.error('DELETE $path unexpected error', e, st);
      return ApiResult.error(UnknownError('Unexpected error: $e', stackTrace: st));
    }
  }

  /// Выполнение запроса с circuit breaker.
  Future<Response<T>> _executeWithCircuitBreaker<T>(
    Future<Response<T>> Function() operation,
  ) async {
    final circuitBreaker = _circuitBreaker;
    if (circuitBreaker != null) {
      return await circuitBreaker.execute(operation);
    }
    return await operation();
  }

  /// Обработка Dio исключений.
  ApiResult<T> _handleDioException<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final statusMessage = e.response?.statusMessage ?? 'Unknown error';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.error(
          NetworkError('Connection timeout', code: 'timeout'),
        );

      case DioExceptionType.connectionError:
        return ApiResult.error(
          NetworkError('Connection error', code: 'connection_error'),
        );

      case DioExceptionType.cancel:
        return ApiResult.error(
          NetworkError('Request cancelled', code: 'cancelled'),
        );

      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          return ApiResult.error(
            AuthError('Unauthorized', code: 'unauthorized'),
          );
        } else if (statusCode == 403) {
          return ApiResult.error(
            AuthError('Forbidden', code: 'forbidden'),
          );
        } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ApiResult.error(
            ValidationError('Client error: $statusMessage', code: 'client_error_$statusCode'),
          );
        } else {
          return ApiResult.error(
            NetworkError('Server error: $statusMessage', code: 'server_error_$statusCode'),
          );
        }

      case DioExceptionType.badCertificate:
        return ApiResult.error(
          NetworkError('Bad certificate', code: 'bad_certificate'),
        );

      case DioExceptionType.unknown:
        return ApiResult.error(
          UnknownError('Unknown error: ${e.message}', stackTrace: e.stackTrace),
        );
    }
  }

  /// Получить Dio инстанс для кастомных запросов.
  Dio get dio => _dio;
}
