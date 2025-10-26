/// A generic result class that represents either a success or failure
sealed class Result<T> {
  const Result();

  /// Creates a success result
  static Result<T> success<T>(T data) => Success(data);

  /// Creates a failure result
  static Result<T> failure<T>(Exception exception) => Failure(exception);
}

/// Represents a successful result with data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed result with an exception
class Failure<T> extends Result<T> {
  final Exception exception;

  const Failure(this.exception);

  @override
  String toString() => 'Failure(exception: $exception)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> && other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;
}

/// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Returns the data if success, null otherwise
  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;

  /// Returns the exception if failure, null otherwise
  Exception? get exceptionOrNull =>
      isFailure ? (this as Failure<T>).exception : null;

  /// Returns the data if success, or the provided default value
  T dataOr(T defaultValue) =>
      isSuccess ? (this as Success<T>).data : defaultValue;

  /// Returns the data if success, or the result of the provided function
  T dataOrElse(T Function() defaultValue) =>
      isSuccess ? (this as Success<T>).data : defaultValue();

  /// Maps the data if success, returns the same failure if failure
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return Success(mapper((this as Success<T>).data));
      } catch (e) {
        return Failure(e is Exception ? e : Exception(e.toString()));
      }
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Maps the data if success, returns the same failure if failure
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    if (isSuccess) {
      try {
        return Success(await mapper((this as Success<T>).data));
      } catch (e) {
        return Failure(e is Exception ? e : Exception(e.toString()));
      }
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Maps the exception if failure, returns the same success if success
  Result<T> mapError(Exception Function(Exception exception) mapper) {
    if (isFailure) {
      return Failure(mapper((this as Failure<T>).exception));
    }
    return this;
  }

  /// Executes the provided function if success
  Result<T> onSuccess(void Function(T data) action) {
    if (isSuccess) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Executes the provided function if failure
  Result<T> onFailure(void Function(Exception exception) action) {
    if (isFailure) {
      action((this as Failure<T>).exception);
    }
    return this;
  }

  /// Executes the provided function if success, returns the result
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    if (isSuccess) {
      return mapper((this as Success<T>).data);
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Executes the provided function if success, returns the result
  Future<Result<R>> flatMapAsync<R>(
      Future<Result<R>> Function(T data) mapper) async {
    if (isSuccess) {
      return await mapper((this as Success<T>).data);
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Fold operation - executes different functions based on success/failure
  R fold<R>(
      R Function(T data) onSuccess, R Function(Exception exception) onFailure) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failure<T>).exception);
    }
  }

  /// Converts the result to a Future
  Future<Result<T>> toFuture() async => this;

  /// Converts the result to a Stream
  Stream<Result<T>> toStream() async* {
    yield this;
  }
}

/// Helper functions for creating results
class ResultHelper {
  /// Creates a success result
  static Result<T> success<T>(T data) => Success(data);

  /// Creates a failure result
  static Result<T> failure<T>(Exception exception) => Failure(exception);

  /// Creates a failure result from an error message
  static Result<T> failureFromMessage<T>(String message) =>
      Failure(Exception(message));

  /// Creates a failure result from an error code and message
  static Result<T> failureFromCode<T>(String code, String message) =>
      Failure(Exception('[$code] $message'));

  /// Executes a function and returns a result
  static Result<T> tryCatch<T>(T Function() function) {
    try {
      return Success(function());
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Executes an async function and returns a result
  static Future<Result<T>> tryCatchAsync<T>(
      Future<T> Function() function) async {
    try {
      return Success(await function());
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Combines multiple results into a single result
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final List<T> data = [];
    for (final result in results) {
      if (result.isFailure) {
        return Failure(result.exceptionOrNull!);
      }
      data.add(result.dataOrNull!);
    }
    return Success(data);
  }

  /// Combines multiple async results into a single result
  static Future<Result<List<T>>> combineAsync<T>(
      List<Future<Result<T>>> results) async {
    final List<T> data = [];
    for (final result in results) {
      final resolved = await result;
      if (resolved.isFailure) {
        return Failure(resolved.exceptionOrNull!);
      }
      data.add(resolved.dataOrNull!);
    }
    return Success(data);
  }
}
