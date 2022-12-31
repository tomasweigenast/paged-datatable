part of 'paged_datatable.dart';

class PagedDataTableFilterBarMenu {
  final String? tooltip;
  final List<Widget> items;
  final double? elevation;
  final BoxConstraints? constraints;
  final void Function(dynamic value)? onSelected;
  final ShapeBorder? shape;

  const PagedDataTableFilterBarMenu({
    required this.items,
    this.tooltip,
    this.elevation,
    this.constraints,
    this.onSelected,
    this.shape
  });
}