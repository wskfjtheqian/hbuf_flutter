import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'h_theme.dart';

class HSwitch extends StatelessWidget {
  final HSwitchStyle? style;

  final bool value;

  final ValueChanged<bool>? onChanged;

  final ImageErrorListener? onInactiveThumbImageError;

  final ValueChanged<bool>? onFocusChange;

  final ImageErrorListener? onActiveThumbImageError;

  const HSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.onInactiveThumbImageError,
    this.onActiveThumbImageError,
    this.onFocusChange,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HSwitchTheme.of(context).defaultSwitch;
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: style.activeColor,
      activeTrackColor: style.activeTrackColor,
      inactiveThumbColor: style.inactiveThumbColor,
      inactiveTrackColor: style.inactiveTrackColor,
      activeThumbImage: style.activeThumbImage,
      onActiveThumbImageError: onActiveThumbImageError,
      inactiveThumbImage: style.inactiveThumbImage,
      onInactiveThumbImageError: onInactiveThumbImageError,
      thumbColor: style.thumbColor,
      trackColor: style.trackColor,
      thumbIcon: style.thumbIcon,
      materialTapTargetSize: style.materialTapTargetSize,
      dragStartBehavior: style.dragStartBehavior,
      mouseCursor: style.mouseCursor,
      focusColor: style.focusColor,
      hoverColor: style.hoverColor,
      overlayColor: style.overlayColor,
      splashRadius: style.splashRadius,
      focusNode: style.focusNode,
      onFocusChange: onFocusChange,
      autofocus: style.autofocus,
    );
  }
}

class HSwitchStyle {
  const HSwitchStyle({
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.thumbColor,
    this.trackColor,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
  });

  final Color? activeColor;

  final Color? activeTrackColor;

  final Color? inactiveThumbColor;

  final Color? inactiveTrackColor;

  final ImageProvider? activeThumbImage;

  final ImageProvider? inactiveThumbImage;

  final MaterialStateProperty<Color?>? thumbColor;

  final MaterialStateProperty<Color?>? trackColor;

  final MaterialStateProperty<Icon?>? thumbIcon;

  final MaterialTapTargetSize? materialTapTargetSize;

  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final Color? focusColor;

  final Color? hoverColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;
}

class HSwitchTheme extends InheritedTheme {
  const HSwitchTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HSwitchThemeData data;

  static HSwitchThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HSwitchTheme>();
    return theme?.data ?? HTheme.of(context).switchTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HSwitchTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HSwitchTheme oldWidget) => data != oldWidget.data;
}

extension HSwitchContext on BuildContext {
  HSwitchStyle get defaultSwitch => HSwitchTheme.of(this).defaultSwitch;

  HSwitchStyle get mediumSwitch => HSwitchTheme.of(this).mediumSwitch;
}

class HSwitchThemeData {
  final HSwitchStyle defaultSwitch;

  final HSwitchStyle mediumSwitch;

  const HSwitchThemeData({
    this.defaultSwitch = const HSwitchStyle(),
    this.mediumSwitch = const HSwitchStyle(),
  });

  HSwitchThemeData copyWith({
    HSwitchStyle? defaultSwitchStyle,
    HSwitchStyle? mediumSwitchStyle,
    HSwitchStyle? smallSwitchStyle,
    HSwitchStyle? miniSwitchStyle,
  }) {
    return HSwitchThemeData(
      defaultSwitch: defaultSwitchStyle ?? defaultSwitch,
      mediumSwitch: mediumSwitchStyle ?? mediumSwitch,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HSwitchThemeData && runtimeType == other.runtimeType && defaultSwitch == other.defaultSwitch && mediumSwitch == other.mediumSwitch;

  @override
  int get hashCode => defaultSwitch.hashCode ^ mediumSwitch.hashCode;
}
