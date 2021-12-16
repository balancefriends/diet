import 'package:diet/diet.dart';
import 'package:diet/src/bound_type.dart';
import 'package:diet/src/cut.dart';
import 'package:diet/src/discrete_domain.dart';
import 'package:test/test.dart';

void main() {
  test('open', () {
    var range = Range.open<int>(4, 8);
    checkContains(range);
    expect(range.hasLowerBound, isTrue);
    expect(range.lowerEndpoint(), 4);
    expect(range.lowerBoundType(), BoundType.open);
    expect(range.hasUpperBound(), isTrue);
    expect(range.upperEndpoint(), 8);
    expect(range.upperBoundType(), BoundType.open);
    expect(range.isEmpty(), isFalse);
    expect(range.toString(), "(4..8)");
  });

  test('closed', () {
    var range = Range.closed(5, 7);
    checkContains(range);

    expect(range.hasLowerBound, isTrue);
    expect(range.lowerEndpoint(), 5);
    expect(range.lowerBoundType(), BoundType.closed);
    expect(range.hasUpperBound(), isTrue);
    expect(range.upperEndpoint(), 7);
    expect(range.upperBoundType(), BoundType.closed);
    expect(range.isEmpty(), isFalse);
    expect(range.toString(), "[5..7]");
  });

  test('OpenClosed', () {
    var range = Range.openClosed(4, 7);
    checkContains(range);

    expect(range.hasLowerBound, isTrue);
    expect(range.lowerEndpoint(), 4);
    expect(range.lowerBoundType(), BoundType.open);
    expect(range.hasUpperBound(), isTrue);
    expect(range.upperEndpoint(), 7);
    expect(range.upperBoundType(), BoundType.closed);
    expect(range.isEmpty(), isFalse);
    expect(range.toString(), "(4..7]");
  });

  test('ClosedOpen', () {
    var range = Range.closedOpen(5, 8);
    checkContains(range);

    expect(range.hasLowerBound, isTrue);
    expect(range.lowerEndpoint(), 5);
    expect(range.lowerBoundType(), BoundType.closed);
    expect(range.hasUpperBound(), isTrue);
    expect(range.upperEndpoint(), 8);
    expect(range.upperBoundType(), BoundType.open);
    expect(range.isEmpty(), isFalse);
    expect(range.toString(), "[5..8)");
  });

  test('isConnected', () {
    expect(Range.closed(3, 5).isConnected(Range.open(5, 6)), isTrue);
    expect(Range.closed(3, 5).isConnected(Range.closed(5, 6)), isTrue);
    expect(Range.closed(5, 6).isConnected(Range.closed(3, 5)), isTrue);
    expect(Range.closed(3, 5).isConnected(Range.openClosed(5, 5)), isTrue);
    expect(Range.open(3, 5).isConnected(Range.closed(5, 6)), isTrue);
    expect(Range.closed(3, 7).isConnected(Range.open(6, 8)), isTrue);
    expect(Range.open(3, 7).isConnected(Range.closed(5, 6)), isTrue);
    expect(Range.closed(3, 5).isConnected(Range.closed(7, 8)), isFalse);
    expect(Range.closed(3, 5).isConnected(Range.closedOpen(7, 7)), isFalse);
  });

  test('singleton', () {
    final range = Range.singleton(4);

    assertFalse(range.contains(3));
    assertTrue(range.contains(4));
    assertFalse(range.contains(5));
    assertTrue(range.hasLowerBound);
    assertEquals(4, range.lowerEndpoint());
    assertEquals(BoundType.closed, range.lowerBoundType());
    assertTrue(range.hasUpperBound());
    assertEquals(4, range.upperEndpoint());
    assertEquals(BoundType.closed, range.upperBoundType());
    assertFalse(range.isEmpty());
    assertEquals("[4..4]", range.toString());
  });

  test('empty1', () {
    final range = Range.closedOpen(4, 4);
    assertFalse(range.contains(3));
    assertFalse(range.contains(4));
    assertFalse(range.contains(5));
    assertTrue(range.hasLowerBound);
    assertEquals(4, range.lowerEndpoint());
    assertEquals(BoundType.closed, range.lowerBoundType());
    assertTrue(range.hasUpperBound());
    assertEquals(4, range.upperEndpoint());
    assertEquals(BoundType.open, range.upperBoundType());
    assertTrue(range.isEmpty());
    assertEquals("[4..4)", range.toString());
  });

  test('empty2', () {
    final range = Range.openClosed(4, 4);
    assertFalse(range.contains(3));
    assertFalse(range.contains(4));
    assertFalse(range.contains(5));
    assertTrue(range.hasLowerBound);
    assertEquals(4, range.lowerEndpoint());
    assertEquals(BoundType.open, range.lowerBoundType());
    assertTrue(range.hasUpperBound());
    assertEquals(4, range.upperEndpoint());
    assertEquals(BoundType.closed, range.upperBoundType());
    assertTrue(range.isEmpty());
    assertEquals("(4..4]", range.toString());
  });

  test('lessThan', () {
    final range = Range.lessThan(5);
    assertTrue(range.contains(double.minPositive.toInt()));
    assertTrue(range.contains(4));
    assertFalse(range.contains(5));
    assertUnboundedBelow(range);
    assertTrue(range.hasUpperBound());
    assertEquals(5, range.upperEndpoint());
    assertEquals(BoundType.open, range.upperBoundType());
    assertFalse(range.isEmpty());
    assertEquals("(-\u221e..5)", range.toString());
  });

  test('greaterThan', () {
    final range = Range.greaterThan(5);
    assertFalse(range.contains(5));
    assertTrue(range.contains(6));
    assertTrue(range.contains(double.maxFinite.toInt()));
    assertTrue(range.hasLowerBound);
    assertEquals(5, range.lowerEndpoint());
    assertEquals(BoundType.open, range.lowerBoundType());
    assertUnboundedAbove(range);
    assertFalse(range.isEmpty());
    assertEquals("(5..+\u221e)", range.toString());
  });

  test('atLeast', () {
    final range = Range.atLeast(6);
    assertFalse(range.contains(5));
    assertTrue(range.contains(6));
    assertTrue(range.contains(double.maxFinite.toInt()));
    assertTrue(range.hasLowerBound);
    assertEquals(6, range.lowerEndpoint());
    assertEquals(BoundType.closed, range.lowerBoundType());
    assertUnboundedAbove(range);
    assertFalse(range.isEmpty());
    assertEquals("[6..+\u221e)", range.toString());
  });

  test('atMost', () {
    final range = Range.atMost(4);
    assertTrue(range.contains(double.minPositive.toInt()));
    assertTrue(range.contains(4));
    assertFalse(range.contains(5));
    assertUnboundedBelow(range);
    assertTrue(range.hasUpperBound());
    assertEquals(4, range.upperEndpoint());
    assertEquals(BoundType.closed, range.upperBoundType());
    assertFalse(range.isEmpty());
    assertEquals("(-\u221e..4]", range.toString());
  });

  test('all', () {
    final range = Range.all<int>();
    assertTrue(range.contains(double.minPositive.toInt()));
    assertTrue(range.contains(double.maxFinite.toInt()));
    assertUnboundedBelow(range);
    assertUnboundedAbove(range);
    assertFalse(range.isEmpty());
    assertEquals("(-\u221e..+\u221e)", range.toString());
    //assertSame(range, reserializeAndAssert(range));
    // expect(range, Range.all<int>());
  });

  test('orderingCuts', () {
    Cut<int> a = Range.lessThan(0).lowerBound;
    Cut<int> b = Range.atLeast(0).lowerBound;
    Cut<int> c = Range.greaterThan(0).lowerBound;
    Cut<int> d = Range.atLeast(1).lowerBound;
    Cut<int> e = Range.greaterThan(1).lowerBound;
    Cut<int> f = Range.greaterThan(1).upperBound;

    testCompareToAndEquals([a, b, c, d, e, f]);
  });

  test('containsAll', () {
    Range<int> range = Range.closed(3, 5);
    assertTrue(range.containsAll([3, 3, 4, 5]));
    assertFalse(range.containsAll([3, 3, 4, 5, 6]));

    // We happen to know that natural-order sorted sets use a different code
    // path, so we test that separately
    assertTrue(range.containsAll({3, 3, 4, 5}));
    assertTrue(range.containsAll({3}));
    assertTrue(range.containsAll(<int>{}));
    assertFalse(range.containsAll({3, 3, 4, 5, 6}));

    assertTrue(Range.openClosed(3, 3).containsAll(<int>{}));
  });

  test('testEncloses_open', () {
    final range = Range.open(2, 5);
    assertTrue(range.encloses(range));
    assertTrue(range.encloses(Range.open(2, 4)));
    assertTrue(range.encloses(Range.open(3, 5)));
    assertTrue(range.encloses(Range.closed(3, 4)));

    assertFalse(range.encloses(Range.openClosed(2, 5)));
    assertFalse(range.encloses(Range.closedOpen(2, 5)));
    assertFalse(range.encloses(Range.closed(1, 4)));
    assertFalse(range.encloses(Range.closed(3, 6)));
    assertFalse(range.encloses(Range.greaterThan(3)));
    assertFalse(range.encloses(Range.lessThan(3)));
    assertFalse(range.encloses(Range.atLeast(3)));
    assertFalse(range.encloses(Range.atMost(3)));
    assertFalse(range.encloses(Range.all<int>()));
  });

  test('testEncloses_closed', () {
    final range = Range.closed(2, 5);
    assertTrue(range.encloses(range));
    assertTrue(range.encloses(Range.open(2, 5)));
    assertTrue(range.encloses(Range.openClosed(2, 5)));
    assertTrue(range.encloses(Range.closedOpen(2, 5)));
    assertTrue(range.encloses(Range.closed(3, 5)));
    assertTrue(range.encloses(Range.closed(2, 4)));

    assertFalse(range.encloses(Range.open(1, 6)));
    assertFalse(range.encloses(Range.greaterThan(3)));
    assertFalse(range.encloses(Range.lessThan(3)));
    assertFalse(range.encloses(Range.atLeast(3)));
    assertFalse(range.encloses(Range.atMost(3)));
    assertFalse(range.encloses(Range.all<int>()));
  });

  test('testIntersection_empty', () {
    Range<int> range = Range.closedOpen(3, 3);
    assertEquals(range, range.intersection(range));

    try {
      range.intersection(Range.open(3, 5));
      fail('');
    } catch (expected) {
      // TODO(kevinb): convert the rest of this file to Truth someday
      print(expected);
      //assertThat(expected).hasMessageThat().contains("connected");
    }
    try {
      range.intersection(Range.closed(0, 2));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }
  });

  test('testIntersection_deFactoEmpty', () {
    var range = Range.open(3, 4);
    assertEquals(range, range.intersection(range));

    assertEquals(Range.openClosed(3, 3), range.intersection(Range.atMost(3)));
    assertEquals(Range.closedOpen(4, 4), range.intersection(Range.atLeast(4)));

    try {
      range.intersection(Range.lessThan(3));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }
    try {
      range.intersection(Range.greaterThan(4));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }

    range = Range.closed(3, 4);
    assertEquals(
        Range.openClosed(4, 4), range.intersection(Range.greaterThan(4)));
  });

  test('testIntersection_singleton', () {
    Range<int> range = Range.closed(3, 3);
    assertEquals(range, range.intersection(range));

    assertEquals(range, range.intersection(Range.atMost(4)));
    assertEquals(range, range.intersection(Range.atMost(3)));
    assertEquals(range, range.intersection(Range.atLeast(3)));
    assertEquals(range, range.intersection(Range.atLeast(2)));

    assertEquals(Range.closedOpen(3, 3), range.intersection(Range.lessThan(3)));
    assertEquals(
        Range.openClosed(3, 3), range.intersection(Range.greaterThan(3)));

    try {
      range.intersection(Range.atLeast(4));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }
    try {
      range.intersection(Range.atMost(2));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }
  });

  test('testIntersection_general', () {
    var range = Range.closed(4, 8);

    // separate below
    try {
      range.intersection(Range.closed(0, 2));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }

    // adjacent below
    assertEquals(
        Range.closedOpen(4, 4), range.intersection(Range.closedOpen(2, 4)));

    // overlap below
    assertEquals(Range.closed(4, 6), range.intersection(Range.closed(2, 6)));

    // enclosed with same start
    assertEquals(Range.closed(4, 6), range.intersection(Range.closed(4, 6)));

    // enclosed, interior
    assertEquals(Range.closed(5, 7), range.intersection(Range.closed(5, 7)));

    // enclosed with same end
    assertEquals(Range.closed(6, 8), range.intersection(Range.closed(6, 8)));

    // equal
    assertEquals(range, range.intersection(range));

    // enclosing with same start
    assertEquals(range, range.intersection(Range.closed(4, 10)));

    // enclosing with same end
    assertEquals(range, range.intersection(Range.closed(2, 8)));

    // enclosing, exterior
    assertEquals(range, range.intersection(Range.closed(2, 10)));

    // overlap above
    assertEquals(Range.closed(6, 8), range.intersection(Range.closed(6, 10)));

    // adjacent above
    assertEquals(
        Range.openClosed(8, 8), range.intersection(Range.openClosed(8, 10)));

    // separate above
    try {
      range.intersection(Range.closed(10, 12));
      fail('');
    } catch (expected) {
      //assertThat(expected).hasMessageThat().contains("connected");
    }
  });

  test('testGap_overlapping', () {
    Range<int> range = Range.closedOpen(3, 5);

    try {
      range.gap(Range.closed(4, 6));
      fail('');
    } catch (expected) {}
    try {
      range.gap(Range.closed(2, 4));
      fail('');
    } catch (expected) {}
    try {
      range.gap(Range.closed(2, 3));
      fail('');
    } catch (expected) {}
  });

  test('testGap_invalidRangesWithInfinity', () {
    try {
      Range.atLeast(1).gap(Range.atLeast(2));
      fail('');
    } catch (expected) {}

    try {
      Range.atLeast(2).gap(Range.atLeast(1));
      fail('');
    } catch (expected) {}

    try {
      Range.atMost(1).gap(Range.atMost(2));
      fail('');
    } catch (expected) {}

    try {
      Range.atMost(2).gap(Range.atMost(1));
      fail('');
    } catch (expected) {}
  });

  test('testGap_connectedAdjacentYieldsEmpty', () {
    Range<int> range = Range.open(3, 4);

    assertEquals(Range.closedOpen(4, 4), range.gap(Range.atLeast(4)));
    assertEquals(Range.openClosed(3, 3), range.gap(Range.atMost(3)));
  });

  test('testGap_general', () {
    Range<int> openRange = Range.open(4, 8);
    Range<int> closedRange = Range.closed(4, 8);

    // first range open end, second range open start
    assertEquals(Range.closed(2, 4), Range.lessThan(2).gap(openRange));
    assertEquals(Range.closed(2, 4), openRange.gap(Range.lessThan(2)));

    // first range closed end, second range open start
    assertEquals(Range.openClosed(2, 4), Range.atMost(2).gap(openRange));
    assertEquals(Range.openClosed(2, 4), openRange.gap(Range.atMost(2)));

    // first range open end, second range closed start
    assertEquals(Range.closedOpen(2, 4), Range.lessThan(2).gap(closedRange));
    assertEquals(Range.closedOpen(2, 4), closedRange.gap(Range.lessThan(2)));

    // first range closed end, second range closed start
    assertEquals(Range.open(2, 4), Range.atMost(2).gap(closedRange));
    assertEquals(Range.open(2, 4), closedRange.gap(Range.atMost(2)));
  });

  test('testSpan_general', () {
    Range<int> range = Range.closed(4, 8);

    // separate below
    assertEquals(Range.closed(0, 8), range.span(Range.closed(0, 2)));
    assertEquals(Range.atMost(8), range.span(Range.atMost(2)));

    // adjacent below
    assertEquals(Range.closed(2, 8), range.span(Range.closedOpen(2, 4)));
    assertEquals(Range.atMost(8), range.span(Range.lessThan(4)));

    // overlap below
    assertEquals(Range.closed(2, 8), range.span(Range.closed(2, 6)));
    assertEquals(Range.atMost(8), range.span(Range.atMost(6)));

    // enclosed with same start
    assertEquals(range, range.span(Range.closed(4, 6)));

    // enclosed, interior
    assertEquals(range, range.span(Range.closed(5, 7)));

    // enclosed with same end
    assertEquals(range, range.span(Range.closed(6, 8)));

    // equal
    assertEquals(range, range.span(range));

    // enclosing with same start
    assertEquals(Range.closed(4, 10), range.span(Range.closed(4, 10)));
    assertEquals(Range.atLeast(4), range.span(Range.atLeast(4)));

    // enclosing with same end
    assertEquals(Range.closed(2, 8), range.span(Range.closed(2, 8)));
    assertEquals(Range.atMost(8), range.span(Range.atMost(8)));

    // enclosing, exterior
    assertEquals(Range.closed(2, 10), range.span(Range.closed(2, 10)));
    assertEquals(Range.all<int>(), range.span(Range.all<int>()));

    // overlap above
    assertEquals(Range.closed(4, 10), range.span(Range.closed(6, 10)));
    assertEquals(Range.atLeast(4), range.span(Range.atLeast(6)));

    // adjacent above
    assertEquals(Range.closed(4, 10), range.span(Range.openClosed(8, 10)));
    assertEquals(Range.atLeast(4), range.span(Range.greaterThan(8)));

    // separate above
    assertEquals(Range.closed(4, 12), range.span(Range.closed(10, 12)));
    assertEquals(Range.atLeast(4), range.span(Range.atLeast(10)));
  });

  test('testCanonical', () {
    assertEquals(Range.closedOpen(1, 5),
        Range.closed(1, 4).canonical(DiscreteDomain.integers()));
    assertEquals(Range.closedOpen(1, 5),
        Range.open(0, 5).canonical(DiscreteDomain.integers()));
    assertEquals(Range.closedOpen(1, 5),
        Range.closedOpen(1, 5).canonical(DiscreteDomain.integers()));
    assertEquals(Range.closedOpen(1, 5),
        Range.openClosed(0, 4).canonical(DiscreteDomain.integers()));

    assertEquals(Range.closedOpen(minInt, 0),
        Range.closedOpen(minInt, 0).canonical(DiscreteDomain.integers()));

    assertEquals(Range.closedOpen(minInt, 0),
        Range.lessThan(0).canonical(DiscreteDomain.integers()));
    assertEquals(Range.closedOpen(minInt, 1),
        Range.atMost(0).canonical(DiscreteDomain.integers()));
    assertEquals(Range.atLeast(0),
        Range.atLeast(0).canonical(DiscreteDomain.integers()));
    assertEquals(Range.atLeast(1),
        Range.greaterThan(0).canonical(DiscreteDomain.integers()));

    assertEquals(Range.atLeast(minInt),
        Range.all<int>().canonical(DiscreteDomain.integers()));
  });

  test('testCanonical_unboundedDomain', () {
    assertEquals(
        Range.lessThan(0), Range.lessThan(0).canonical(UNBOUNDED_DOMAIN));
    assertEquals(
        Range.lessThan(1), Range.atMost(0).canonical(UNBOUNDED_DOMAIN));
    assertEquals(
        Range.atLeast(0), Range.atLeast(0).canonical(UNBOUNDED_DOMAIN));
    assertEquals(
        Range.atLeast(1), Range.greaterThan(0).canonical(UNBOUNDED_DOMAIN));

    assertEquals(
        Range.all<int>(), Range.all<int>().canonical(UNBOUNDED_DOMAIN));
  });

  test('testEncloseAll', () {
    assertEquals(Range.closed(0, 0), Range.encloseAll([0]));
    assertEquals(Range.closed(-3, 5), Range.encloseAll([5, -3]));
    assertEquals(
        Range.closed(-3, 5), Range.encloseAll([1, 2, 2, 2, 5, -3, 0, -1]));
  });

  test('testEncloseAll_empty', () {
    try {
      Range.encloseAll(<int>{});
      fail('');
    } catch (expected) {}
  });

  test('testEquivalentFactories', () {
    expect(Range.atLeast(1), Range.downTo(1, BoundType.closed));
    expect(Range.greaterThan(1), Range.downTo(1, BoundType.open));
    expect(Range.atMost(7), Range.upTo(7, BoundType.closed));
    expect(Range.lessThan(7), Range.upTo(7, BoundType.open));
    expect(Range.open(1, 7), Range.range(1, BoundType.open, 7, BoundType.open));
    expect(Range.openClosed(1, 7),
        Range.range(1, BoundType.open, 7, BoundType.closed));
    expect(Range.closed(1, 7),
        Range.range(1, BoundType.closed, 7, BoundType.closed));
    expect(Range.closedOpen(1, 7),
        Range.range(1, BoundType.closed, 7, BoundType.open));
  });
}

