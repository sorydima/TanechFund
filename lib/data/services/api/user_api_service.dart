import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import '../../models/dto/auth_dto.dart';
import '../../models/dto/api_response_dto.dart';

/// REST API сервис для работы с пользователем.
class UserApiService {
  final Dio _dio;

  UserApiService(this._dio);

  /// Получить профиль пользователя.
  Future<ApiResponse<UserResponse>> getProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return _parseResponse(response, (data) => UserResponse.fromJson(data));
    } catch (e) {
      AppLogger.error('Get profile API error', e);
      return _errorResponse('Ошибка получения профиля');
    }
  }

  /// Обновить профиль пользователя.
  Future<ApiResponse<UserResponse>> updateProfile(Map<String, dynamic> body) async {
    try {
      final response = await _dio.put('/user/profile', data: body);
      return _parseResponse(response, (data) => UserResponse.fromJson(data));
    } catch (e) {
      AppLogger.error('Update profile API error', e);
      return _errorResponse('Ошибка обновления профиля');
    }
  }

  /// Загрузить аватар.
  Future<ApiResponse<UserResponse>> uploadAvatar(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await _dio.post('/user/avatar', data: formData);
      return _parseResponse(response, (data) => UserResponse.fromJson(data));
    } catch (e) {
      AppLogger.error('Upload avatar API error', e);
      return _errorResponse('Ошибка загрузки аватара');
    }
  }

  /// Изменить пароль.
  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _dio.post(
        '/user/change-password',
        data: request.toJson(),
      );
      return _parseVoidResponse(response);
    } catch (e) {
      AppLogger.error('Change password API error', e);
      return _errorResponse('Ошибка изменения пароля');
    }
  }

  /// Получить настройки пользователя.
  Future<ApiResponse<Map<String, dynamic>>> getSettings() async {
    try {
      final response = await _dio.get('/user/settings');
      return _parseResponse(response, (data) => data);
    } catch (e) {
      AppLogger.error('Get settings API error', e);
      return _errorResponse('Ошибка получения настроек');
    }
  }

  /// Обновить настройки пользователя.
  Future<ApiResponse<Map<String, dynamic>>> updateSettings(Map<String, dynamic> settings) async {
    try {
      final response = await _dio.put('/user/settings', data: settings);
      return _parseResponse(response, (data) => data);
    } catch (e) {
      AppLogger.error('Update settings API error', e);
      return _errorResponse('Ошибка обновления настроек');
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
