import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'h_theme.dart';

extension HColor on Color {
  Color? operator [](int index) {
    return HSLColor.fromColor(this).withLightness(1 - index / 2000).toColor();
  }

  ColorSwatch get colorSwatch {
    var hsv = HSLColor.fromColor(this);
    Map<int, Color> swatch = {
      50: hsv.withLightness(1 - 0.05).toColor(),
      100: hsv.withLightness(1 - 0.10).toColor(),
      200: hsv.withLightness(1 - 0.20).toColor(),
      300: hsv.withLightness(1 - 0.30).toColor(),
      400: hsv.withLightness(1 - 0.40).toColor(),
      500: hsv.withLightness(1 - 0.50).toColor(),
      600: hsv.withLightness(1 - 0.60).toColor(),
      700: hsv.withLightness(1 - 0.70).toColor(),
      800: hsv.withLightness(1 - 0.80).toColor(),
      900: hsv.withLightness(1 - 0.90).toColor(),
    };
    return ColorSwatch(value, swatch);
  }
}

class HColorTheme extends InheritedTheme {
  const HColorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HColorThemeData data;

  static HColorThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HColorTheme>();
    return theme?.data ?? HTheme.of(context).colorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HColorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HColorTheme oldWidget) => data != oldWidget.data;
}

extension HColorContext on BuildContext {
  Color get brandColor {
    return HColorTheme._of(this).brandColor;
  }

  Color get successColor {
    return HColorTheme._of(this).successColor;
  }

  Color get warningColor {
    return HColorTheme._of(this).warningColor;
  }

  Color get dangerColor {
    return HColorTheme._of(this).dangerColor;
  }

  Color get infoColor {
    return HColorTheme._of(this).infoColor;
  }

  Color get textColor {
    return HColorTheme._of(this).textColor;
  }

  Color get textGeneralColor {
    return HColorTheme._of(this).textGeneralColor;
  }

  Color get textOrderColor {
    return HColorTheme._of(this).textOrderColor;
  }

  Color get textPlaceColor {
    return HColorTheme._of(this).textPlaceColor;
  }

  Color get whiteColor {
    return HColorTheme._of(this).whiteColor;
  }

  Color get blackColor {
    return HColorTheme._of(this).blackColor;
  }

  Color get transparentColor {
    return HColorTheme._of(this).transparentColor;
  }
}

class HColorThemeData {
  final Color whiteColor;

  final Color blackColor;

  final Color transparentColor;

  final Color brandColor;

  final Color successColor;

  final Color warningColor;

  final Color dangerColor;

  final Color infoColor;

  //主要文字
  final Color textColor;

  //常规文字
  final Color textGeneralColor;

  //次要文字
  final Color textOrderColor;

  //占位文字
  final Color textPlaceColor;

  //一级边框
  final Color border1Color;

  //二级边框
  final Color border2Color;

  //三级边框
  final Color border3Color;

  //四级边框
  final Color border4Color;

  const HColorThemeData({
    this.brandColor = const Color(0xff409EFF),
    this.successColor = const Color(0xFF67C23A),
    this.warningColor = const Color(0xFFE6A23C),
    this.dangerColor = const Color(0xFFF56C6C),
    this.infoColor = const Color(0xFF909399),
    this.textColor = const Color(0xFF303133),
    this.textGeneralColor = const Color(0xFF606266),
    this.textOrderColor = const Color(0xFF909399),
    this.textPlaceColor = const Color(0xFFC0C4CC),
    this.whiteColor = const Color(0xFFFFFFFF),
    this.blackColor = const Color(0xFF000000),
    this.transparentColor = const Color(0x00000000),
    this.border1Color = const Color(0xFFDCDFE6),
    this.border2Color = const Color(0xFFE4E7ED),
    this.border3Color = const Color(0xFFEBEEF5),
    this.border4Color = const Color(0xFFF2F6FC),
  });

  HColorThemeData copyWith({
    Color? whiteColor,
    Color? blackColor,
    Color? transparentColor,
    Color? brandColor,
    Color? successColor,
    Color? warningColor,
    Color? dangerColor,
    Color? infoColor,
    Color? textColor,
    Color? textGeneralColor,
    Color? textOrderColor,
    Color? textPlaceColor,
    Color? border1Color,
    Color? border2Color,
    Color? border3Color,
    Color? border4Color,
  }) {
    return HColorThemeData(
      whiteColor: whiteColor ?? this.whiteColor,
      blackColor: blackColor ?? this.blackColor,
      transparentColor: transparentColor ?? this.transparentColor,
      brandColor: brandColor ?? this.brandColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      dangerColor: dangerColor ?? this.dangerColor,
      infoColor: infoColor ?? this.infoColor,
      textColor: textColor ?? this.textColor,
      textGeneralColor: textGeneralColor ?? this.textGeneralColor,
      textOrderColor: textOrderColor ?? this.textOrderColor,
      textPlaceColor: textPlaceColor ?? this.textPlaceColor,
      border1Color: border1Color ?? this.border1Color,
      border2Color: border2Color ?? this.border2Color,
      border3Color: border3Color ?? this.border3Color,
      border4Color: border4Color ?? this.border4Color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HColorThemeData &&
          runtimeType == other.runtimeType &&
          whiteColor == other.whiteColor &&
          blackColor == other.blackColor &&
          transparentColor == other.transparentColor &&
          brandColor == other.brandColor &&
          successColor == other.successColor &&
          warningColor == other.warningColor &&
          dangerColor == other.dangerColor &&
          infoColor == other.infoColor &&
          textColor == other.textColor &&
          textGeneralColor == other.textGeneralColor &&
          textOrderColor == other.textOrderColor &&
          textPlaceColor == other.textPlaceColor &&
          border1Color == other.border1Color &&
          border2Color == other.border2Color &&
          border3Color == other.border3Color &&
          border4Color == other.border4Color;

  @override
  int get hashCode =>
      whiteColor.hashCode ^
      blackColor.hashCode ^
      transparentColor.hashCode ^
      brandColor.hashCode ^
      successColor.hashCode ^
      warningColor.hashCode ^
      dangerColor.hashCode ^
      infoColor.hashCode ^
      textColor.hashCode ^
      textGeneralColor.hashCode ^
      textOrderColor.hashCode ^
      textPlaceColor.hashCode ^
      border1Color.hashCode ^
      border2Color.hashCode ^
      border3Color.hashCode ^
      border4Color.hashCode;
}
