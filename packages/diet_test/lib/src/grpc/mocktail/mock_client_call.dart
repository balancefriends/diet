import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

/// Dependency: Mocktail
class MockClientCall<Q, R> extends Mock implements ClientCall<Q, R> {
  MockClientCall(
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
