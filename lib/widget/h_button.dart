import 'package:flutter/material.dart';

import 'h_border.dart';
import 'h_size.dart';
import 'h_theme.dart';

class HButton extends StatefulWidget {
  final Widget child;
  final HButtonStyle? style;

  const HButton({
    Key? key,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  State<HButton> createState() => _HButtonState();
}

class _HButtonState extends State<HButton> {
  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    var style = widget.style ?? HButtonTheme.of(context);
    if (null != style.padding) {
      child = Padding(
        padding: style.padding!,
        child: child,
      );
    }
    child = Align(
      child: child,
    );
    child = InkWell(
      child: child,
      onTap: () {},
    );

    child = Material(
      borderRadius: style.borderRadius,
      color: style.color,
      child: child,
    );

    if (null != style.borderRadius) {
      child = ClipRRect(
        borderRadius: style.borderRadius,
        child: child,
      );
    }

    if (null != style.margin) {
      child = Padding(
        padding: style.margin!,
        child: child,
      );
    }

    return HSize(
      style: style,
      child: child,
    );
  }
}

class HButtonTheme extends InheritedTheme {
  const HButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HButtonStyle data;

  static HButtonStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HButtonTheme>();
    return theme?.data ?? HTheme.of(context).buttonStyle;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HButtonTheme oldWidget) => data != oldWidget.data;
}

extension HButtonContext on BuildContext {
  HButtonStyle get buttonStyle {
    return HButtonTheme.of(this);
  }
}

class HButtonStyle extends HSizeStyle {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final DecorationImage? image;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape shape;
  final DecorationPosition position;

  const HButtonStyle({
    super.minWidth = 0,
    super.minHeight = 0,
    super.maxWidth = double.infinity,
    super.maxHeight = double.infinity,
    super.sizes,
    super.count = kHSizeCount,
    this.margin,
    this.padding = const EdgeInsets.all(8),
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
    this.position = DecorationPosition.background,
  });

  @override
  HButtonStyle copyWith({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    Map<double, int>? sizes,
    int? count,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? color,
    DecorationImage? image,
    HBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
    DecorationPosition? position,
  }) {
    return HButtonStyle(
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      sizes: sizes ?? this.sizes,
      count: count ?? this.count,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return 'HButtonStyle{margin: $margin, padding: $padding, color: $color, image: $image, border: $border, borderRadius: $borderRadius, boxShadow: $boxShadow, gradient: $gradient, backgroundBlendMode: $backgroundBlendMode, shape: $shape, position: $position}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is HButtonStyle &&
          runtimeType == other.runtimeType &&
          margin == other.margin &&
          padding == other.padding &&
          color == other.color &&
          image == other.image &&
          border == other.border &&
          borderRadius == other.borderRadius &&
          boxShadow == other.boxShadow &&
          gradient == other.gradient &&
          backgroundBlendMode == other.backgroundBlendMode &&
          shape == other.shape &&
          position == other.position;

  @override
  int get hashCode =>
      super.hashCode ^
      margin.hashCode ^
      padding.hashCode ^
      color.hashCode ^
      image.hashCode ^
      border.hashCode ^
      borderRadius.hashCode ^
      boxShadow.hashCode ^
      gradient.hashCode ^
      backgroundBlendMode.hashCode ^
      shape.hashCode ^
      position.hashCode;
}
