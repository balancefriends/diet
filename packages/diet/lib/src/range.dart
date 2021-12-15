import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiver/check.dart';

import 'bound_type.dart';
import 'cut.dart';
import 'discrete_domain.dart';

// name:

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
class Range<C extends Comparable> {
  /// Returns a range that contains all values strictly greater than {@code lower} and strictly less
  /// than {@code upper}.
  ///
  /// @throws IllegalArgumentException if {@code lower} is greater than <i>or equal to</i> {@code
  ///     upper}
  /// @throws ClassCastException if {@code lower} and {@code upper} are not mutually comparable
  /// @since 14.0
  static Range<C> open<C extends Comparable>(C lower, C upper) {
    return create(Cut.aboveValue(lower), Cut.belowValue(upper));
  }

  /// Returns a range that contains all values greater than or equal to {@code lower} and less than
  /// or equal to {@code upper}.
  ///
  /// @throws IllegalArgumentException if {@code lower} is greater than {@code upper}
  /// @throws ClassCastException if {@code lower} and {@code upper} are not mutually comparable
  /// @since 14.0
  static Range<C> closed<C extends Comparable>(C lower, C upper) {
    return create(Cut.belowValue(lower), Cut.aboveValue(upper));
  }

  /// Returns a range that contains all values greater than or equal to {@code lower} and strictly
  /// less than {@code upper}.
  ///
  /// @throws IllegalArgumentException if {@code lower} is greater than {@code upper}
  /// @throws ClassCastException if {@code lower} and {@code upper} are not mutually comparable
  /// @since 14.0
  static Range<C> closedOpen<C extends Comparable>(C lower, C upper) {
    return create(Cut.belowValue(lower), Cut.belowValue(upper));
  }

  /**
   * Returns a range that contains all values strictly greater than {@code lower} and less than or
   * equal to {@code upper}.
   *
   * @throws IllegalArgumentException if {@code lower} is greater than {@code upper}
   * @throws ClassCastException if {@code lower} and {@code upper} are not mutually comparable
   * @since 14.0
   */
  static Range<C> openClosed<C extends Comparable>(C lower, C upper) {
    return create(Cut.aboveValue(lower), Cut.aboveValue(upper));
  }

  /**
   * Returns a range that contains any value from {@code lower} to {@code upper}, where each
   * endpoint may be either inclusive (closed) or exclusive (open).
   *
   * @throws IllegalArgumentException if {@code lower} is greater than {@code upper}
   * @throws ClassCastException if {@code lower} and {@code upper} are not mutually comparable
   * @since 14.0
   */
  static Range<C> range<C extends Comparable>(
      C lower, BoundType lowerType, C upper, BoundType upperType) {
    checkNotNull(lowerType);
    checkNotNull(upperType);

    Cut<C> lowerBound = (lowerType == BoundType.open)
        ? Cut.aboveValue(lower)
        : Cut.belowValue(lower);
    Cut<C> upperBound = (upperType == BoundType.open)
        ? Cut.belowValue(upper)
        : Cut.aboveValue(upper);
    return create(lowerBound, upperBound);
  }

  /// Returns a range that contains all values strictly less than {@code endpoint}.
  ///
  /// @since 14.0
  static Range<C> lessThan<C extends Comparable>(C endpoint) {
    return create(Cut.belowAll<C>(), Cut.belowValue(endpoint));
  }

  /// Returns a range that contains all values less than or equal to {@code endpoint}.
  ///
  /// @since 14.0
  static Range<C> atMost<C extends Comparable>(C endpoint) {
    return create(Cut.belowAll<C>(), Cut.aboveValue(endpoint));
  }

  /**
   * Returns a range with no lower bound up to the given endpoint, which may be either inclusive
   * (closed) or exclusive (open).
   *
   * @since 14.0
   */
  static Range<C> upTo<C extends Comparable>(C endpoint, BoundType boundType) {
    switch (boundType) {
      case BoundType.open:
        return lessThan(endpoint);
      case BoundType.closed:
        return atMost(endpoint);
      default:
        throw AssertionError();
    }
  }

  /// Returns a range that contains all values strictly greater than {@code endpoint}.
  ///
  /// @since 14.0
  static Range<C> greaterThan<C extends Comparable>(C endpoint) {
    return create(Cut.aboveValue(endpoint), Cut.aboveAll<C>());
  }

  /// Returns a range that contains all values greater than or equal to {@code endpoint}.
  ///
  /// @since 14.0
  static Range<C> atLeast<C extends Comparable>(C endpoint) {
    return create(Cut.belowValue(endpoint), Cut.aboveAll<C>());
  }

