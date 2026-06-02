import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Базовый HTTP-клиент с перехватчиками, таймаутами и обработкой сетевых ошибок.
class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> _defaultHeaders;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? defaultHeaders,
  }) : _defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?defaultHeaders,
        };

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
    AppLogger.info('API auth token ${token != null ? 'set' : 'cleared'}');
  }

  Map<String, String> get _headers {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Result<T, AppError>> get<T>(
    String path, {
    Map<String, String>? queryParams,
    required T Function(dynamic data) parser,
  }) async {
    return _request(
      method: 'GET',
      path: path,
      queryParams: queryParams,
      parser: parser,
    );
  }

  Future<Result<T, AppError>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic data) parser,
  }) async {
    return _request(
      method: 'POST',
      path: path,
      body: body,
      parser: parser,
    );
  }

  Future<Result<T, AppError>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic data) parser,
  }) async {
    return _request(
      method: 'PUT',
      path: path,
      body: body,
      parser: parser,
    );
  }

  Future<Result<T, AppError>> delete<T>(
    String path, {
    required T Function(dynamic data) parser,
  }) async {
    return _request(
      method: 'DELETE',
      path: path,
      parser: parser,
    );
  }

  Future<Result<T, AppError>> _request<T>({
    required String method,
    required String path,
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
    required T Function(dynamic data) parser,
  }) async {
    // Проверка соединения
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return const Failure(NetworkError('Нет подключения к интернету', code: 'NO_CONNECTION'));
    }

    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final bodyJson = body != null ? jsonEncode(body) : null;

    AppLogger.debug('API $method $uri');

    try {
      final request = switch (method) {
        'GET' => http.get(uri, headers: _headers),
        'POST' => http.post(uri, headers: _headers, body: bodyJson),
        'PUT' => http.put(uri, headers: _headers, body: bodyJson),
        'DELETE' => http.delete(uri, headers: _headers),
        _ => throw UnsupportedError('HTTP method $method not supported'),
      };

      final response = await request.timeout(timeout);
      AppLogger.debug('API response ${response.statusCode} for $method $path');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return Success(parser(data));
      } else if (response.statusCode == 401) {
        return Failure(AuthError(
          'Сессия истекла. Необходимо повторно авторизоваться.',
          code: 'UNAUTHORIZED',
        ));
      } else if (response.statusCode >= 500) {
        return Failure(NetworkError(
          'Ошибка сервера (${response.statusCode}). Попробуйте позже.',
          code: 'SERVER_ERROR_${response.statusCode}',
        ));
      } else {
        return Failure(NetworkError(
          'Ошибка запроса: ${response.statusCode}',
          code: 'HTTP_${response.statusCode}',
        ));
      }
    } on SocketException catch (e, st) {
      AppLogger.error('Network socket error', e, st);
      return Failure(NetworkError('Ошибка сети: ${e.message}', code: 'SOCKET_ERROR', stackTrace: st));
    } on FormatException catch (e, st) {
      AppLogger.error('JSON parse error', e, st);
      return Failure(NetworkError('Некорректный ответ сервера', code: 'PARSE_ERROR', stackTrace: st));
    } on TimeoutException catch (e, st) {
      AppLogger.error('Request timeout', e, st);
      return Failure(NetworkError('Превышено время ожидания', code: 'TIMEOUT', stackTrace: st));
    } catch (e, st) {
      AppLogger.error('Unexpected API error', e, st);
      return Failure(UnknownError('Неизвестная ошибка: $e', code: 'UNKNOWN', stackTrace: st));
    }
  }
}
