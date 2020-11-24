import 'package:quiver/check.dart';

extension DietStringExtension on String {
  String runeSubstring(int start, [int end]) {
    if (end != null) {
      checkListIndex(end, runes.length);
    }
    return String.fromCharCodes(runes.toList().sublist(start, end));
  }

  String runeSlice(int start, [int end]) {
    if (end != null) {
      checkListIndex(end, runes.length);
    }
    return String.fromCharCodes(runes.toList().sublist(start, end));
  }
}
