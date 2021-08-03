import 'package:async/async.dart' as $async;
import 'package:meta/meta.dart';

extension ResultExtension<T> on $async.Result<T> {
  bool get isSuccess => isValue;

  bool get hasValue => isValue && asValue!.value != null;

  T get value => asValue!.value;

  Object get error => asError!.error;

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
      {required TResult Function(T value) success,
      required TResult Function(dynamic error) error}) {
    if (isValue) {
      return success(asValue!.value);
    } else {
      return error(asError!.error);
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? success,
    TResult Function(dynamic e)? error,
    required TResult Function() orElse,
  }) {
    if (isValue && success != null) {
      return success(asValue!.value);
    } else if (isError && error != null) {
      return error(asError!.error);
    }
    return orElse();
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(T value) success,
    required TResult Function(dynamic error) error,
  }) {
    if (isValue) {
      return success(asValue!.value);
    } else {
      return error(asError!.error);
    }
  }

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(T value)? success,
    TResult Function(dynamic value)? error,
    required TResult Function() orElse,
  }) {
    if (isValue && success != null) {
      return success(asValue!.value);
    } else if (isError && error != null) {
      return error(asError!.error);
    }
    return orElse();
  }
}
