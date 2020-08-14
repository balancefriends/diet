import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  group('Range tests', () {
    test('open Test', () {
      var range = Range<int>.open(1, 5);

      expect(range.contains(2), isTrue);
    });
  });
}
