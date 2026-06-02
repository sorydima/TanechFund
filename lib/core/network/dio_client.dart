import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/config/api_config.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/retry_interceptor.dart';
import 'package:rechain_vc_lab/core/storage/secure_storage.dart';

/// Конфигурируемый Dio HTTP клиент с retry, logging и auth interceptors.
@singleton
class DioClient {
  late final Dio dio;
  final ISecureStorage _secureStorage;

  static const _authHeader = 'Authorization';
  static const _tokenPrefix = 'Bearer';

  DioClient(this._secureStorage) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.current.baseUrl,
      connectTimeout: ApiConfig.current.connectTimeout,
      receiveTimeout: ApiConfig.current.receiveTimeout,
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Retry interceptor
    dio.interceptors.add(RetryInterceptor(
      maxRetries: ApiConfig.current.maxRetries,
      baseDelay: const Duration(seconds: 1),
    ));

    // Auth interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));

    // Logging interceptor (только в debug)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => AppLogger.debug('[DIO] $obj'),
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Пропускаем если заголовок уже установлен
    if (options.headers[_authHeader] != null) {
      handler.next(options);
      return;
    }

    final tokenResult = await _secureStorage.read('auth_token');
    if (tokenResult.isSuccess && tokenResult.value != null) {
      options.headers[_authHeader] = '$_tokenPrefix ${tokenResult.value}';
    }

    handler.next(options);
  }

  Future<void> _onError(DioException err, ErrorInterceptorHandler handler) async {
    // Обработка 401 — попытка refresh token
    if (err.response?.statusCode == 401) {
      final refreshResult = await _secureStorage.read('refresh_token');
      if (refreshResult.isSuccess && refreshResult.value != null) {
        AppLogger.info('Attempting token refresh');
        // TODO: Реализовать вызов refresh endpoint
      }
    }
    handler.next(err);
  }

  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void setAuthToken(String token) {
    dio.options.headers[_authHeader] = '$_tokenPrefix $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove(_authHeader);
  }
}
