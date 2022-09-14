import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class MarqueeView extends SingleChildRenderObjectWidget {
  final double speed;

  MarqueeView({super.key, super.child, this.speed = 5});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MarqueeViewRender();
  }

  @override
  SingleChildRenderObjectElement createElement() {
    return _MarqueeViewElement(this);
  }
}

class _MarqueeViewElement extends SingleChildRenderObjectElement implements TickerProvider {
  Ticker? _ticker;

  AnimationController? _animation;

  int? _time;

  double _x = 0;

  _MarqueeViewElement(super.widget);

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

  @override
  MarqueeView get widget => super.widget as MarqueeView;

  @override
  _MarqueeViewRender get renderObject => super.renderObject as _MarqueeViewRender;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _animation = AnimationController(vsync: this, duration: const Duration(seconds: 1000));
    _animation?.addListener(() {
      var time = DateTime.now().millisecondsSinceEpoch;
      if (null != _time) {
        renderObject.x = _x -= widget.speed / (time - _time!);
      }
      _time = time;
    });
    _animation?.repeat();
  }

  @override
  void unmount() {
    _animation?.dispose();
    super.unmount();
  }
}

class _MarqueeViewRender extends RenderProxyBox {
  final LayerHandle<ClipRectLayer> _clipRectLayer = LayerHandle<ClipRectLayer>();

  double _x = 0;

  int _count = 0;

  set x(double v) {
    _x = v;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  void performLayout() {
    if (child != null) {
      var _additionalConstraints = BoxConstraints(
        minWidth: 0,
        maxWidth: double.infinity,
        minHeight: size.height,
        maxHeight: size.height,
      );
      child!.layout(_additionalConstraints, parentUsesSize: true);
      _count = (size.width / child!.size.width).ceil() + 1;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipRectLayer.layer,
    );
  }

  void defaultPaint(PaintingContext context, Offset offset) {
    double width = child!.size.width;
    var dx = _x % (width * _count);
    dx = dx % width;
    for (int i = 0; i < _count; i++) {
      super.paint(context, offset + Offset(width * (i - 1) + dx, 0));
    }
  }
}
