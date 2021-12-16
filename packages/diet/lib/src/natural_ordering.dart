/*
 * Copyright (C) 2007 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:quiver/check.dart';

import 'ordering.dart';
import 'reverse_natural_ordering.dart';

class NaturalOrdering extends Ordering<Comparable<dynamic>> {
  static final NaturalOrdering INSTANCE = NaturalOrdering._();

  Ordering<Comparable?>? _nullsFirst;
  Ordering<Comparable?>? _nullsLast;

  @override
  Ordering<S?> nullsFirst<S extends Comparable>() {
    Ordering<Comparable?>? result = _nullsFirst;
    result ??= _nullsFirst = super.nullsFirst<Comparable>();
    return result as Ordering<S>;
  }

  @override
  Ordering<S?> nullsLast<S extends Comparable>() {
    Ordering<Comparable?>? result = _nullsLast;
    result ??= _nullsLast = super.nullsLast<Comparable>();
    return result as Ordering<S>;
  }

  @override
  Ordering<S> reverse<S extends Comparable>() {
    return ReverseNaturalOrdering.INSTANCE as Ordering<S>;
  }

// preserving singleton-ness gives equals()/hashCode() for free
  Object _readResolve() {
    return INSTANCE;
  }

  @override
  String toString() {
    return "Ordering.natural()";
  }

  NaturalOrdering._();

  @override
  int compare(Comparable left, Comparable right) {
    return left.compareTo(right);
  }
}
