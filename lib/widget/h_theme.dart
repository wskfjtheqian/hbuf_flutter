import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

import 'h_button.dart';
import 'h_layout.dart';

class HTheme extends InheritedTheme {
  const HTheme({
    super.key,
    this.data = const HThemeData(),
    required super.child,
  });

  final HThemeData data;

  static HThemeData of(BuildContext context) {
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

class HThemeData {
  final HSizeThemeData sizeTheme;

  final HColorThemeData colorTheme;

  final HButtonThemeData buttonTheme;

  final HLayoutThemeData layoutTheme;


  const HThemeData({
    this.sizeTheme = const HSizeThemeData(),
    this.colorTheme = const HColorThemeData(),
    this.buttonTheme = const HButtonThemeData(),
    this.layoutTheme = const HLayoutThemeData(),
  });
}
