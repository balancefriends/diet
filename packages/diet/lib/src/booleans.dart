import 'dart:core';

class BooleanComparator {
  final int _trueValue;
  final String _toString;

  BooleanComparator(this._trueValue, this._toString);

  int compare(bool a, bool b) {
    int aVal = a ? _trueValue : 0;
    int bVal = b ? _trueValue : 0;
    return bVal - aVal;
  }

  @override
  String toString() => _toString;
}

class Booleans {
  static BooleanComparator get trueFirst =>
      BooleanComparator(1, 'Booleans.trueFirst()');

  static BooleanComparator get falseFirst =>
      BooleanComparator(-1, 'Booleans.falseFirst()');

  static int hashCodes(bool value) {
    return value ? 1231 : 1237;
  }

  static int compare(bool a, bool b) {
    return (a == b) ? 0 : (a ? 1 : -1);
  }
}
