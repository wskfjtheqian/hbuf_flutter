import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter/widgets.dart';

class ParticleAnimationController extends ChangeNotifier {
  final List<Offset> _position = [];

  void addPosition(Offset offset) {
    _position.add(offset);
    notifyListeners();
  }
}

class ParticleAnimation extends RenderObjectWidget {
  final ParticleAnimationController controller;

  final List<ImageProvider> providers;

  //最小生命周期毫秒
  final int minLife;

  //最大生命周期毫秒
  final int maxLife;

  //最小缩放比例
  final double minScale;

  //最大缩放比例
  final double maxScale;

  //最小衰减年龄比
  final double minDecay;

  //最大衰减年龄比
  final double maxDecay;

  //最小点的数量
  final int minPointCount;

  //最大点的数量
  final int maxPointCount;

  //最小点半径
  final int minRadius;

  //最大点半径
  final int maxRadius;

  //最小摆动幅度
  final int minRange;

  //最大摆动幅度
  final int maxRange;

  //最小不透明度
  final double minOpacity;

  //最大不透明度
  final double maxOpacity;

//  最小旋转角度
  final double minAngle;

  //最大旋转角度
  final double maxAngle;

  //图标向上
  final bool isUpward;

  const ParticleAnimation({
    Key? key,
    required this.controller,
    required this.providers,
    this.minLife = 4000,
    this.maxLife = 5500,
    this.minScale = 0.5,
    this.maxScale = 0.8,
    this.minDecay = 0.7,
    this.maxDecay = 0.8,
    this.minPointCount = 3,
    this.maxPointCount = 4,
    this.minRadius = 400,
    this.maxRadius = 450,
    this.minRange = 5,
    this.maxRange = 10,
    this.minOpacity = 0.5,
    this.maxOpacity = 0.9,
    this.minAngle = 170,
    this.maxAngle = 190,
    this.isUpward = false,
  })  : assert(2 <= minPointCount && 2 <= maxPointCount && minPointCount <= maxPointCount, "点的数量取值大于等于2，并且 minPointCount 小于等于 maxPointCount"),
        assert(0 <= minLife && 0 <= maxLife && minLife <= maxLife, "生命值大于等于0，并且 minLife 小于等于 maxLife"),
        assert(0 <= minRange && 0 <= maxRange && minRange <= maxRange, "动幅度取值大于等于0，并且 minRange 小于等于 maxRange"),
        assert(0 <= minOpacity && 1 >= maxOpacity && minOpacity <= maxOpacity, "不透明度取值范围0-1度,并且minOpacity小于等于maxOpacity"),
        assert(0 <= minDecay && 1 >= maxDecay && minDecay <= maxDecay, "衰减年龄比取值范围0-1度,并且minDecay小于等于maxDecay"),
        assert(0 <= minScale && 1 >= maxScale && minScale <= maxScale, "衰放比例比取值范围0-1度,并且minScale小于等于maxScale"),
        assert(0 <= minAngle && 360 >= maxAngle && minAngle <= maxAngle, "旋转角度取值范围0-360度,并且minAngle小于等于maxAngle"),
        super(key: key);

