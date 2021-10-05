import 'package:async/async.dart' as $async;
import 'package:meta/meta.dart';

import 'tuples.dart';

extension ResultExtension<V> on $async.Result<V> {
  bool get isSuccess => isValue;

  bool get hasValue => isValue && asValue!.value != null;

  V get value => asValue!.value;

  Object get error => asError!.error;

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
      {required TResult Function(V value) success,
      required TResult Function(dynamic error) error}) {
    if (isValue) {
      return success(asValue!.value);
    } else {
      return error(asError!.error);
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(V value)? success,
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

  $async.Result<U> map<U>(U Function(V) transform) {
    if (isValue) {
      return $async.Result.value(transform(asValue!.value));
    } else {
      return $async.Result.error(asError!.error);
    }
  }

  $async.Result<V> mapError(dynamic Function(dynamic) transform) {
    if (isValue) {
      return $async.Result.value(asValue!.value);
    } else {
      return $async.Result.error(transform(asError!.error));
    }
  }

  $async.Result<U> mapBoth<U>(
      U Function(V) transformValue, dynamic Function(dynamic) transformError) {
    if (isValue) {
      return $async.Result.value(transformValue(asValue!.value));
    } else {
      return $async.Result.error(transformError(asError!.error));
    }
  }

  $async.Result<U> flatMap<U>($async.Result<U> Function(V) transform) {
    if (isValue) {
      return transform(asValue!.value);
    } else {
      return $async.Result.error(asError!.error);
    }
  }

  $async.Result<V> flatMapError($async.Result<V> Function(dynamic) transform) {
    if (isValue) {
      return $async.Result.value(asValue!.value);
    } else {
      return transform(asError!.error);
    }
  }

  $async.Result<V> onValue(Function(V) f) => fold((v) {
        f(asValue!.value);
        return this;
      }, (_) => this);

  $async.Result<V> onSuccess(Function(V) f) => onValue(f);

  $async.Result<V> onError(Function(dynamic) f) => fold((_) => this, (_) {
        f(asError!.error);
        return this;
      });

  $async.Result<V> onFailure(Function(dynamic) f) => onError(f);

  X fold<X>(X Function(V) success, X Function(dynamic) failure) {
    if (isValue) {
      return success(asValue!.value);
    } else {
      return failure(asError!.error);
    }
  }

  $async.Result<Pair<V, U>> fanout<U>($async.Result<U> Function() other) =>
      flatMap((outer) => other().map((v) => Pair(outer, v)));

  bool any(bool Function(V) predicate) {
    if (isValue) {
      return predicate(asValue!.value);
    } else {
      return false;
    }
  }
}

extension FutureResultX<V> on Future<$async.Result<V>> {
  Future<$async.Result<U>> map<U>(U Function(V) transform) =>
      then((result) => result.map(transform));

  Future<$async.Result<V>> mapError(dynamic Function(dynamic) transform) =>
      then((result) => result.mapError(transform));

  Future<$async.Result<U>> mapBoth<U>(U Function(V) transformValue,
          dynamic Function(dynamic) transformError) =>
      then((result) => result.mapBoth(transformValue, transformError));

  Future<$async.Result<U>> flatMap<U>($async.Result<U> Function(V) transform) =>
      then((result) => result.flatMap(transform));

  Future<$async.Result<V>> flatMapError(
          $async.Result<V> Function(dynamic) transform) =>
      then((result) => result.flatMapError(transform));

  Future<$async.Result<V>> onValue(Function(V) f) =>
      then((result) => result.onValue(f));

  Future<$async.Result<V>> onSuccess(Function(V) f) => onValue(f);

  Future<$async.Result<V>> onError(Function(dynamic) f) =>
      then((result) => result.onError(f));

  Future<$async.Result<V>> onFailure(Function(dynamic) f) => onError(f);

  Future<X> fold<X>(X Function(V) success, X Function(dynamic) failure) =>
      then((result) => result.fold(success, failure));

  Future<bool> any(bool Function(V) predicate) =>
      then((result) => result.any(predicate));
}
