/// Indicates whether an endpoint of some range is contained in the range itself ("closed") or not
/// ("open"). If a range is unbounded on a side, it is neither open nor closed on that side; the
/// bound simply does not exist.
///
enum BoundType {
  open,
  closed,
}

extension BoundTypeX on BoundType {
  bool get inclusive => this == BoundType.closed;

  /// Returns the bound type corresponding to a boolean value for inclusivity.
  static BoundType forBool(bool inclusive) {
    return inclusive ? BoundType.closed : BoundType.open;
  }
}
