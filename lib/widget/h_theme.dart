import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_color.dart';
import 'package:hbuf_flutter/widget/h_text.dart';

import 'h_button.dart';
import 'h_cascader.dart';
import 'h_color_picker.dart';
import 'h_menu.dart';
import 'h_pagination.dart';
import 'h_select.dart';

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

  final HSliderThemeData sliderTheme;

  final HColorButtonThemeData colorButtonTheme;

  final HMenuThemeData menuTheme;

  final HCascaderStyle cascaderStyle;

  final HPaginationThemeData paginationTheme;

  final HSelectThemeData selectTheme;



  const HThemeData({
    this.selectTheme = const HSelectThemeData(),
    this.paginationTheme = const HPaginationThemeData(),
    this.cascaderStyle = const HCascaderStyle(),
    this.menuTheme = const HMenuThemeData(),
    this.colorButtonTheme = const HColorButtonThemeData(),
    this.sliderTheme = const HSliderThemeData(),
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
