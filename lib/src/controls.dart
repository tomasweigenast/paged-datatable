part of 'paged_datatable.dart';

class _DateTimePicker extends HookWidget {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateTime? initialDate;
  final DateFormat? dateFormat;
  final void Function(DateTime? date) onSaved;

  const _DateTimePicker({
    required this.decoration, 
    required this.initialDate, 
    required this.firstDate, 
    required this.lastDate,
    required this.onSaved,
    required this.dateFormat
  });
  
  @override
  Widget build(BuildContext context) {
    var textController = useTextEditingController();
    var currentValueRef = useRef<DateTime?>(null);
    var dateFormat = useMemoized(() {
      var df = this.dateFormat ?? DateFormat.yMd();
      if(initialDate != null) {
        currentValueRef.value = initialDate;
        textController.text = df.format(currentValueRef.value!);
      }

      return df;
    });

    return TextFormField(
      decoration: decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValueRef.value = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.single,
            firstDate: firstDate,
            lastDate: lastDate,
            currentDate: initialDate
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return value.first!;
        });

        if(currentValueRef.value != null) {
          textController.text = dateFormat.format(currentValueRef.value!);
        }
      },
      onSaved: (_) => onSaved(currentValueRef.value),
    );
  }
}

class _DateTimeRangePicker extends HookWidget {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateTimeRange? initialValue;
  final DateFormat? dateFormat;
  final void Function(DateTimeRange? date) onSaved;

  const _DateTimeRangePicker({
    required this.decoration, 
    required this.initialValue, 
    required this.firstDate, 
    required this.lastDate,
    required this.onSaved,
    required this.dateFormat
  });

  @override
  Widget build(BuildContext context) {
    var textController = useTextEditingController();
    var currentValueRef = useRef<DateTimeRange?>(null);
    var dateFormat = useMemoized(() {
      var df = this.dateFormat ?? DateFormat.yMd();
      if(initialValue != null) {
        currentValueRef.value = initialValue;
        textController.text = _format(df, currentValueRef);
      }

      return df;
    });


    return TextFormField(
      decoration: decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValueRef.value = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.range,
            firstDate: firstDate,
            lastDate: lastDate,
            currentDate: initialValue?.start,
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return DateTimeRange(start: value.first!, end: value.last!);
        });

        if(currentValueRef.value != null) {
          textController.text = _format(dateFormat, currentValueRef);
        }
      },
      onSaved: (_) => onSaved(currentValueRef.value),
    );
  }

  String _format(DateFormat dateFormat, ObjectRef<DateTimeRange?> currentValueRef) {
    return "${dateFormat.format(currentValueRef.value!.start)} - ${dateFormat.format(currentValueRef.value!.end)}";
  }

}

class _DropdownButtonCell<TType extends Object, T extends Object> extends HookWidget {
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final InputDecoration? decoration;
  final FutureOr<bool> Function(T newValue) setter;
  final TType item;

  const _DropdownButtonCell({required this.item, required this.items, required this.decoration, required this.setter, required this.initialValue});
  
  @override
  Widget build(BuildContext context) {
    var focusNode = useFocusNode();
    var currentValueRef = useRef<T?>(initialValue);
    var isLoadingN = useState<bool>(false);
    useEffect(() {
      currentValueRef.value = initialValue;
      return null;
    }, [item]);

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<T>(
        focusNode: focusNode,
        items: items,
        decoration: decoration ?? const InputDecoration(
          border: InputBorder.none
        ),
        value: currentValueRef.value,
        onChanged: isLoadingN.value ? null : (newValue) async {
          if(newValue == null || newValue == currentValueRef.value) {
            focusNode.unfocus();
            return;
          }

          isLoadingN.value = true;
          bool mustUpdate = await setter(newValue);
          if(mustUpdate) {
            currentValueRef.value = newValue;
          }

          isLoadingN.value = false;
          focusNode.unfocus();
        },
      ),
    );
  }
}

class _TextFieldCell<TType extends Object> extends HookWidget {
  final String? initialValue;
  final InputDecoration? decoration;
  final bool isNumeric;
  final FutureOr<bool> Function(String newValue) setter;
  final TType item;
  final List<TextInputFormatter>? inputFormatters;

  const _TextFieldCell({required this.isNumeric, required this.item, required this.decoration, required this.setter, required this.initialValue, required this.inputFormatters});
  
