import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_data_table_coded_intl.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_state.dart';
import 'package:paged_datatable/src/helpers/timer_builder.dart';
import 'package:provider/provider.dart';

class PagedDataTableFooter<T> extends StatefulWidget {
  
  final PagedDataTableConfigurationData configuration;
  final Widget? additional;

  const PagedDataTableFooter({required this.configuration, required this.additional, Key? key }) : super(key: key);

  @override
  _PagedDataTableFooterState<T> createState() => _PagedDataTableFooterState<T>();
}

class _PagedDataTableFooterState<T> extends State<PagedDataTableFooter<T>> {

  final ScrollController _additionalWidgetsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var intl = PagedDataTableLocalization.maybeOf(context) ?? PagedDataTableCodedIntl.maybeFrom(widget.configuration);

    return Material(
      color: widget.configuration.theme?.footerTheme?.backgroundColor ?? Colors.grey[200],
      elevation: widget.configuration.theme?.footerTheme?.backgroundColor != null ? 3 : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 50,
        child: DefaultTextStyle(
          style: TextStyle(color: widget.configuration.theme?.footerTheme?.textColor ?? Colors.black),
          child: Consumer<PagedDataTableState<T>>(
            builder: (context, state, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(widget.additional != null)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _additionalWidgetsScrollController,
                        child: SingleChildScrollView(
                          controller: _additionalWidgetsScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: widget.additional!,
                          )
                        ),
                      ),
                    ),

                  const Spacer(),
                  if(widget.configuration.refreshButtonEnabled)
                    TimerBuilder(
                      duration: const Duration(minutes: 1),
                      builder: (context, child) => IconButton(
                        color: widget.configuration.theme?.footerTheme?.textColor,
                        icon: const Icon(Icons.refresh),
                        splashRadius: 20,
                        tooltip: intl?.refreshButtonText(widget.configuration.refreshButtonDateFormatting(context, state.lastSyncDate)) ?? "Refresh. Refreshed ${widget.configuration.refreshButtonDateFormatting(context, state.lastSyncDate)}",
                        onPressed: state.lastSyncDate == null || state.lastSyncDate!.difference(DateTime.now()).abs().inMinutes >= 1 ? () {
                          state.refresh(clearCache: false, skipCache: true);
                        } : null,
                      ) 
                    ),
                  const SizedBox(width: 12),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 12),

                  if(state.isRowsPerPageAvailable)
                    ...[
                      SelectableText(intl?.rowsPagePageText ?? "Rows per page"),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        constraints: const BoxConstraints(
                          maxWidth: 80,
                        ),
                        child: DropdownButtonFormField<int>(
                          value: state.currentPageSize,
                          iconEnabledColor: widget.configuration.theme?.footerTheme?.textColor ?? widget.configuration.theme?.footerTheme?.paginationButtonsColor,
                          decoration: widget.configuration.theme?.footerTheme?.rowsPerPageDropdownInputDecoration ?? InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: widget.configuration.theme?.footerTheme?.textColor ?? const Color(0xff000000),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: widget.configuration.theme?.footerTheme?.textColor?.withOpacity(.5) ?? const Color(0xff000000),
                              ),
                            )
                          ),
                          style: TextStyle(fontSize: 14, color: widget.configuration.theme?.footerTheme?.textColor),
                          items: state.pageSizes.map((e) => DropdownMenuItem(
                            child: Text(e.toString()), 
                            value: e,
                          )).toList(),
                          dropdownColor: widget.configuration.theme?.footerTheme?.backgroundColor?.withOpacity(1),
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
                    ]
                  else
                    const SizedBox(width: 12),

                  SelectableText(intl?.pageIndicatorText(state.currentPage.index+1) ?? "Page ${state.currentPage.index+1}"),

                  const SizedBox(width: 20),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.navigate_before, color: widget.configuration.theme?.footerTheme?.textColor ?? widget.configuration.theme?.footerTheme?.paginationButtonsColor),
                    splashRadius: 20,
                    tooltip: intl?.previousPageButtonText ?? "Previous page",
                    color: widget.configuration.theme?.footerTheme?.paginationButtonsColor,
                    onPressed: state.currentPage.hasPreviousPage && !state.isLoading ? () {
                      state.resolvePage(pageType: TablePageType.previous, skipCache: false);
                    } : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.navigate_next, color: widget.configuration.theme?.footerTheme?.textColor ?? widget.configuration.theme?.footerTheme?.paginationButtonsColor),
                    splashRadius: 20,
                    tooltip: intl?.nextPageButtonText ?? "Next page",
                    color: widget.configuration.theme?.footerTheme?.paginationButtonsColor,
                    onPressed: state.currentPage.hasNextPage && !state.isLoading ? () {
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

  @override
  void dispose() {
    _additionalWidgetsScrollController.dispose();
    super.dispose();
  }
}