  /// Returns a range from the given endpoint, which may be either inclusive (closed) or exclusive
  /// (open), with no upper bound.
  ///
  /// @since 14.0
  static Range<C> downTo<C extends Comparable>(
      C endpoint, BoundType boundType) {
    switch (boundType) {
      case BoundType.open:
        return greaterThan(endpoint);
      case BoundType.closed:
        return atLeast(endpoint);
      default:
        throw AssertionError();
    }
  }

  static final Range<Comparable> _ALL = Range._(Cut.belowAll(), Cut.aboveAll());

  /// Returns a range that contains every value of type {@code C}.
  ///
  /// @since 14.0
  static Range<C> all<C extends Comparable>() {
    return _ALL as Range<C>;
  }

  /// Returns a range that {@linkplain Range#contains(Comparable) contains} only the given value. The
  /// returned range is {@linkplain BoundType#CLOSED closed} on both ends.
  ///
  /// @since 14.0
  static Range<C> singleton<C extends Comparable>(C value) {
    return closed(value, value);
  }

  /**
   * Returns the minimal range that {@linkplain Range#contains(Comparable) contains} all of the
   * given values. The returned range is {@linkplain BoundType#CLOSED closed} on both ends.
   *
   * @throws ClassCastException if the values are not mutually comparable
   * @throws NoSuchElementException if {@code values} is empty
   * @throws NullPointerException if any of {@code values} is null
   * @since 14.0
   */
  static Range<C> encloseAll<C extends Comparable>(Iterable<C> values) {
    checkNotNull(values);

    Iterator<C> valueIterator = values.iterator;
    C min = checkNotNull(valueIterator.current);
    C max = min;
    while (valueIterator.moveNext()) {
      C value = checkNotNull(valueIterator.current);
      min = Ordering.natural().min(min, value);
      max = Ordering.natural().max(max, value);
    }
    return closed(min, max);
  }

  final Cut<C> lowerBound;
  final Cut<C> upperBound;

  Range._(this.lowerBound, this.upperBound) {
    if (lowerBound.compareTo(upperBound) > 0 ||
        lowerBound == Cut.aboveAll<C>() ||
        upperBound == Cut.belowAll<C>()) {
      throw ArgumentError('Invalid Rage');
    }
  }

  /// Returns `true` if this range has a lower endpoint.
  bool get hasLowerBound => lowerBound != Cut.belowAll();

  /// Returns the lower endpoint of this range.
  ///
  /// @throws IllegalStateException if this range is unbounded below (that is, {@link
  ///     #hasLowerBound()} returns {@code false})
  C lowerEndpoint() {
    return lowerBound.endpoint;
  }

  /// Returns the type of this range's lower bound: {@link BoundType#CLOSED} if the range includes
  /// its lower endpoint, {@link BoundType#OPEN} if it does not.
  ///
  /// @throws IllegalStateException if this range is unbounded below (that is, {@link
  ///     #hasLowerBound()} returns {@code false})
  BoundType lowerBoundType() {
    return lowerBound.typeAsLowerBound();
  }

  /// Returns {@code true} if this range has an upper endpoint. */
  bool hasUpperBound() {
    return upperBound != Cut.aboveAll();
  }

  /// Returns the upper endpoint of this range.
  ///
  /// @throws IllegalStateException if this range is unbounded above (that is, {@link
  ///     #hasUpperBound()} returns {@code false})
  C upperEndpoint() {
    return upperBound.endpoint;
  }

  /// Returns the type of this range's upper bound: {@link BoundType#CLOSED} if the range includes
  /// its upper endpoint, {@link BoundType#OPEN} if it does not.
  ///
  /// @throws IllegalStateException if this range is unbounded above (that is, {@link
  ///     #hasUpperBound()} returns {@code false})
  BoundType upperBoundType() {
    return upperBound.typeAsUpperBound();
  }

  /// Returns {@code true} if this range is of the form {@code [v..v)} or {@code (v..v]}. (This does
  /// not encompass ranges of the form {@code (v..v)}, because such ranges are <i>invalid</i> and
  /// can't be constructed at all.)
  ///
  /// <p>Note that certain discrete ranges such as the integer range {@code (3..4)} are <b>not</b>
  /// considered empty, even though they contain no actual values. In these cases, it may be helpful
  /// to preprocess ranges with {@link #canonical(DiscreteDomain)}.
  bool isEmpty() {
    return lowerBound == upperBound;
  }

  /// Returns `true` if [value] is within the bounds of this range. For example, on the
  /// range `[0..2)`, `contains(1)` returns `true`, while `contains(2)`
  /// returns `false`.
  bool contains(C value) {
    // let this throw CCE if there is some trickery going on
    return lowerBound.isLessThan(value) && !upperBound.isLessThan(value);
  }

  /**
   * Returns {@code true} if every element in {@code values} is {@linkplain #contains contained} in
   * this range.
   */
  bool containsAll(Iterable<C> values) {
    if (values.isEmpty) {
      return true;
    }

    for (C value in values) {
      if (!contains(value)) {
        return false;
      }
    }
    return true;
  }

