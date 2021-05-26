import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mockito/mockito.dart';

/// Dependency: Mockito
class FakeClientCall<Q, R> extends Fake implements ClientCall<Q, R> {
  FakeClientCall(
    this.result,
  ) {
    result.then((value) {
      _responses.add(value);
      _responses.close();
    }).catchError((error) {
      _responses.addError(error);
      _responses.close();
    });
  }

  final Future<R> result;
  final StreamController<R> _responses = StreamController<R>();

  @override
  Stream<R> get response => _responses.stream;
}
