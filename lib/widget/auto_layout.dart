import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double sm = 540;
const double md = 720;
const double lg = 960;
const double xl = 1140;
const double ll = 1600;

class AutoLayout extends SingleChildRenderObjectWidget {
  final double? minHeight;

  final double? maxHeight;

  final Map<double, int> sizes;

  final int count;

  const AutoLayout({
    Key? key,
    Widget? child,
    this.sizes = const {},
    this.minHeight,
    this.maxHeight,
    this.count = 24,
  })  : assert(!(null != minHeight && null != maxHeight && minHeight <= maxHeight), "minHeight > maxHeight"),
        super(key: key, child: child);

  @override
  SingleChildRenderObjectElement createElement() {
    return SingleChildRenderObjectElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return AutoLayoutRender(sizes, minHeight, maxHeight, count);
  }

  @override
  void updateRenderObject(BuildContext context, covariant AutoLayoutRender renderObject) {
    renderObject
      ..sizes = sizes
      ..minHeight = minHeight
      ..maxHeight = maxHeight
      ..count = count;
    super.updateRenderObject(context, renderObject);
  }
}

class AutoLayoutRender extends RenderProxyBox {
  AutoLayoutRender(this._sizes, this._minHeight, this._maxHeight, this._count) {
    _keys = _sizes.keys.toList()..sort((a, b) => (b - a).ceil());
  }

  List<double> _keys = [];

  int _count;

  set count(int value) {
    _count = value;
    markNeedsLayout();
  }

  Map<double, int> _sizes;

  set sizes(Map<double, int> value) {
    _sizes = value;
    _keys = _sizes.keys.toList()..sort((a, b) => (b - a).ceil());
    markNeedsLayout();
  }

  double? _minHeight;

  set minHeight(double? value) {
    _minHeight = value;
    markNeedsLayout();
  }

  double? _maxHeight;

  set maxHeight(double? value) {
    _maxHeight = value;
    markNeedsLayout();
  }

  BoxConstraints _additionalConstraints = BoxConstraints.expand();

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
    var temp = parent;
    var winSize = Size.zero;
    do {
      temp = temp!.parent;
      if (temp is RenderBox && temp.hasSize) {
        winSize = temp.size;
      }
    } while (null != temp!.parent);

    double key = winSize.width;
    for (double item in _keys) {
      if (key >= item) {
        key = item;
        break;
      }
    }

    var width = constraints.biggest.width / _count;
    if (_sizes.containsKey(key)) {
      width = width * _sizes[key]!;
    } else {
      width = constraints.biggest.width;
    }

    _additionalConstraints = BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: _minHeight ?? _maxHeight ?? double.infinity,
      maxHeight: _maxHeight ?? _minHeight ?? double.infinity,
    );
    if (child != null) {
      child!.layout(_additionalConstraints.enforce(constraints), parentUsesSize: true);
      size = child!.size;
    } else {
      size = _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }
}
