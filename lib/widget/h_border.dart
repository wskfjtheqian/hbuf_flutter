import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:hbuf_flutter/utils/dash_path.dart';

class HBorderSide extends BorderSide {
  final List<double>? dash;

  const HBorderSide({
    super.color = const Color(0xFF000000),
    super.width = 1.0,
    super.style = BorderStyle.solid,
    super.strokeAlign = BorderSide.strokeAlignInside,
    this.dash,
  });

  static const HBorderSide none = HBorderSide(width: 0.0, style: BorderStyle.none);

  static HBorderSide merge(HBorderSide a, HBorderSide b) {
    assert(BorderSide.canMerge(a, b));
    final bool aIsNone = a.style == BorderStyle.none && a.width == 0.0;
    final bool bIsNone = b.style == BorderStyle.none && b.width == 0.0;
    if (aIsNone && bIsNone) {
      return HBorderSide.none;
    }
    if (aIsNone) {
      return b;
    }
    if (bIsNone) {
      return a;
    }
    assert(a.color == b.color);
    assert(a.style == b.style);
    return HBorderSide(
      color: a.color,
      // == b.color
      width: a.width + b.width,
      strokeAlign: max(a.strokeAlign, b.strokeAlign),
      style: a.style,
      // == b.style
      dash: a.dash, // == b.dash
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || super == other && other is HBorderSide && runtimeType == other.runtimeType && dash == other.dash;

  @override
  int get hashCode => super.hashCode ^ dash.hashCode;
}

mixin HShapeBorder implements ShapeBorder {
  void paintCircle(Canvas canvas, Rect rect, HBorderSide side) {
    final Paint paint = Paint()..color = side.color;

    Path path = Path()
      ..addOval(rect)
      ..close();
    if (side.dash != null) {
      path = dashPath(path, dashArray: CircularIntervalList(side.dash!));
    }
    canvas.drawPath(path, paint);
  }

  void paintRRect(Canvas canvas, Rect rect, HBorderSide side, BorderRadius borderRadius) {
    assert(side.style != BorderStyle.none);
    final Paint paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width;
    var offset = -side.strokeOffset / 2;
    rect = Rect.fromLTRB(
      rect.left + offset,
      rect.top + offset,
      rect.right - offset,
      rect.bottom - offset,
    );
    Path path = Path()
      ..addRRect(borderRadius.toRRect(rect))
      ..close();
    if (side.dash != null) {
      path = dashPath(path, dashArray: CircularIntervalList(side.dash!));
    }
    canvas.drawPath(path, paint);
  }

  void paintRect(Canvas canvas, Rect rect, HBorderSide side) {
    assert(side.style != BorderStyle.none);
    final Paint paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width;
    var offset = -side.strokeOffset / 2;
    rect = Rect.fromLTRB(
      rect.left + offset,
      rect.top + offset,
      rect.right - offset,
      rect.bottom - offset,
    );
    Path path = Path()
      ..addRect(rect)
      ..close();
    if (side.dash != null) {
      path = dashPath(path, dashArray: CircularIntervalList(side.dash!));
    }
    canvas.drawPath(path, paint);
  }

  void paintBorder(
    Canvas canvas,
    Rect rect, {
    HBorderSide top = HBorderSide.none,
    HBorderSide right = HBorderSide.none,
    HBorderSide bottom = HBorderSide.none,
    HBorderSide left = HBorderSide.none,
  }) {
    final Paint paint = Paint()..strokeWidth = 0.0;

    Path path = Path();

    switch (top.style) {
      case BorderStyle.solid:
        paint.color = top.color;
        path.reset();
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        if (top.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.right - right.width, rect.top + top.width);
          path.lineTo(rect.left + left.width, rect.top + top.width);
        }
        if (top.dash != null) {
          path = dashPath(path, dashArray: CircularIntervalList(top.dash!));
        }
        canvas.drawPath(path, paint);
        break;
      case BorderStyle.none:
        break;
    }

    switch (right.style) {
      case BorderStyle.solid:
        paint.color = right.color;
        path.reset();
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        if (right.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
          path.lineTo(rect.right - right.width, rect.top + top.width);
        }
        if (right.dash != null) {
          path = dashPath(path, dashArray: CircularIntervalList(right.dash!));
        }
        canvas.drawPath(path, paint);
        break;
      case BorderStyle.none:
        break;
    }

    switch (bottom.style) {
      case BorderStyle.solid:
        paint.color = bottom.color;
        path.reset();
        path.moveTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        if (bottom.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
          path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
        }
        if (bottom.dash != null) {
          path = dashPath(path, dashArray: CircularIntervalList(bottom.dash!));
        }
        canvas.drawPath(path, paint);
        break;
      case BorderStyle.none:
        break;
    }

    switch (left.style) {
      case BorderStyle.solid:
        paint.color = left.color;
        path.reset();
        path.moveTo(rect.left, rect.bottom);
        path.lineTo(rect.left, rect.top);
        if (left.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.left + left.width, rect.top + top.width);
          path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
        }
        if (left.dash != null) {
          path = dashPath(path, dashArray: CircularIntervalList(left.dash!));
        }
        canvas.drawPath(path, paint);
        break;
      case BorderStyle.none:
        break;
    }
  }
}

