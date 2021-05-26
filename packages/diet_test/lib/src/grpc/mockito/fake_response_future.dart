import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mockito/mockito.dart';

/// Dependency: Mockito
class FakeResponseFuture<T> extends Fake implements ResponseFuture<T> {
  final Future<T> future;
  final Map<String, String> _trailer;

  FakeResponseFuture.value(T value)
      : future = Future.value(value),
        _trailer = {'grpc-status': '0'};

  FakeResponseFuture.error(Object error)
      : future = Future.error(error),
        _trailer = {'grpc-status': '2'};

  FakeResponseFuture.future(this.future) : _trailer = {'grpc-status': '0'};

  @override
  Future<Map<String, String>> get trailers async => _trailer;

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      future.catchError(onError, test: test);

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      future.then(onValue, onError: onError);
}
