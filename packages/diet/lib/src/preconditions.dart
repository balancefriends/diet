num checkNonnegative(num value, String name) {
  if (value < 0) {
    throw ArgumentError.value(value, name, "cannot be negative");
  }
  return value;
}
