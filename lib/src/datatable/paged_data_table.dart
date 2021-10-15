import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/column/checkbox_table_column.dart';
import 'package:paged_datatable/src/datatable/column/table_column.dart';
import 'package:paged_datatable/src/datatable/filter/paged_datatable_filter.dart';
import 'package:paged_datatable/src/datatable/page_indicator.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_event.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_header.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_state.dart';
import 'package:paged_datatable/src/helpers/date_format.dart';
import 'package:paged_datatable/src/helpers/timer_builder.dart';
import 'package:provider/provider.dart';

typedef PageResolver<T> = Future<PageIndicator<T>> Function(String? pageToken, int pageSize, FilterCollection filters);

class PagedDataTable<T extends Object> extends StatefulWidget {

  final List<BaseTableColumn<T>> columns;
  final List<int>? pageSizes;
  final int? defaultPageSize;
  final String initialPageToken;
  final PageResolver<T> resolvePage;
  final PagedDataTableTheme? theme;
  final void Function(T item, bool selected)? onRowSelected;
  final PagedTableRowTapped<T>? onRowTap;
  final List<BasePagedDataTableFilter>? filters;

  const PagedDataTable({required this.columns, required this.resolvePage, this.filters, this.onRowSelected, this.theme, this.onRowTap, String? initialPageToken, this.pageSizes, this.defaultPageSize, Key? key }) 
    : initialPageToken = initialPageToken ?? "", super(key: key);

  @override
  _PagedDataTableState<T> createState() => _PagedDataTableState<T>();
}

class _PagedDataTableState<T extends Object> extends State<PagedDataTable<T>> {

  late final PagedDataTableState<T> _state;
  StreamSubscription? _onEventReceivedListener;

