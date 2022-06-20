import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_data_table_coded_intl.dart';
import 'package:paged_datatable/src/datatable/filter/paged_datatable_filter_popup.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_filter_state.dart';
import 'package:provider/provider.dart';

class PagedDataTableHeader<T> extends StatefulWidget{

  final List<BaseTableColumn<T>> columns;
  final List<BasePagedDataTableFilter>? filters;
  final Widget? additional;
  final PagedDataTableConfigurationData configuration;
  final PagedDataTableOptionsMenu? optionsMenu;

  const PagedDataTableHeader({required this.columns, required this.filters, required this.additional, required this.configuration, required this.optionsMenu, Key? key }) : super(key: key);

  @override
  _PagedDataTableHeaderState createState() => _PagedDataTableHeaderState();
}

class _PagedDataTableHeaderState<T> extends State<PagedDataTableHeader<T>> {

  @override
  Widget build(BuildContext context) {
    var theme = widget.configuration.theme?.headerTheme ?? PagedDataTableConfiguration.maybeOf(context)?.theme?.headerTheme;
    var intl = PagedDataTableLocalization.maybeOf(context) ?? PagedDataTableCodedIntl.maybeFrom(widget.configuration);

    return Material(
      elevation: theme?.backgroundColor != null ? 3 : 0,
      color: theme?.backgroundColor ?? Colors.grey[200],
      child: DefaultTextStyle(
        style: TextStyle(fontWeight: FontWeight.w500, color: theme?.columnNameColor),
        textAlign: TextAlign.left,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.filters != null)
              ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildFilters(theme, intl),
                ),
                const Divider(height: 1),
              ],

            SizedBox(
              height: 40,
              child: DefaultTextStyle(
                style: TextStyle(fontWeight: FontWeight.w600, color: theme?.columnNameColor),
                overflow: TextOverflow.ellipsis,
                child: Row(
                  children: _buildColumnHeaders(theme)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColumnHeaders(PagedDataTableHeaderTheme? theme) {
    List<Widget> items = [];
    for(var column in widget.columns) {
      if(column is TableColumnBuilder<T>) {
        items.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: column.title
        ));
      } else {
        items.add(Expanded(
          flex: column.flex ?? 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: column.alignment ?? Alignment.centerLeft,
            child: column.title,
          ),
        ));
      }
    }

    return items;
  }

  Widget _buildFilters(PagedDataTableHeaderTheme? theme, PagedDataTableLocalization? intl) {
    return Consumer<PagedDataTableFilterState>(
      builder: (context, state, child) {
        return Row(
          children: [
            IconButton(
              splashRadius: 20,
              tooltip: intl?.showFilterMenuTooltip ?? "Show filter menu",
              icon: Icon(Icons.filter_list_rounded, color: theme?.columnNameColor),
              onPressed: () async {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                var offset = renderBox.localToGlobal(Offset.zero);
                var size = renderBox.size;

                RelativeRect rect = RelativeRect.fromLTRB(offset.dx, offset.dy+size.height, 0, 0);

                await showDialog(
                  barrierDismissible: true,
                  barrierColor: Colors.transparent,
                  useSafeArea: true,
                  context: context, 
                  builder: (context) => Stack(
                    fit: StackFit.loose,
                    children: [
                      Positioned(
                        top: rect.top,
                        left: rect.left,
                        child: PagedDataTableFilterPopup(
                          state: state,
                          clearAllButtonEnabled: state.activeFilters.isNotEmpty,
                          widgets: widget.filters!.map((filter) => _buildFilter(filter, state)),
                          intl: intl,
                        ),
                      )
                    ],
                  )
                );
              }
            ),
            _buildSelectedFilterChips(intl),
            const Spacer(),
            if(widget.additional != null)
              widget.additional!,

            if(widget.optionsMenu != null)
              widget.optionsMenu!
          ],
        );
      }
    );
  }

  Widget _buildFilter(BasePagedDataTableFilter filter, PagedDataTableFilterState state) {
    if(filter is PagedDataTableTextFieldFilter) {
      return _buildTextFilter(filter, state);
    } else if(filter is PagedDataTableDropdownFilter) {
      return _buildDropdownFilter(filter, state);
    }

    return Container();
  }

  Widget _buildTextFilter(PagedDataTableTextFieldFilter filter, PagedDataTableFilterState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      // constraints: const BoxConstraints(
      //   minWidth: 600
      // ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: filter.text,
          hintText: filter.decoration?.hintText,
          border: filter.decoration?.border,
          contentPadding: filter.decoration?.contentPadding,
          helperText: filter.decoration?.helperText,
          suffix: filter.decoration?.suffix,
          suffixIcon: filter.decoration?.suffixIcon,
          suffixStyle: filter.decoration?.suffixStyle,
          suffixText: filter.decoration?.suffixText,
          prefix: filter.decoration?.prefix,
          prefixIcon: filter.decoration?.prefixIcon,
          prefixStyle: filter.decoration?.prefixStyle,
          prefixText: filter.decoration?.prefixText,
          isDense: true
        ),
        initialValue: state.getFilterValue(filter.filterId) as String?,
        autofocus: false,
        autovalidateMode: AutovalidateMode.disabled,
        onSaved: (fieldText) {
          if(fieldText != null && fieldText.isNotEmpty) {
            state.setFilterValue(filter.filterId, fieldText);
          }
        },
      )
    );
  }

  Widget _buildDropdownFilter(PagedDataTableDropdownFilter filter, PagedDataTableFilterState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      // constraints: const BoxConstraints(
      //   minWidth: 600
      // ),
      child: DropdownButtonFormField<dynamic>(
        items: filter.items,
        isExpanded: false,
        value: state.getFilterValue(filter.filterId),
        decoration: InputDecoration(
          labelText: filter.text,
          hintText: filter.decoration?.hintText,
          border: filter.decoration?.border,
          contentPadding: filter.decoration?.contentPadding,
          helperText: filter.decoration?.helperText,
          suffix: filter.decoration?.suffix,
          suffixIcon: filter.decoration?.suffixIcon,
          suffixStyle: filter.decoration?.suffixStyle,
          suffixText: filter.decoration?.suffixText,
          prefix: filter.decoration?.prefix,
          prefixIcon: filter.decoration?.prefixIcon,
          prefixStyle: filter.decoration?.prefixStyle,
          prefixText: filter.decoration?.prefixText,
          isDense: true
        ),
        autofocus: false,
        autovalidateMode: AutovalidateMode.disabled,
        onChanged: (newValue) {
          state.setFilterValue(filter.filterId, newValue);
        },
      )
    );
  }

  Widget _buildSelectedFilterChips(PagedDataTableLocalization? intl){
    return Consumer<PagedDataTableFilterState>(
      builder: (context, state, _) {
        return Row(
          children: state.activeFilters.where((element) => (element.filter as dynamic).chipFormatter != null).map((filter) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: InputChip(
              label: Text((filter.filter as dynamic).chipFormatter.call(filter.currentValue!)),
              deleteIcon: const MouseRegion(
                child: Icon(Icons.close, size: 16),
                cursor: SystemMouseCursors.click,
              ),
              deleteButtonTooltipMessage: intl?.removeFilterButtonText ?? "Remove this filter",
              isEnabled: true,
              onDeleted: () {
                state.removeFilter(filter.filterId);
              },
            ),
          )).toList()
        );
      }
    );
  }
}