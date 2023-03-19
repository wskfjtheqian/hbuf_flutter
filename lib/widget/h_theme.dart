

import 'package:flutter/widgets.dart';

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

  final HButtonStyle buttonStyle;

  const HStyle({
    this.sizeStyle = const HSizeStyle(),
    this.layoutStyle = const HLayoutStyle(),
    this.buttonStyle = const HButtonStyle(),
  });
}
