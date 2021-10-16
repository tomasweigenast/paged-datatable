import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_event.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_state.dart';
import 'package:paged_datatable/src/helpers/date_format.dart';
import 'package:paged_datatable/src/helpers/timer_builder.dart';
import 'package:provider/provider.dart';

class PagedDataTableFooter<T> extends StatefulWidget {
  
  final PagedDataTableFooterTheme? theme;

  const PagedDataTableFooter({required this.theme, Key? key }) : super(key: key);

  @override
  _PagedDataTableFooterState<T> createState() => _PagedDataTableFooterState<T>();
}

class _PagedDataTableFooterState<T> extends State<PagedDataTableFooter<T>> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme ?? PagedDataTableConfiguration.maybeOf(context)?.theme?.footerTheme ?? PagedDataTableTheme.fromThemeData(Theme.of(context)).footerTheme;

    return Material(
      color: theme?.backgroundColor ?? Colors.grey[200],
      elevation: theme?.backgroundColor != null ? 3 : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 42,
        child: DefaultTextStyle(
          style: TextStyle(color: theme?.textColor ?? Colors.black),
          child: Consumer<PagedDataTableState<T>>(
            builder: (context, state, _) {
              return Row(
                children: [
                  if(kDebugMode)
                    ...[
                      TextButton(
                        child: const Text("Fire event"),
                        onPressed: () {
                          state.fireEvent(const DataTableCacheResetEvent(reason: DataTableCacheResetReason.previosPageNotFoundInCache));
                        },
                      )
                    ],
                  const Spacer(),
                  TimerBuilder(
                    duration: const Duration(minutes: 1),
                    builder: (context, child) => IconButton(
                      icon: Icon(Icons.refresh, color: theme?.textColor),
                      splashRadius: 20,
                      tooltip: "Refresh. Refreshed ${VerboseDateFormat.format(state.lastSyncDate)}",
                      onPressed: state.lastSyncDate == null || state.lastSyncDate!.difference(DateTime.now()).abs().inMinutes >= 1 ? () {
                        state.refresh(clearCache: false, skipCache: true);
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
                      value: state.currentPageSize,
                      iconEnabledColor: theme?.textColor ?? theme?.paginationButtonsColor,
                      decoration: theme?.rowsPerPageDropdownInputDecoration ?? InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme?.textColor ?? const Color(0xff000000),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme?.textColor?.withOpacity(.5) ?? const Color(0xff000000),
                          ),
                        )
                      ),
                      
                      style: TextStyle(fontSize: 14, color: theme?.textColor),
                      items: state.pageSizes.map((e) => DropdownMenuItem(
                        child: Text(e.toString()), 
                        value: e,
                      )).toList(),
                      dropdownColor: theme?.backgroundColor?.withOpacity(1),
                      onChanged: state.isLoading ? null : (newPageSize) {
                        if(newPageSize != null) {
                          state.setPageSize(newPageSize);
                          state.refresh(clearCache: true, skipCache: true);
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 20),

                  SelectableText("Page ${state.currentPage.index+1}"),

                  const SizedBox(width: 20),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.navigate_before, color: theme?.textColor ?? theme?.paginationButtonsColor),
                    splashRadius: 20,
                    tooltip: "Previous page",
                    color: theme?.paginationButtonsColor,
                    onPressed: state.currentPage.hasPreviousPage ? () {
                      state.resolvePage(pageType: TablePageType.previous, skipCache: false);
                    } : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.navigate_next, color: theme?.textColor ?? theme?.paginationButtonsColor),
                    splashRadius: 20,
                    tooltip: "Next page",
                    color: theme?.paginationButtonsColor,
                    onPressed: state.currentPage.hasNextPage ? () {
                      state.resolvePage(pageType: TablePageType.next, skipCache: false);
                    } : null,
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}