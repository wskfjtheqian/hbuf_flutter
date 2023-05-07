import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_badge.dart';
import 'package:hbuf_flutter/widget/h_checkbox.dart';
import 'package:hbuf_flutter/widget/h_color.dart';
import 'package:hbuf_flutter/widget/h_link.dart';
import 'package:hbuf_flutter/widget/h_tag.dart';
import 'package:hbuf_flutter/widget/h_text.dart';

import 'h_border.dart';
import 'h_button.dart';
import 'h_layout.dart';
import 'h_switch.dart';

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

  final HLinkThemeData linkTheme;

  final HTextThemeData textTheme;

  final HBorderSideThemeData borderSideTheme;

  final HRadiusThemeData radiusTheme;

  final HBadgeThemeData badgeTheme;

  final HTagThemeData tagTheme;

  final HSwitchThemeData switchTheme;

  final HRadioThemeData radioTheme;

  final HCheckBoxThemeData checkBoxTheme;

  const HThemeData({
    this.checkBoxTheme = const HCheckBoxThemeData(),
    this.radioTheme = const HRadioThemeData(),
    this.switchTheme = const HSwitchThemeData(),
    this.tagTheme = const HTagThemeData(),
    this.textTheme = const HTextThemeData(),
    this.sizeTheme = const HSizeThemeData(),
    this.colorTheme = const HColorThemeData(),
    this.buttonTheme = const HButtonThemeData(),
    this.layoutTheme = const HLayoutThemeData(),
    this.linkTheme = const HLinkThemeData(),
    this.borderSideTheme = const HBorderSideThemeData(),
    this.radiusTheme = const HRadiusThemeData(),
    this.badgeTheme = const HBadgeThemeData(),
  });
}