  @override
  ParticleAnimationElement createElement() {
    return ParticleAnimationElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ParticleAnimationRenderObject();
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class ParticleAnimationElement extends RenderObjectElement implements TickerProvider {
  final List<ui.Image> _image = [];

  ParticleAnimationController? _controller;

  List<ImageProvider> _providers = [];

  Ticker? _ticker;

  AnimationController? _animation;

  ParticleAnimationElement(RenderObjectWidget widget) : super(widget);

  @override
  ParticleAnimationRenderObject get renderObject => super.renderObject as ParticleAnimationRenderObject;

  @override
  ParticleAnimation get widget => super.widget as ParticleAnimation;

  void _resolveImages() {
    _image.clear();
    for (var element in _providers) {
      _resolveImage(element).then((value) => _image.add(value));
    }
  }

  Future<ui.Image> _resolveImage(ImageProvider provider) async {
    final ImageStream stream = provider.resolve(createLocalImageConfiguration(this));
    var completer = Completer.sync();
    var listener = ImageStreamListener((image, synchronousCall) {
      completer.complete(image.image);
    }, onError: (exception, stackTrace) {
      completer.completeError(exception, stackTrace);
    });
    stream.addListener(listener);
    try {
      return await completer.future;
    } finally {
      stream.removeListener(listener);
    }
  }

  @override
  void update(ParticleAnimation newWidget) {
    super.update(newWidget);
    if (_providers != newWidget.providers) {
      _providers = widget.providers;
      _resolveImages();
    }

    if (_controller != newWidget.controller) {
      _controller!.removeListener(_onListener);
      _controller = widget.controller;
      _controller!.addListener(_onListener);
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _controller = widget.controller;
    _controller!.addListener(_onListener);

    _providers = widget.providers;
    _resolveImages();
    _animation = AnimationController(vsync: this, duration: const Duration(seconds: 1000));
    _animation!.addListener(() {
      renderObject.markNeedsPaint();
      _createSpirit();
    });
    _animation!.repeat();
  }

  @override
  void unmount() {
    _controller!.removeListener(_onListener);
    _controller = null;
    _animation?.dispose();
    _animation = null;
    super.unmount();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(onTick);
    return _ticker!;
  }

  @override
  void didChangeDependencies() {
    if (_ticker != null) {
      _ticker!.muted = !TickerMode.of(this);
    }
    super.didChangeDependencies();
  }

  void _createSpirit() {}

  void _onListener() {
    if (_image.isEmpty) {
      return;
    }

    var now = DateTime.now().millisecondsSinceEpoch;
    var random = Random();
    for (var element in _controller!._position) {
      var life = widget.minLife + random.nextInt(widget.maxLife - widget.minLife + 1);
      var _spirit = _Spirit(
        isUpward: widget.isUpward,
        birth: now,
        life: life,
        path: _createPath(element),
        image: _image[random.nextInt(_image.length)],
        scale: widget.minScale + random.nextDouble() * (widget.maxScale - widget.minScale),
        opacity: widget.minOpacity + random.nextDouble() * (widget.maxOpacity - widget.minOpacity),
        decay: (life * (widget.minDecay + random.nextDouble() * (widget.maxDecay - widget.minDecay))).toInt(),
      );
      renderObject._list.add(_spirit);
    }
    _controller!._position.clear();
  }

  _createPath(Offset element) {
    var random = Random();
    int count = widget.minPointCount + random.nextInt(widget.maxPointCount - widget.minPointCount + 1);
    List<_Point> points = [];
    var radius = (widget.minRadius + random.nextInt(widget.maxRadius - widget.minRadius + 1)) / (count - 1);
    bool temp = 0 == random.nextInt(2);
    for (var i = 0; i < count; i++) {
      var dx = (temp ? -1.0 : 1.0) * (widget.minRange + random.nextInt(widget.maxRange - widget.minRange + 1));
      var dy = i * radius;

      points.add(_Point(dx, dy));
      temp = !temp;
    }

    var curves = getCurve(points, radius / 3);
    var angle = widget.minAngle + random.nextDouble() * (widget.maxAngle - widget.minAngle);
    angle = (angle / 180) * pi;
    for (var i = 0; i < count; i++) {
      curves[i] = _Curve(
        poi: _rotate(curves[i].poi, angle),
        dot1: _rotate(curves[i].dot1, angle),
        dot2: _rotate(curves[i].dot2, angle),
      );
    }

    Path path = Path();
    path.moveTo(element.dx + curves[0].poi.x, element.dy + curves[0].poi.y);
    for (var i = 1; i < count; i++) {
      path.cubicTo(
        element.dx + curves[i].dot1.x,
        element.dy + curves[i].dot1.y,
        element.dx + curves[i].dot2.x,
        element.dy + curves[i].dot2.y,
        element.dx + curves[i].poi.x,
        element.dy + curves[i].poi.y,
      );
    }

    return path;
  }

  List<_Curve> getCurve(List<_Point> point, double len) {
    List<_Curve> curve = [];
    for (var i = 0; i < point.length; i++) {
      if (0 == i) {
        _Point self = point[i];
        curve.add(_Curve(poi: self, dot1: self, dot2: self));
      } else {
        _Point pre = point[i - 1];
        _Point self = point[i];

        var dot1 = _Point(pre.x, pre.y + len);
        var dot2 = _Point(self.x, self.y - len);
        curve.add(_Curve(poi: self, dot1: dot1, dot2: dot2));
      }
    }
    return curve;
  }

  _Point _rotate(_Point poi, double angle) {
    return _Point(
      poi.x * cos(angle) - poi.y * sin(angle),
      poi.x * sin(angle) + poi.y * cos(angle),
    );
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

class ParticleAnimationRenderObject extends RenderProxyBox {
  final List<_Spirit> _list = [];

  @override
  void markNeedsPaint() {
    bool isNotEmpty = _list.isNotEmpty;

    var now = DateTime.now().millisecondsSinceEpoch;
    _list.removeWhere((element) => element.birth + element.life < now);

    if (isNotEmpty) {
      super.markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var now = DateTime.now().millisecondsSinceEpoch;
    var canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    for (var item in _list) {
      item.paint(canvas, now);
    }
    canvas.restore();
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      if (debugPaintSizeEnabled) {
        var canvas = context.canvas;
        canvas.save();
        canvas.translate(offset.dx, offset.dy);
        for (var item in _list) {
          item.debugPaint(context.canvas);
        }
        canvas.restore();
      }
      return true;
    }());
  }
  @override
  bool hitTestSelf(ui.Offset position) {
    return true;
  }
}

class _Spirit {
  //图片
  final ui.Image image;

  //绽放
  final double scale;

  //生命毫秒
  final int life;

  //出生时间
  final int birth;

  //运动路径
  final ui.Path path;

  //衰减年龄
  final int decay;

  final double opacity;

  late ui.PathMetric _metric;

  final bool isUpward;

  _Spirit({
    required this.path,
    required this.image,
    required this.birth,
    this.scale = 1,
    this.life = 500,
    this.decay = 400,
    this.opacity = 1,
    this.isUpward = false,
  }) {
    _metric = path.computeMetrics().elementAt(0);
  }

  void paint(Canvas canvas, int now) {
    var index = ((now - birth) / life) * _metric.length;
    if (index > _metric.length) {
      return;
    }
    var opacity = (1 - max(now - (birth + decay), 0) / (life - decay)) * this.opacity;
    var tangent = _metric.getTangentForOffset(index);

    canvas.save();
    canvas.translate(tangent!.position.dx, tangent.position.dy);
    canvas.scale(scale * 0.6);
    if (!isUpward) {
      canvas.rotate(tangent.angle * -1 + pi / 2);
    }
    canvas.drawImage(
      image,
      Offset(image.width.toDouble(), image.height.toDouble()) / -2,
      Paint()..colorFilter = ui.ColorFilter.mode(const ui.Color(0xFF000000).withOpacity(opacity), BlendMode.dstIn),
    );
    canvas.restore();
  }

  void debugPaint(Canvas canvas) {
    canvas.drawPath(
      path,
      Paint()
        ..color = const ui.Color(0xff00FF00)
        ..style = PaintingStyle.stroke,
    );
  }

}
