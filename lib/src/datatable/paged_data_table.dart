import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/column/checkbox_table_column.dart';
import 'package:paged_datatable/src/datatable/column/table_column.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_datatable_configuration.dart';
import 'package:paged_datatable/src/datatable/filter/paged_datatable_filter.dart';
import 'package:paged_datatable/src/datatable/page_indicator.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_event.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_footer.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_header.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_state.dart';
import 'package:paged_datatable/src/helpers/nil.dart';
import 'package:provider/provider.dart';

import 'configuration/paged_datatable_configuration_data.dart';

/// Function that resolves a page.
typedef PageResolver<T> = Future<PageIndicator<T>> Function(String? pageToken, int pageSize, FilterCollection filters);

class PagedDataTable<T extends Object> extends StatefulWidget {

  final List<BaseTableColumn<T>> columns;
  final List<int>? pageSizes;
  final int? defaultPageSize;
  final String initialPageToken;
  final PageResolver<T> resolvePage;
  final void Function(T item, bool selected)? onRowSelected;
  final PagedTableRowTapped<T>? onRowTap;
  final List<BasePagedDataTableFilter>? filters;
  final PagedDataTableConfigurationData? configuration;
  final Object? Function(T item)? itemIdEvaluator;

  const PagedDataTable({
    required this.columns, 
    required this.resolvePage, 
    this.filters, 
    this.onRowSelected,
    this.onRowTap, 
    String? initialPageToken, 
    this.pageSizes, 
    this.defaultPageSize,
    this.configuration,
    this.itemIdEvaluator,
    Key? key}) 
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
    var configuration = widget.configuration ?? PagedDataTableConfiguration.maybeOf(context) ?? _kDefaultDataTableConfiguration;

    return ChangeNotifierProvider<PagedDataTableState<T>>.value(
      value: _state,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: configuration.theme?.shape,
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
              child: Container(
                color: configuration.theme?.rowColors?[0],
                child: Consumer<PagedDataTableState<T>>(
                  builder: (context, model, child) {
                    if(configuration.enableTransitions) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildResultSet(context, configuration),
                        switchInCurve: Curves.easeIn,
                      );
                    } else {
                      return _buildResultSet(context, configuration);
                    }
                  }
                ),
              ),
            ),
            const Divider(height: 1),
            PagedDataTableFooter<T>(
              theme: configuration.theme?.footerTheme,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultSet(BuildContext context, PagedDataTableConfigurationData configuration) {
    if(_state.isLoading) {
      return SizedBox(
        key: ValueKey(_state.tableState),
        child: configuration.loader.child,
      );
    }

    if(_state.hasError) {
      return Center(child: Text("An error has ocurred.\n${_state.error}"), key: ValueKey(_state.tableState));
    }

    if(_state.currentPage.items.isEmpty) {
      return Center(child: const Text("No items have been found."), key: ValueKey(_state.tableState));
    }

    return ListView.separated(
      key: ValueKey(_state.tableState),
      separatorBuilder: (_, __) => configuration.theme?.rowColors != null ? const Nil() : const Divider(height: 0, thickness: 1),
      itemCount: _state.currentPage.items.length,
      itemBuilder: (context, index) {
        var item = _state.currentPage.items[index];
        return Material(
          color: configuration.theme?.rowColors == null ? _state.isRowSelected(item) ? configuration.theme?.selectedRowColor ?? Theme.of(context).colorScheme.primary.withOpacity(.1) : Colors.white : (configuration.theme!.rowColors!.length == 1 ? configuration.theme!.rowColors![0] : index % 2 == 0 ? configuration.theme!.rowColors![0] : configuration.theme!.rowColors![1]),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
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
    var items = <Widget>[];

    for(var column in _state.columns) {
      if(column is TableColumnBuilder<T>) {
        items.add(_buildCell(context, column, item));
      } else {
        items.add(Expanded(
          flex: column.flex ?? 1,
          child: Align(
            alignment: column.alignment ?? Alignment.centerLeft,
            child: _buildCell(context, column, item),
          ),
        ));
      }
    }

    return items;
  }

  Widget _buildCell(BuildContext context, BaseTableColumn<T> column, T item) {
    if(column is TableColumn<T>) {
      return Padding(
        key: ValueKey(widget.itemIdEvaluator?.call(item) ?? item),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: column.rowFormatter(context, item),
      );
    } else if(column is CheckboxTableColumn<T>) {
      return Padding(
        key: ValueKey(widget.itemIdEvaluator?.call(item) ?? item),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CheckboxTableColumnWidget(
          onChange: column.onChange == null ? null : (newValue) => column.onChange!.call(item, newValue),
          initialValue: column.forField(item),
        ),
      );
    } else if(column is TableColumnBuilder<T>) {
      return Padding(
        key: ValueKey(widget.itemIdEvaluator?.call(item) ?? item),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: column.rowFormatter(context, item),
      );
    } else {
      return const SizedBox();
    }
  }

  void _onEvent(PagedDataTableEvent event) {
    var configuration = PagedDataTableConfiguration.maybeOf(context) ?? _kDefaultDataTableConfiguration;

    if(event is DataTableCacheResetEvent) {
      // TODO: Add message translation
      String message = event.reason == DataTableCacheResetReason.previosPageNotFoundInCache ? "Table has been reset because previous page has expired." : "Table has been reset because cache has been expired";

      if(configuration.messageEventNotifier == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ));
      } else {
        if(configuration.messageEventNotifier!.function != null) {
          configuration.messageEventNotifier!.function!.call(message);
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

const PagedDataTableConfigurationData _kDefaultDataTableConfiguration = PagedDataTableConfigurationData(
  enableTransitions: false,
  loader: PagedDataTableLoader.linear()
);