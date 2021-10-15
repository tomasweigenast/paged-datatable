abstract class PagedDataTableEvent {
  const PagedDataTableEvent();
}

class DataTableCacheResetEvent extends PagedDataTableEvent {
  final DataTableCacheResetReason reason;

  const DataTableCacheResetEvent({required this.reason});
}

enum DataTableCacheResetReason {
  previosPageNotFoundInCache, resultSetExpired
}