class HBorder extends Border with HShapeBorder {
  const HBorder({
    super.top = HBorderSide.none,
    super.right = HBorderSide.none,
    super.bottom = HBorderSide.none,
    super.left = HBorderSide.none,
  });

  const HBorder.fromHBorderSide(HBorderSide side) : super(top: side, right: side, bottom: side, left: side);

  const HBorder.symmetric({
    HBorderSide vertical = HBorderSide.none,
    HBorderSide horizontal = HBorderSide.none,
  }) : super(top: vertical, right: horizontal, bottom: vertical, left: horizontal);

  /// A uniform border with all sides the same color and width.
  ///
  /// The sides default to black solid borders, one logical pixel wide.
  factory HBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    double strokeAlign = BorderSide.strokeAlignInside,
    List<double>? dash,
  }) {
    final HBorderSide side = HBorderSide(color: color, width: width, style: style, strokeAlign: strokeAlign, dash: dash);
    return HBorder.fromHBorderSide(side);
  }

  static Border merge(Border a, Border b) {
    assert(BorderSide.canMerge(a.top, b.top));
    assert(BorderSide.canMerge(a.right, b.right));
    assert(BorderSide.canMerge(a.bottom, b.bottom));
    assert(BorderSide.canMerge(a.left, b.left));
    return Border(
      top: HBorderSide.merge(a.top as HBorderSide, b.top as HBorderSide),
      right: HBorderSide.merge(a.right as HBorderSide, b.right as HBorderSide),
      bottom: HBorderSide.merge(a.bottom as HBorderSide, b.bottom as HBorderSide),
      left: HBorderSide.merge(a.left as HBorderSide, b.left as HBorderSide),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection, BoxShape shape = BoxShape.rectangle, BorderRadius? borderRadius}) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null, 'A borderRadius can only be given for rectangular boxes.');
              paintCircle(canvas, rect, top as HBorderSide);
              return;
            case BoxShape.rectangle:
              if (borderRadius != null && borderRadius != BorderRadius.zero) {
                paintRRect(canvas, rect, top as HBorderSide, borderRadius);
              } else {
                paintRect(canvas, rect, top as HBorderSide);
              }
          }
          return;
      }
    } else {
      assert(() {
        if (borderRadius != null) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('A borderRadius can only be given for a uniform Border.'),
            ErrorDescription('The following is not uniform:'),
            if (!_colorIsUniform) ErrorDescription('HBorderSide.color'),
            if (!_widthIsUniform) ErrorDescription('HBorderSide.width'),
            if (!_styleIsUniform) ErrorDescription('HBorderSide.style'),
            if (!_strokeAlignIsUniform) ErrorDescription('HBorderSide.strokeAlign'),
          ]);
        }
        return true;
      }());
      assert(() {
        if (shape != BoxShape.rectangle) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('A Border can only be drawn as a circle if it is uniform.'),
            ErrorDescription('The following is not uniform:'),
            if (!_colorIsUniform) ErrorDescription('HBorderSide.color'),
            if (!_widthIsUniform) ErrorDescription('HBorderSide.width'),
            if (!_styleIsUniform) ErrorDescription('HBorderSide.style'),
            if (!_strokeAlignIsUniform) ErrorDescription('HBorderSide.strokeAlign'),
          ]);
        }
        return true;
      }());
      assert(() {
        if (!_strokeAlignIsUniform || top.strokeAlign != BorderSide.strokeAlignInside) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('A Border can only draw strokeAlign different than HBorderSide.strokeAlignInside on uniform borders.'),
          ]);
        }
        return true;
      }());
      this.paintBorder(canvas, rect, top: top as HBorderSide, right: right as HBorderSide, bottom: bottom as HBorderSide, left: left as HBorderSide);
    }
  }

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor && bottom.color == topColor && left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth && bottom.width == topWidth && left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle && bottom.style == topStyle && left.style == topStyle;
  }

  bool get _strokeAlignIsUniform {
    final double topStrokeAlign = top.strokeAlign;
    return right.strokeAlign == topStrokeAlign && bottom.strokeAlign == topStrokeAlign && left.strokeAlign == topStrokeAlign;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || super == other && other is HBorder && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}


