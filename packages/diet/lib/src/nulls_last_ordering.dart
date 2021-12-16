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

import 'package:diet/src/ordering.dart';
import 'package:meta/meta.dart';

class NullsLastOrdering<T extends Object?> extends Ordering<T> {
  final Ordering<T> ordering;

  @protected
  NullsLastOrdering(this.ordering);

  @override
  int compare(T? left, T? right) {
    if (left == right) {
      return 0;
    }
    if (left == null) {
      return Ordering.LEFT_IS_GREATER;
    }
    if (right == null) {
      return Ordering.RIGHT_IS_GREATER;
    }
    return ordering.compare(left, right);
  }

  @override
  Ordering<S?> reverse<S extends T>() {
    // ordering.reverse() might be optimized, so let it do its thing
    return ordering.reverse().nullsFirst();
  }

  @override
  Ordering<S?> nullsFirst<S extends T>() {
    return ordering.nullsFirst<S>();
  }

  @override
  Ordering<S?> nullsLast<S extends T>() {
    return this as Ordering<S?>;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NullsLastOrdering &&
          runtimeType == other.runtimeType &&
          ordering == other.ordering;

  @override
  int get hashCode => ordering.hashCode ^ -921210296; // meaningless;

  @override
  String toString() {
    return "$ordering.nullsLast()";
  }
}