  /// Returns {@code true} if the bounds of {@code other} do not extend outside the bounds of this
  /// range. Examples:
  ///
  /// <ul>
  ///   <li>{@code [3..6]} encloses {@code [4..5]}
  ///   <li>{@code (3..6)} encloses {@code (3..6)}
  ///   <li>{@code [3..6]} encloses {@code [4..4)} (even though the latter is empty)
  ///   <li>{@code (3..6]} does not enclose {@code [3..6]}
  ///   <li>{@code [4..5]} does not enclose {@code (3..6)} (even though it contains every value
  ///       contained by the latter range)
  ///   <li>{@code [3..6]} does not enclose {@code (1..1]} (even though it contains every value
  ///       contained by the latter range)
  /// </ul>
  ///
  /// <p>Note that if {@code a.encloses(b)}, then {@code b.contains(v)} implies {@code
  /// a.contains(v)}, but as the last two examples illustrate, the converse is not always true.
  ///
  /// <p>Being reflexive, antisymmetric and transitive, the {@code encloses} relation defines a
  /// <i>partial order</i> over ranges. There exists a unique {@linkplain Range#all maximal} range
  /// according to this relation, and also numerous {@linkplain #isEmpty minimal} ranges. Enclosure
  /// also implies {@linkplain #isConnected connectedness}.
  bool encloses(Range<C> other) {
    return lowerBound.compareTo(other.lowerBound) <= 0 &&
        upperBound.compareTo(other.upperBound) >= 0;
  }

  /// Returns {@code true} if there exists a (possibly empty) range which is {@linkplain #encloses
  /// enclosed} by both this range and {@code other}.
  ///
  /// <p>For example,
  ///
  /// <ul>
  ///   <li>{@code [2, 4)} and {@code [5, 7)} are not connected
  ///   <li>{@code [2, 4)} and {@code [3, 5)} are connected, because both enclose {@code [3, 4)}
  ///   <li>{@code [2, 4)} and {@code [4, 6)} are connected, because both enclose the empty range
  ///       {@code [4, 4)}
  /// </ul>
  ///
  /// <p>Note that this range and {@code other} have a well-defined {@linkplain #span union} and
  /// {@linkplain #intersection intersection} (as a single, possibly-empty range) if and only if this
  /// method returns {@code true}.
  ///
  /// <p>The connectedness relation is both reflexive and symmetric, but does not form an {@linkplain
  /// Equivalence equivalence relation} as it is not transitive.
  ///
  /// <p>Note that certain discrete ranges are not considered connected, even though there are no
  /// elements "between them." For example, {@code [3, 5]} is not considered connected to {@code [6,
  /// 10]}. In these cases, it may be desirable for both input ranges to be preprocessed with {@link
  /// #canonical(DiscreteDomain)} before testing for connectedness.
  bool isConnected(Range<C> other) {
    return lowerBound.compareTo(other.upperBound) <= 0 &&
        other.lowerBound.compareTo(upperBound) <= 0;
  }

  /**
   * Returns the maximal range {@linkplain #encloses enclosed} by both this range and {@code
   * connectedRange}, if such a range exists.
   *
   * <p>For example, the intersection of {@code [1..5]} and {@code (3..7)} is {@code (3..5]}. The
   * resulting range may be empty; for example, {@code [1..5)} intersected with {@code [5..7)}
   * yields the empty range {@code [5..5)}.
   *
   * <p>The intersection exists if and only if the two ranges are {@linkplain #isConnected
   * connected}.
   *
   * <p>The intersection operation is commutative, associative and idempotent, and its identity
   * element is {@link Range#all}).
   *
   * @throws IllegalArgumentException if {@code isConnected(connectedRange)} is {@code false}
   */
  Range<C> intersection(Range<C> connectedRange) {
    int lowerCmp = lowerBound.compareTo(connectedRange.lowerBound);
    int upperCmp = upperBound.compareTo(connectedRange.upperBound);
    if (lowerCmp >= 0 && upperCmp <= 0) {
      return this;
    } else if (lowerCmp <= 0 && upperCmp >= 0) {
      return connectedRange;
    } else {
      Cut<C> newLower =
          (lowerCmp >= 0) ? lowerBound : connectedRange.lowerBound;
      Cut<C> newUpper =
          (upperCmp <= 0) ? upperBound : connectedRange.upperBound;

      // create() would catch this, but give a confusing error message
      checkArgument(
        newLower.compareTo(newUpper) <= 0,
        message:
            "intersection is undefined for disconnected ranges $this and $connectedRange",
      );

      // TODO(kevinb): all the precondition checks in the constructor are redundant...
      return create(newLower, newUpper);
    }
  }

