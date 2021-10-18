import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_filter_state.dart';

class PagedDataTableFilterPopup extends StatefulWidget{

  final Iterable<Widget> widgets;
  final bool clearAllButtonEnabled;
  final PagedDataTableLocalization? intl;
  final PagedDataTableFilterState state;

  const PagedDataTableFilterPopup({required this.widgets, required this.intl, required this.clearAllButtonEnabled, required this.state, Key? key }) : super(key: key);

  @override
  _PagedDataTableFilterPopupState createState() => _PagedDataTableFilterPopupState();
}

class _PagedDataTableFilterPopupState extends State<PagedDataTableFilterPopup> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Card(
      elevation: 5,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height / 2,
          maxWidth: size.width / 3,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                child: SelectableText(widget.intl?.filterByTitle ?? "Filter by", style: const TextStyle(color: Colors.black, fontSize: 16)),
              ),

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: widget.widgets.toList(),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20)
                        ),
                        child: Text(widget.intl?.removeAllFiltersButtonText ?? "Remove all"),
                        onPressed: widget.clearAllButtonEnabled ? () {
                         widget.state.clearFilters();
                          Navigator.pop(context);
                        } : null,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20)
                        ),
                        child: Text(widget.intl?.cancelFilteringButtonText ?? "Cancel"),
                        onPressed: () {
                          widget.state.clearFilters(notify: false);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20)
                        ),
                        child: Text(widget.intl?.applyFilterButtonText ?? "Apply", textAlign: TextAlign.center),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if(_formKey.currentState!.validate()) {
                            widget.state.applyFilters();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}