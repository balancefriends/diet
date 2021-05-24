import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  group('open tests', () {
    test('int', () {
      var range = Range<int>.open(1, 5);
      expect(range.contains(1), isFalse);
      expect(range.contains(2), isTrue);
      expect(range.contains(5), isFalse);
    });

    test('double', () {
      var range = Range<double>.open(1, 5);
      expect(range.contains(1), isFalse);
      expect(range.contains(2), isTrue);
      expect(range.contains(5), isFalse);
    });
  });

  group('closed tests', () {
    test('int range', () {
      var range = Range<int>.closed(1, 5);
      expect(range.contains(1), isTrue);
      expect(range.contains(2), isTrue);
      expect(range.contains(5), isTrue);
      expect(range.contains(6), isFalse);
    });

    test('double range', () {
      var range = Range<double>.closed(1, 5);
      expect(range.contains(1), isTrue);
      expect(range.contains(2), isTrue);
      expect(range.contains(5), isTrue);
      expect(range.contains(6), isFalse);
    });
  });
}
