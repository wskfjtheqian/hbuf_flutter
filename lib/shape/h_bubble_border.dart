import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
    this.arrowSize = const Size(6, 6),
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

    double arrow = math.max(y - arrowSize.height / 2, 0);
    double height = math.min(r.tlRadiusY, arrow);

    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX * (height / r.tlRadiusY), height), -math.pi / 2, -math.pi / 2, false);
    path.lineTo(r.left, r.top + arrow);
    path.lineTo(r.left - arrowSize.width, r.top + y);

    arrow = r.height - math.min(r.height, y + arrowSize.height / 2);
    height = math.min(r.blRadiusY, arrow);
    path.lineTo(r.left, r.bottom - arrow);

    path.arcTo(Rect.fromLTWH(r.left, r.bottom - height, r.blRadiusX * (height / r.blRadiusY), height), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.brRadiusX, r.bottom - r.brRadiusY, r.brRadiusX, r.brRadiusY), math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.trRadiusX, r.top, r.trRadiusX, r.trRadiusY), 0, -math.pi / 2, false);
  } else if (position == HBubblePosition.right) {
    double y = r.height / 2 * (1 + align.align);

    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX, r.tlRadiusY), -math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, r.blRadiusX, r.blRadiusY), -math.pi, -math.pi / 2, false);

    double arrow = r.height - math.min(r.height, y + arrowSize.height / 2);
    double height = math.min(r.blRadiusY, arrow);
    double width = r.brRadiusX * (height / r.brRadiusY);
    path.arcTo(Rect.fromLTWH(r.right - width, r.bottom - height, width, height), math.pi / 2, -math.pi / 2, false);
    path.lineTo(r.right, r.bottom - arrow);

    path.lineTo(r.right + arrowSize.width, r.top + y);

    arrow = math.max(y - arrowSize.height / 2, 0);
    height = math.min(r.tlRadiusY, arrow);
    width = r.trRadiusX * (height / r.trRadiusY);

    path.lineTo(r.right, r.top + arrow);
    path.arcTo(Rect.fromLTWH(r.right - width, r.top, width, height), 0, -math.pi / 2, false);
  } else if (position == HBubblePosition.top) {
    double x = r.width / 2 * (1 + align.align);
    path.moveTo(r.left + x, r.top - arrowSize.height);

    double arrow = math.max(x - arrowSize.width / 2, 0);
    double width = math.min(r.tlRadiusX, arrow);
    path.lineTo(r.left + arrow, r.top);
    path.arcTo(Rect.fromLTWH(r.left, r.top, width, r.trRadiusY * (width / r.tlRadiusX)), -math.pi / 2, -math.pi / 2, false);

    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, r.blRadiusX, r.blRadiusY), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.brRadiusX, r.bottom - r.brRadiusY, r.brRadiusX, r.brRadiusY), math.pi / 2, -math.pi / 2, false);

    arrow = r.width - math.min(r.width, x + arrowSize.width / 2);
    width = math.min(r.trRadiusX, arrow);
    path.arcTo(Rect.fromLTWH(r.right - width, r.top, width, r.trRadiusY * (width / r.trRadiusX)), 0, -math.pi / 2, false);
    path.lineTo(r.right - arrow, r.top);
  } else if (position == HBubblePosition.bottom) {
    double x = r.width / 2 * (1 + align.align);
    path.arcTo(Rect.fromLTWH(r.left, r.top, r.tlRadiusX, r.trRadiusY), -math.pi / 2, -math.pi / 2, false);

    double arrow = math.max(x - arrowSize.width / 2, 0);
    double width = math.min(r.blRadiusX, arrow);
    path.arcTo(Rect.fromLTWH(r.left, r.bottom - r.blRadiusY, width, r.blRadiusY * (width / r.blRadiusX)), -math.pi, -math.pi / 2, false);
    path.lineTo(r.left + arrow, r.bottom);
    path.lineTo(r.left + x, r.bottom + arrowSize.height);

    arrow = r.width - math.min(r.width, x + arrowSize.width / 2);
    width = math.min(r.brRadiusX, arrow);
    path.lineTo(r.right - arrow, r.bottom);

    path.arcTo(Rect.fromLTWH(r.right - width, r.bottom - r.brRadiusY, width, r.brRadiusY * (width / r.brRadiusX)), math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(r.right - r.trRadiusX, r.top, r.trRadiusX, r.trRadiusY), 0, -math.pi / 2, false);
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
