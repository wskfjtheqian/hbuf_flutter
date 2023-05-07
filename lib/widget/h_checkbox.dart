import 'package:flutter/material.dart';

import 'h_theme.dart';

class HCheckBox extends StatelessWidget {
  final HCheckBoxStyle? style;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? text;

  const HCheckBox({
    super.key,
    this.style,
    required this.value,
    required this.onChanged,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HCheckBoxTheme.of(context).defaultCheckBox;
    Widget child = Checkbox(
      value: value,
      onChanged: onChanged,
      tristate: style.tristate,
      mouseCursor: style.mouseCursor,
      activeColor: style.activeColor,
      fillColor: style.fillColor,
      checkColor: style.checkColor,
      focusColor: style.focusColor,
      hoverColor: style.hoverColor,
      overlayColor: style.overlayColor,
      splashRadius: style.splashRadius,
      materialTapTargetSize: style.materialTapTargetSize,
      visualDensity: style.visualDensity,
      focusNode: style.focusNode,
      autofocus: style.autofocus,
      shape: style.shape,
      side: style.side,
      isError: style.isError,
    );
    if (null != text) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          InkWell(
            child: Text(text!, style: style.textStyle),
            onTap: () => onChanged?.call(true == value ? false : true),
          ),
        ],
      );
    }
    return child;
  }
}

class HCheckBoxStyle {
  const HCheckBoxStyle({
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.textStyle,
    this.isError = false,
  });

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final Color? activeColor;

  final MaterialStateProperty<Color?>? fillColor;

  final Color? checkColor;

  final bool tristate;

  final MaterialTapTargetSize? materialTapTargetSize;

  final VisualDensity? visualDensity;

  final Color? focusColor;

  final Color? hoverColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;

  final OutlinedBorder? shape;

  final BorderSide? side;

  final bool isError;

  static const double width = 18.0;
}

class HCheckBoxTheme extends InheritedTheme {
  const HCheckBoxTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HCheckBoxThemeData data;

  static HCheckBoxThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HCheckBoxTheme>();
    return theme?.data ?? HTheme.of(context).checkBoxTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HCheckBoxTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HCheckBoxTheme oldWidget) => data != oldWidget.data;
}

extension HCheckBoxContext on BuildContext {
  HCheckBoxStyle get defaultCheckBox => HCheckBoxTheme.of(this).defaultCheckBox;

  HCheckBoxStyle get mediumCheckBox => HCheckBoxTheme.of(this).mediumCheckBox;
}

class HCheckBoxThemeData {
  final HCheckBoxStyle defaultCheckBox;

  final HCheckBoxStyle mediumCheckBox;

  const HCheckBoxThemeData({
    this.defaultCheckBox = const HCheckBoxStyle(),
    this.mediumCheckBox = const HCheckBoxStyle(),
  });

  HCheckBoxThemeData copyWith({
    HCheckBoxStyle? defaultCheckBoxStyle,
    HCheckBoxStyle? mediumCheckBoxStyle,
    HCheckBoxStyle? smallCheckBoxStyle,
    HCheckBoxStyle? miniCheckBoxStyle,
  }) {
    return HCheckBoxThemeData(
      defaultCheckBox: defaultCheckBoxStyle ?? defaultCheckBox,
      mediumCheckBox: mediumCheckBoxStyle ?? mediumCheckBox,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HCheckBoxThemeData && runtimeType == other.runtimeType && defaultCheckBox == other.defaultCheckBox && mediumCheckBox == other.mediumCheckBox;

  @override
  int get hashCode => defaultCheckBox.hashCode ^ mediumCheckBox.hashCode;
}
