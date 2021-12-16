import 'package:diet/src/ordering.dart';

class ReverseOrdering<T extends Object?> extends Ordering<T> {
  final Ordering<dynamic> forwardOrder;

  ReverseOrdering(this.forwardOrder);

  @override
  Ordering<S> reverse<S extends T>() {
    return forwardOrder as Ordering<S>;
  }

  @override
  int compare(T left, T right) {
    return forwardOrder.compare(right, left);
  }

  @override
  E min<E extends T>(E a, E b) {
    return forwardOrder.max(a, b);
  }

  @override
  E max<E extends T>(E a, E b) {
    return forwardOrder.min(a, b);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReverseOrdering &&
          runtimeType == other.runtimeType &&
          forwardOrder == other.forwardOrder;

  @override
  int get hashCode => forwardOrder.hashCode;

  @override
  String toString() {
    return "$forwardOrder.reverse()";
  }
}
