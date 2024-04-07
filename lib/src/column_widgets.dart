part of 'paged_datatable.dart';

final class _SelectRowCheckbox<K extends Comparable<K>, T> extends StatelessWidget {
  final int index;

  const _SelectRowCheckbox({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final tableController = TableControllerProvider.of<K, T>(context);

    return Checkbox(
      value: tableController._selectedRows.contains(index),
      tristate: false,
      onChanged: (_) => tableController.toggleRow(index),
    );
  }
}

final class _SelectAllRowsCheckbox<K extends Comparable<K>, T> extends StatefulWidget {
  const _SelectAllRowsCheckbox({super.key});

  @override
  State<StatefulWidget> createState() => _SelectAllRowsCheckboxState<K, T>();
}

final class _SelectAllRowsCheckboxState<K extends Comparable<K>, T> extends State<_SelectAllRowsCheckbox<K, T>> {
  late final tableController = TableControllerProvider.of<K, T>(context);
  bool? state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _onTableControllerChanged();
    tableController.addListener(_onTableControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: state,
      tristate: true,
      onChanged: (newValue) {
        switch (newValue) {
          case false:
          case null:
            tableController.unselectEveryRow();
            break;

          case true:
            tableController.selectAllRows();
            break;
        }
      },
    );
  }

  void _onTableControllerChanged() {
    final newState = tableController._selectedRows.isEmpty
        ? false
        : tableController._selectedRows.length == tableController._totalItems
            ? true
            : null;

    if (state != newState) {
      setState(() {
        state = newState;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    tableController.removeListener(_onTableControllerChanged);
  }
}

class _DropdownCell<T, V> extends StatefulWidget {
  final Getter<T, V> getter;
  final Setter<T, V> setter;
  final T item;
  final int index;
  final List<DropdownMenuItem<V>> items;
  final InputDecoration inputDecoration;

  const _DropdownCell({
    required this.getter,
    required this.setter,
    required this.item,
    required this.index,
    required this.items,
    required this.inputDecoration,
    super.key,
  });

  @override
  State<_DropdownCell> createState() => _DropdownCellState<T, V>();
}

class _DropdownCellState<T, V> extends State<_DropdownCell<T, V>> {
  late V? currentValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentValue = widget.getter(widget.item, widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<V>(
        items: widget.items,
        style: PagedDataTableTheme.of(context).cellTextStyle,
        value: currentValue,
        onChanged: isLoading
            ? null
            : (newValue) async {
                if (newValue == null) return;

                setState(() {
                  isLoading = true;
                });
                if (await widget.setter(widget.item, newValue, widget.index)) {
                  currentValue = newValue;
                }

                setState(() {
                  isLoading = false;
                });
              },
      ),
    );
  }
}

class _TextFieldCell<T> extends StatefulWidget {
  final Getter<T, String> getter;
  final Setter<T, String> setter;
  final T item;
  final int index;
  final bool isDialog;
  final InputDecoration inputDecoration;
  final List<TextInputFormatter>? inputFormatters;

  const _TextFieldCell({
    required this.getter,
    required this.setter,
    required this.item,
    required this.index,
    required this.isDialog,
    required this.inputDecoration,
    required this.inputFormatters,
    super.key,
  });

  @override
  State<_TextFieldCell<T>> createState() => _TextFieldCellState<T>();
}

class _TextFieldCellState<T> extends State<_TextFieldCell<T>> {
  late final TextEditingController textController;
  String? previousValue;
  bool isLoading = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    previousValue = widget.getter(widget.item, widget.index);
    textController = TextEditingController(text: previousValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);
    if (isEditing) {
      return TextField(
        controller: textController,
        style: theme.cellTextStyle,
        enabled: !isLoading,
        autofocus: true,
        inputFormatters: widget.inputFormatters,
        decoration: widget.inputDecoration,
        onEditingComplete: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                final newValue = textController.text;
                if (newValue != previousValue) {
                  if (await widget.setter(widget.item, newValue, widget.index)) {
                    previousValue = newValue;
                  } else {
                    textController.text = previousValue ?? '';
                  }
                }
                setState(() {
                  isLoading = false;
                  isEditing = false;
                });
              },
      );
    }

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Text(textController.text, style: theme.cellTextStyle),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}