void checkContains(Range<int> range) {
  expect(range.contains(4), isFalse);
  expect(range.contains(5), isTrue);
  expect(range.contains(7), isTrue);
  expect(range.contains(8), isFalse);
}

void assertTrue(c) {
  expect(c, isTrue);
}

void assertFalse(c) {
  expect(c, isFalse);
}

void assertEquals(a, b) {
  expect(a, b);
}

void assertUnboundedBelow(Range<int> range) {
  assertFalse(range.hasLowerBound);
  try {
    range.lowerEndpoint();
    fail('');
  } catch (expected) {}
  try {
    range.lowerBoundType();
    fail('');
  } catch (expected) {}
}

void assertUnboundedAbove(Range<int> range) {
  assertFalse(range.hasUpperBound());
  try {
    range.upperEndpoint();
    fail('');
  } catch (expected) {}
  try {
    range.upperBoundType();
    fail('');
  } catch (expected) {}
}

void testCompareToAndEquals<T extends Comparable<T>>(
    List<T> valuesInExpectedOrder) {
  // This does an O(n^2) test of all pairs of values in both orders
  for (int i = 0; i < valuesInExpectedOrder.length; i++) {
    T t = valuesInExpectedOrder[i];

    for (int j = 0; j < i; j++) {
      T lesser = valuesInExpectedOrder[j];
      expect(lesser.compareTo(t) < 0, isTrue, reason: '$lesser.compareTo($t)');
      assertFalse(lesser == t);
    }

    assertEquals(0, t.compareTo(t));
    assertTrue(t == t);

    for (int j = i + 1; j < valuesInExpectedOrder.length; j++) {
      T greater = valuesInExpectedOrder[j];
      assertTrue(greater.compareTo(t) > 0);
      assertFalse(greater == t);
    }
  }
}

final UNBOUNDED_DOMAIN = UnboundedDomain();

class UnboundedDomain extends DiscreteDomain<int> {
  @override
  int? next(int value) {
    return DiscreteDomain.integers().next(value);
  }

  @override
  int? previous(int value) {
    return DiscreteDomain.integers().previous(value);
  }

  @override
  int distance(int start, int end) {
    return DiscreteDomain.integers().distance(start, end);
  }
}
