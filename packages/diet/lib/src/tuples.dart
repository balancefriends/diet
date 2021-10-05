/// Represents a generic pair of two values.
///
/// There is no meaning attached to values in this class, it can be used for
/// any purpose. Pair exhibits value semantics, i.e. two pairs are equal if
/// both components are equal.
///
/// [A] : type of the first value
/// [B] : type of the second value
class Pair<A, B> {
  /// [first] : First value
  final A first;

  /// [second] : Second value
  final B second;

  const Pair(this.first, this.second);

  /// Returns string representation of the [Pair] including its [first] and [second] values.
  @override
  String toString() => '($first, $second)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

extension PairX<T> on Pair<T, T> {
  /// Converts this pair into a list.
  List<T> toList() {
    return [first, second];
  }
}

extension PairInline<A, B> on A {
  /// Creates a tuple of type [Pair] from this and [that].
  Pair<A, B> to(B that) => Pair(this, that);
}

/// Represents a triad of values
///
/// There is no meaning attached to values in this class, it can be used for any purpose.
/// Triple exhibits value semantics, i.e. two triples are equal if all three components are equal.
/// An example of decomposing it into values:
///
/// [A] type of the first value.
/// [B] type of the second value.
/// [C] type of the third value.
/// [first] First value.
/// [second] Second value.
/// [third] Third value.
class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;

  const Triple(this.first, this.second, this.third);

  /// Returns string representation of the [Triple] including its [first],
  /// [second] and [third] values.
  @override
  String toString() => '($first, $second, $third)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Triple &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;
}

extension TripleX<T> on Triple<T, T, T> {
  List<T> toList() {
    return [first, second, third];
  }
}
