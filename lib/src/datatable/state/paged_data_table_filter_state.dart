import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:stream_transform/stream_transform.dart';

class PagedDataTableFilterState extends ChangeNotifier {
  final Map<String, _FilterState> _filters;
  final StreamController<FilterUpdateEvent> _filterUpdateNotifier = StreamController.broadcast();

  List<_FilterState> get activeFilters => UnmodifiableListView(_filters.values.where((element) => element._currentValue != null));
  Stream<FilterUpdateEvent> get onFilterUpdated => _filterUpdateNotifier.stream.debounce(const Duration(milliseconds: 500));

  PagedDataTableFilterState({required List<BasePagedDataTableFilter> filters}) 
    : _filters = { for (var filter in filters) filter.filterId: _FilterState(filter: filter, currentValue: filter.initialValue) };

  Object? getFilterValue(String filterId) {
    return _filters[filterId]?._currentValue;
  } 

  BasePagedDataTableFilter getFilter(String filterId) {
    return _filters[filterId]!.filter;
  } 

  void setFilterValue<T extends Object>(String filterId, T? newValue, {bool notify = false, bool create = false, bool apply = false}) {
    var filterState = _filters[filterId];
    if(filterState == null && create) {
      filterState = _FilterState<T>(
        filter: _CustomFilter<T>(filterId, newValue),
        currentValue: newValue
      );

      _filters[filterId] = filterState;
      debugPrint("A new filter was registered with id '$filterId'");
    }

    if(filterState != null){
      filterState._currentValue = newValue;
      if(notify) {
        notifyListeners();
      }

      debugPrint("Filter '$filterId' changed its value to '$newValue'");
    }

    if(apply) {
      applyFilters();
    }
  }

  void removeFilter(String filterId) {
    if(_filters.containsKey(filterId)) {
      _filters[filterId]!._currentValue = null;
      notifyListeners();
    }

    _filterUpdateNotifier.add(FilterUpdateEvent._(filterId: filterId, currentValue: null));
  }

  void clearFilters({bool notify = true}) {
    if(activeFilters.isEmpty) {
      return;
    }

    for(var activeFilter in _filters.values.where((element) => element._currentValue != null).toList()){
      _filters[activeFilter.filterId]!._currentValue = null;
    }
    notifyListeners();

    if(notify) {
      _filterUpdateNotifier.add(FilterUpdateEvent._(filterId: "*", currentValue: null));
    }
  }

  void applyFilters() {
    if(activeFilters.isEmpty) {
      return;
    }

    notifyListeners();

    for(var activeFilter in activeFilters){
      _filterUpdateNotifier.add(FilterUpdateEvent._(filterId: activeFilter.filterId, currentValue: activeFilter.currentValue));
    }
  }

  @override
  void dispose() {
    _filterUpdateNotifier.close();
    super.dispose();
  }
}

class _FilterState<T extends Object> {
  final String filterId;
  final BasePagedDataTableFilter filter;
  
  T? _currentValue;

  T? get currentValue => _currentValue;

  _FilterState({required this.filter, T? currentValue}) : filterId = filter.filterId, _currentValue = currentValue;
}

class _CustomFilter<T> extends BasePagedDataTableFilter<T> {
  const _CustomFilter(String filterId, T? initialValue) : super(filterId: filterId, initialValue: initialValue, chipFormatter: null);
}

class FilterUpdateEvent {
  final String filterId;
  final Object? currentValue;

  FilterUpdateEvent._({required this.filterId, required this.currentValue});
}