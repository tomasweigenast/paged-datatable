class FilterCollection {
  final Map<String, Object?> _filters;

  FilterCollection({required Map<String, Object?>? filters}) : _filters = filters ?? const {};

  Object filter(String filterId) {
    try {
      return _filters[filterId]!;
    } catch(_) {
      throw Exception("Filter $filterId does not exist or has a null value.");
    }
  }

  T filterAs<T>(String filterId) {
    return filter(filterId) as T;
  }

  T? filterAsOrNull<T>(String filterId) {
    return _filters[filterId] as T?;
  }

  @override
  String toString() => _filters.keys.toString();
}