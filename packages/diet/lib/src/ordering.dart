abstract class Ordering<T> implements Comparable<T> {
  // Natural order

  /**
   * Returns a serializable ordering that uses the natural order of the values. The ordering throws
   * a {@link NullPointerException} when passed a null parameter.
   *
   * <p>The type specification is {@code <C extends Comparable>}, instead of the technically correct
   * {@code <C extends Comparable<? super C>>}, to support legacy types from before Java 5.
   *
   * <p><b>Java 8 users:</b> use {@link Comparator#naturalOrder} instead.
   */
  static Ordering<C> natural<C extends Comparable>() {
    return NaturalOrdering.INSTANCE(Ordering<C>);
  }

  Ordering<S?> nullsFirst <S extends T>() {
    return NullsFirstOrdering<S>(this);
  }

  //@override
  int compare( Object? left, Object? right) {
    if (left == right) {
      return 0;
    } else if (left == null) {
      return -1;
    } else if (right == null) {
      return 1;
    }
    int leftCode = identityHashCode(left);
    int rightCode = identityHashCode(right);
    if (leftCode != rightCode) {
      return leftCode < rightCode ? -1 : 1;
    }

    // identityHashCode collision (rare, but not as rare as you'd think)
    int result = getUid(left).compareTo(getUid(right));
    if (result == 0) {
      throw new AssertionError(); // extremely, extremely unlikely.
    }
    return result;
  }
}

