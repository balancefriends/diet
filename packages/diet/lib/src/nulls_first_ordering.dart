import 'ordering.dart';

class NullsFirstOrdering<T extends Object?> extends Ordering<T> {
  final Ordering<T> ordering;

  NullsFirstOrdering(this.ordering);

  @override
  int compareTo(T other) {
    if ( this == other) {
      return 0;
    }
    if ( this)
  }
}
