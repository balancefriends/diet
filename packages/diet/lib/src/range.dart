import 'dart:collection';

/// Notation	Definition	      Factory method
/// (a..b)	  {x | a < x < b}	  open
/// [a..b]	  {x | a <= x <= b}	closed
/// (a..b]	  {x | a < x <= b}	openClosed
/// [a..b)	  {x | a <= x < b}	closedOpen
/// (a..+∞)	  {x | x > a}	      greaterThan
/// [a..+∞)	  {x | x >= a}	    atLeast
/// (-∞..b)	  {x | x < b}	      lessThan
/// (-∞..b]	  {x | x <= b}	    atMost
/// (-∞..+∞)	{x}	all
//TODO(Amond): implement
class Range<T extends num> {
  final Cut lowerBound;
  final Cut upperBound;

  Range({Cut<num>? lowerBound, Cut<num>? upperBound})
      : lowerBound =
            Cut.closed(lowerBound?.value.toDouble() ?? double.negativeInfinity),
        upperBound =
            Cut.closed(upperBound?.value.toDouble() ?? double.infinity);

  /// Returns `true` if `value` is within the bounds of this range. For example, on the
  /// range `[0..2)`, `contains(1)` returns `true`, while `contains(2)`
  /// returns `false`.
  bool contains(T value) {
    return lowerBound.isLessThan(value.toDouble()) &&
        upperBound.isGreaterThan(value.toDouble());
  }

  // Computed properties
  bool get ascending => lowerBound.value <= upperBound.value;

  bool encloses(Range<T> other) {
    return lowerBound.compareTo(other.lowerBound) <= 0 &&
        upperBound.compareTo(other.upperBound) >= 0;
  }

  Range<T> gap(Range<T> other) {
    final isThisFirst = lowerBound.compareTo(other.lowerBound) < 0;
    final firstRange = isThisFirst ? this : other;
    final secondRange = isThisFirst ? other : this;
    return Range<T>(
        lowerBound: firstRange.upperBound, upperBound: secondRange.lowerBound);
  }

  /// Returns the minimal range that {@linkplain #encloses encloses} both this range and {@code
  /// other}. For example, the span of {@code [1..3]} and {@code (5..7)} is {@code [1..7)}.
  ///
  /// <p><i>If</i> the input ranges are {@linkplain #isConnected connected}, the returned range can
  /// also be called their <i>union</i>. If they are not, note that the span might contain values
  /// that are not contained in either input range.
  ///
  /// <p>Like {@link #intersection(Range) intersection}, this operation is commutative, associative
  /// and idempotent. Unlike it, it is always well-defined for any two input ranges.
  Range<T> span(Range<T> other) {
    var lowerCmp = lowerBound.compareTo(other.lowerBound);
    var upperCmp = upperBound.compareTo(other.upperBound);
    if (lowerCmp <= 0 && upperCmp >= 0) {
      return this;
    } else if (lowerCmp >= 0 && upperCmp <= 0) {
      return other;
    } else {
      var newLower = (lowerCmp <= 0) ? lowerBound : other.lowerBound;
      var newUpper = (upperCmp >= 0) ? upperBound : other.upperBound;
      return Range(lowerBound: newLower, upperBound: newUpper);
    }
  }

  /// Notation : (a..b)
  /// {x | a < x < b}
  factory Range.open(T lowerBound, T upperBound) {
    return Range(
        lowerBound: Cut.open(lowerBound), upperBound: Cut.open(upperBound));
  }

  /// {x | a <= x <= b}
  factory Range.closed(T lowerBound, T upperBound) {
    return Range(
        lowerBound: Cut.closed(lowerBound), upperBound: Cut.closed(upperBound));
  }

  /// {x | a < x <= b}
  factory Range.openClosed(T lowerBound, T upperBound) {
    return Range(
        lowerBound: Cut.open(lowerBound), upperBound: Cut.closed(upperBound));
  }

  /// {x | a <= x < b}
  factory Range.closedOpen(T lowerBound, T upperBound) {
    return Range(
        lowerBound: Cut.closed(lowerBound), upperBound: Cut.open(upperBound));
  }

  /// {x | x > a}
  factory Range.greaterThan(T lowerBound) {
    return Range(lowerBound: Cut.closed(lowerBound));
  }

  /// {x | x >= a}
  factory Range.atLeast(T lowerBound) {
    return Range(lowerBound: Cut.open(lowerBound));
  }

  /// {x | x < b}
  factory Range.lessThan(T upperBound) {
    return Range(upperBound: Cut.closed(upperBound));
  }

  /// {x | x <= b}
  factory Range.atMost(T upperBound) {
    return Range(upperBound: Cut.open(upperBound));
  }

  /// {x}
  factory Range.all() {
    return Range();
  }

  factory Range.create(Cut<T>? lowerBound, Cut<T>? upperBound) {
    return Range(lowerBound: lowerBound, upperBound: upperBound);
  }
}

class Cut<T extends num> implements Comparable<Cut<T>> {
  final T value;
  final bool closed;

  Cut(this.value, {this.closed = true});

  factory Cut.open(T value) => Cut(value, closed: false);

  factory Cut.closed(T value) => Cut(value, closed: true);

  @override
  int compareTo(Cut<T> other) {
    return value.compareTo(other.value);
  }

  bool isLessThan(T other) {
    return value.toDouble() < other.toDouble() || (closed && value == other);
  }

  bool isGreaterThan(T other) {
    return value > other || (closed && value == other);
    ;
  }
}

class IntRage extends Range<int> {}

class DoubleRage extends Range<double> {}
