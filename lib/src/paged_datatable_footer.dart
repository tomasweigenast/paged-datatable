part of 'paged_datatable.dart';

class _PagedDataTableFooter<TKey extends Object, TResult extends Object>
    extends StatelessWidget {
  final Widget? footer;

  const _PagedDataTableFooter(this.footer);

  @override
  Widget build(BuildContext context) {
    final config = PagedDataTableConfiguration.of(context);
    var localization = PagedDataTableLocalization.of(context);

    return Consumer<_PagedDataTableState<TKey, TResult>>(
      builder: (context, state, child) => SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* USER DEFINED CONTROLS */
                if (footer != null) footer!,

                /* PAGINATION CONTROLS */
                Row(
                  children: [
                    /* REFRESH */
                    if (config.allowRefresh) ...[
                      IconButton(
                          splashRadius: 20,
                          tooltip: localization.refreshText,
                          onPressed: () =>
                              state._refresh(currentDataset: false),
                          icon: const Icon(Icons.refresh_outlined)),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: VerticalDivider(indent: 10, endIndent: 10)),
                    ],

                    /* ROWS PER PAGE */
                    if (config.pageSizes != null &&
                        config.pageSizes!.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(localization.rowsPagePageText),
                          const SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: DropdownButtonFormField<int>(
                                value: config.initialPageSize,
                                decoration: const InputDecoration(
                                    isCollapsed: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 8),
                                    border: OutlineInputBorder()),
                                style: const TextStyle(fontSize: 14),
                                onChanged:
                                    state.tableState == _TableState.loading
                                        ? null
                                        : (newPageSize) {
                                            if (newPageSize != null) {
                                              state.setPageSize(newPageSize);
                                            }
                                          },
                                items: config.pageSizes!
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e.toString())))
                                    .toList()),
                          )
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: VerticalDivider(indent: 10, endIndent: 10)),
                    ],

                    /* CURRENT PAGE ELEMENTS */
                    if (config.footer.showTotalElements)
                      Text(localization
                          .totalElementsText(state.tableCache.currentLength))
                    else
                      Text(localization.pageIndicatorText(
                          state.tableCache.currentPageIndex)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: VerticalDivider(indent: 10, endIndent: 10)),

                    /* PAGE BUTTONS */
                    IconButton(
                      tooltip: localization.previousPageButtonText,
                      splashRadius: 20,
                      icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      onPressed: (state.tableCache.canGoBack &&
                              state.tableState != _TableState.loading)
                          ? () {
                              state.navigate(
                                  state.tableCache.currentPageIndex - 1);
                            }
                          : null,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      tooltip: localization.nextPageButtonText,
                      splashRadius: 20,
                      icon: const Icon(Icons.keyboard_arrow_right_rounded),
                      onPressed: (state.tableCache.canGoNext &&
                              state.tableState != _TableState.loading)
                          ? () {
                              state.navigate(
                                  state.tableCache.currentPageIndex + 1);
                            }
                          : null,
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
