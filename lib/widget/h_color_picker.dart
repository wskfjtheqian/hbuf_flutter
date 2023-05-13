import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

import 'h_theme.dart';

typedef OnHColorChanged = void Function(HSVColor color);

enum HColorSliderDirection {
  horizontal,
  vertical,
}

class HColorBox extends SingleChildRenderObjectWidget {
  final HSVColor color;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  final BoxBorder? border;

  final BorderRadius? borderRadius;

  const HColorBox({
    super.key,
    super.child,
    required this.color,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
    this.border,
    this.borderRadius,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ColorBoxRender(
      color: color,
      backBoxSize: backBoxSize,
      backBoxColor0: backBoxColor0,
      backBoxColor1: backBoxColor1,
      border: border,
      borderRadius: borderRadius,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ColorBoxRender renderObject) {
    renderObject
      ..color = color
      ..backBoxSize = backBoxSize
      ..backBoxColor1 = backBoxColor1
      ..backBoxColor0 = backBoxColor0
      ..border = border
      ..textDirection = Directionality.maybeOf(context)
      ..borderRadius = borderRadius;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HSVColor>('color', color));
    properties.add(DoubleProperty('backBoxSize', backBoxSize));
    properties.add(ColorProperty('backBoxColor0', backBoxColor0));
    properties.add(ColorProperty('backBoxColor1', backBoxColor1));
  }
}

class _ColorBoxRender extends RenderProxyBoxWithHitTestBehavior {
  _ColorBoxRender({
    required HSVColor color,
    required double backBoxSize,
    required Color backBoxColor0,
    required Color backBoxColor1,
    BorderRadius? borderRadius,
    BoxBorder? border,
    TextDirection? textDirection,
  }) : super(behavior: HitTestBehavior.opaque) {
    _color = color;
    _backBoxSize = backBoxSize;
    _backBoxColor0 = backBoxColor0;
    _backBoxColor1 = backBoxColor1;
    _borderRadius = borderRadius;
    _border = border;
    _textDirection = textDirection;
  }

  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    _textDirection = value;
    markNeedsPaint();
  }

  double _backBoxSize = 6.0;

  set backBoxSize(double value) {
    _backBoxSize = value;
    markNeedsPaint();
  }

  Color _backBoxColor0 = Colors.grey;

  set backBoxColor0(Color value) {
    _backBoxColor0 = value;
    markNeedsPaint();
  }

  BorderRadius? _borderRadius;

  set borderRadius(BorderRadius? value) {
    _borderRadius = value;
    markNeedsPaint();
  }

  BoxBorder? _border;

  set border(BoxBorder? value) {
    _border = value;
    markNeedsPaint();
  }

  Color _backBoxColor1 = Colors.white;

  set backBoxColor1(Color value) {
    _backBoxColor1 = value;
    markNeedsPaint();
  }

  late HSVColor _color;

  set color(HSVColor value) {
    _color = value;
    markNeedsPaint();
  }

  @override
  RRect get _clip => _borderRadius?.resolve(_textDirection).toRRect(Offset.zero & size) ?? RRect.fromRectAndCorners(Offset.zero & size);

  @override
  void paint(PaintingContext context, Offset offset) {
    var clip = _clip;
    if (null != _borderRadius) {
      layer = context.pushClipRRect(
        needsCompositing,
        offset,
        clip.outerRect,
        clip,
        paintContent,
        clipBehavior: Clip.antiAlias,
        oldLayer: layer as ClipRRectLayer?,
      );
    } else {
      paintContent(context, offset);
    }
  }

  void paintContent(PaintingContext context, Offset offset) {
    var rect = offset & size;
    _paintBack(context.canvas, rect, _backBoxSize, _backBoxColor0, _backBoxColor1);
    Path path;
    if (null != _borderRadius) {
      path = Path()..addRRect(_borderRadius!.resolve(_textDirection).toRRect(rect));
    } else {
      path = Path()..addRect(rect);
    }

    context.canvas.drawPath(
      path,
      Paint()
        ..color = _color.toColor()
        ..style = PaintingStyle.fill,
    );
    super.paint(context, offset);

    _border?.paint(context.canvas, rect, textDirection: _textDirection, borderRadius: _borderRadius);
  }
}

