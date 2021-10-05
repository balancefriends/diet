import 'package:async/async.dart';
import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  test('map test', () async {
    final result = Future.value(Result.value(1));

    final s = await result.map((v) => v.toString());

    expect(s, ValueResult('1'));
  });

  test('mapError test', () async {
    final result = Future.value(Result.error(1));

    final s = await result.mapError((v) => v.toString());

    expect(s, ErrorResult('1'));
  });

  test('mapBoth test', () async {
    final result = Future.value(Result.error(1));

    final s = await result.mapBoth((v) => v.toString(), (e) => e.toString());
    expect(s, ErrorResult('1'));

    final e = s.mapBoth((v) => v.toString(), (e) => int.tryParse(e));
    expect(e, ErrorResult(1));
  });

  test('flatMap test', () async {
    final result = Future.value(Result.value(1));

    final v = await result.flatMap((v) => Result.value(v.toString()));
    expect(v, ValueResult('1'));

    final e = await result.flatMap((v) => Result.error(v.toString()));
    expect(e, ErrorResult('1'));
  });

  test('flatMapError test', () async {
    final result = Future.value(Result.error(1));

    final v = await result.flatMapError((v) => Result.value(v.toString()));
    expect(v, ValueResult('1'));

    final e = await result.flatMapError((v) => Result.error(v.toString()));
    expect(e, ErrorResult('1'));
  });

  test('onValue test', () async {
    final result = Future.value(Result.value(1));

    var value = 0;
    await result.onValue((v) => value = v);
    expect(value, 1);
  });

  test('onError test', () async {
    final result = Future.value(Result.error(1));

    var error = 0;
    await result.onError((e) => error = e);
    expect(error, 1);
  });
}
