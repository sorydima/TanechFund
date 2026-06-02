import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/stability/circuit_breaker.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';

/// Базовый класс для API репозиториев с обработкой ошибок, retry и circuit breaker.
/// 
/// Пример использования:
/// ```dart
/// class AuthApiRepository extends BaseApiRepository implements IAuthRepository {
///   AuthApiRepository(Dio dio, NetworkManager networkManager)
///     : super(dio, networkManager, basePath: '/api/v1/auth');
///   
///   @override
///   Future<Result<UserModel, AppError>> signInWithEmail(String email, String password) async {
///     return await post<Map<String, dynamic>>('/signin', data: {
///       'email': email,
///       'password': password,
///     });
///   }
/// }
/// ```
abstract class BaseApiRepository {
  final Dio _dio;
  final NetworkManager _networkManager;
  final String _basePath;
  final CircuitBreaker _circuitBreaker;

  /// Максимальное количество retry попыток
  final int maxRetries;

  /// Базовая задержка между retry (экспоненциальное увеличение)
  final Duration baseRetryDelay;

  BaseApiRepository(
    this._dio,
    this._networkManager, {
    required String basePath,
    CircuitBreaker? circuitBreaker,
    this.maxRetries = 3,
    this.baseRetryDelay = const Duration(seconds: 1),
  }) : _basePath = basePath.startsWith('/') ? basePath : '/$basePath',
       _circuitBreaker = circuitBreaker ?? CircuitBreaker();

  /// Выполняет GET запрос с обработкой ошибок.
  Future<Result<T, AppError>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => _dio.get<T>(
        '$_basePath$path',
        queryParameters: queryParameters,
        options: options,
      ),
      'GET $_basePath$path',
    );
  }

  /// Выполняет POST запрос с обработкой ошибок.
  Future<Result<T, AppError>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => _dio.post<T>(
        '$_basePath$path',
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'POST $_basePath$path',
    );
  }

  /// Выполняет PUT запрос с обработкой ошибок.
  Future<Result<T, AppError>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => _dio.put<T>(
        '$_basePath$path',
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'PUT $_basePath$path',
    );
  }

  /// Выполняет PATCH запрос с обработкой ошибок.
  Future<Result<T, AppError>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => _dio.patch<T>(
        '$_basePath$path',
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'PATCH $_basePath$path',
    );
  }

  /// Выполняет DELETE запрос с обработкой ошибок.
  Future<Result<T, AppError>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => _dio.delete<T>(
        '$_basePath$path',
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'DELETE $_basePath$path',
    );
  }

  /// Выполняет запрос с circuit breaker и retry логикой.
  Future<Result<T, AppError>> _executeRequest<T>(
    Future<Response<T>> Function() request,
    String operationName,
  ) async {
    // Проверка сети
    if (!_networkManager.isOnline) {
      AppLogger.warning('$operationName: No network connection');
      return Failure(NetworkError(
        'Отсутствует подключение к сети',
        code: 'no_connection',
      ));
    }

    int attempt = 0;
    Duration delay = baseRetryDelay;

    while (attempt <= maxRetries) {
      try {
        // Circuit breaker защита
        final response = await _circuitBreaker.execute(() => request());

        // Успешный ответ
        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          if (attempt > 0) {
            AppLogger.info('$operationName: Succeeded after $attempt retries');
          }
          return Success(response.data as T);
        }

        // Обработка HTTP ошибок
        return Failure(_mapHttpError(response.statusCode, operationName));
      } on DioException catch (e, st) {
        attempt++;

        if (attempt > maxRetries) {
          AppLogger.error('$operationName: Failed after $maxRetries retries', e, st);
          return Failure(_mapDioError(e, operationName));
        }

        // Экспоненциальная задержка перед retry
        await Future.delayed(delay);
        delay *= 2;

        AppLogger.warning('$operationName: Retry $attempt/$maxRetries after ${delay.inMilliseconds}ms');
      } catch (e, st) {
        AppLogger.error('$operationName: Unexpected error', e, st);
        return Failure(UnknownError('Неожиданная ошибка: $e', stackTrace: st));
      }
    }

    return Failure(UnknownError('Превышено количество попыток'));
  }

  /// Маппинг HTTP статус кодов в AppError.
  AppError _mapHttpError(int? statusCode, String operation) {
    switch (statusCode) {
      case 400:
        return ValidationError('Неверные данные запроса', code: 'bad_request');
      case 401:
        return AuthError('Неавторизован', code: 'unauthorized');
      case 403:
        return AuthError('Доступ запрещён', code: 'forbidden');
      case 404:
        return NetworkError('Ресурс не найден', code: 'not_found');
      case 408:
        return NetworkError('Таймаут запроса', code: 'request_timeout');
      case 409:
        return ValidationError('Конфликт данных', code: 'conflict');
      case 422:
        return ValidationError('Ошибка валидации', code: 'validation_error');
      case 429:
        return NetworkError('Слишком много запросов', code: 'rate_limited');
      case 500:
        return NetworkError('Ошибка сервера', code: 'internal_server_error');
      case 502:
        return NetworkError('Ошибка шлюза', code: 'bad_gateway');
      case 503:
        return NetworkError('Сервис недоступен', code: 'service_unavailable');
      case 504:
        return NetworkError('Таймаут шлюза', code: 'gateway_timeout');
      default:
        return NetworkError('HTTP ошибка: $statusCode', code: 'http_$statusCode');
    }
  }

  /// Маппинг Dio ошибок в AppError.
  AppError _mapDioError(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError('Таймаут соединения', code: 'timeout', stackTrace: e.stackTrace);
      case DioExceptionType.badResponse:
        return _mapHttpError(e.response?.statusCode, operation);
      case DioExceptionType.cancel:
        return NetworkError('Запрос отменён', code: 'cancelled');
      case DioExceptionType.connectionError:
        return NetworkError('Ошибка подключения', code: 'connection_error', stackTrace: e.stackTrace);
      case DioExceptionType.unknown:
      default:
        // Проверка на SocketException
        if (e.error is SocketException) {
          return NetworkError('Ошибка сети: ${(e.error as SocketException).message}', 
            code: 'socket_error', stackTrace: e.stackTrace);
        }
        return UnknownError('Неизвестная ошибка: ${e.message}', stackTrace: e.stackTrace);
    }
  }

  /// Сброс circuit breaker.
  void resetCircuitBreaker() {
    _circuitBreaker.reset();
  }

  /// Получение статуса circuit breaker.
  CircuitState get circuitBreakerState => _circuitBreaker.state;

  /// Очистка ресурсов.
  void dispose() {
    _circuitBreaker.dispose();
  }
}
