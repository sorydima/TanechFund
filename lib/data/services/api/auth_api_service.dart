import 'package:dio/dio.dart';
import 'package:rechain_vc_lab/core/config/api_config.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import '../../models/dto/auth_dto.dart';
import '../../models/dto/api_response_dto.dart';

/// REST API сервис для аутентификации.
/// Реализован вручную без кодогенерации для надежности.
class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  /// Логин пользователя.
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return _parseResponse(response, (data) => AuthResponse.fromJson(data));
    } catch (e) {
      AppLogger.error('Login API error', e);
      return _errorResponse('Ошибка входа');
    }
  }

  /// Регистрация нового пользователя.
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      return _parseResponse(response, (data) => AuthResponse.fromJson(data));
    } catch (e) {
      AppLogger.error('Register API error', e);
      return _errorResponse('Ошибка регистрации');
    }
  }

  /// Обновление токена.
  Future<ApiResponse<AuthTokens>> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: request.toJson(),
      );
      return _parseResponse(response, (data) => AuthTokens.fromJson(data));
    } catch (e) {
      AppLogger.error('Refresh token API error', e);
      return _errorResponse('Ошибка обновления токена');
    }
  }

  /// Выход из системы.
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _dio.post('/auth/logout');
      return _parseVoidResponse(response);
    } catch (e) {
      AppLogger.error('Logout API error', e);
      return _errorResponse('Ошибка выхода');
    }
  }

  /// Сброс пароля.
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: request.toJson(),
      );
      return _parseVoidResponse(response);
    } catch (e) {
      AppLogger.error('Reset password API error', e);
      return _errorResponse('Ошибка сброса пароля');
    }
  }

  /// Подтверждение email.
  Future<ApiResponse<void>> verifyEmail(String token) async {
    try {
      final response = await _dio.get(
        '/auth/verify-email',
        queryParameters: {'token': token},
      );
      return _parseVoidResponse(response);
    } catch (e) {
      AppLogger.error('Verify email API error', e);
      return _errorResponse('Ошибка подтверждения email');
    }
  }

  // Helper methods

  ApiResponse<T> _parseResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final data = response.data as Map<String, dynamic>;
    return ApiResponse<T>(
      success: data['success'] ?? true,
      message: data['message'],
      data: data['data'] != null ? parser(data['data']) : null,
      errorCode: data['error_code'],
      errorDetails: data['error_details'],
      requestId: data['request_id'],
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'])
          : null,
    );
  }

  ApiResponse<void> _parseVoidResponse(Response response) {
    final data = response.data as Map<String, dynamic>?;
    return ApiResponse<void>(
      success: data?['success'] ?? true,
      message: data?['message'],
      errorCode: data?['error_code'],
      errorDetails: data?['error_details'],
      requestId: data?['request_id'],
      timestamp: data?['timestamp'] != null
          ? DateTime.parse(data?['timestamp'])
          : null,
    );
  }

  ApiResponse<T> _errorResponse<T>(String message) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errorCode: 'api_error',
    );
  }
}
