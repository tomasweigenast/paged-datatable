part of 'paged_datatable.dart';

/// Represents the filter model of the table.
///
/// Calling [Map] conventional methods should be sufficient to try to get values for filters as this class
/// extends Map<String, dynamic> and because value is dynamic, you can access it like so:
///
/// ```dart
/// final String? myFilterValue = filterModel["filterId"];
/// ```
///
/// If the filter does not have any value set, this won't throw an error as it will return null and,
/// if there is a value, it is in fact an String, so the conversion is made by Dart automatically.
///
/// Obviously if filter's value is not an String an error will be thrown.
final class FilterModel extends UnmodifiableMapBase<String, dynamic> {
  final Map<String, dynamic> _inner;

  FilterModel._(this._inner);

  @override
  operator [](Object? key) => _inner[key];

  @override
  Iterable<String> get keys => _inner.keys;

  /// Tries to get the value of [filterId] and converts it to [T].
  ///
  /// If the filter does not have a value set, [orElse] will get called if not null, otherwise an
  /// error will be thrown.
  T valueAs<T>(String filterId, {T Function()? orElse}) {
    final value = _inner[filterId];
    if (value == null) {
      if (orElse != null) return orElse();
      throw StateError("Value for filter $filterId was not found.");
    }

    return value as T;
  }
}
