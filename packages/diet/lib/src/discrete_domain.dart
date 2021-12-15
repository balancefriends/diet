/*
 * Copyright (C) 2009 The Guava Authors
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

import 'preconditions.dart';

/// A descriptor for a <i>discrete</i> {@code Comparable} domain such as all {@link Integer}
/// instances. A discrete domain is one that supports the three basic operations: {@link #next},
/// {@link #previous} and {@link #distance}, according to their specifications. The methods {@link
/// #minValue} and {@link #maxValue} should also be overridden for bounded types.
///
/// <p>A discrete domain always represents the <i>entire</i> set of values of its type; it cannot
/// represent partial domains such as "prime integers" or "strings of length 5."
///
/// <p>See the Guava User Guide section on <a href=
/// "https://github.com/google/guava/wiki/RangesExplained#discrete-domains"> {@code
/// DiscreteDomain}</a>.
///
/// @author Kevin Bourrillion
/// @since 10.0
abstract class DiscreteDomain<C extends Comparable> {
  static DiscreteDomain<int> integers() {
    return IntDomain._INSTANCE;
  }

  final bool supportsFastOffset;

  /// Private constructor for built-in DiscreteDomains supporting fast offset. */
  DiscreteDomain([this.supportsFastOffset = false]);

  /// Returns, conceptually, "origin + distance", or equivalently, the result of calling {@link
  /// #next} on {@code origin} {@code distance} times.
  C offset(C origin, int distance) {
    C? current = origin;
    checkArgument(distance >= 0, message: 'distance must be non-negative');
    for (int i = 0; i < distance; i++) {
      current = next(current!);
      if (current == null) {
        throw ArgumentError("overflowed computing offset($origin, $distance)");
      }
    }
    return current!;
  }

  /// Returns the unique least value of type {@code C} that is greater than {@code value}, or {@code
  /// null} if none exists. Inverse operation to {@link #previous}.
  ///
  /// @param value any value of type {@code C}
  /// @return the least value greater than {@code value}, or {@code null} if {@code value} is {@code
  ///     maxValue()}
  C? next(C value);

  /// Returns the unique greatest value of type [C] that is less than {@code value}, or
  /// `null` if none exists. Inverse operation to {@link #next}.
  ///
  /// [value] any value of type [C]
  /// return the greatest value less than [value], or `null` if [value] is
  ///     [minValue()]
  C? previous(C value);

  /// Returns a signed value indicating how many nested invocations of {@link #next} (if positive) or
  /// {@link #previous} (if negative) are needed to reach {@code end} starting from {@code start}.
  /// For example, if {@code end = next(next(next(start)))}, then {@code distance(start, end) == 3}
  /// and {@code distance(end, start) == -3}. As well, {@code distance(a, a)} is always zero.
  ///
  /// <p>Note that this function is necessarily well-defined for any discrete type.
  ///
  /// @return the distance as described above, or {@link Long#MIN_VALUE} or {@link Long#MAX_VALUE} if
  ///     the distance is too small or too large, respectively.
  int distance(C start, C end);

  /// Returns the minimum value of type {@code C}, if it has one. The minimum value is the unique
  /// value for which {@link Comparable#compareTo(Object)} never returns a positive value for any
  /// input of type {@code C}.
  ///
  /// <p>The default implementation throws {@code NoSuchElementException}.
  ///
  /// @return the minimum value of type {@code C}; never null
  /// @throws NoSuchElementException if the type has no (practical) minimum value; for example,
  ///     {@link java.math.BigInteger}
  C minValue() {
    throw UnimplementedError();
  }

  /// Returns the maximum value of type {@code C}, if it has one. The maximum value is the unique
  /// value for which {@link Comparable#compareTo(Object)} never returns a negative value for any
  /// input of type {@code C}.
  ///
  /// <p>The default implementation throws {@code NoSuchElementException}.
  ///
  /// @return the maximum value of type {@code C}; never null
  /// @throws NoSuchElementException if the type has no (practical) maximum value; for example,
  ///     {@link java.math.BigInteger}
  C maxValue() {
    throw UnimplementedError();
  }
}

class IntDomain extends DiscreteDomain<int> {
  static final IntDomain _INSTANCE = IntDomain._();

  IntDomain._() : super(true);

  @override
  int? next(int value) {
    int i = value;
    return (i == maxInt) ? null : i + 1;
  }

  @override
  int? previous(int value) {
    int i = value;
    return (i == minInt) ? null : i - 1;
  }

  @override
  int offset(int origin, int distance) {
    checkNonnegative(distance, 'distance');
    return origin + distance;
  }

  @override
  int distance(int start, int end) {
    return end - start;
  }

  @override
  int minValue() {
    return minInt;
  }

  @override
  int maxValue() {
    return maxInt;
  }

  @override
  String toString() {
    return "DiscreteDomain.integers()";
  }
}

final int maxInt = (double.infinity is int) ? double.infinity as int : ~minInt;
final int minInt =
    (double.infinity is int) ? -double.infinity as int : (-1 << 63);

// dartweb
// const int intMaxValue = 9007199254740991;
