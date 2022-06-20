import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/column/checkbox_table_column.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_data_table_coded_intl.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_event.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_footer.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_header.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_state.dart';
import 'package:paged_datatable/src/helpers/nil.dart';
import 'package:provider/provider.dart';

part 'paged_data_table_controller.dart';

/// Function that resolves a page.
typedef PageResolver<T> = Future<PageIndicator<T>> Function(String? pageToken, int pageSize, FilterCollection filters);

class PagedDataTable<T extends Object> extends StatefulWidget {

  /// The list of columns.
  final List<BaseTableColumn<T>> columns;

  /// The list of page sizes that can be selected. If no or single value is provided,
  /// "Rows per page" dropdown won't be shown.
  final List<int>? pageSizes;

  /// The default page size to use.
  final int? defaultPageSize;

  /// The initial page token to use.
  final String initialPageToken;

  /// A function that resolves a page.
  final PageResolver<T> resolvePage;

  /// A function that gets called when a row is selected.
  final void Function(T item, bool selected)? onRowSelected;

  /// Defines how rows behave when tapped.
  final PagedTableRowTapped<T>? onRowTap;

  /// The list of filters that are available for this [PagedDataTable]
  final List<BasePagedDataTableFilter>? filters;

  /// Configures this [PagedDataTable].
  final PagedDataTableConfigurationData? configuration;

  /// A function that returns a property of [T], which will be used for comparison. 
  /// If not set, a simple equality comparison will be made on [T].
  final Object? Function(T item)? itemIdEvaluator;
  
  /// A custom [PagedDataTableController] can be set to have more control of the table.
  final PagedDataTableController<T>? controller;
  
  /// Any additional widget to add to the footer row.
  /// This property is not recommended due to design guidelines, a more apropiate way if to use [dataTableOptions].
  /// If you still want to use this property, try to not overhead with many items, it will cause a Scrollbar to be shown.
  final Widget? footer;

  /// Any Additional widget to add to the header row.
  final Widget? header;

  /// Sets an Options menu at the top right corner of the table.
  final PagedDataTableOptionsMenu? optionsMenu;

  /// A stream can be passed so when it gets an update, the list is refreshed automatically.
  final Stream? refreshListener;

  /// A custom row builder.
  final PagedDataTableRowBuilder<T>? rowBuilder;

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
    this.footer,
    this.header,
    this.controller,
    this.optionsMenu,
    this.refreshListener,
    this.rowBuilder,
    Key? key}) 
    : initialPageToken = initialPageToken ?? "", super(key: key);

  @override
  _PagedDataTableState<T> createState() => _PagedDataTableState<T>();
}

class _PagedDataTableState<T extends Object> extends State<PagedDataTable<T>> {

  late final PagedDataTableState<T> _state;
  StreamSubscription? _onEventReceivedListener, _onControllerEventReceivedListener, _onRefreshListenerUpdate;

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
      pageSizes: widget.pageSizes,
      initialPageToken: widget.initialPageToken,
      isSelectable: widget.onRowSelected != null,
      onRowTapped: widget.onRowTap,
      onRowSelected: widget.onRowSelected,
      filters: widget.filters
    );

    _onEventReceivedListener = _state.eventStream.listen(_onEvent);
    _state.resolvePage(pageType: TablePageType.current, skipCache: false);

    if(widget.controller != null) {
      widget.controller!._state = _state;
      _onControllerEventReceivedListener = widget.controller!._onEvent.listen(_onControllerEvent);
    }

    if(widget.refreshListener != null) {
      _onRefreshListenerUpdate = widget.refreshListener!.listen((_) { 
        _state.refresh(clearCache: false, skipCache: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var configuration = widget.configuration ?? PagedDataTableConfiguration.maybeOf(context) ?? _kDefaultDataTableConfiguration;

    return ChangeNotifierProvider<PagedDataTableState<T>>.value(
      value: _state,
      child: ProxyProvider<PagedDataTableState<T>, PagedDataTableController?>(
        create: (context) {
          debugPrint("ProxyProvider created.");
          return widget.controller;
        },
        update: (context, state, controller) {
          if(controller != null) {
            controller._state = state;
            debugPrint("Controller received table state.");
          }

          return null;
        },
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: configuration.theme?.shape,
          elevation: configuration.theme?.elevation ?? 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChangeNotifierProvider.value(
                value: _state.filterState,
                child: PagedDataTableHeader(
                  configuration: configuration,
                  additional: widget.header,
                  columns: _state.columns,
                  filters: widget.filters,
                  optionsMenu: widget.optionsMenu,
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              Expanded(
                child: Container(
                  color: configuration.theme?.rowColors?[0],
                  child: Consumer<PagedDataTableState<T>>(
                    builder: (context, model, child) {
                      if(configuration.enableTransitions) {
                        return AnimatedSwitcher(
                          transitionBuilder: configuration.transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
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
                additional: widget.footer,
                configuration: configuration,
              ),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
            ],
          ),
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
      if(configuration.theme?.onErrorBuilder != null) {
        return SizedBox(
          key: ValueKey(_state.tableState),
          child: configuration.theme!.onErrorBuilder!.call(context, _state.error),
        );
      }

      return Center(child: Text("An error has ocurred.\n${_state.error}"), key: ValueKey(_state.tableState));
    }

    if(_state.currentPage.items.isEmpty) {
      if(configuration.theme?.onNoItemsFound != null) {
        return SizedBox(
          key: ValueKey(_state.tableState),
          child: configuration.theme!.onNoItemsFound!.call(context),
        );
      }
      
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

    if(widget.rowBuilder?.enabledWhen?.call(context, item) == true) {
      return [
        widget.rowBuilder!.builder(context, item)
      ];
    } else {
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
    var intl = PagedDataTableLocalization.maybeOf(context) ?? PagedDataTableCodedIntl.maybeFrom(widget.configuration);

    if(event is DataTableCacheResetEvent) {
      String message = event.reason == DataTableCacheResetReason.previosPageNotFoundInCache 
        ? intl?.previousPageButtonText ?? "Table has been reset because previous page has expired." 
        : intl?.tableResetDueCacheReset ?? "Table has been reset because cache has been expired";

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

  void _onControllerEvent(dynamic event) {
    if(event is _PagedDataTableControllerResetEvent) {
      _state.refresh(clearCache: event.clearCache, skipCache: true);
    }
  }

  @override
  void dispose() {
    _state.dispose();
    _onEventReceivedListener?.cancel();
    _onControllerEventReceivedListener?.cancel();
    _onRefreshListenerUpdate?.cancel();
    super.dispose();
  }
}

const PagedDataTableConfigurationData _kDefaultDataTableConfiguration = PagedDataTableConfigurationData(
  enableTransitions: false,
  loader: PagedDataTableLoader.linear()
);