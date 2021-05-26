import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

/// Dependency: Mocktail
class MockResponseFuture<T> extends Mock implements ResponseFuture<T> {
  final Future<T> future;
  final Map<String, String> _trailer;

  MockResponseFuture.value(T value)
      : future = Future.value(value),
        _trailer = {'grpc-status': '0'};

  MockResponseFuture.error(Object error)
      : future = Future.error(error),
        _trailer = {'grpc-status': '2'};

  MockResponseFuture.future(this.future) : _trailer = {'grpc-status': '0'};

  @override
  Future<Map<String, String>> get trailers async => _trailer;

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      future.catchError(onError, test: test);

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      future.then(onValue, onError: onError);
}
