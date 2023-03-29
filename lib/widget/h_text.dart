import 'package:flutter/widgets.dart';

import 'h_theme.dart';

class HTextTheme extends InheritedTheme {
  const HTextTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HTextThemeData data;

  static HTextThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HTextTheme>();
    return theme?.data ?? HTheme.of(context).textTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HTextTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HTextTheme oldWidget) => data != oldWidget.data;
}

extension HTextContext on BuildContext {
  //辅助文字
  TextStyle get auxText => HTextTheme._of(this).auxText;

  //正文（小）
  TextStyle get bodyMinText => HTextTheme._of(this).bodyMinText;

  //正文
  TextStyle get bodyText => HTextTheme._of(this).bodyText;

  //小标题
  TextStyle get titleMinText => HTextTheme._of(this).titleMinText;

  //标题
  TextStyle get titleText => HTextTheme._of(this).titleText;

  //主标题
  TextStyle get mainText => HTextTheme._of(this).mainText;
}

class HTextThemeData {
  //辅助文字
  final TextStyle auxText;

  //正文（小）
  final TextStyle bodyMinText;

  //正文
  final TextStyle bodyText;

  //小标题
  final TextStyle titleMinText;

  //标题
  final TextStyle titleText;

  //主标题
  final TextStyle mainText;

  const HTextThemeData({
    this.auxText = const TextStyle(fontSize: 12),
    this.bodyMinText = const TextStyle(fontSize: 13),
    this.bodyText = const TextStyle(fontSize: 14),
    this.titleMinText = const TextStyle(fontSize: 16),
    this.titleText = const TextStyle(fontSize: 18),
    this.mainText = const TextStyle(fontSize: 20),
  });

  HTextThemeData copyWith({
    TextStyle? auxText,
    TextStyle? bodyMinText,
    TextStyle? bodyText,
    TextStyle? titleMinText,
    TextStyle? titleText,
    TextStyle? mainText,
  }) {
    return HTextThemeData(
      auxText: auxText ?? this.auxText,
      bodyMinText: bodyMinText ?? this.bodyMinText,
      bodyText: bodyText ?? this.bodyText,
      titleMinText: titleMinText ?? this.titleMinText,
      titleText: titleText ?? this.titleText,
      mainText: mainText ?? this.mainText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HTextThemeData &&
          runtimeType == other.runtimeType &&
          auxText == other.auxText &&
          bodyMinText == other.bodyMinText &&
          bodyText == other.bodyText &&
          titleMinText == other.titleMinText &&
          titleText == other.titleText &&
          mainText == other.mainText;

  @override
  int get hashCode => auxText.hashCode ^ bodyMinText.hashCode ^ bodyText.hashCode ^ titleMinText.hashCode ^ titleText.hashCode ^ mainText.hashCode;
}
