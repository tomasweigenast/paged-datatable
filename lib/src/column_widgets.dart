part of 'paged_datatable.dart';

final class _SelectRowCheckbox<K extends Comparable<K>, T>
    extends StatelessWidget {
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

final class _SelectAllRowsCheckbox<K extends Comparable<K>, T>
    extends StatefulWidget {
  const _SelectAllRowsCheckbox({super.key});

  @override
  State<StatefulWidget> createState() => _SelectAllRowsCheckboxState<K, T>();
}

final class _SelectAllRowsCheckboxState<K extends Comparable<K>, T>
    extends State<_SelectAllRowsCheckbox<K, T>> {
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

final class _DropdownCell<T, V> extends StatefulWidget {
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

final class _DropdownCellState<T, V> extends State<_DropdownCell<T, V>> {
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

final class _TextFieldCell<T> extends StatefulWidget {
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

final class _TextFieldCellState<T> extends State<_TextFieldCell<T>> {
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
                  if (await widget.setter(
                      widget.item, newValue, widget.index)) {
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

final class _LargeTextFieldCell<T> extends StatefulWidget {
  final Getter<T, String> getter;
  final Setter<T, String> setter;
  final T item;
  final int index;
  final bool isDialog;
  final InputDecoration inputDecoration;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final bool tooltipText;
  final FormFieldValidator? validator;
  final BoxConstraints? tooltipConstraints;
  final TextStyle tooltipStyle;
  final double bottomSheetBreakpoint;

  const _LargeTextFieldCell({
    required this.getter,
    required this.setter,
    required this.item,
    required this.index,
    required this.isDialog,
    required this.inputDecoration,
    required this.inputFormatters,
    required this.label,
    required this.tooltipText,
    required this.validator,
    required this.tooltipStyle,
    required this.tooltipConstraints,
    required this.bottomSheetBreakpoint,
    super.key,
  });

  @override
  State<_LargeTextFieldCell<T>> createState() => _LargeTextFieldCellState<T>();
}

final class _LargeTextFieldCellState<T> extends State<_LargeTextFieldCell<T>> {
  late final TextEditingController textController;
  String? previousValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    previousValue = widget.getter(widget.item, widget.index);
    textController = TextEditingController(text: previousValue);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        final bool isBottomSheet =
            MediaQuery.of(context).size.width < widget.bottomSheetBreakpoint;

        String? newText;

        if (isBottomSheet) {
          newText = await showModalBottomSheet(
            context: context,
            builder: (context) => _EditableTextFieldBottomSheet(
              value: textController.text,
              validator: widget.validator,
              decoration: widget.inputDecoration,
              label: widget.label,
              formatters: widget.inputFormatters,
            ),
          );
        } else {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          var offset = renderBox.localToGlobal(Offset.zero);
          var availableSize = MediaQuery.of(context).size;
          var drawWidth = availableSize.width / 3;
          var drawHeight = availableSize.height / 3;
          var size = renderBox.size;

          double x, y;
          if (offset.dx + drawWidth > availableSize.width) {
            x = offset.dx - drawWidth + size.width;
          } else {
            x = offset.dx;
          }

          if (offset.dy + drawHeight > availableSize.height) {
            y = offset.dy - drawHeight - size.height;
          } else {
            y = offset.dy + size.height;
          }
          RelativeRect rect = RelativeRect.fromLTRB(x, y, 0, 0);

          newText = await showDialog(
            context: context,
            useSafeArea: true,
            barrierColor: Colors.black.withOpacity(.3),
            builder: (context) => _EditableTextFieldOverlay(
              position: rect,
              formatters: widget.inputFormatters,
              value: textController.text,
              width: drawWidth,
              height: drawHeight,
              validator: widget.validator,
              decoration: widget.inputDecoration,
              label: widget.label,
            ),
          );
        }

        if (newText != null && newText != textController.text) {
          if (context.mounted) {
            setState(() {
              isLoading = true;
            });
          }

          if (await widget.setter(widget.item, newText, widget.index)) {
            textController.text = newText;
          } else {
            textController.text = previousValue ?? '';
          }

          if (context.mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : (widget.tooltipText
              ? Tooltip(
                  richMessage: WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Container(
                        constraints: widget.tooltipConstraints ??
                            BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 2),
                        child: Text(textController.text,
                            style: widget.tooltipStyle),
                      )),
                  child: Text(
                    textController.text,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Text(
                  textController.text,
                  overflow: TextOverflow.ellipsis,
                )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}

final class _EditableTextFieldOverlay extends StatefulWidget {
  final RelativeRect position;
  final String value;
  final InputDecoration decoration;
  final String label;
  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? formatters;
  final double width, height;

  const _EditableTextFieldOverlay({
    required this.position,
    required this.value,
    required this.validator,
    required this.decoration,
    required this.label,
    required this.formatters,
    required this.width,
    required this.height,
  });

  @override
  State<StatefulWidget> createState() => _EditableTextFieldOverlayState();
}

final class _EditableTextFieldOverlayState
    extends State<_EditableTextFieldOverlay> {
  late final TextEditingController textController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = PagedDataTableLocalization.of(context);
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: widget.position.top,
            left: widget.position.left,
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: widget.width,
                height: widget.height,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          inputFormatters: widget.formatters,
                          decoration: widget.decoration
                              .copyWith(labelText: widget.label),
                          validator: widget.validator,
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 12,
                          minLines: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                                localizations.editableColumnCancelButtonText),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context, textController.text);
                              }
                            },
                            child: Text(localizations
                                .editableColumnSaveChangesButtonText),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}

final class _EditableTextFieldBottomSheet extends StatefulWidget {
  final String value;
  final InputDecoration decoration;
  final String label;
  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? formatters;

  const _EditableTextFieldBottomSheet({
    required this.value,
    required this.validator,
    required this.decoration,
    required this.label,
    required this.formatters,
  });

  @override
  State<StatefulWidget> createState() => _EditableTextFieldBottomSheetState();
}

final class _EditableTextFieldBottomSheetState
    extends State<_EditableTextFieldBottomSheet> {
  late final TextEditingController textController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = PagedDataTableLocalization.of(context);
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    inputFormatters: widget.formatters,
                    decoration:
                        widget.decoration.copyWith(labelText: widget.label),
                    validator: widget.validator,
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 12,
                    minLines: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(localizations.editableColumnCancelButtonText),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, textController.text);
                        }
                      },
                      child: Text(
                          localizations.editableColumnSaveChangesButtonText),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}
