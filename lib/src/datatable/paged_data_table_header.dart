import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/filter/paged_datatable_filter.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_filter_state.dart';
import 'package:paged_datatable/src/helpers/popup_menu_widget.dart';
import 'package:provider/provider.dart';

class PagedDataTableHeader<T> extends StatefulWidget{

  final List<BaseTableColumn<T>> columns;
  final List<BasePagedDataTableFilter>? filters;

  const PagedDataTableHeader({required this.columns, required this.filters, Key? key }) : super(key: key);

  @override
  _PagedDataTableHeaderState createState() => _PagedDataTableHeaderState();
}

class _PagedDataTableHeaderState<T> extends State<PagedDataTableHeader<T>> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 35),
      color: Colors.grey[200],
      child: DefaultTextStyle(
        style: const TextStyle(fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.filters != null)
              ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildFilters(),
                ),
                const Divider(),
              ],

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(  
                children: _buildColumnHeaders()
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColumnHeaders() {
    List<Widget> items = [];
    for(var column in widget.columns) {
      if(column is TableColumnBuilder<T>) {
        items.addAll([
          column.title,
          const SizedBox(width: 20)
        ]);
      } else {
        items.addAll([
          if(column.flex != null)
            Expanded(
              flex: column.flex!,
              child: Align(
                alignment: Alignment.centerLeft,
                child: column.title,
              ),
            )
          else
            Align(
              alignment: column.alignment ?? Alignment.centerLeft,
              child: column.title,
            ),

          const SizedBox(width: 20)
        ]);
      }
    }

    return items;
  }

  Widget _buildFilters() {
    return Consumer<PagedDataTableFilterState>(
      builder: (context, state, child) {
        return Row(
          children: [
            PopupMenuButton(
              tooltip: "Show filter menu",
              icon: const Icon(Icons.filter_list_rounded),
              itemBuilder: (context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  enabled: false,
                  height: 22,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: SelectableText("Filter by", style: TextStyle(color: Colors.black)),
                ),
                PopupMenuWidget(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.filters!.map((filter) => _buildFilter(filter, state)).toList()
                    ),
                  ),
                ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem(
                  enabled: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(20)
                          ),
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20)
                          ),
                          child: const Text("Apply"),
                          onPressed: () {
                            _formKey.currentState!.save();
                            if(_formKey.currentState!.validate()) {
                              state.applyFilters();
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  value: null,
                )
              ],
              elevation: 8,
              offset: const Offset(20, 35),
              enableFeedback: false,
            ),
            _buildSelectedFilterChips()
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
      constraints: const BoxConstraints(
        minWidth: 600
      ),
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
      constraints: const BoxConstraints(
        minWidth: 600
      ),
      child: DropdownButtonFormField<dynamic>(
        items: filter.items,
        isExpanded: true,
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

  Widget _buildSelectedFilterChips() {
    return Consumer<PagedDataTableFilterState>(
      builder: (context, state, _) {
        return Row(
          children: state.activeFilters.map((filter) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: InputChip(
              label: Text((filter.filter as dynamic).chipFormatter.call(filter.currentValue!)),
              deleteIcon: const MouseRegion(
                child: Icon(Icons.close, size: 16),
                cursor: SystemMouseCursors.click,
              ),
              deleteButtonTooltipMessage: "Remove this filter",
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