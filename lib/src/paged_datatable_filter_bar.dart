part of 'paged_datatable.dart';

class _PagedDataTableFilterTab<
    TKey extends Comparable,
    TResultId extends Comparable,
    TResult extends Object> extends StatelessWidget {
  final PagedDataTableFilterBarMenu? menu;
  final Widget? header;

  const _PagedDataTableFilterTab(this.menu, this.header);

  @override
  Widget build(BuildContext context) {
    var localizations = PagedDataTableLocalization.of(context);
    var theme = PagedDataTableTheme.of(context);

    Widget child = SizedBox(
      height: theme.configuration.filterBarHeight,
      child: Consumer<_PagedDataTableState<TKey, TResultId, TResult>>(
          builder: (context, state, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  /* FILTER BUTTON */
                  if (state.filters.isNotEmpty)
                    Ink(
                      child: InkWell(
                        radius: 20,
                        child: Tooltip(
                          message: localizations.showFilterMenuTooltip,
                          child: MouseRegion(
                            cursor: state.tableState == _TableState.loading
                                ? SystemMouseCursors.basic
                                : SystemMouseCursors.click,
                            child: GestureDetector(
                              onTapDown: state.tableState == _TableState.loading
                                  ? null
                                  : (details) {
                                      _showFilterOverlay(details, context,
                                          state, localizations);
                                    },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Icon(Icons.filter_list_rounded,
                                    color: theme.buttonsColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  /* SELECTED FILTERS */
                  Expanded(
                    child: Scrollbar(
                      controller: state.filterChipsScrollController,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: state.filterChipsScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: state.filters.values
                                .where((element) => element.hasValue)
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Chip(
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 20,
                                          ),
                                          deleteButtonTooltipMessage:
                                              localizations
                                                  .removeFilterButtonText,
                                          onDeleted: () {
                                            state.removeFilter(e._filter.id);
                                          },
                                          label: Text(
                                              (e._filter as dynamic)
                                                  .chipFormatter(e.value),
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ))
                                .toList()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  if (header != null) ...[
                    const Spacer(),
                    Flexible(child: header!)
                  ] else
                    const Spacer(),

                  /* MENU */
                  if (menu != null)
                    IconButton(
                      splashRadius: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      tooltip: menu!.tooltip,
                      icon: Icon(Icons.more_vert, color: theme.buttonsColor),
                      onPressed: () {
                        _showMenu(context: context, items: menu!.items);
                      },
                    )
                ],
              ),
            )
          ],
        );
      }),
    );

    if (theme.headerBackgroundColor != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: theme.headerBackgroundColor),
        child: child,
      );
    }

    if (theme.chipTheme != null) {
      child = ChipTheme(
        data: theme.chipTheme!,
        child: child,
      );
    }

    if (theme.filtersHeaderTextStyle != null) {
      child =
          DefaultTextStyle(style: theme.filtersHeaderTextStyle!, child: child);
    }

    return child;
  }

  Future<void> _showFilterOverlay(
      TapDownDetails details,
      BuildContext context,
      _PagedDataTableState<TKey, TResultId, TResult> state,
      PagedDataTableLocalization localizations) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;

    var rect = RelativeRect.fromLTRB(
        offset.dx + 10, offset.dy + size.height - 10, 0, 0);

    await showDialog(
        context: context,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) => _FiltersDialog<TKey, TResultId, TResult>(
            rect: rect, state: state, localizations: localizations));
  }
}

class _FiltersDialog<TKey extends Comparable, TResultId extends Comparable,
    TResult extends Object> extends StatelessWidget {
  final RelativeRect rect;
  final _PagedDataTableState<TKey, TResultId, TResult> state;
  final PagedDataTableLocalization localizations;

  const _FiltersDialog(
      {required this.rect, required this.state, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            top: rect.top,
            left: rect.left,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black54)],
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Material(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8.0),
                      child: Form(
                        key: state.filtersFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(localizations.filterByTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...state.filters.entries
                                .where(
                                    (element) => element.value._filter.visible)
                                .map((entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: entry.value._filter
                                          .buildPicker(context, entry.value),
                                    ))
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)),
                            onPressed: () {
                              Navigator.pop(context);
                              state.removeFilters();
                            },
                            child:
                                Text(localizations.removeAllFiltersButtonText),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:
                                Text(localizations.cancelFilteringButtonText),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)),
                            onPressed: () {
                              // to ensure onSaved is called
                              state.filtersFormKey.currentState!.save();
                              Navigator.pop(context);
                              state.applyFilters();
                            },
                            child: Text(localizations.applyFilterButtonText),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
