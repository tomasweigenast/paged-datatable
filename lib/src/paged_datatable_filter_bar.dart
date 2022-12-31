part of 'paged_datatable.dart';

class _PagedDataTableFilterTab<TKey extends Object, TResult extends Object> extends StatelessWidget {
  final PagedDataTableFilterBarMenu? menu;
  
  const _PagedDataTableFilterTab(this.menu);

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          /* FILTER BUTTON */
          if(state.filters.isNotEmpty)
            Ink(
              child: InkWell(
                radius: 20,
                child: Tooltip(
                  message: "Filter",
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (details) {
                        _showFilterOverlay(details, context, state);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.filter_list_rounded),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          /* SELECTED FILTERS */
          Row(
            children: state.filters.values.where((element) => element.hasValue).map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                visualDensity: VisualDensity.comfortable,
                deleteIcon: const Icon(Icons.close, size: 20,),
                deleteButtonTooltipMessage: "Remove filter",
                onDeleted: () {
                  state.removeFilter(e._filter.id);
                },
                label: Text((e._filter as dynamic).chipFormatter(e.value), style: const TextStyle(fontWeight: FontWeight.bold))
              ),
            )).toList()
          ),
          const Spacer(),
          
          /* MENU */
          if(menu != null)
            IconButton(
              splashRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tooltip: menu!.tooltip,
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showMenu(context: context, items: menu!.items);
              },
            )
        ],
      ),
    );
  }

  Future<void> _showFilterOverlay(TapDownDetails details, BuildContext context, _PagedDataTableState<TKey, TResult> state) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;

    var rect = RelativeRect.fromLTRB(offset.dx+10, offset.dy+size.height-10, 0, 0);

    await showDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => _FiltersDialog<TKey, TResult>(rect: rect, state: state)
    );
  }
}

class _FiltersDialog<TKey extends Object, TResult extends Object> extends StatelessWidget {
  final RelativeRect rect;
  final _PagedDataTableState<TKey, TResult> state;

  const _FiltersDialog({required this.rect, required this.state});

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
              borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: Material(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                    child: Form(
                      key: state.filtersFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("Filter by", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...state.filters.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: entry.value._filter.buildPicker(context, entry.value),
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
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            state.removeFilters();
                          },
                          child: const Text("Remove"),
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                          ),
                          onPressed: () {
                            // to ensure onSaved is called
                            state.filtersFormKey.currentState!.save();
                            Navigator.pop(context);
                            state.applyFilters();
                          },
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
}