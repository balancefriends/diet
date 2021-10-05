import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  final t = Triple(1, 'a', 0.07);

  test('triple first and second', () {
    expect(t.first, 1);
    expect(t.second, 'a');
    expect(t.third, 0.07);
  });

  test('triple to String', () {
    expect(t.toString(), '(1, a, 0.07)');
  });

  test('triple equals', () {
    expect(t, Triple(1, 'a', 0.07));
    expect(t, isNot(equals(Triple(2, 'a', 0.07))));
    expect(t, isNot(equals(Triple(1, 'b', 0.07))));
    expect(t, isNot(equals(Triple(1, 'a', 0.1))));

    expect(t, isNot(equals(null)));
  });

  test('triple hash code', () {
    expect(t.hashCode, Triple(1, 'a', 0.07).hashCode);
    expect(t.hashCode, isNot(equals(Triple(2, 'a', 0.07).hashCode)));

    expect(Triple(null, 'b', 0.07).hashCode, isNot(0));
    expect(Triple('b', null, 0.07).hashCode, isNot(0));
    expect(Triple('b', 1, null).hashCode, isNot(0));
    expect(Triple(null, null, null).hashCode, isNot(0));
  });

  test('triple hash set', () {
    final s = {
      Triple(1, 'a', 0.07),
      Triple(1, 'b', 0.07),
      Triple(1, 'a', 0.07)
    };

    expect(s.length, 2);
    expect(s, contains(t));
  });

  test('triple to list', () {
    expect(Triple(1, 2, 3).toList(), [1, 2, 3]);
    expect(Triple(1, null, 3).toList(), [1, null, 3]);
    expect(Triple(1, 2, '3').toList(), [1, 2, '3']);
  });
}
