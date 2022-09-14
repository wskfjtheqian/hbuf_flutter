
import 'dart:math';

import 'package:flutter/material.dart';

class _DecorationValue {
  final List<double> values;

  final Color color;

  _DecorationValue(this.values, this.color);
}

class _RecordingButtonDecoration extends Decoration {
  final Color? color;

  final double scale;

  final List<_DecorationValue>? values;

  const _RecordingButtonDecoration({
    this.color,
    required this.scale,
    this.values,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RecordingButtonPainter(color, scale, values);
  }
}

class _RecordingButtonPainter extends BoxPainter {
  final Color? color;

  final double scale;

  final List<_DecorationValue>? values;

  _RecordingButtonPainter(this.color, this.scale, this.values);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    if (null == color) {
      return;
    }
    Rect rect = Rect.fromLTWH(0, 0, config.size!.width, config.size!.height);
    canvas.save();

    var center = offset + rect.center;
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    if (null != values) {
      for (var item in values!) {
        _printDecibels(canvas, rect, item);
      }
    }
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: rect.width + 16, height: rect.height + 16),
      Paint()..color = color!,
    );
    canvas.restore();
  }

  void _printDecibels(Canvas canvas, Rect rect, _DecorationValue item) {
    int count = item.values.length;

    List<_Point> points = [];
    for (var i = 0; i < count; i++) {
      var temp = 2 * pi / count * i;
      var radius = item.values[i] + min(rect.width, rect.height) / 2 + 8;
      points.add(_Point(radius * cos(temp), radius * sin(temp)));
      if (item.values[i] > 0) {
        item.values[i] -= 0.3;
      }
    }
    var curves = getCurve(points, canvas);
    Path path = Path();
    path.moveTo(curves[count - 1].poi.x, curves[count - 1].poi.y);
    for (var i = 0; i < count; i++) {
      path.cubicTo(
        curves[i == 0 ? count - 1 : i - 1].dot1.x,
        curves[i == 0 ? count - 1 : i - 1].dot1.y,
        curves[i].dot2.x,
        curves[i].dot2.y,
        curves[i].poi.x,
        curves[i].poi.y,
      );
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = item.color
        ..style = PaintingStyle.fill,
    );
  }

  List<_Curve> getCurve(List<_Point> point, Canvas canvas) {
    List<_Curve> curve = [];
    for (var i = 0; i < point.length; i++) {
      _Point pre = point[0 == i ? point.length - 1 : i - 1];
      _Point self = point[i];
      _Point next = point[i == point.length - 1 ? 0 : i + 1];

      var k1 = jd(pre.x - self.x, pre.y - self.y);
      var k2 = jd(next.x - self.x, next.y - self.y);
      var tt = k2 + (k1 - k2) / 2 + (k1 < k2 ? pi : 0);
      var temp = tt - pi / 2;
      var r = ds(next.x - self.x, next.y - self.y) / 3;
      var dot1 = _Point(self.x + r * cos(temp), self.y + r * sin(temp));

      temp = tt + pi / 2;

      var dot2 = _Point(self.x + r * cos(temp), self.y + r * sin(temp));

      curve.add(_Curve(poi: self, dot1: dot1, dot2: dot2));
    }
    return curve;
  }

  double ds(double w, double h) {
    return sqrt(w * w + h * h);
  }

  double jd(double w, double h) {
    if (0 < w && 0 == h) {
      return 0;
    } else if (0 < w && 0 < h) {
      return atan(h.abs() / w.abs());
    } else if (0 == w && 0 < h) {
      return pi / 2;
    } else if (0 > w && 0 < h) {
      return pi / 2 + atan(w.abs() / h.abs());
    } else if (0 > w && 0 == h) {
      return pi;
    } else if (0 > w && 0 > h) {
      return pi + atan(h.abs() / w.abs());
    } else if (0 == w && 0 > h) {
      return pi * 1.5;
    } else if (0 < w && 0 > h) {
      return pi * 1.5 + atan(w.abs() / h.abs());
    }
    return 0;
  }
}

class _Point {
  final double x;
  final double y;

  _Point(this.x, this.y);

  Offset get offset => Offset(x, y);
}

class _Curve {
  final _Point poi;
  final _Point dot1;
  final _Point dot2;

  _Curve({
    required this.poi,
    required this.dot1,
    required this.dot2,
  });
}

