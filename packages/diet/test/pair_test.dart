import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  final p = Pair(1, 'a');

  test('pair first and second', () {
    expect(p.first, 1);
    expect(p.second, 'a');
  });

  test('pair to String', () {
    expect(p.toString(), '(1, a)');
  });

  test('pair equals', () {
    expect(p, Pair(1, 'a'));
    expect(p, isNot(equals(Pair(2, 'a'))));
    expect(p, isNot(equals(Pair(2, 'b'))));

    expect(p, isNot(equals(null)));
  });

  test('pair hash code', () {
    expect(p.hashCode, Pair(1, 'a').hashCode);
    expect(p.hashCode, isNot(equals(Pair(null, 'a').hashCode)));
    expect(p.hashCode, isNot(equals(Pair('b', null).hashCode)));

    expect(Pair(null, null).hashCode, 0);
  });

  test('pair hash set', () {
    final s = {Pair(1, 'a'), Pair(1, 'b'), Pair(1, 'a')};

    expect(s.length, 2);
    expect(s, contains(p));
  });

  test('pair to list', () {
    expect(1.to(2).toList(), [1, 2]);
    expect(1.to(null).toList(), [1, null]);
    expect(1.to('2').toList(), [1, '2']);
  });
}