  @override
  Widget build(BuildContext context) {
    var focusNode = useFocusNode();
    var currentValueRef = useRef<String?>(initialValue);
    var isLoadingN = useState<bool>(false);
    var isEnabledN = useState<bool>(false);
    useEffect(() {
      currentValueRef.value = initialValue;
      return null;
    }, [item]);

    if(isEnabledN.value || isLoadingN.value) {
      return TextFormField(
        textAlign: isNumeric ? TextAlign.right : TextAlign.start,
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        decoration: decoration ?? const InputDecoration(
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: isLoadingN.value ? const TextStyle(color: Colors.grey) : null,
        initialValue: currentValueRef.value,
        onFieldSubmitted: isLoadingN.value ? null : (newValue) async {
          if(newValue == currentValueRef.value) {
            focusNode.unfocus();
            return;
          }
    
          isLoadingN.value = true;
          bool mustUpdate = await setter(newValue);
          if(mustUpdate) {
            currentValueRef.value = newValue;
          }
    
          isLoadingN.value = false;
          isEnabledN.value = false;
          focusNode.unfocus();
        },
      );
    } /*else if(isLoadingN.value) {
      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
    } */else {
      return GestureDetector(
        onDoubleTap: isEnabledN.value ? null : () {
          isEnabledN.value = true;
          focusNode.requestFocus();
        },
        child: Text(currentValueRef.value ?? ""),
      );
    }
  }
}

class _EditableTextField extends HookWidget {

  final FutureOr<bool> Function(String text) setter;
  final String initialValue;
  final String? Function(String? text)? validator;
  final InputDecoration? decoration;
  final String label;
  final bool tooltipText;
  final List<TextInputFormatter>? formatters;
  final EdgeInsets? tooltipPadding, tooltipMargin;

  const _EditableTextField({
    required this.initialValue, 
    required this.setter, 
    required this.validator, 
    required this.decoration, 
    required this.label, 
    required this.formatters,
    required this.tooltipMargin,
    required this.tooltipPadding,
    required this.tooltipText});

  @override
  Widget build(BuildContext context) {
    var currentValueRef = useRef<String>(initialValue);
    var isLoadingN = useState<bool>(false);
    var isMounted = useIsMounted();

    return GestureDetector(
      onDoubleTap: () async {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        var offset = renderBox.localToGlobal(Offset.zero);
        var availableSize = MediaQuery.of(context).size;
        var drawWidth = availableSize.width / 3;
        var drawHeight = availableSize.height / 3;
        var size = renderBox.size;

        double x, y;
        if(offset.dx+drawWidth > availableSize.width) {
          x = offset.dx-drawWidth+size.width;
        } else {
          x = offset.dx;
        }

        if(offset.dy+drawHeight > availableSize.height) {
          y = offset.dy-drawHeight-size.height;
        } else {
          y = offset.dy+size.height;
        }
        RelativeRect rect = RelativeRect.fromLTRB(x, y, 0, 0);

        String? newText = await showDialog(
          context: context,
          useSafeArea: true,
          barrierColor:  Colors.black.withOpacity(.3),
          builder: (context) => _EditableTextFieldOverlay(
            position: rect,
            formatters: formatters,
            value: currentValueRef.value, 
            width: drawWidth,
            height: drawHeight,
            validator: validator,
            decoration: decoration,
            label: label,
          )
        );

        if(newText != null && newText != currentValueRef.value) {
          isLoadingN.value = true;

          bool mustUpdate = await setter(newText);
          if(mustUpdate) {
            currentValueRef.value = newText;
          }

          if(isMounted()) {
            isLoadingN.value = false;
          }
        }
      },
      child: isLoadingN.value 
        ? const SizedBox(
          child: CircularProgressIndicator(),
          height: 20, 
          width: 20,
        ) 
        : (tooltipText ? Tooltip(
          message: currentValueRef.value,
          margin: tooltipMargin,
          padding: tooltipPadding,
          child: Text(currentValueRef.value, overflow: TextOverflow.ellipsis)
        ) : Text(currentValueRef.value, overflow: TextOverflow.ellipsis))
    );
  }
  
}

class _EditableTextFieldOverlay extends HookWidget {
  final RelativeRect position;
  final String value;
  final InputDecoration? decoration;
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
    required this.height});

  @override
  Widget build(BuildContext context) {
    var fieldController = useTextEditingController(text: value);
    var formKey = useMemoized(() => GlobalKey<FormState>());

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: position.top,
            left: position.left,
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: width,
                height: height,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          inputFormatters: formatters,
                          decoration: decoration ?? InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: label,
                            // hintText: "Edit ${label.toLowerCase()}"
                          ),
                          validator: validator,
                          controller: fieldController,
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
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                Navigator.pop(context, fieldController.text);
                              }
                            }, 
                            child: const Text("Save changes")
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
}

class _TimerBuilder extends HookWidget {
  final Widget Function(BuildContext context, bool isEnabled, void Function() call) builder;
  final bool Function() canDisplay;
  final Duration checkInterval;

  const _TimerBuilder({required this.builder, required this.checkInterval, required this.canDisplay});

  @override
  Widget build(BuildContext context) {
    var enabledN = useState<bool>(canDisplay());
    var keyRef = useRef<int>(0);
    useEffect(() {
      Timer.periodic(checkInterval, (timer) {
        bool enabled = canDisplay();
        if(enabled) {
          enabledN.value = true;
          timer.cancel();
        }
      });
      return null;
    }, [keyRef.value]);

    return builder(context, enabledN.value, () {
      keyRef.value = DateTime.now().microsecondsSinceEpoch;
      enabledN.value = canDisplay();
    });
  }

}