  @override
  void initState() {
    super.initState();

    assert(() {
      if(widget.pageSizes != null && widget.defaultPageSize != null) {
        return widget.pageSizes!.contains(widget.defaultPageSize!);
      }

      return true;
    }(), "defaultPageSize must be included in pageSizes.");

    if(widget.onRowSelected != null) {
      widget.columns.insert(0, TableColumnBuilder(
        title: Selector<PagedDataTableState<T>, bool?>(
          selector: (context, state) => state.selectedAllRows,
          builder: (context, value, child) => Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              tristate: true,
              value: value,
              onChanged: (newValue) {
                _state.selectAll(newValue);
              },
            ),
          ),
        ), 
        rowFormatter: (context, item) => Align(
          alignment: Alignment.topLeft,
          child: Checkbox(
            tristate: false,
            value: _state.isRowSelected(item),
            onChanged: (newValue) {
              _state.setRowSelected(item, newValue!);
            },
          ),
        )
      ));
    }
    _state = PagedDataTableState(
      columns: widget.columns,
      pageResolver: widget.resolvePage,
      currentPageSize: widget.defaultPageSize ?? 20, 
      pageSizes: widget.pageSizes ?? [20, 50, 70],
      initialPageToken: widget.initialPageToken,
      isSelectable: widget.onRowSelected != null,
      onRowTapped: widget.onRowTap,
      onRowSelected: widget.onRowSelected,
      filters: widget.filters
    );

    _onEventReceivedListener = _state.eventStream.listen(_onEvent);

    _state.resolvePage(pageType: TablePageType.current, skipCache: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PagedDataTableState<T>>.value(
      value: _state,
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChangeNotifierProvider.value(
              value: _state.filterState,
              child: PagedDataTableHeader(
                columns: _state.columns,
                filters: widget.filters
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Consumer<PagedDataTableState<T>>(
                builder: (context, model, child) => _buildResultSet(context),
              ),
            ),
            const Divider(height: 1),
            _buildFooter()
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 42,
      color: Colors.grey[200],
      child: Consumer<PagedDataTableState<T>>(
        builder: (context, state, _) {
          return Row(
            children: [
              if(kDebugMode)
                ...[
                  TextButton(
                    child: const Text("Fire event"),
                    onPressed: () {
                      _state.fireEvent(const DataTableCacheResetEvent(reason: DataTableCacheResetReason.previosPageNotFoundInCache));
                    },
                  )
                ],
              const Spacer(),
              TimerBuilder(
                duration: const Duration(minutes: 1),
                builder: (context, child) => IconButton(
                  icon: const Icon(Icons.refresh),
                  splashRadius: 20,
                  tooltip: "Refresh. Refreshed ${VerboseDateFormat.format(_state.lastSyncDate)}",
                  color: widget.theme?.paginationButtonsColor,
                  onPressed: _state.lastSyncDate == null || _state.lastSyncDate!.difference(DateTime.now()).abs().inMinutes >= 1 ? () {
                    _state.refresh(clearCache: false, skipCache: true);
                  } : null,
                ) 
              ),
              const SizedBox(width: 12),
              const VerticalDivider(width: 1),
              const SizedBox(width: 12),

              const SelectableText("Rows per page"),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: 80,
                child: DropdownButtonFormField<int>(
                  isExpanded: false,
                  value: _state.currentPageSize,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  style: const TextStyle(fontSize: 14),
                  items: _state.pageSizes.map((e) => DropdownMenuItem(child: Text(e.toString()), value: e)).toList(),
                  onChanged: _state.isLoading ? null : (newPageSize) {
                    if(newPageSize != null) {
                      _state.setPageSize(newPageSize);
                      _state.refresh(clearCache: true, skipCache: true);
                    }
                  },
                ),
              ),

              const SizedBox(width: 12),
              const VerticalDivider(width: 1),
              const SizedBox(width: 20),

              SelectableText("Page ${_state.currentPage.index+1}"),

              const SizedBox(width: 20),
              const VerticalDivider(width: 1),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.navigate_before),
                splashRadius: 20,
                tooltip: "Previous page",
                color: widget.theme?.paginationButtonsColor,
                onPressed: _state.currentPage.hasPreviousPage ? () {
                  _state.resolvePage(pageType: TablePageType.previous, skipCache: false);
                } : null,
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                splashRadius: 20,
                tooltip: "Next page",
                color: widget.theme?.paginationButtonsColor,
                onPressed: _state.currentPage.hasNextPage ? () {
                  _state.resolvePage(pageType: TablePageType.next, skipCache: false);
                } : null,
              )
            ],
          );
        }
      ),
    );
  }

  Widget _buildResultSet(BuildContext context) {
    if(_state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if(_state.hasError) {
      return Center(child: Text("An error has ocurred.\n${_state.error}"));
    }

    if(_state.currentPage.items.isEmpty) {
      return const Center(child: Text("No items have been found."));
    }

    return ListView.builder(
      itemCount: _state.currentPage.items.length,
      itemBuilder: (context, index) {
        var item = _state.currentPage.items[index];
        return Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              _state.onRowTapped(item);
            },
            child: Row(
              children: _buildRow(context, item)
            )
          ),
        );
      },
    );
  }

  List<Widget> _buildRow(BuildContext context, T item) {
    var items = <Widget>[
      const SizedBox(width: 12)
    ];
    for(var column in _state.columns) {
      if(column is TableColumnBuilder<T>) {
        items.add(_buildCell(context, column, item));
      } else if(column.flex != null) {
        items.add(Expanded(
          flex: column.flex!,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildCell(context, column, item),
          ),
        ));
      } else {
        items.add(Align(
          alignment: column.alignment ?? Alignment.centerLeft,
          child: _buildCell(context, column, item),
        ));
      }

      items.add(const SizedBox(width: 20));
    }

    items.add(const SizedBox(width: 12));

    return items;
  }

  Widget _buildCell(BuildContext context, BaseTableColumn<T> column, T item) {
    if(column is TableColumn<T>) {
      return column.rowFormatter(context, item);
    } else if(column is CheckboxTableColumn<T>) {
      return CheckboxTableColumnWidget(
        onChange: column.onChange,
        initialValue: column.forField(item),
      );
    } else if(column is TableColumnBuilder<T>) {
      return column.rowFormatter(context, item);
    } else {
      return const SizedBox();
    }
  }

  void _onEvent(PagedDataTableEvent event) {
    if(event is DataTableCacheResetEvent) {
      // TODO: Add message translation
      String message = event.reason == DataTableCacheResetReason.previosPageNotFoundInCache ? "Table has been reset because previous page has expired." : "Table has been reset because cache has been expired";

      if(widget.theme?.messageEventNotifier == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ));
      } else {
        if(widget.theme!.messageEventNotifier!.function != null) {
          widget.theme!.messageEventNotifier!.function!.call(message);
        }
      }
    }
  }

  @override
  void dispose() {
    _onEventReceivedListener?.cancel();
    super.dispose();
  }
}