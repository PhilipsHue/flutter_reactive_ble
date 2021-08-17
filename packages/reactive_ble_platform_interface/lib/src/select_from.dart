T selectFrom<T>(List<T> values,
    {required int? index, required T Function(int? index) fallback}) {
  if (index != null && index >= 0 && index < values.length) {
    return values[index];
  }
  return fallback(index);
}