class HColorOpacitySlider extends RenderObjectWidget {
  final HColorSliderDirection direction;

  final HSVColor color;

  final HSVColor value;

  final OnHColorChanged onChanged;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  const HColorOpacitySlider({
    super.key,
    required this.color,
    required this.value,
    required this.onChanged,
    this.direction = HColorSliderDirection.horizontal,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
  });

  @override
  RenderObjectElement createElement() {
    return _HColorOpacitySliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HColorOpacitySliderRender(
      direction: direction,
      color: color,
      value: value,
      onChanged: onChanged,
      backBoxSize: backBoxSize,
      backBoxColor0: backBoxColor0,
      backBoxColor1: backBoxColor1,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _HColorOpacitySliderRender renderObject) {
    renderObject
      ..direction = direction
      ..color = color
      ..onChanged = onChanged
      ..backBoxSize = backBoxSize
      ..backBoxColor1 = backBoxColor1
      ..backBoxColor0 = backBoxColor0;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<HColorSliderDirection>('direction', direction));
    properties.add(DiagnosticsProperty<HSVColor>('color', color));
    properties.add(DiagnosticsProperty<HSVColor>('value', value));
    properties.add(DoubleProperty('backBoxSize', backBoxSize));
    properties.add(ColorProperty('backBoxColor0', backBoxColor0));
    properties.add(ColorProperty('backBoxColor1', backBoxColor1));
  }
}

class _HColorOpacitySliderElement extends RenderObjectElement {
  _HColorOpacitySliderElement(super.widget);

  @override
  HColorOpacitySlider get widget => super.widget as HColorOpacitySlider;

  @override
  _HColorOpacitySliderRender get renderObject => super.renderObject as _HColorOpacitySliderRender;

