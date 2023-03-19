import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'h_theme.dart';

const double mm = 375;
const double sm = 540;
const double md = 720;
const double lg = 960;
const double xl = 1140;
const double ll = 1600;
const kHSizeCount = 24;

class HSize extends SingleChildRenderObjectWidget {
  final HSizeStyle? style;

  const HSize({
    Key? key,
    Widget? child,
    this.style,
  }) : super(key: key, child: child);

  @override
  SingleChildRenderObjectElement createElement() {
    return SingleChildRenderObjectElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    var style = this.style ?? HSizeTheme.of(context);
    return HSizeRender(
      style,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant HSizeRender renderObject) {
    var style = this.style ?? HSizeTheme.of(context);
    renderObject.style = style;
    super.updateRenderObject(context, renderObject);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HSizeStyle>('style', style));
  }
}

class HSizeRender extends RenderProxyBox {
  HSizeRender(this._style) {
    _keys = _style.sizes?.keys.toList()?..sort((a, b) => (b - a).ceil());
  }

  List<double>? _keys = [];

  HSizeStyle _style;

  set style(HSizeStyle value) {
    if (_style != value) {
      _style = value;
      _keys = value.sizes?.keys.toList()?..sort((a, b) => (b - a).ceil());
      markNeedsLayout();
    }
  }

  BoxConstraints _additionalConstraints = const BoxConstraints.expand();

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_additionalConstraints.hasBoundedWidth && _additionalConstraints.hasTightWidth) return _additionalConstraints.minWidth;
    final double width = super.computeMinIntrinsicWidth(height);
    assert(width.isFinite);
    if (!_additionalConstraints.hasInfiniteWidth) return _additionalConstraints.constrainWidth(width);
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (_additionalConstraints.hasBoundedWidth && _additionalConstraints.hasTightWidth) return _additionalConstraints.minWidth;
    final double width = super.computeMaxIntrinsicWidth(height);
    assert(width.isFinite);
    if (!_additionalConstraints.hasInfiniteWidth) return _additionalConstraints.constrainWidth(width);
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (_additionalConstraints.hasBoundedHeight && _additionalConstraints.hasTightHeight) return _additionalConstraints.minHeight;
    final double height = super.computeMinIntrinsicHeight(width);
    assert(height.isFinite);
    if (!_additionalConstraints.hasInfiniteHeight) return _additionalConstraints.constrainHeight(height);
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (_additionalConstraints.hasBoundedHeight && _additionalConstraints.hasTightHeight) return _additionalConstraints.minHeight;
    final double height = super.computeMaxIntrinsicHeight(width);
    assert(height.isFinite);
    if (!_additionalConstraints.hasInfiniteHeight) return _additionalConstraints.constrainHeight(height);
    return height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      return child!.getDryLayout(_additionalConstraints.enforce(constraints));
    } else {
      return _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    super.debugPaintSize(context, offset);
    assert(() {
      final Paint paint;
      if (child == null || child!.size.isEmpty) {
        paint = Paint()..color = const Color(0x90909090);
        context.canvas.drawRect(offset & size, paint);
      }
      return true;
    }());
  }

  @override
  void performLayout() {
    double minWidth = _style.minWidth;
    double maxWidth = _style.maxWidth;
    if (null != _style.sizes) {
      var temp = parent;
      var winSize = Size.zero;
      do {
        temp = temp!.parent;
        if (temp is RenderView) {
          winSize = temp.size;
        }
      } while (null != temp!.parent);

      double key = winSize.width;
      for (double item in _keys!) {
        if (key >= item) {
          key = item;
          break;
        }
      }

      var width = constraints.biggest.width / _style.count;
      if (_style.sizes!.containsKey(key)) {
        minWidth = maxWidth = width * _style.sizes![key]!;
      } else {
        minWidth = maxWidth = constraints.biggest.width;
      }
    }

    _additionalConstraints = BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: _style.minHeight,
      maxHeight: _style.maxHeight,
    );

    if (child != null) {
      child!.layout(_additionalConstraints.enforce(constraints), parentUsesSize: true);
      size = child!.size;
    } else {
      size = _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }
}

class HSizeTheme extends InheritedTheme {
  const HSizeTheme({
    super.key,
    required this.data,
    required super.child,
  }) ;

  final HSizeStyle data;

  static HSizeStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HSizeTheme>();
    return theme?.data ?? HTheme.of(context).sizeStyle;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HSizeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HSizeTheme oldWidget) => data != oldWidget.data;
}

extension HSizeContext on BuildContext {
  HSizeStyle get sizeBoxStyle {
    return HSizeTheme.of(this);
  }
}

class HSizeStyle {
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final Map<double, int>? sizes;
  final int count;

  const HSizeStyle({
    this.minWidth = 0,
    this.minHeight = 0,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    this.sizes,
    this.count = kHSizeCount,
  })  : assert(minWidth <= maxWidth, "minWidth > maxWidth"),
        assert(minHeight <= maxHeight, ".minHeight > maxHeight");

  HSizeStyle copyWith({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    Map<double, int>? sizes,
    int? count,
  }) {
    return HSizeStyle(
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      sizes: sizes ?? this.sizes,
      count: count ?? this.count,
    );
  }

  @override
  String toString() {
    return 'HSizeStyle{minWidth: $minWidth, minHeight: $minHeight, maxWidth: $maxWidth, maxHeight: $maxHeight, sizes: $sizes, count: $count}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HSizeStyle &&
          runtimeType == other.runtimeType &&
          minWidth == other.minWidth &&
          minHeight == other.minHeight &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          sizes == other.sizes &&
          count == other.count;

  @override
  int get hashCode => minWidth.hashCode ^ minHeight.hashCode ^ maxWidth.hashCode ^ maxHeight.hashCode ^ sizes.hashCode ^ count.hashCode;
}
