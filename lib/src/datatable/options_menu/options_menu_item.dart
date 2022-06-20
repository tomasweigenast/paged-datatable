import 'package:flutter/material.dart';

class OptionsMenuItem {
  final Widget Function(BuildContext context) builder;
  final bool Function()? onTap;

  const OptionsMenuItem._({required this.onTap, required this.builder});

  factory OptionsMenuItem({required Widget title, Widget? subtitle, Widget? leading, Widget? trailing, void Function()? onTap}) {
    return OptionsMenuItem._(
      onTap: onTap == null ? null : () {
        onTap();
        return true;
      }, 
      builder: (context) => ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap == null ? null : () {
          
          // Close menu
          Navigator.pop(context);

          // Custom callback
          onTap();
        }
      )
    );
  }
}