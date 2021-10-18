import 'package:flutter/material.dart';
import 'package:paged_datatable/src/datatable/options_menu/options_menu_item.dart';

class PagedDataTableOptionsMenu extends StatelessWidget {
  
  final List<OptionsMenuItem> items;
  final String? tooltipButtonText;
  final Widget icon;
  final Color? iconColor;
  final Clip? clipBehavior;

  const PagedDataTableOptionsMenu({
    required this.items, 
    this.tooltipButtonText, 
    Widget? icon, 
    this.iconColor, 
    this.clipBehavior,
    Key? key}) 
    : icon = icon ?? const Icon(Icons.more_vert), super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 16,
      tooltip: tooltipButtonText,
      color: iconColor,
      onPressed: () async {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        var offset = renderBox.localToGlobal(Offset.zero);
        var size = renderBox.size;
        var maxWidth = MediaQuery.of(context).size.width / 5;

        RelativeRect rect = RelativeRect.fromLTRB(offset.dx - maxWidth + size.width, offset.dy+size.height, 0, 0);

        await _showMenu(context, rect, maxWidth);
      }, 
      icon: icon
    );
  }

  Future _showMenu(BuildContext context, RelativeRect position, double maxWidth) async {
    return showDialog(
      context: context, 
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.left,
            top: position.top,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth
              ),
              child: Card(
                clipBehavior: clipBehavior,
                elevation: 8,
                child: Column(
                  children: items.map((item) => item.builder(context)).toList()
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}