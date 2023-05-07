import 'package:flutter/material.dart';

import 'h_theme.dart';

class HSlider extends StatelessWidget {
  final HSliderStyle? style;

  final double value;

  final ValueChanged<double>? onChanged;

  final double? secondaryTrackValue;

  final ValueChanged<double>? onChangeStart;

  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  const HSlider({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HSliderTheme.of(context).defaultSlider;
    return Slider(
      value: value,
      secondaryTrackValue: secondaryTrackValue,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: style.divisions,
      label: style.label,
      activeColor: style.activeColor,
      inactiveColor: style.inactiveColor,
      secondaryActiveColor: style.secondaryActiveColor,
      thumbColor: style.thumbColor,
      overlayColor: style.overlayColor,
      mouseCursor: style.mouseCursor,
      semanticFormatterCallback: style.semanticFormatterCallback,
      focusNode: style.focusNode,
      autofocus: style.autofocus,
    );
  }
}

class HSliderStyle {
  const HSliderStyle({
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  });

  final int? divisions;

  final String? label;

  final Color? activeColor;

  final Color? inactiveColor;

  final Color? secondaryActiveColor;

  final Color? thumbColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final MouseCursor? mouseCursor;

  final SemanticFormatterCallback? semanticFormatterCallback;

  final FocusNode? focusNode;

  final bool autofocus;
}

class HSliderTheme extends InheritedTheme {
  const HSliderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HSliderThemeData data;

  static HSliderThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HSliderTheme>();
    return theme?.data ?? HTheme.of(context).sliderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HSliderTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HSliderTheme oldWidget) => data != oldWidget.data;
}

extension HSliderContext on BuildContext {
  HSliderStyle get defaultSlider => HSliderTheme.of(this).defaultSlider;

  HSliderStyle get mediumSlider => HSliderTheme.of(this).mediumSlider;
}

class HSliderThemeData {
  final HSliderStyle defaultSlider;

  final HSliderStyle mediumSlider;

  const HSliderThemeData({
    this.defaultSlider = const HSliderStyle(),
    this.mediumSlider = const HSliderStyle(),
  });

  HSliderThemeData copyWith({
    HSliderStyle? defaultSliderStyle,
    HSliderStyle? mediumSliderStyle,
    HSliderStyle? smallSliderStyle,
    HSliderStyle? miniSliderStyle,
  }) {
    return HSliderThemeData(
      defaultSlider: defaultSliderStyle ?? defaultSlider,
      mediumSlider: mediumSliderStyle ?? mediumSlider,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HSliderThemeData && runtimeType == other.runtimeType && defaultSlider == other.defaultSlider && mediumSlider == other.mediumSlider;

  @override
  int get hashCode => defaultSlider.hashCode ^ mediumSlider.hashCode;
}
