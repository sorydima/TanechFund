import 'package:json_annotation/json_annotation.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

part 'api_response_dto.g.dart';

/// Унифицированный формат ответа API.
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  @JsonKey(name: 'error_code')
  final String? errorCode;
  @JsonKey(name: 'error_details')
  final Map<String, dynamic>? errorDetails;
  @JsonKey(name: 'request_id')
  final String? requestId;
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errorCode,
    this.errorDetails,
    this.requestId,
    this.timestamp,
  });

  /// Конвертирует ApiResponse в domain Result.
  ///
  /// [fromJson] — функция для преобразования data в модель.
  ///
  /// Возвращает:
  /// - Success с данными если success == true
  /// - Failure с ошибкой если success == false
  Result<R, ApiError> toResult<R>(R Function(T?) fromJson) {
    if (success) {
      try {
        final parsedData = data != null ? fromJson(data) : null;
        return Success(parsedData as R);
      } catch (e) {
        return Failure(ApiError(
          message: 'Ошибка парсинга данных: $e',
          code: 'parse_error',
          requestId: requestId,
        ));
      }
    } else {
      return Failure(ApiError(
        message: message ?? 'Неизвестная ошибка',
        code: errorCode ?? 'unknown_error',
        details: errorDetails,
        requestId: requestId,
      ));
    }
  }

  /// Упрощённый toResult для void операций.
  Result<void, ApiError> toVoidResult() {
    if (success) {
      return const Success(null);
    } else {
      return Failure(ApiError(
        message: message ?? 'Неизвестная ошибка',
        code: errorCode ?? 'unknown_error',
        details: errorDetails,
        requestId: requestId,
      ));
    }
  }

  Map<String, dynamic> toJson(Object? Function(T?) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

/// DTO для API ошибки.
@JsonSerializable()
class ApiError {
  final String message;
  final String code;
  final Map<String, dynamic>? details;
  final String? requestId;

  const ApiError({
    required this.message,
    required this.code,
    this.details,
    this.requestId,
  });

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  @override
  String toString() => 'ApiError(code: $code, message: $message, requestId: $requestId)';
}

