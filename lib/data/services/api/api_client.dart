import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rechain_vc_lab/core/config/api_config.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/retry_interceptor.dart';
import 'package:rechain_vc_lab/core/storage/secure_storage.dart';
import 'package:rechain_vc_lab/data/models/dto/api_response_dto.dart';
import 'package:rechain_vc_lab/data/models/dto/auth_dto.dart';
import 'package:rechain_vc_lab/data/services/api/auth_api_service.dart';
import 'package:rechain_vc_lab/data/services/api/user_api_service.dart';

/// Фабрика для создания API клиентов.
/// Управляет Dio instance, interceptors и сервисами.
@singleton
class ApiClient {
  final Dio _dio;
  final ISecureStorage _secureStorage;

  late final AuthApiService authApi;
  late final UserApiService userApi;

  ApiClient(this._dio, this._secureStorage) {
    _setupInterceptors();
    _setupServices();
  }

  /// Настройка interceptors.
  void _setupInterceptors() {
    // Clear existing interceptors
    _dio.interceptors.clear();

    // Auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    // Retry interceptor
    _dio.interceptors.add(RetryInterceptor(
      maxRetries: ApiConfig.current.maxRetries,
      baseDelay: const Duration(seconds: 1),
    ));

    // Logging interceptor
    if (ApiConfig.current.enableLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }

    AppLogger.info('API interceptors configured');
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Добавляем токен авторизации
    final tokenResult = await _secureStorage.read('auth_token');
    final token = tokenResult.value;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Добавляем стандартные заголовки
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['X-App-Version'] = '1.0.0';
    options.headers['X-Platform'] = 'flutter';

    AppLogger.debug('API Request: ${options.method} ${options.path}');
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.debug('API Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = error.response?.statusCode;
    final path = error.requestOptions.path;

    AppLogger.error('API Error: $statusCode $path', error);

    // Обработка 401 Unauthorized
    if (statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Повторяем запрос с новым токеном
        final tokenResult = await _secureStorage.read('auth_token');
        final token = tokenResult.value;
        
        if (token != null) {
          error.requestOptions.headers['Authorization'] = 'Bearer $token';
          try {
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            AppLogger.error('Retry failed after token refresh', e);
          }
        }
      }

      // Если refresh не удался — выходим
      await _clearAuthData();
    }

    handler.next(error);
  }

  /// Обновление токена.
  Future<bool> _refreshToken() async {
    try {
      final refreshResult = await _secureStorage.read('refresh_token');
      final refreshToken = refreshResult.value;

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Создаём временный Dio без auth interceptor
      final tempDio = Dio(BaseOptions(baseUrl: ApiConfig.current.baseUrl));
      final authApi = AuthApiService(tempDio);

      final response = await authApi.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      if (response.success && response.data != null) {
        final tokens = response.data!;
        await _secureStorage.write('auth_token', tokens.accessToken);
        await _secureStorage.write('refresh_token', tokens.refreshToken);
        AppLogger.info('Token refreshed successfully');
        return true;
      }
    } catch (e, st) {
      AppLogger.error('Token refresh failed', e, st);
    }

    return false;
  }

  /// Очистка данных авторизации.
  Future<void> _clearAuthData() async {
    await _secureStorage.delete('auth_token');
    await _secureStorage.delete('refresh_token');
    await _secureStorage.delete('user_data');
    AppLogger.info('Auth data cleared');
  }

  /// Настройка сервисов API.
  void _setupServices() {
    authApi = AuthApiService(_dio);
    userApi = UserApiService(_dio);
    AppLogger.info('API services initialized');
  }

  /// Обновление base URL (для смены окружения).
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _setupServices();
    AppLogger.info('API base URL updated: $baseUrl');
  }

  /// Получение текущего Dio instance.
  Dio get dio => _dio;
}
