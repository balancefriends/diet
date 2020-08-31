import 'package:diet/diet.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtension tests', () {
    group('Unicode Tests', () {
      test('substringUnicode Test', () {
        final emojiString = '😀😃😄';

        expect(emojiString.length, 6);
        expect(emojiString.runeSubstring(0), emojiString);
        expect(emojiString.runeSubstring(0, 2), '😀😃');
        expect(emojiString.runeSubstring(0, 1), '😀');
        expect(emojiString.runeSubstring(1, 2), '😃');
      });

      test('throw index error', () {
        final emojiString = '😀😃😄';
        expect(emojiString.runeSubstring(0), emojiString);
        expect(() => emojiString.runeSubstring(0, 4), throwsRangeError);
      });
    });
  });
}
