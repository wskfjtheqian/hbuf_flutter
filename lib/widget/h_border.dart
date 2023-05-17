import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/utils/dash_path.dart';

import 'h_theme.dart';

class HBorderSide extends BorderSide {
  final List<double>? dash;

  final Color? borderColor;

  const HBorderSide({
    super.color = const Color(0xFF000000),
    super.width = 1.0,
    super.style = BorderStyle.solid,
    super.strokeAlign = BorderSide.strokeAlignInside,
    this.dash,
    this.borderColor,
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

  HBorderSide copyWith({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
    List<double>? dash,
  }) {
    return HBorderSide(
      color: color ?? this.color,
      width: width ?? this.width,
      style: style ?? this.style,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      dash: dash ?? this.dash,
    );
  }

  HBorderSide copyFill({
    List<double>? dash,
  }) {
    return HBorderSide(
      color: color,
      width: width,
      style: style,
      strokeAlign: strokeAlign,
      dash: this.dash ?? dash,
    );
  }
}

class HBorderSideTheme extends InheritedTheme {
  const HBorderSideTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HBorderSideThemeData data;

  static HBorderSideThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HBorderSideTheme>();
    return theme?.data ?? HTheme.of(context).borderSideTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HBorderSideTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HBorderSideTheme oldWidget) => data != oldWidget.data;
}

extension HBorderSideContext on BuildContext {
  //细边
  HBorderSide get thinBorderSide {
    return HBorderSideTheme._of(this).thinBorderSide;
  }

  //默认边
  HBorderSide get defaultBorderSide {
    return HBorderSideTheme._of(this).defaultBorderSide;
  }

  //粗边
  HBorderSide get wideBorderSide {
    return HBorderSideTheme._of(this).wideBorderSide;
  }

  //细边
  HBorderSide get thinDashBorderSide {
    return HBorderSideTheme._of(this).thinDashBorderSide;
  }

  //默认边
  HBorderSide get defaultDashBorderSide {
    return HBorderSideTheme._of(this).defaultDashBorderSide;
  }

  //粗边
  HBorderSide get wideDashBorderSide {
    return HBorderSideTheme._of(this).wideDashBorderSide;
  }
}

class HBorderSideThemeData {
  //细边
  final HBorderSide thinBorderSide;

  //默认边
  final HBorderSide defaultBorderSide;

  //粗边
  final HBorderSide wideBorderSide;

  //细边
  final HBorderSide thinDashBorderSide;

  //默认边
  final HBorderSide defaultDashBorderSide;

  //粗边
  final HBorderSide wideDashBorderSide;

  const HBorderSideThemeData({
    this.thinBorderSide = const HBorderSide(width: 0.5, color: Color(0xFFDCDFE6)),
    this.defaultBorderSide = const HBorderSide(width: 1, color: Color(0xFFDCDFE6)),
    this.wideBorderSide = const HBorderSide(width: 2, color: Color(0xFFDCDFE6)),
    this.thinDashBorderSide = const HBorderSide(width: 0.5, dash: [4, 4], color: Color(0xFFDCDFE6)),
    this.defaultDashBorderSide = const HBorderSide(width: 1, dash: [6, 6], color: Color(0xFFDCDFE6)),
    this.wideDashBorderSide = const HBorderSide(width: 2, dash: [8, 8], color: Color(0xFFDCDFE6)),
  });

