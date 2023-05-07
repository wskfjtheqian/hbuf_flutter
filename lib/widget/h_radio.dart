import 'package:flutter/material.dart';

import 'h_theme.dart';

class HRadio<T> extends StatelessWidget {
  final HRadioStyle? style;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? text;

  const HRadio({
    super.key,
    this.style,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HRadioTheme.of(context).defaultRadio;
    Widget child = Radio<T>(
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      activeColor: style.activeColor,
      mouseCursor: style.mouseCursor,
      toggleable: style.toggleable,
      fillColor: style.fillColor,
      focusColor: style.focusColor,
      hoverColor: style.hoverColor,
      overlayColor: style.overlayColor,
      splashRadius: style.splashRadius,
      materialTapTargetSize: style.materialTapTargetSize,
      visualDensity: style.visualDensity,
      focusNode: style.focusNode,
      autofocus: style.autofocus,
    );
    if (null != text) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          InkWell(
            child: Text(text!, style: style.textStyle),
            onTap: () => onChanged?.call(value),
          ),
        ],
      );
    }
    return child;
  }
}

class HRadioStyle {
  const HRadioStyle({
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.textStyle,
    this.autofocus = false,
  });

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final bool toggleable;

  final Color? activeColor;

  final MaterialStateProperty<Color?>? fillColor;

  final MaterialTapTargetSize? materialTapTargetSize;

  final VisualDensity? visualDensity;

  final Color? focusColor;

  final Color? hoverColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;
}

class HRadioTheme extends InheritedTheme {
  const HRadioTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HRadioThemeData data;

  static HRadioThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HRadioTheme>();
    return theme?.data ?? HTheme.of(context).radioTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HRadioTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HRadioTheme oldWidget) => data != oldWidget.data;
}

extension HRadioContext on BuildContext {
  HRadioStyle get defaultRadio => HRadioTheme.of(this).defaultRadio;

  HRadioStyle get mediumRadio => HRadioTheme.of(this).mediumRadio;
}

class HRadioThemeData {
  final HRadioStyle defaultRadio;

  final HRadioStyle mediumRadio;

  const HRadioThemeData({
    this.defaultRadio = const HRadioStyle(),
    this.mediumRadio = const HRadioStyle(),
  });

  HRadioThemeData copyWith({
    HRadioStyle? defaultRadioStyle,
    HRadioStyle? mediumRadioStyle,
    HRadioStyle? smallRadioStyle,
    HRadioStyle? miniRadioStyle,
  }) {
    return HRadioThemeData(
      defaultRadio: defaultRadioStyle ?? defaultRadio,
      mediumRadio: mediumRadioStyle ?? mediumRadio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HRadioThemeData && runtimeType == other.runtimeType && defaultRadio == other.defaultRadio && mediumRadio == other.mediumRadio;

  @override
  int get hashCode => defaultRadio.hashCode ^ mediumRadio.hashCode;
}
