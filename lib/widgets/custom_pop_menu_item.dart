import 'package:flutter/material.dart';

class CustomPopupMenuItem {
  static PopupMenuEntry<dynamic> build(
      {required dynamic index,
      required IconData iconData,
      required String text}) {
    return PopupMenuItem(
      value: index,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          dense: true,
          visualDensity: VisualDensity.compact,
          titleAlignment: ListTileTitleAlignment.center,
          trailing: Icon(
            iconData,
            size: 20,
          ),
          title: Text(
            text,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}