  @override
  void update(covariant HColorOpacitySlider newWidget) {
    if (widget.color != newWidget.color) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _HColorOpacitySliderRender extends RenderProxyBox {
  double _alignment = 0;

  late Gradient _gradient;

  _HColorOpacitySliderRender({
    required HSVColor color,
    required HColorSliderDirection direction,
    required HSVColor value,
    required OnHColorChanged onChanged,
    required double backBoxSize,
    required Color backBoxColor0,
    required Color backBoxColor1,
  }) {
    _direction = direction;
    _color = color;
    _onChanged = onChanged;
    backBoxSize = backBoxSize;
    backBoxColor0 = backBoxColor0;
    backBoxColor1 = backBoxColor1;
    _alignment = value.alpha * 2 - 1;
    createGradient();
  }

  late OnHColorChanged _onChanged;

  set value(HSVColor value) {
    _alignment = value.alpha * 2 - 1;
    markNeedsPaint();
  }

  set onChanged(OnHColorChanged value) {
    _onChanged = value;
  }

  late HColorSliderDirection _direction;

  set direction(HColorSliderDirection value) {
    _direction = value;
    createGradient();
    markNeedsPaint();
  }

  double _backBoxSize = 6.0;

  set backBoxSize(double value) {
    _backBoxSize = value;
    markNeedsPaint();
  }

  Color _backBoxColor0 = Colors.grey;

  set backBoxColor0(Color value) {
    _backBoxColor0 = value;
    markNeedsPaint();
  }

  Color _backBoxColor1 = Colors.white;

  set backBoxColor1(Color value) {
    _backBoxColor1 = value;
    markNeedsPaint();
  }

  late HSVColor _color;

  set color(HSVColor value) {
    _color = value;
    createGradient();
    markNeedsPaint();
  }

  void createGradient() {
    _gradient = LinearGradient(
      colors: [_color.withAlpha(0).toColor(), _color.toColor()],
      begin: HColorSliderDirection.horizontal == _direction ? Alignment.centerLeft : Alignment.topCenter,
      end: HColorSliderDirection.horizontal == _direction ? Alignment.centerRight : Alignment.bottomCenter,
    );
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  bool get sizedByParent => true;

  @override
  void performLayout() {}

  @override
  void paint(PaintingContext context, Offset offset) {
    var rect = offset & size;
    var thumbRect = HColorSliderDirection.horizontal == _direction
        ? Rect.fromLTWH(rect.left + size.width * (_alignment + 1) / 2 - 6, rect.top, 12, size.height)
        : Rect.fromLTWH(rect.left, rect.top + size.height * (_alignment + 1) / 2 - 6, size.width, 12);
    var thumbPaint = Paint()
      ..color = const Color(0xffffffff)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _paintBack(context.canvas, rect, _backBoxSize, _backBoxColor0, _backBoxColor1);
    context.canvas.drawRect(rect, Paint()..shader = _gradient.createShader(rect));
    context.canvas.drawRRect(RRect.fromRectXY(thumbRect, 4, 4), thumbPaint);
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    if (event is PointerMoveEvent) {
      _alignment = HColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(_color.withAlpha((_alignment + 1) / 2));
      markNeedsPaint();
    } else if (event is PointerDownEvent) {
      _alignment = HColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(_color.withAlpha((_alignment + 1) / 2));
      markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }
}

void _paintBack(Canvas canvas, Rect rect, double boxSize, Color color0, Color color1) {
  for (double y = rect.top; y < rect.bottom; y += boxSize) {
    var color = (0 == ((y - rect.top) / boxSize) % 2) ? color0 : color1;

    for (double x = rect.left; x < rect.right; x += boxSize) {
      canvas.drawRect(
        Rect.fromLTRB(x, y, min(x + boxSize, rect.right), min(y + boxSize, rect.bottom)),
        Paint()..color = (color = color == color1 ? color0 : color1),
      );
    }
  }
}

class HColorLinearSlider extends RenderObjectWidget {
  final HColorSliderDirection direction;

  final HSVColor value;

  final OnHColorChanged onChanged;

  const HColorLinearSlider({
    super.key,
    required this.value,
    this.direction = HColorSliderDirection.vertical,
    required this.onChanged,
  });

  @override
  RenderObjectElement createElement() {
    return _ColorLinearSliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HColorLinearSliderRender(
      direction: direction,
      onChanged: onChanged,
      value: value,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _HColorLinearSliderRender renderObject) {
    renderObject.direction = direction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<HColorSliderDirection>('direction', direction));
    properties.add(DiagnosticsProperty<HSVColor>('value', value));
  }
}

class _ColorLinearSliderElement extends RenderObjectElement {
  _ColorLinearSliderElement(super.widget);

  @override
  HColorLinearSlider get widget => super.widget as HColorLinearSlider;

  @override
  _HColorLinearSliderRender get renderObject => super.renderObject as _HColorLinearSliderRender;

  @override
  void update(covariant HColorLinearSlider newWidget) {
    if (widget.value != newWidget.value) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _HColorLinearSliderRender extends RenderProxyBox {
  late Gradient _gradient;

  double _alignment = 0;

  late OnHColorChanged _onChanged;

  _HColorLinearSliderRender({
    required HColorSliderDirection direction,
    required OnHColorChanged onChanged,
    required HSVColor value,
  }) {
    _direction = direction;
    _onChanged = onChanged;
    _alignment = (1 - (value.hue / 360)) * 2 - 1;
    createGradient();
  }

  set value(HSVColor color) {
    _alignment = (1 - (color.hue / 360)) * 2 - 1;
    markNeedsPaint();
  }

  late HColorSliderDirection _direction;

  set direction(HColorSliderDirection value) {
    _direction = value;
    createGradient();
    markNeedsPaint();
  }

  set onChanged(OnHColorChanged value) {
    _onChanged = value;
  }

  void createGradient() {
    _gradient = LinearGradient(
      colors: [
        const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 060.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 000.0, 1.0, 1.0).toColor(),
      ],
      begin: HColorSliderDirection.horizontal == _direction ? Alignment.centerLeft : Alignment.topCenter,
      end: HColorSliderDirection.horizontal == _direction ? Alignment.centerRight : Alignment.bottomCenter,
    );
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  bool get sizedByParent => true;

  @override
  void performLayout() {}

  @override
  void paint(PaintingContext context, Offset offset) {
    var rect = offset & size;
    var thumbRect = HColorSliderDirection.horizontal == _direction
        ? Rect.fromLTWH(rect.left + size.width * (_alignment + 1) / 2 - 6, rect.top, 12, size.height)
        : Rect.fromLTWH(rect.left, rect.top + size.height * (_alignment + 1) / 2 - 6, size.width, 12);
    var thumbPaint = Paint()
      ..color = const Color(0xffffffff)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    context.canvas.drawRect(rect, Paint()..shader = _gradient.createShader(rect));
    context.canvas.drawRRect(RRect.fromRectXY(thumbRect, 4, 4), thumbPaint);
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    if (event is PointerMoveEvent) {
      _alignment = HColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(HSVColor.fromAHSV(1.0, 360 * (1 - (_alignment + 1) / 2), 1.0, 1.0));
      markNeedsPaint();
    } else if (event is PointerDownEvent) {
      _alignment = HColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(HSVColor.fromAHSV(1.0, 360 * (1 - (_alignment + 1) / 2), 1.0, 1.0));
      markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }
}

class HColorBrightSlider extends RenderObjectWidget {
  final HSVColor color;

  final HSVColor value;

  final OnHColorChanged onChanged;

  const HColorBrightSlider({
    super.key,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  RenderObjectElement createElement() {
    return _HColorBrightSliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HColorBrightSliderRender(
      color: color,
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _HColorBrightSliderRender renderObject) {
    renderObject
      ..onChanged = onChanged
      ..color = color;
  }
}

class _HColorBrightSliderElement extends RenderObjectElement {
  _HColorBrightSliderElement(super.widget);

  @override
  HColorBrightSlider get widget => super.widget as HColorBrightSlider;

  @override
  _HColorBrightSliderRender get renderObject => super.renderObject as _HColorBrightSliderRender;

  @override
  void update(covariant HColorBrightSlider newWidget) {
    if (widget.value != newWidget.value) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _HColorBrightSliderRender extends RenderProxyBox {
  late Gradient _colorGradient;

  late Gradient _brightGradient;

  late HSVColor _color;

  late Alignment _alignment;

  late OnHColorChanged _onChanged;

  _HColorBrightSliderRender({
    required HSVColor color,
    required OnHColorChanged onChanged,
    required HSVColor value,
  }) {
    _onChanged = onChanged;
    _color = color;
    _alignment = Alignment(value.saturation * 2 - 1, (1 - value.value) * 2 - 1);
    createGradient();
  }

  set value(HSVColor value) {
    _alignment = Alignment(value.saturation * 2 - 1, (1 - value.value) * 2 - 1);
    markNeedsPaint();
  }

  set color(HSVColor color) {
    _color = color;
    createGradient();
    markNeedsPaint();
  }

  void createGradient() {
    _colorGradient = LinearGradient(
      colors: [const Color(0xffffffff), _color.toColor()],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    _brightGradient = const LinearGradient(
      colors: [Color(0x00000000), Color(0xff000000)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  set onChanged(OnHColorChanged value) {
    _onChanged = value;
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  bool get sizedByParent => true;

  @override
  void performLayout() {}

  @override
  void paint(PaintingContext context, Offset offset) {
    var rect = offset & size;
    var thumbPos = Offset(size.width * (_alignment.x + 1) / 2, size.height * (_alignment.y + 1) / 2);
    var thumbPaint = Paint()
      ..color = -0.5 > _alignment.y ? const Color(0xff000000) : const Color(0xffffffff)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    context.canvas.drawRect(rect, Paint()..shader = _colorGradient.createShader(rect));
    context.canvas.drawRect(rect, Paint()..shader = _brightGradient.createShader(rect));
    context.canvas.drawCircle(offset + thumbPos, 6, thumbPaint);
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    if (event is PointerMoveEvent) {
      _alignment = Alignment(
        min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1)),
        min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1)),
      );
      _onChanged(HSVColor.fromAHSV(_color.alpha, _color.hue, (_alignment.x + 1) / 2, 1 - (_alignment.y + 1) / 2));
      markNeedsPaint();
    } else if (event is PointerDownEvent) {
      _alignment = Alignment(
        min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1)),
        min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1)),
      );
      _onChanged(HSVColor.fromAHSV(_color.alpha, _color.hue, (_alignment.x + 1) / 2, 1 - (_alignment.y + 1) / 2));
      markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }
}

class HColorSelect extends StatefulWidget {
  final HSVColor color;

  final double spacing;

  final OnHColorChanged changed;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  const HColorSelect({
    Key? key,
    required this.color,
    this.spacing = 10,
    required this.changed,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
  }) : super(key: key);

  @override
  _HColorSelectState createState() => _HColorSelectState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(DoubleProperty('backBoxSize', backBoxSize));
    properties.add(ColorProperty('backBoxColor0', backBoxColor0));
    properties.add(ColorProperty('backBoxColor1', backBoxColor1));
    properties.add(DiagnosticsProperty<HSVColor>('color', color));
  }
}

class _HColorSelectState extends State<HColorSelect> {
  HSVColor _brightColor = HSVColor.fromColor(const Color(0xffff0000));

  HSVColor _opacityColor = HSVColor.fromColor(const Color(0xffff0000));

  HSVColor _color = HSVColor.fromColor(const Color(0xffff0000));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: HColorBrightSlider(
                  color: _brightColor,
                  value: _opacityColor,
                  onChanged: (HSVColor color) {
                    setState(() {
                      _opacityColor = color;
                      _color = _opacityColor.withAlpha(_color.alpha);
                    });
                    widget.changed(_color);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: widget.spacing),
                child: SizedBox(
                  width: 24,
                  child: HColorLinearSlider(
                    value: widget.color,
                    onChanged: (HSVColor color) {
                      setState(() {
                        _brightColor = color;
                        _opacityColor = _opacityColor.withHue(color.hue);
                        _color = _opacityColor.withAlpha(_color.alpha);
                      });
                      widget.changed(_color);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.spacing),
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                Expanded(
                  child: HColorOpacitySlider(
                    backBoxSize: widget.backBoxSize,
                    backBoxColor0: widget.backBoxColor0,
                    backBoxColor1: widget.backBoxColor1,
                    color: _opacityColor,
                    value: _color,
                    onChanged: (HSVColor color) {
                      setState(() {
                        _color = color;
                      });
                      widget.changed(_color);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: widget.spacing),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: HColorBox(
                      backBoxSize: widget.backBoxSize,
                      backBoxColor0: widget.backBoxColor0,
                      backBoxColor1: widget.backBoxColor1,
                      color: _color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // SelectableText('HEX: 0x${_color.toColor().value.toRadixString(16).padLeft(8, '0')}'),
        // SelectableText('HSV: ${_color.toString()}'),
      ],
    );
  }
}

/// 选择颜色
/// color 默认颜色
/// 返回选择的颜色
Future<Color?> showHColorPicker(BuildContext context, {required Color color}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: HColorPicker(color: color),
      );
    },
  );
}

typedef HColorPickerTextCall = String Function(BuildContext context);

HColorPickerTextCall colorPickerOkTextCall = (context) => "确定";

HColorPickerTextCall colorPickerCancelTextCall = (context) => "取消";

class HColorPicker extends StatefulWidget {
  final Color color;

  const HColorPicker({Key? key, required this.color}) : super(key: key);

  @override
  _HColorPickerState createState() => _HColorPickerState();
}

class _HColorPickerState extends State<HColorPicker> {
  Color _color = const Color(0x00000000);

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: HColorSelect(
                color: HSVColor.fromColor(widget.color),
                changed: (HSVColor color) {
                  setState(() {
                    _color = color.toColor();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: 260,
                child: SelectableText('HEX: 0x${_color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 260,
                child: SelectableText('ARGB: (${_color.alpha},${_color.red},${_color.green},${_color.blue})'),
              ),
            ),
            SizedBox(
              width: 260,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: HButton(
                      style: context.smallButton,
                      child: Text(S.of(context).cancelButtonLabel),
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  HButton(
                    style: context.smallButton.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop(_color);
                    },
                    child: Text(
                      S.of(context).okButtonLabel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HColorButton extends StatelessWidget {
  final HColorButtonStyle? style;

  final Color? color;

  final ValueChanged<Color?>? onChanged;

  const HColorButton({
    Key? key,
    required this.style,
    this.color,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? HColorButtonTheme.of(context).defaultColorButton;
    return SizedBox(
      width: style.width,
      height: style.height,
      child: DecoratedBox(
        decoration: style.decoration,
        child: Padding(
          padding: EdgeInsets.all(style.padding),
          child: HColorBox(
            color: HSVColor.fromColor(color ?? const Color(0x00000000)),
            borderRadius: style.borderRadius,
            border: style.border,
            child: Material(
              color: const Color(0x00000000),
              child: InkWell(
                onTap: () async {
                  var value = await showHColorPicker(context, color: color ?? const Color(0xffffffff));
                  onChanged?.call(value);
                },
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: style.iconSize,
                  color: HSLColor.fromColor(color ?? const Color(0x00000000)).lightness > 0.5 ? const Color(0xff666666) : const Color(0xffffffff),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HColorButtonStyle {
  final double width;

  final double height;

  final BoxDecoration decoration;

  final double padding;

  final double iconSize;

  final BoxBorder? border;

  final BorderRadius? borderRadius;

  const HColorButtonStyle({
    this.width = 40,
    this.height = 40,
    this.decoration = const BoxDecoration(
      border: Border.fromBorderSide(BorderSide(color: Color(0xffe6e6e6))),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    this.border = const Border.fromBorderSide(BorderSide(color: Color(0xff999999), width: 1)),
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.padding = 4,
    this.iconSize = 18,
  });

  HColorButtonStyle copyWith({
    double? width,
    double? height,
    BoxDecoration? decoration,
    double? padding,
    double? iconSize,
    BoxBorder? border,
    BorderRadius? borderRadius,
  }) {
    return HColorButtonStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  HColorButtonStyle copyFill({
    BoxBorder? border,
    BorderRadius? borderRadius,
  }) {
    return HColorButtonStyle(
      width: width,
      height: height,
      decoration: decoration,
      padding: padding,
      iconSize: iconSize,
      border: this.border ?? border,
      borderRadius: this.borderRadius ?? borderRadius,
    );
  }

  HColorButtonStyle merge(HColorButtonStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      width: other.width,
      height: other.height,
      decoration: other.decoration,
      padding: other.padding,
      iconSize: other.iconSize,
      border: other.border,
      borderRadius: other.borderRadius,
    );
  }
}

class HColorButtonTheme extends InheritedTheme {
  const HColorButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HColorButtonThemeData data;

  static HColorButtonThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HColorButtonTheme>();
    return theme?.data ?? HTheme.of(context).colorButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HColorButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HColorButtonTheme oldWidget) => data != oldWidget.data;
}

extension HColorButtonContext on BuildContext {
  HColorButtonStyle get defaultColorButton => HColorButtonTheme.of(this).defaultColorButton;

  HColorButtonStyle get mediumColorButton => HColorButtonTheme.of(this).mediumColorButton;

  HColorButtonStyle get smallColorButton => HColorButtonTheme.of(this).smallColorButton;

  HColorButtonStyle get miniColorButton => HColorButtonTheme.of(this).miniColorButton;
}

class HColorButtonThemeData {
  final HColorButtonStyle defaultColorButton;

  final HColorButtonStyle mediumColorButton;

  final HColorButtonStyle smallColorButton;

  final HColorButtonStyle miniColorButton;

  const HColorButtonThemeData({
    this.defaultColorButton = const HColorButtonStyle(),
    this.mediumColorButton = const HColorButtonStyle(width: 36, height: 36),
    this.smallColorButton = const HColorButtonStyle(width: 32, height: 32),
    this.miniColorButton = const HColorButtonStyle(width: 28, height: 28),
  });

  HColorButtonThemeData copyWith({
    HColorButtonStyle? defaultColorButton,
    HColorButtonStyle? mediumColorButton,
    HColorButtonStyle? smallColorButton,
    HColorButtonStyle? miniColorButton,
  }) {
    return HColorButtonThemeData(
      defaultColorButton: defaultColorButton ?? this.defaultColorButton,
      mediumColorButton: mediumColorButton ?? this.mediumColorButton,
      smallColorButton: smallColorButton ?? this.smallColorButton,
      miniColorButton: miniColorButton ?? this.miniColorButton,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HColorButtonThemeData &&
          runtimeType == other.runtimeType &&
          defaultColorButton == other.defaultColorButton &&
          mediumColorButton == other.mediumColorButton &&
          smallColorButton == other.smallColorButton &&
          miniColorButton == other.miniColorButton;

  @override
  int get hashCode => defaultColorButton.hashCode ^ mediumColorButton.hashCode ^ smallColorButton.hashCode ^ miniColorButton.hashCode;
}