  HBorderSideThemeData copyWith({
    HBorderSide? thinBorderSide,
    HBorderSide? defaultBorderSide,
    HBorderSide? wideBorderSide,
    HBorderSide? thinDashBorderSide,
    HBorderSide? defaultDashBorderSide,
    HBorderSide? wideDashBorderSide,
  }) {
    return HBorderSideThemeData(
      thinBorderSide: thinBorderSide ?? this.thinBorderSide,
      defaultBorderSide: defaultBorderSide ?? this.defaultBorderSide,
      wideBorderSide: wideBorderSide ?? this.wideBorderSide,
      thinDashBorderSide: thinDashBorderSide ?? this.thinDashBorderSide,
      defaultDashBorderSide: defaultDashBorderSide ?? this.defaultDashBorderSide,
      wideDashBorderSide: wideDashBorderSide ?? this.wideDashBorderSide,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HBorderSideThemeData &&
          runtimeType == other.runtimeType &&
          thinBorderSide == other.thinBorderSide &&
          defaultBorderSide == other.defaultBorderSide &&
          wideBorderSide == other.wideBorderSide &&
          thinDashBorderSide == other.thinDashBorderSide &&
          defaultDashBorderSide == other.defaultDashBorderSide &&
          wideDashBorderSide == other.wideDashBorderSide;

  @override
  int get hashCode =>
      thinBorderSide.hashCode ^
      defaultBorderSide.hashCode ^
      wideBorderSide.hashCode ^
      thinDashBorderSide.hashCode ^
      defaultDashBorderSide.hashCode ^
      wideDashBorderSide.hashCode;
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
    Paint paint = Paint();

    Path path = Path();

    switch (top.style) {
      case BorderStyle.solid:
        paint.color = top.color;
        path.reset();
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);

        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = bottom.width;
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

        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = bottom.width;
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

        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = bottom.width;
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

        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = bottom.width;
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

  HBorder copyWith({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
  }) {
    return HBorder(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }
}

class HRadiusTheme extends InheritedTheme {
  const HRadiusTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HRadiusThemeData data;

  static HRadiusThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HRadiusTheme>();
    return theme?.data ?? HTheme.of(context).radiusTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HRadiusTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HRadiusTheme oldWidget) => data != oldWidget.data;
}

extension HRadiusContext on BuildContext {
  //迷你的圆角
  Radius get minRadius {
    return HRadiusTheme._of(this).minRadius;
  }

  //小的圆角
  Radius get smallRadius {
    return HRadiusTheme._of(this).smallRadius;
  }

  //默认的圆角
  Radius get defaultRadius {
    return HRadiusTheme._of(this).defaultRadius;
  }

  //中等的圆角
  Radius get mediumRadius {
    return HRadiusTheme._of(this).mediumRadius;
  }

  //最大的圆角
  Radius get maxRadius {
    return HRadiusTheme._of(this).maxRadius;
  }
}

class HRadiusThemeData {
  final Radius minRadius;
  final Radius smallRadius;
  final Radius defaultRadius;
  final Radius mediumRadius;
  final Radius maxRadius;

  const HRadiusThemeData({
    this.minRadius = const Radius.circular(2),
    this.smallRadius = const Radius.circular(4),
    this.defaultRadius = const Radius.circular(8),
    this.mediumRadius = const Radius.circular(16),
    this.maxRadius = const Radius.circular(32),
  });

  HRadiusThemeData copyWith({
    Radius? minRadius,
    Radius? smallRadius,
    Radius? defaultRadius,
    Radius? mediumRadius,
    Radius? maxRadius,
  }) {
    return HRadiusThemeData(
      minRadius: minRadius ?? this.minRadius,
      smallRadius: smallRadius ?? this.smallRadius,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      mediumRadius: mediumRadius ?? this.mediumRadius,
      maxRadius: maxRadius ?? this.maxRadius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HRadiusThemeData &&
          runtimeType == other.runtimeType &&
          minRadius == other.minRadius &&
          smallRadius == other.smallRadius &&
          defaultRadius == other.defaultRadius &&
          mediumRadius == other.mediumRadius &&
          maxRadius == other.maxRadius;

  @override
  int get hashCode => minRadius.hashCode ^ smallRadius.hashCode ^ defaultRadius.hashCode ^ mediumRadius.hashCode ^ maxRadius.hashCode;
}

enum HBubblePosition {
  left,
  right,
  top,
  bottom,
}

class ArrowAlign {
  final double align;

  const ArrowAlign(this.align);

  static const ArrowAlign start = ArrowAlign(-1);

  static const ArrowAlign center = ArrowAlign(0);

  static const ArrowAlign end = ArrowAlign(1);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ArrowAlign && runtimeType == other.runtimeType && align == other.align;

  @override
  int get hashCode => align.hashCode;
}

class HBubbleBorder extends OutlinedBorder {
  final BorderRadius radius;

  final Size arrowSize;

  final HBubblePosition position;

  final ArrowAlign align;

  const HBubbleBorder({
    BorderSide side = BorderSide.none,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.arrowSize = const Size(8, 8),
    required this.position,
    this.align = ArrowAlign.center,
  }) : super(side: side);

  HBubbleBorder copyWith({
    BorderSide? side,
    BorderRadius? radius,
    Size? arrowSize,
    HBubblePosition? position,
    ArrowAlign? align,
  }) {
    return HBubbleBorder(
      side: side ?? this.side,
      radius: radius ?? this.radius,
      arrowSize: arrowSize ?? this.arrowSize,
      position: position ?? this.position,
      align: align ?? this.align,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(left: side.width);
  }

  @override
  ShapeBorder scale(double t) => HBubbleBorder(position: position, side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is HBubbleBorder) {
      return HBubbleBorder(position: position, side: BorderSide.lerp(a.side, side, t));
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is HBubbleBorder) {
      return HBubbleBorder(position: position, side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(
      RRect.fromRectAndCorners(
        rect,
        bottomRight: radius.bottomRight,
        bottomLeft: radius.bottomLeft,
        topRight: radius.topRight,
        topLeft: radius.topLeft,
      ).deflate(side.width),
      arrowSize,
      position,
      align,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(
      RRect.fromRectAndCorners(
        rect,
        bottomRight: radius.bottomRight,
        bottomLeft: radius.bottomLeft,
        topRight: radius.topRight,
        topLeft: radius.topLeft,
      ).deflate(side.width),
      arrowSize,
      position,
      align,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(
          _getPath(
            RRect.fromRectAndCorners(
              rect,
              bottomRight: radius.bottomRight,
              bottomLeft: radius.bottomLeft,
              topRight: radius.topRight,
              topLeft: radius.topLeft,
            ).deflate(side.width),
            arrowSize,
            position,
            align,
          ),
          side.toPaint(),
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is HBubbleBorder && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'ArrowBorder')}($side)';
  }
}

Path _getPath(RRect r, Size arrowSize, HBubblePosition position, ArrowAlign align) {
  var path = Path();
  if (position == HBubblePosition.left) {
    double y = r.height / 2 * (1 + align.align);

    double arrow = max(y - arrowSize.height / 2, 0);
    double height = min(r.tlRadiusY, arrow);

    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX * (height / r.tlRadiusY), height), -pi / 2, -pi / 2, false);
    path.lineTo(r.left, r.top + arrow);
    path.lineTo(r.left - arrowSize.width, r.top + y);

    arrow = r.height - min(r.height, y + arrowSize.height / 2);
    height = min(r.blRadiusY, arrow);
    path.lineTo(r.left, r.bottom - arrow);

    path.arcTo(Rect.fromLTWH(r.left, r.bottom - height, r.blRadiusX * (height / r.blRadiusY), height), -pi, -pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.brRadiusX, r.bottom - r.brRadiusY, r.brRadiusX, r.brRadiusY), pi / 2, -pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.trRadiusX, r.top, r.trRadiusX, r.trRadiusY), 0, -pi / 2, false);
  } else if (position == HBubblePosition.right) {
    double y = r.height / 2 * (1 + align.align);

    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX, r.tlRadiusY), -pi / 2, -pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, r.blRadiusX, r.blRadiusY), -pi, -pi / 2, false);

    double arrow = r.height - min(r.height, y + arrowSize.height / 2);
    double height = min(r.blRadiusY, arrow);
    double width = r.brRadiusX * (height / r.brRadiusY);
    path.arcTo(Rect.fromLTWH(r.right - width, r.bottom - height, width, height), pi / 2, -pi / 2, false);
    path.lineTo(r.right, r.bottom - arrow);

    path.lineTo(r.right + arrowSize.width, r.top + y);

    arrow = max(y - arrowSize.height / 2, 0);
    height = min(r.tlRadiusY, arrow);
    width = r.trRadiusX * (height / r.trRadiusY);

    path.lineTo(r.right, r.top + arrow);
    path.arcTo(Rect.fromLTWH(r.right - width, r.top, width, height), 0, -pi / 2, false);
  } else if (position == HBubblePosition.top) {
    double x = r.width / 2 * (1 + align.align);
    path.moveTo(r.left + x, r.top - arrowSize.height);

    double arrow = max(x - arrowSize.width / 2, 0);
    double width = min(r.tlRadiusX, arrow);
    path.lineTo(r.left + arrow, r.top);
    path.arcTo(Rect.fromLTWH(r.left, r.top, width, r.trRadiusY * (width / r.tlRadiusX)), -pi / 2, -pi / 2, false);

    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, r.blRadiusX, r.blRadiusY), -pi, -pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.brRadiusX, r.bottom - r.brRadiusY, r.brRadiusX, r.brRadiusY), pi / 2, -pi / 2, false);

    arrow = r.width - min(r.width, x + arrowSize.width / 2);
    width = min(r.trRadiusX, arrow);
    path.arcTo(Rect.fromLTWH(r.right - width, r.top, width, r.trRadiusY * (width / r.trRadiusX)), 0, -pi / 2, false);
    path.lineTo(r.right - arrow, r.top);
  } else if (position == HBubblePosition.bottom) {
    double x = r.width / 2 * (1 + align.align);
    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX, r.trRadiusY), -pi / 2, -pi / 2, false);

    double arrow = max(x - arrowSize.width / 2, 0);
    double width = min(r.blRadiusX, arrow);
    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, width, r.blRadiusY * (width / r.blRadiusX)), -pi, -pi / 2, false);
    path.lineTo(r.left + arrow, r.bottom);
    path.lineTo(r.left + x, r.bottom + arrowSize.height);

    arrow = r.width - min(r.width, x + arrowSize.width / 2);
    width = min(r.brRadiusX, arrow);
    path.lineTo(r.right - arrow, r.bottom);

    path.arcTo(Rect.fromLTWH(r.right - width, r.bottom - r.brRadiusY, width, r.brRadiusY * (width / r.brRadiusX)), pi / 2, -pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.trRadiusX, r.top, r.trRadiusX, r.trRadiusY), 0, -pi / 2, false);
  }

  path.close();

  return path;
}

class HClipBubble extends CustomClipper<Path> {
  final BorderRadius radius;
  final Size arrowSize;
  final HBubblePosition position;
  final ArrowAlign align;

  HClipBubble({
    this.radius = const BorderRadius.all(Radius.zero),
    this.arrowSize = const Size(6, 6),
    required this.position,
    this.align = ArrowAlign.center,
  });

  @override
  Path getClip(Size size) {
    return _getPath(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        bottomRight: radius.bottomRight,
        bottomLeft: radius.bottomLeft,
        topRight: radius.topRight,
        topLeft: radius.topLeft,
      ),
      arrowSize,
      position,
      align,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
