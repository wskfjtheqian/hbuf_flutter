import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum HBubblePosition {
  left,
  right,
  top,
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
    this.radius = const BorderRadius.all(Radius.circular(32)),
    this.arrowSize = const Size(32, 32),
    required this.position,
    this.align = ArrowAlign.center,
  }) : super(side: side);

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
  HBubbleBorder copyWith({BorderSide? side}) {
    return HBubbleBorder(position: position, side: side ?? this.side);
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

Path _getPath(RRect rect, Size arrowSize, HBubblePosition position, ArrowAlign align) {
  var path = Path();
  if (position == HBubblePosition.left) {
    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left + arrowSize.width, rect.top + arrowSize.height);
    path.arcTo(Rect.fromLTWH(rect.left + arrowSize.width, rect.bottom - rect.blRadius.y, rect.blRadius.x, rect.blRadius.y), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.right - rect.brRadius.x, rect.bottom - rect.brRadius.y, rect.brRadius.x, rect.brRadius.y), math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.right - rect.trRadius.x, rect.top, rect.trRadius.x, rect.trRadius.y), 0, -math.pi / 2, false);
  } else if (position == HBubblePosition.right) {
    path.arcTo(Rect.fromLTWH(rect.left, rect.top, rect.tlRadius.x, rect.tlRadius.y), -math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.left, rect.bottom - rect.blRadius.y, rect.blRadius.x, rect.blRadius.y), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.right - arrowSize.width - rect.brRadius.x, rect.bottom - rect.brRadius.y, rect.brRadius.x, rect.brRadius.y), math.pi / 2,
        -math.pi / 2, false);
    path.lineTo(rect.right - arrowSize.width, rect.top + arrowSize.height);
    path.lineTo(rect.right, rect.top);
  } else if (position == HBubblePosition.top) {
    double x = rect.width / 2 * (1 + align.align);
    path.moveTo(x, -arrowSize.height);

    double arrow = math.max(x - arrowSize.width / 2, 0);
    double width = math.min(rect.tlRadiusX, arrow);
    path.lineTo(arrow, 0);
    path.arcTo(Rect.fromLTWH(0, 0, width, rect.trRadiusY * (width / rect.tlRadiusX)), -math.pi / 2, -math.pi / 2, false);

    path.arcTo(Rect.fromLTWH(0, rect.height - rect.blRadiusY, rect.blRadiusX, rect.blRadiusY), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.width - rect.brRadiusX, rect.height - rect.brRadiusY, rect.brRadiusX, rect.brRadiusY), math.pi / 2, -math.pi / 2, false);

    arrow = rect.width - math.min(rect.width, x + arrowSize.width / 2);
    width = math.min(rect.trRadiusX, arrow);
    path.arcTo(Rect.fromLTWH(rect.right - width, 0, width, rect.trRadiusY * (width / rect.trRadiusX)), 0, -math.pi / 2, false);
    path.lineTo(rect.right - arrow, 0);
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
