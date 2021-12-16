import 'ordering.dart';

class NullsFirstOrdering<T extends Object?> extends Ordering<T> {
  final Ordering<T> ordering;

  NullsFirstOrdering(this.ordering);

  @override
  int compare(T left, T right) {
    if (left == right) {
      return 0;
    }
    if (left == null) {
      return Ordering.RIGHT_IS_GREATER;
    }
    if (right == null) {
      return Ordering.LEFT_IS_GREATER;
    }
    return ordering.compare(left, right);
  }

  @override
  Ordering<S?> reverse<S extends T>() {
    // ordering.reverse() might be optimized, so let it do its thing
    return ordering.reverse().nullsLast() as Ordering<S>;
  }

  @override
  Ordering<S?> nullsFirst<S extends T>() {
    return this as Ordering<S?>;
  }

  @override
  Ordering<S?> nullsLast<S extends T>() {
    return ordering.nullsLast<S>();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NullsFirstOrdering &&
          runtimeType == other.runtimeType &&
          ordering == other.ordering;

  @override
  int get hashCode => ordering.hashCode ^ 957692532; // meaningless;

  @override
  String toString() {
    return "$ordering.nullsFirst()";
  }
}