  /**
   * Returns the maximal range lying between this range and {@code otherRange}, if such a range
   * exists. The resulting range may be empty if the two ranges are adjacent but non-overlapping.
   *
   * <p>For example, the gap of {@code [1..5]} and {@code (7..10)} is {@code (5..7]}. The resulting
   * range may be empty; for example, the gap between {@code [1..5)} {@code [5..7)} yields the empty
   * range {@code [5..5)}.
   *
   * <p>The gap exists if and only if the two ranges are either disconnected or immediately adjacent
   * (any intersection must be an empty range).
   *
   * <p>The gap operation is commutative.
   *
   * @throws IllegalArgumentException if this range and {@code otherRange} have a nonempty
   *     intersection
   * @since 27.0
   */
  Range<C> gap(Range<C> otherRange) {
    /*
     * For an explanation of the basic principle behind this check, see
     * https://stackoverflow.com/a/35754308/28465
     *
     * In that explanation's notation, our `overlap` check would be `x1 < y2 && y1 < x2`. We've
     * flipped one part of the check so that we're using "less than" in both cases (rather than a
     * mix of "less than" and "greater than"). We've also switched to "strictly less than" rather
     * than "less than or equal to" because of *handwave* the difference between "endpoints of
     * inclusive ranges" and "Cuts."
     */
    if (lowerBound.compareTo(otherRange.upperBound) < 0 &&
        otherRange.lowerBound.compareTo(upperBound) < 0) {
      throw ArgumentError(
          "Ranges have a nonempty intersection: $this, $otherRange");
    }

    bool isThisFirst = this.lowerBound.compareTo(otherRange.lowerBound) < 0;
    Range<C> firstRange = isThisFirst ? this : otherRange;
    Range<C> secondRange = isThisFirst ? otherRange : this;
    return create(firstRange.upperBound, secondRange.lowerBound);
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
  Range<C> span(Range<C> other) {
    int lowerCmp = lowerBound.compareTo(other.lowerBound);
    int upperCmp = upperBound.compareTo(other.upperBound);
    if (lowerCmp <= 0 && upperCmp >= 0) {
      return this;
    } else if (lowerCmp >= 0 && upperCmp <= 0) {
      return other;
    } else {
      Cut<C> newLower = (lowerCmp <= 0) ? lowerBound : other.lowerBound;
      Cut<C> newUpper = (upperCmp >= 0) ? upperBound : other.upperBound;
      return create(newLower, newUpper);
    }
  }

  /// Returns the canonical form of this range in the given domain. The canonical form has the
  /// following properties:
  ///
  /// <ul>
  ///   <li>equivalence: {@code a.canonical().contains(v) == a.contains(v)} for all {@code v} (in
  ///       other words, {@code ContiguousSet.create(a.canonical(domain), domain).equals(
  ///       ContiguousSet.create(a, domain))}
  ///   <li>uniqueness: unless {@code a.isEmpty()}, {@code ContiguousSet.create(a,
  ///       domain).equals(ContiguousSet.create(b, domain))} implies {@code
  ///       a.canonical(domain).equals(b.canonical(domain))}
  ///   <li>idempotence: {@code a.canonical(domain).canonical(domain).equals(a.canonical(domain))}
  /// </ul>
  ///
  /// <p>Furthermore, this method guarantees that the range returned will be one of the following
  /// canonical forms:
  ///
  /// <ul>
  ///   <li>[start..end)
  ///   <li>[start..+∞)
  ///   <li>(-∞..end) (only if type {@code C} is unbounded below)
  ///   <li>(-∞..+∞) (only if type {@code C} is unbounded below)
  /// </ul>
  Range<C> canonical(DiscreteDomain<C> domain) {
    checkNotNull(domain);
    Cut<C> lower = lowerBound.canonical(domain);
    Cut<C> upper = upperBound.canonical(domain);
    return (lower == lowerBound && upper == upperBound)
        ? this
        : create(lower, upper);
  }

  @override
  bool operator ==(Object object) {
    if (object is Range) {
      Range other = object;
      return lowerBound == (other.lowerBound) &&
          upperBound == (other.upperBound);
    }
    return false;
  }

  /// Returns a hash code for this range.
  @override
  int get hashCode {
    return lowerBound.hashCode * 31 + upperBound.hashCode;
  }

  String toString() {
    return _toString(lowerBound, upperBound);
  }

  static String toString(Cut lowerBound, Cut upperBound) {
    StringBuffer sb = StringBuffer();
    lowerBound.describeAsLowerBound(sb);
    sb.write("..");
    upperBound.describeAsUpperBound(sb);
    return sb.toString();
  }

  Object readResolve() {
    if (this == ALL) {
      return all();
    } else {
      return this;
    }
  }

  static int compareOrThrow(Comparable left, Comparable right) {
    return left.compareTo(right);
  }
}

class IntRage extends Range<int> {}

class DoubleRage extends Range<double> {}
