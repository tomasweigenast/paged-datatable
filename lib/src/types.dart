// ignore_for_file: prefer_final_fields

part of 'paged_datatable.dart';

typedef FetchCallback<TKey extends Object, TResult extends Object> 
  = FutureOr<PaginationResult<TKey, TResult>> Function(
      TKey pageToken, 
      int pageSize, 
      SortBy? sortBy,
      Filtering filtering
    );

typedef ErrorBuilder = Widget Function(Object error);

typedef Getter<T extends Object, TValue extends Object> = TValue? Function(T item);
typedef Setter<T extends Object, TValue> = FutureOr<bool> Function(T item, TValue newValue);

class SortBy {
  String _columnId;
  bool _descending;

  String get columnId => _columnId;
  bool get descending => _descending;

  SortBy._internal({required String columnId, required bool descending})
    : _columnId = columnId, _descending = descending;
}

class Filtering {
  final Map<String, TableFilterState> _states;

  const Filtering._internal(this._states);
  
  /// Returns the current value of a filter or null if the filter is not found
  /// or does not have a value.
  dynamic valueOrNull(String filterId) {
    var state = _states[filterId];
    if(state == null) {
      return null;
    }

    return state.value;
  }

  /// Returns the current value of a filter casting to [T] or null if the filter is not found
  /// or does not have a value.
  T? valueOrNullAs<T>(String filterId) {
    var value = valueOrNull(filterId);
    return value as T?;
  }

  /// Returns true if [filterId] has a value.
  bool has(String filterId) {
    return _states[filterId]?.value != null;
  }
}