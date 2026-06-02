import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Расширения для удобной работы с Result.
extension ResultExtensions<T, E extends AppError> on Result<T, E> {
  /// Выполняет действие при успехе и возвращает тот же результат.
  Result<T, E> tap(void Function(T value) onSuccess) {
    when(
      success: onSuccess,
      failure: (_) {},
    );
    return this;
  }

  /// Выполняет действие при ошибке и возвращает тот же результат.
  Result<T, E> tapError(void Function(E error) onError) {
    when(
      success: (_) {},
      failure: onError,
    );
    return this;
  }

  /// Преобразует ошибку в другой тип.
  Result<T, E2> mapError<E2 extends AppError>(E2 Function(E error) transform) {
    return switch (this) {
      Success<T, E>() => this as Success<T, E2>,
      Failure<T, E>(error: final e) => Failure(transform(e)),
    };
  }

  /// Возвращает значение по умолчанию при ошибке.
  T getOrElse(T Function(E error) defaultValue) {
    return switch (this) {
      Success<T, E>(value: final v) => v,
      Failure<T, E>(error: final e) => defaultValue(e),
    };
  }

  /// Возвращает null при ошибке.
  T? getOrNull() {
    return switch (this) {
      Success<T, E>(value: final v) => v,
      Failure<T, E>() => null,
    };
  }

  /// Преобразует Result в Future.
  Future<Result<T, E>> asFuture() => Future.value(this);

  /// Выполняет асинхронное действие при успехе.
  Future<Result<T, E>> tapAsync(Future<void> Function(T value) onSuccess) async {
    when(
      success: onSuccess,
      failure: (_) {},
    );
    return this;
  }

  /// Выполняет асинхронное действие при ошибке.
  Future<Result<T, E>> tapErrorAsync(Future<void> Function(E error) onError) async {
    when(
      success: (_) {},
      failure: onError,
    );
    return this;
  }
}

/// Расширения для работы с списком Result.
extension ResultListExtensions<T, E extends AppError> on List<Result<T, E>> {
  /// Преобразует список Result в Result со списком.
  /// Возвращает первую ошибку или список успешных значений.
  Result<List<T>, E> sequence() {
    final values = <T>[];

    for (final result in this) {
      switch (result) {
        case Success<T, E>(value: final v):
          values.add(v);
        case Failure<T, E>(error: final e):
          return Failure(e);
      }
    }

    return Success(values);
  }

  /// Преобразует список Result в список значений, игнорируя ошибки.
  List<T> flatten() {
    return where((r) => r.isSuccess)
        .map((r) => (r as Success<T, E>).value)
        .toList();
  }
}

/// Расширения для работы с Future<Result>.
extension FutureResultExtensions<T, E extends AppError> on Future<Result<T, E>> {
  /// Выполняет действие при успехе.
  Future<Result<T, E>> tap(void Function(T value) onSuccess) async {
    final result = await this;
    result.tap(onSuccess);
    return result;
  }

  /// Выполняет действие при ошибке.
  Future<Result<T, E>> tapError(void Function(E error) onError) async {
    final result = await this;
    result.tapError(onError);
    return result;
  }

  /// Возвращает значение по умолчанию при ошибке.
  Future<T> getOrElse(T Function(E error) defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Возвращает null при ошибке.
  Future<T?> getOrNull() async {
    final result = await this;
    return result.getOrNull();
  }

  /// Преобразует успешное значение.
  Future<Result<R, E>> map<R>(R Function(T value) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// Выполняет асинхронное действие при успехе.
  Future<Result<T, E>> tapAsync(Future<void> Function(T value) onSuccess) async {
    final result = await this;
    await result.tapAsync(onSuccess);
    return result;
  }

  /// Выполняет асинхронное действие при ошибке.
  Future<Result<T, E>> tapErrorAsync(Future<void> Function(E error) onError) async {
    final result = await this;
    await result.tapErrorAsync(onError);
    return result;
  }
}

/// Расширения для обработки ошибок по типу.
extension ResultErrorHandling<T, E extends AppError> on Result<T, E> {
  /// Обрабатывает NetworkError.
  Result<T, E> handleNetworkError(void Function(NetworkError error) handler) {
    when(
      success: (_) {},
      failure: (error) {
        if (error is NetworkError) handler(error);
      },
    );
    return this;
  }

  /// Обрабатывает AuthError.
  Result<T, E> handleAuthError(void Function(AuthError error) handler) {
    when(
      success: (_) {},
      failure: (error) {
        if (error is AuthError) handler(error);
      },
    );
    return this;
  }

  /// Обрабатывает ValidationError.
  Result<T, E> handleValidationError(void Function(ValidationError error) handler) {
    when(
      success: (_) {},
      failure: (error) {
        if (error is ValidationError) handler(error);
      },
    );
    return this;
  }

  /// Обрабатывает StorageError.
  Result<T, E> handleStorageError(void Function(StorageError error) handler) {
    when(
      success: (_) {},
      failure: (error) {
        if (error is StorageError) handler(error);
      },
    );
    return this;
  }

  /// Обрабатывает UnknownError.
  Result<T, E> handleUnknownError(void Function(UnknownError error) handler) {
    when(
      success: (_) {},
      failure: (error) {
        if (error is UnknownError) handler(error);
      },
    );
    return this;
  }
}
