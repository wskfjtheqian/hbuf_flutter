import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum HBubblePosition {
  left,
  right,
  top,
}

class HBubbleBorder extends OutlinedBorder {
  final BorderRadius radius;
  final Size arrowSize;
  final HBubblePosition position;

  const HBubbleBorder({
    BorderSide side = BorderSide.none,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.arrowSize = const Size(6, 6),
    required this.position,
  }) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
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

Path _getPath(RRect rect, Size arrowSize, HBubblePosition position) {
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
    path.arcTo(Rect.fromLTWH(rect.left, rect.top, rect.tlRadius.x, rect.tlRadius.y), -math.pi / 2, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.left, rect.bottom - rect.blRadius.y, rect.blRadius.x, rect.blRadius.y), -math.pi, -math.pi / 2, false);
    path.arcTo(Rect.fromLTWH(rect.right - arrowSize.width - rect.brRadius.x, rect.bottom - rect.brRadius.y, rect.brRadius.x, rect.brRadius.y), math.pi / 2,
        -math.pi / 2, false);
    path.lineTo(rect.right - arrowSize.width, rect.top + arrowSize.height);
    path.lineTo(rect.right, rect.top);
  }

  path.close();

  return path;
}

class HClipBubble extends CustomClipper<Path> {
  final BorderRadius radius;
  final Size arrowSize;
  final HBubblePosition position;

  HClipBubble({
    this.radius = const BorderRadius.all(Radius.zero),
    this.arrowSize = const Size(6, 6),
    required this.position,
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
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
