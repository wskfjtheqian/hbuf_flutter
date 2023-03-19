import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

import 'h_border.dart';

class HLayout extends StatelessWidget {
  final Widget? child;

  final HLayoutStyle? style;

  const HLayout({Key? key, this.child, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HLayoutTheme.of(context);
    Widget? child = this.child;

    if (null != style.padding) {
      child = Padding(
        padding: style.padding!,
        child: child,
      );
    }

    var decoration = getDecoration(style);
    if (null != decoration) {
      child = DecoratedBox(
        decoration: decoration,
        position: style.position,
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

  BoxDecoration? getDecoration(HLayoutStyle style) {
    if (!(null != style.color ||
        null != style.image ||
        null != style.border ||
        null != style.borderRadius ||
        null != style.boxShadow ||
        null != style.gradient ||
        null != style.backgroundBlendMode)) {
      return null;
    }
    return BoxDecoration(
      color: style.color,
      image: style.image,
      border: style.border,
      borderRadius: style.borderRadius,
      boxShadow: style.boxShadow,
      gradient: style.gradient,
      backgroundBlendMode: style.backgroundBlendMode,
      shape: style.shape,
    );
  }
}

class HLayoutTheme extends InheritedTheme {
  const HLayoutTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HLayoutStyle data;

  static HLayoutStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HLayoutTheme>();
    return theme?.data ?? HTheme.of(context).layoutStyle;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HLayoutTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HLayoutTheme oldWidget) => data != oldWidget.data;
}

extension HLayoutContext on BuildContext {
  HLayoutStyle get layoutStyle {
    return HLayoutTheme.of(this);
  }
}

class HLayoutStyle extends HSizeStyle {
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

  const HLayoutStyle({
    super.minWidth = 0,
    super.minHeight = 0,
    super.maxWidth = double.infinity,
    super.maxHeight = double.infinity,
    super.sizes,
    super.count = kHSizeCount,
    this.margin,
    this.padding,
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
  HLayoutStyle copyWith({
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
    return HLayoutStyle(
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
    return 'HLayoutStyle{margin: $margin, padding: $padding, color: $color, image: $image, border: $border, borderRadius: $borderRadius, boxShadow: $boxShadow, gradient: $gradient, backgroundBlendMode: $backgroundBlendMode, shape: $shape, position: $position}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is HLayoutStyle &&
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
