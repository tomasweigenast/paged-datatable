part of 'paged_datatable.dart';

class PagedDataTableFilterBarMenu {
  final String? tooltip;
  final List<BaseFilterMenuItem> items;
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
    this.shape,
  });
}

abstract class BaseFilterMenuItem {
  const BaseFilterMenuItem();

  Widget _build(BuildContext context);
}

class FilterMenuItem extends BaseFilterMenuItem {
  final VoidCallback? onTap;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading, trailing;

  const FilterMenuItem(
      {this.onTap,
      required this.title,
      this.subtitle,
      this.leading,
      this.trailing});

  @override
  Widget _build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      leading: leading,
      onTap: onTap == null
          ? null
          : () {
              Navigator.pop(context);
              onTap!();
            },
    );
  }
}

class FilterMenuDivider extends BaseFilterMenuItem {
  final double height;

  const FilterMenuDivider({this.height = 0});

  @override
  Widget _build(BuildContext context) => Divider(height: height);
}

class FilterMenuItemBuilder extends BaseFilterMenuItem {
  final WidgetBuilder builder;

  const FilterMenuItemBuilder({required this.builder});

  @override
  Widget _build(BuildContext context) => builder(context);
}
