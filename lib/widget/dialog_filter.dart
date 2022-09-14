import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DialogFilter extends SingleChildRenderObjectWidget {
  const DialogFilter({
    Key? key,
    required this.filter,
    Widget? child,
    this.blendMode = BlendMode.srcOver,
  }) : super(key: key, child: child);

  final ui.ImageFilter filter;

  final BlendMode blendMode;

  @override
  RenderDialogFilter createRenderObject(BuildContext context) {
    return RenderDialogFilter(filter: filter, blendMode: blendMode);
  }

  @override
  void updateRenderObject(BuildContext context, RenderDialogFilter renderObject) {
    renderObject
      ..filter = filter
      ..blendMode = blendMode;
  }
}

class RenderDialogFilter extends RenderProxyBox {
  RenderDialogFilter({RenderBox? child, required ui.ImageFilter filter, BlendMode blendMode = BlendMode.srcOver})
      : _filter = filter,
        _blendMode = blendMode,
        super(child);

  @override
  ClipRRectLayer? get layer => super.layer as ClipRRectLayer?;

  ui.ImageFilter get filter => _filter;
  ui.ImageFilter _filter;

  set filter(ui.ImageFilter value) {
    if (_filter == value) {
      return;
    }
    _filter = value;
    markNeedsPaint();
  }

  BlendMode get blendMode => _blendMode;
  BlendMode _blendMode;

  set blendMode(BlendMode value) {
    if (_blendMode == value) {
      return;
    }
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);
      layer = context.pushClipRRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        RRect.fromRectAndCorners(
          Offset.zero & size,
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
        ),
        _paintFilter,
      );
      context.paintChild(child!, offset);
    } else {
      layer = null;
    }
  }

  void _paintFilter(PaintingContext context, Offset offset) {
    var layer = BackdropFilterLayer();
    layer.filter = _filter;
    layer.blendMode = _blendMode;
    context.pushLayer(layer, (context, offset) {
      context.canvas.drawColor(const Color(0xCCffffff), BlendMode.srcOver);
    }, offset);
  }
}
