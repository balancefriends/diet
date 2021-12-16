import 'natural_ordering.dart';
import 'nulls_first_ordering.dart';
import 'nulls_last_ordering.dart';
import 'reverse_ordering.dart';

mixin Comparator<T> {
  int compare(T left, T right);
}

abstract class Ordering<T> with Comparator<T> {
  // Natural order

  /// Returns a serializable ordering that uses the natural order of the values. The ordering throws
  /// a {@link NullPointerException} when passed a null parameter.
  ///
  /// <p>The type specification is {@code <C extends Comparable>}, instead of the technically correct
  /// {@code <C extends Comparable<? super C>>}, to support legacy types from before Java 5.
  ///
  /// <p><b>Java 8 users:</b> use {@link Comparator#naturalOrder} instead.
  static Ordering<C> natural<C extends Comparable>() {
    return NaturalOrdering.INSTANCE as Ordering<C>;
  }

  /// Returns an ordering that treats {@code null} as less than all other values and uses {@code
  /// this} to compare non-null values.
  ///
  /// <p><b>Java 8 users:</b> Use {@code Comparator.nullsFirst(thisComparator)} instead.
  // type parameter <S> lets us avoid the extra <String> in statements like:
  // Ordering<String> o = Ordering.<String>natural().nullsFirst();
  Ordering<S?> nullsFirst<S extends T>() {
    return NullsFirstOrdering<S>(this as Ordering<S>);
  }

  /// Returns an ordering that treats {@code null} as greater than all other values and uses this
  /// ordering to compare non-null values.
  ///
  /// <p><b>Java 8 users:</b> Use {@code Comparator.nullsLast(thisComparator)} instead.
  // type parameter <S> lets us avoid the extra <String> in statements like:
  // Ordering<String> o = Ordering.<String>natural().nullsLast();
  Ordering<S?> nullsLast<S extends T>() {
    return NullsLastOrdering<S>(this as Ordering<S>);
  }

  /// Returns the reverse of this ordering; the {@code Ordering} equivalent to {@link
  /// Collections#reverseOrder(Comparator)}.
  ///
  /// <p><b>Java 8 users:</b> Use {@code thisComparator.reversed()} instead.
  // type parameter <S> lets us avoid the extra <String> in statements like:
  // Ordering<String> o = Ordering.<String>natural().reverse();
  Ordering<S?> reverse<S extends T>() {
    return ReverseOrdering(this);
  }

  E min<E extends T>(E a, E b) {
    return compare(a, b) <= 0 ? a : b;
  }

  E max<E extends T>(E a, E b) {
    return compare(a, b) >= 0 ? a : b;
  }

  static final int LEFT_IS_GREATER = 1;
  static final int RIGHT_IS_GREATER = -1;
}
