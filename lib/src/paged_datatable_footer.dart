part of 'paged_datatable.dart';

class _PagedDataTableFooter<
    TKey extends Comparable,
    TResultId extends Comparable,
    TResult extends Object> extends StatelessWidget {
  final Widget? footer;

  const _PagedDataTableFooter(this.footer);

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);
    final localization = PagedDataTableLocalization.of(context);

    return Consumer<_PagedDataTableState<TKey, TResultId, TResult>>(
      builder: (context, state, child) {
        Widget child = SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* USER DEFINED CONTROLS */
                if (footer != null) footer! else const SizedBox.shrink(),

                /* PAGINATION CONTROLS */
                Row(
                  children: [
                    /* REFRESH */
                    if (theme.configuration.allowRefresh) ...[
                      IconButton(
                          splashRadius: 20,
                          tooltip: localization.refreshText,
                          onPressed: () => state._refresh(),
                          icon: Icon(Icons.refresh_outlined,
                              color: theme.buttonsColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                          color: theme.dividerColor,
                        ),
                      ),
                    ],

                    /* ROWS PER PAGE */
                    if (theme.configuration.pageSizes != null &&
                        theme.configuration.pageSizes!.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(localization.rowsPagePageText),
                          const SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: DropdownButtonFormField<int>(
                              value: theme.configuration.initialPageSize,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style:
                                  theme.footerTextStyle?.copyWith(fontSize: 14),
                              onChanged: state.tableState == _TableState.loading
                                  ? null
                                  : (newPageSize) {
                                      if (newPageSize != null) {
                                        state.setPageSize(newPageSize);
                                      }
                                    },
                              items: theme.configuration.pageSizes!
                                  .map(
                                    (page) => DropdownMenuItem(
                                      value: page,
                                      child: Text(page.toString()),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                          color: theme.dividerColor,
                        ),
                      ),
                    ],

                    /* CURRENT PAGE ELEMENTS */
                    if (theme.configuration.footer.showTotalElements)
                      Text(
                        localization.totalElementsText(state._rowsState.length),
                      )
                    else
                      Text(
                        localization.pageIndicatorText(state.currentPage),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: VerticalDivider(
                        indent: 10,
                        endIndent: 10,
                        color: theme.dividerColor,
                      ),
                    ),

                    /* PAGE BUTTONS */
                    IconButton(
                      tooltip: localization.previousPageButtonText,
                      splashRadius: 20,
                      icon: Icon(Icons.keyboard_arrow_left_rounded,
                          color: theme.buttonsColor),
                      onPressed: (state.hasPreviousPage &&
                              state.tableState != _TableState.loading)
                          ? state.previousPage
                          : null,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      tooltip: localization.nextPageButtonText,
                      splashRadius: 20,
                      icon: Icon(Icons.keyboard_arrow_right_rounded,
                          color: theme.buttonsColor),
                      onPressed: (state.hasNextPage &&
                              state.tableState != _TableState.loading)
                          ? state.nextPage
                          : null,
                    )
                  ],
                )
              ],
            ),
          ),
        );

        if (theme.headerBackgroundColor != null) {
          child = DecoratedBox(
            decoration: BoxDecoration(color: theme.headerBackgroundColor),
            child: child,
          );
        }

        if (theme.footerTextStyle != null) {
          child = DefaultTextStyle(style: theme.footerTextStyle!, child: child);
        }

        return child;
      },
    );
  }
}
