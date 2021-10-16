import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paged_datatable/paged_datatable.dart';

class EditableTextField extends StatefulWidget {

  final Future Function(String text)? onChange;
  final String initialValue;
  final String? Function(String? text)? validator;
  final InputDecoration? decoration;
  final bool multiline;
  final String label;
  final List<TextInputFormatter>? formatters;
  final EditableColumnTheme? theme;

  const EditableTextField({
    required this.initialValue, 
    required this.onChange, 
    required this.validator, 
    required this.decoration, 
    required this.multiline, 
    required this.label, 
    required this.formatters,
    required this.theme, 
    Key? key }) : super(key: key);

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {

  late String currentValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        var offset = renderBox.localToGlobal(Offset.zero);
        var screenWidth = MediaQuery.of(context).size.width;
        var availableSpace = MediaQuery.of(context).size.width / 3;
        var size = renderBox.size;

        RelativeRect rect;
        if(offset.dx+availableSpace > screenWidth) {
          rect = RelativeRect.fromLTRB(offset.dx-availableSpace+size.width, offset.dy+size.height, 0, 0);
        } else {
          rect = RelativeRect.fromLTRB(size.width, offset.dy+size.height, 0, 0);
        }

        String? newText = await showDialog(
          context: context,
          useSafeArea: true,
          barrierColor: (widget.theme?.obscureBackground ?? true) ? Colors.black.withOpacity(.3),
          builder: (context) => _EditableTextFieldOverlay(
            position: rect,
            theme: widget.theme,
            formatters: widget.formatters,
            value: currentValue, 
            width: availableSpace,
            validator: widget.validator,
            decoration: widget.decoration,
            multiline: widget.multiline,
            label: widget.label,
          )
        );

        if(newText != null && newText != currentValue) {
          if(widget.onChange != null) {
            setState(() {
              currentValue = newText;
              isLoading = true;
            });

            await widget.onChange!(newText);
            
            if(mounted) {
              setState(() {
                isLoading = false;
              });
            }
          } else {
            setState(() {
              currentValue = newText;
            });
          }
        }
      },
      child: isLoading 
        ? const SizedBox(
          child: CircularProgressIndicator(),
          height: 20, 
          width: 20,
        ) 
        : Tooltip(
        message: currentValue,
        margin: const EdgeInsets.symmetric(horizontal: 500),
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500
        ),
        child: Text(currentValue, overflow: TextOverflow.ellipsis),
      )
    );
  }
}

class _EditableTextFieldOverlay extends StatefulWidget {
  final RelativeRect position;
  final String value;
  final bool multiline;
  final InputDecoration? decoration;
  final String label;
  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? formatters;
  final double width;
  final EditableColumnTheme? theme;

  const _EditableTextFieldOverlay({
    required this.position, 
    required this.value, 
    required this.validator, 
    required this.multiline, 
    required this.decoration, 
    required this.label, 
    required this.formatters, 
    required this.width,
    required this.theme});

  @override
  _EditableTextFieldOverlayState createState()  => _EditableTextFieldOverlayState();
}

class _EditableTextFieldOverlayState extends State<_EditableTextFieldOverlay> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fieldController.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: true,
                        inputFormatters: widget.formatters,
                        decoration: widget.decoration ?? InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: widget.label,
                          hintText: "Edit ${widget.label.toLowerCase()}"
                        ),
                        validator: widget.validator,
                        controller: _fieldController,
                        maxLines: widget.multiline ? 6 : null,
                        minLines: widget.multiline ? 6 : null,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: widget.theme?.cancelButtonStyle,
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: widget.theme?.saveButtonStyle,
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                Navigator.pop(context, _fieldController.text);
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

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }  
}