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

  void setFilterValue(String filterId, Object? newValue, {bool notify = false}) {
    if(_filters.containsKey(filterId)) {
      _filters[filterId]!._currentValue = newValue;
      if(notify) {
        notifyListeners();
      }

      debugPrint("Filter '$filterId' changed its value to '$newValue'");
    }
  }

  void removeFilter(String filterId) {
    if(_filters.containsKey(filterId)) {
      _filters[filterId]!._currentValue = null;
      notifyListeners();
    }

    _filterUpdateNotifier.add(FilterUpdateEvent._(filterId: filterId, currentValue: null));
  }

  void clearFilters() {
    for(var activeFilter in activeFilters){
      _filters[activeFilter.filterId]!._currentValue = null;
    }
    notifyListeners();
    _filterUpdateNotifier.add(FilterUpdateEvent._(filterId: "*", currentValue: null));
  }

  void applyFilters() {
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

class _FilterState {
  final String filterId;
  final BasePagedDataTableFilter filter;
  
  Object? _currentValue;

  Object? get currentValue => _currentValue;

  _FilterState({required this.filter, Object? currentValue}) : filterId = filter.filterId, _currentValue = currentValue;
}

class FilterUpdateEvent {
  final String filterId;
  final Object? currentValue;

  FilterUpdateEvent._({required this.filterId, required this.currentValue});
}