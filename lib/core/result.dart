/// Унифицированный тип результата операции.
/// Исключает использование исключений для контроля потока.
sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get value => switch (this) {
        Success<T, E>(value: final v) => v,
        Failure<T, E>() => null,
      };

  E? get error => switch (this) {
        Success<T, E>() => null,
        Failure<T, E>(error: final e) => e,
      };

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success<T, E>(value: final v) => success(v),
      Failure<T, E>(error: final e) => failure(e),
    };
  }

  Result<R, E> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T, E>(value: final v) => Success(transform(v)),
      Failure<T, E>(error: final e) => Failure(e),
    };
  }
}

final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
