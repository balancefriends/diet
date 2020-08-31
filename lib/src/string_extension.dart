extension DietStringExtension on String {
  String runeSubstring(int start, [int end]) {
    return String.fromCharCodes(runes.toList().sublist(start, end));
  }
}
