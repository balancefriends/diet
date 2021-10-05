import 'package:test/test.dart';
import 'package:diet/diet.dart';
import 'package:async/async.dart';

void main() {
  test('map test', () {
    final result = Result.value(1);

    final s = result.map((v) => v.toString());

    expect(s, ValueResult('1'));
  });

  test('mapError test', () {
    final result = Result.error(1);

    final s = result.mapError((v) => v.toString());

    expect(s, ErrorResult('1'));
  });

  test('mapBoth test', () {
    final result = Result.error(1);

    final s = result.mapBoth((v) => v.toString(), (e) => e.toString());
    expect(s, ErrorResult('1'));

    final e = s.mapBoth((v) => v.toString(), (e) => int.tryParse(e));
    expect(e, ErrorResult(1));
  });

  test('flatMap test', () {
    final result = Result.value(1);

    final v = result.flatMap((v) => Result.value(v.toString()));
    expect(v, ValueResult('1'));

    final e = result.flatMap((v) => Result.error(v.toString()));
    expect(e, ErrorResult('1'));
  });

  test('flatMapError test', () {
    final result = Result.error(1);

    final v = result.flatMapError((v) => Result.value(v.toString()));
    expect(v, ValueResult('1'));

    final e = result.flatMapError((v) => Result.error(v.toString()));
    expect(e, ErrorResult('1'));
  });

  test('onValue test', () {
    final result = Result.value(1);

    var value = 0;
    result.onValue((v) => value = v);
    expect(value, 1);
  });

  test('onError test', () {
    final result = Result.error(1);

    var error = 0;
    result.onError((e) => error = e);
    expect(error, 1);
  });
}
