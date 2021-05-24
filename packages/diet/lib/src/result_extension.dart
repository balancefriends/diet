import 'package:async/async.dart' as $async;
import 'package:meta/meta.dart';
import 'package:quiver/check.dart';

extension ResultExtension<T> on $async.Result<T> {
  bool get isSuccess => isValue;
  bool get hasValue => isValue && asValue!.value != null;
  T get value => asValue!.value;
  Object get error => asError!.error;

  @optionalTypeArgs
  R when<R extends Object>(
      {required R Function(T value) success,
      required R Function(dynamic error) error}) {
    checkNotNull(success != null);
    checkNotNull(error != null);
    if (isValue) {
      return success(asValue!.value);
    } else {
      return error(asError!.error);
    }
  }

  @optionalTypeArgs
  R maybeWhen<R extends Object>({
    R Function(T value)? success,
    R Function(dynamic e)? error,
    required R Function() orElse,
  }) {
    checkNotNull(orElse);
    if (isValue && success != null) {
      return success(asValue!.value);
    } else if (isError && error != null) {
      return error(asError!.error);
    }
    return orElse();
  }

  @optionalTypeArgs
  R map<R extends Object>({
    required R Function(T value) success,
    required R Function(dynamic error) error,
  }) {
    checkNotNull(success);
    checkNotNull(error);
    if (isValue) {
      return success(asValue!.value);
    } else {
      return error(asError!.error);
    }
  }

  @optionalTypeArgs
  R maybeMap<R extends Object>({
    R Function(T value)? success,
    R Function(dynamic value)? error,
    required R Function() orElse,
  }) {
    checkNotNull(orElse);
    if (isValue && success != null) {
      return success(asValue!.value);
    } else if (isError && orElse != null) {
      return error!(asError!.error);
    }
    return orElse();
  }
}
