/*
 * Copyright (C) 2009 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

import 'package:diet/src/booleans.dart';
import 'package:quiver/check.dart';

import 'bound_type.dart';
import 'discrete_domain.dart';
import 'range.dart';

/// Implementation detail for the internal structure of {@link Range} instances. Represents a unique
/// way of "cutting" a "number line" (actually of instances of type {@code C}, not necessarily
/// "numbers") into two sections; this can be done below a certain value, above a certain value,
/// below all values or above all values. With this object defined in this way, an interval can
/// always be represented by a pair of {@code Cut} instances.
abstract class Cut<C extends Comparable> implements Comparable<Cut<C>> {
  final C endpoint;

  Cut(this.endpoint);

  bool isLessThan(C value);

  BoundType typeAsLowerBound();

  BoundType typeAsUpperBound();

  Cut<C> withLowerBoundType(BoundType boundType, DiscreteDomain<C> domain);

  Cut<C> withUpperBoundType(BoundType boundType, DiscreteDomain<C> domain);

  void describeAsLowerBound(StringBuffer sb);

  void describeAsUpperBound(StringBuffer sb);

  Comparable? leastValueAbove(DiscreteDomain<C> domain);

  Comparable? greatestValueBelow(DiscreteDomain<C> domain);

  /*
   * The canonical form is a BelowValue cut whenever possible, otherwise ABOVE_ALL, or
   * (only in the case of types that are unbounded below) BELOW_ALL.
   */
  Cut<C> canonical(DiscreteDomain<C> domain) {
    return this;
  }

  // note: overridden by {BELOW,ABOVE}_ALL
  @override
  int compareTo(Cut<C> that) {
    if (that == belowAll()) {
      return 1;
    }
    if (that == aboveAll()) {
      return -1;
    }
    int result = Range.compareOrThrow(endpoint, that.endpoint);
    if (result != 0) {
      return result;
    }
    // same value. below comes before above
    return Booleans.compare(this is AboveValue, that is AboveValue);
  }

  static Cut<C> belowAll<C extends Comparable>() =>
      _BelowAll._INSTANCE as Cut<C>;

  static Cut<C> aboveAll<C extends Comparable>() =>
      _AboveAll._INSTANCE as Cut<C>;

  @override
  bool operator ==(Object obj) {
    if (obj is Cut) {
      // It might not really be a Cut<C>, but we'll catch a CCE if it's not
      Cut<C> that = obj as Cut<C>;
      try {
        int compareResult = compareTo(that);
        return compareResult == 0;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static Cut<C> belowValue<C extends Comparable>(C endpoint) {
    return _BelowValue(endpoint);
  }

  static Cut<C> aboveValue<C extends Comparable>(C endpoint) {
    return AboveValue(endpoint);
  }

// Prevent "missing hashCode" warning by explicitly forcing subclasses implement it
//@override
//int hashCode();
}

/// The implementation neither produces nor consumes any non-null instance of type C, so
/// casting the type parameter is safe.
class _BelowAll extends Cut<Comparable> {
  static final _BelowAll _INSTANCE = _BelowAll();

  /// No code ever sees this bogus value for `endpoint`: This class overrides both methods that
  /// use the `endpoint` field, compareTo() and endpoint(). Additionally, the main implementation
  /// of Cut.compareTo checks for belowAll before reading accessing `endpoint` on another Cut
  /// instance.
  _BelowAll() : super("");

  @override
  Comparable get endpoint {
    throw StateError("range unbounded on this side");
  }

  @override
  BoundType typeAsLowerBound() =>
      throw StateError("range unbounded on this side");

  @override
  BoundType typeAsUpperBound() =>
      throw AssertionError("this statement should be unreachable");

  @override
  bool isLessThan(Comparable value) =>
      Range.compareOrThrow(endpoint, value) <= 0;

  @override
  Cut<Comparable> withLowerBoundType(
      BoundType boundType, DiscreteDomain<Comparable> domain) {
    throw StateError('');
  }

  @override
  Cut<Comparable> withUpperBoundType(
      BoundType boundType, DiscreteDomain<Comparable> domain) {
    throw AssertionError("this statement should be unreachable");
  }

  @override
  void describeAsLowerBound(StringBuffer sb) {
    sb.write("(-\u221e");
  }

  @override
  void describeAsUpperBound(StringBuffer sb) {
    throw AssertionError();
  }

  @override
  Comparable leastValueAbove(DiscreteDomain<Comparable> domain) {
    return domain.minValue();
  }

  @override
  Comparable? greatestValueBelow(DiscreteDomain<Comparable> domain) {
    throw AssertionError();
  }

  @override
  Cut<Comparable> canonical(DiscreteDomain<Comparable> domain) {
    try {
      return Cut.belowValue(domain.minValue());
    } catch (e) {
      return this;
    }
  }

  @override
  int compareTo(Cut<Comparable> o) {
    return (o == this) ? 0 : -1;
  }

  @override
  int get hashCode => Object.hash(this, null);

  @override
  String toString() {
    return "-\u221e";
  }
}

class _AboveAll extends Cut<Comparable> {
  static final _AboveAll _INSTANCE = _AboveAll();

  _AboveAll() : super("");

  @override
  Comparable get endpoint {
    throw StateError("range unbounded on this side");
  }

  @override
  BoundType typeAsLowerBound() {
    throw AssertionError("this statement should be unreachable");
  }

  @override
  BoundType typeAsUpperBound() {
    throw StateError('');
  }

  @override
  bool isLessThan(Comparable value) {
    return false;
  }

  @override
  void describeAsLowerBound(StringBuffer sb) {
    throw AssertionError();
  }

  @override
  void describeAsUpperBound(StringBuffer sb) {
    sb.write("+\u221e)");
  }

  @override
  Comparable? greatestValueBelow(DiscreteDomain<Comparable> domain) {
    // TODO: implement greatestValueBelow
    throw UnimplementedError();
  }

  @override
  Comparable? leastValueAbove(DiscreteDomain<Comparable> domain) {
    return domain.maxValue();
  }

  @override
  Cut<Comparable> withLowerBoundType(
      BoundType boundType, DiscreteDomain<Comparable> domain) {
    throw AssertionError("this statement should be unreachable");
  }

  @override
  Cut<Comparable> withUpperBoundType(
      BoundType boundType, DiscreteDomain<Comparable> domain) {
    throw new StateError('');
  }

  @override
  int compareTo(Cut<Comparable> o) {
    return (o == this) ? 0 : 1;
  }

  @override
  int get hashCode => Object.hash(this, null);

  @override
  String toString() {
    return "+\u221e";
  }
}

class _BelowValue<C extends Comparable> extends Cut<C> {
  _BelowValue(C endpoint) : super(checkNotNull(endpoint));

  @override
  bool isLessThan(C value) {
    return Range.compareOrThrow(endpoint, value) <= 0;
  }

  @override
  BoundType typeAsLowerBound() {
    return BoundType.closed;
  }

  @override
  BoundType typeAsUpperBound() {
    return BoundType.open;
  }

  @override
  Cut<C> withLowerBoundType(BoundType boundType, DiscreteDomain<C> domain) {
    switch (boundType) {
      case BoundType.closed:
        return this;
      case BoundType.open:
        C? previous = domain.previous(endpoint);
        return (previous == null) ? Cut.belowAll<C>() : AboveValue<C>(previous);
      default:
        throw AssertionError();
    }
  }

  @override
  Cut<C> withUpperBoundType(BoundType boundType, DiscreteDomain<C> domain) {
    switch (boundType) {
      case BoundType.closed:
        C? previous = domain.previous(endpoint);
        return (previous == null) ? Cut.aboveAll<C>() : AboveValue<C>(previous);
      case BoundType.open:
        return this;
      default:
        throw AssertionError();
    }
  }

  @override
  void describeAsLowerBound(StringBuffer sb) {
    sb
      ..write('[')
      ..write(endpoint);
  }

  @override
  void describeAsUpperBound(StringBuffer sb) {
    sb
      ..write(endpoint)
      ..write(')');
  }

  @override
  Comparable? greatestValueBelow(DiscreteDomain<C> domain) {
    return domain.previous(endpoint);
  }

  @override
  Comparable? leastValueAbove(DiscreteDomain<C> domain) {
    return endpoint;
  }

  @override
  int get hashCode {
    return endpoint.hashCode;
  }

  @override
  String toString() {
    return "\\$endpoint/";
  }
}

class AboveValue<C extends Comparable> extends Cut<C> {
  AboveValue(C endpoint) : super(checkNotNull(endpoint));

  @override
  bool isLessThan(C value) {
    return Range.compareOrThrow(endpoint, value) < 0;
  }

  @override
  BoundType typeAsLowerBound() {
    return BoundType.open;
  }

  @override
  BoundType typeAsUpperBound() {
    return BoundType.closed;
  }

  @override
  Cut<C> withLowerBoundType(BoundType boundType, DiscreteDomain<C> domain) {
    switch (boundType) {
      case BoundType.open:
        return this;
      case BoundType.closed:
        C? next = domain.next(endpoint);
        return (next == null) ? Cut.belowAll<C>() : Cut.belowValue(next);
      default:
        throw AssertionError();
    }
  }

  @override
  Cut<C> withUpperBoundType(BoundType boundType, DiscreteDomain<C> domain) {
    switch (boundType) {
      case BoundType.open:
        C? next = domain.next(endpoint);
        return (next == null) ? Cut.aboveAll<C>() : Cut.belowValue(next);
      case BoundType.closed:
        return this;
      default:
        throw AssertionError();
    }
  }

  @override
  void describeAsLowerBound(StringBuffer sb) {
    sb
      ..write('(')
      ..write(endpoint);
  }

  @override
  void describeAsUpperBound(StringBuffer sb) {
    sb
      ..write(endpoint)
      ..write(']');
  }

  @override
  C? leastValueAbove(DiscreteDomain<C> domain) {
    return domain.next(endpoint);
  }

  @override
  C? greatestValueBelow(DiscreteDomain<C> domain) {
    return endpoint;
  }

  @override
  Cut<C> canonical(DiscreteDomain<C> domain) {
    C? next = leastValueAbove(domain);
    return (next != null) ? Cut.belowValue(next) : Cut.aboveAll<C>();
  }

  @override
  int get hashCode {
    return ~endpoint.hashCode;
  }

  @override
  String toString() {
    return "/$endpoint\\";
  }
}
