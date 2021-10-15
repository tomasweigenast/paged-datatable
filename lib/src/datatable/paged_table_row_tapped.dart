class PagedTableRowTapped<T> {
  final List<void Function(T item)>? functions;
  final bool selectRow;

  const PagedTableRowTapped.ignore() : functions = null, selectRow = false;
  const PagedTableRowTapped.selectRow() : functions = null, selectRow = true;
  PagedTableRowTapped.function(void Function(T item) function) : functions = [function], selectRow = false;
  PagedTableRowTapped.multiple(Iterable<PagedTableRowTapped<T>> events) 
    : functions = [...events.where((element) => element.functions != null).map((e) => e.functions!).reduce((value, element) => [...value, ...element])],
      selectRow = events.any((element) => element.selectRow);
}