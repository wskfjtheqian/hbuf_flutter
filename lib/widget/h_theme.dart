import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

import 'h_button.dart';
import 'h_layout.dart';
import 'h_size.dart';

class HTheme extends InheritedTheme {
  const HTheme({
    super.key,
    this.data = const HStyle(),
    required super.child,
  });

  final HStyle data;

  static HStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HTheme>();
    return theme!.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HTheme oldWidget) => data != oldWidget.data;
}

class HStyle {
  final HSizeStyle sizeStyle;

  final HLayoutStyle layoutStyle;

  final HButtonStyle defaultButtonStyle;

  final HButtonStyle mediumButtonStyle;

  final HButtonStyle smallButtonStyle;

  final HButtonStyle miniButtonStyle;

  final HColorStyle colorStyle;

  const HStyle({
    this.sizeStyle = const HSizeStyle(),
    this.layoutStyle = const HLayoutStyle(),
    this.colorStyle = const HColorStyle(),
    this.defaultButtonStyle = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(104),
        minHeight: MaterialStatePropertyAll(40),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(8))
    ),
    this.mediumButtonStyle = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(98),
        minHeight: MaterialStatePropertyAll(98),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(8))
    ),
    this.smallButtonStyle = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(80),
        minHeight: MaterialStatePropertyAll(32),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(4))
    ),
    this.miniButtonStyle = const HButtonStyle(
      minWidth: MaterialStatePropertyAll(80),
      minHeight: MaterialStatePropertyAll(28),
      textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
      padding: MaterialStatePropertyAll(EdgeInsets.all(2))
    ),
  });
}
