import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

part 'api_result.freezed.dart';

/// Sealed class для типобезопасных API-ответов.
/// Заменяет ручную проверку isSuccess/isFailure.
@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.idle() = ApiIdle<T>;
  const factory ApiResult.loading() = ApiLoading<T>;
  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.error(AppError error) = ApiError<T>;
}

/// Расширения для удобной работы с ApiResult
extension ApiResultX<T> on ApiResult<T> {
  bool get isIdle => this is ApiIdle<T>;
  bool get isLoading => this is ApiLoading<T>;
  bool get isSuccess => this is ApiSuccess<T>;
  bool get isError => this is ApiError<T>;

  T? get data => when(
        idle: () => null,
        loading: () => null,
        success: (data) => data,
        error: (_) => null,
      );

  AppError? get error => when(
        idle: () => null,
        loading: () => null,
        success: (_) => null,
        error: (error) => error,
      );

  R? whenOrNull<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(T data)? success,
    R Function(AppError err)? error,
  }) {
    return when(
      idle: () => idle?.call(),
      loading: () => loading?.call(),
      success: (data) => success?.call(data),
      error: (err) => error?.call(err),
    );
  }

  /// Проверяет успешность и выполняет действие
  void ifSuccess(void Function(T data) action) {
    whenOrNull(success: action);
  }

  /// Проверяет ошибку и выполняет действие
  void ifError(void Function(AppError error) action) {
    whenOrNull(error: action);
  }
}
