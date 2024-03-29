import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnColorChanged = void Function(HSVColor color);

enum ColorSliderDirection {
  horizontal,
  vertical,
}

class ColorBox extends RenderObjectWidget {
  final HSVColor color;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  const ColorBox({
    super.key,
    required this.color,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
  });

  @override
  RenderObjectElement createElement() {
    return _ColorBoxElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ColorBoxRender(
      color: color,
      backBoxSize: backBoxSize,
      backBoxColor0: backBoxColor0,
      backBoxColor1: backBoxColor1,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ColorBoxRender renderObject) {
    renderObject
      ..color = color
      ..backBoxSize = backBoxSize
      ..backBoxColor1 = backBoxColor1
      ..backBoxColor0 = backBoxColor0;
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

class _ColorBoxElement extends RenderObjectElement {
  _ColorBoxElement(super.widget);
}

class _ColorBoxRender extends RenderProxyBox {
  _ColorBoxRender({required HSVColor color, required double backBoxSize, required Color backBoxColor0, required Color backBoxColor1}) {
    _color = color;
    backBoxSize = backBoxSize;
    backBoxColor0 = backBoxColor0;
    backBoxColor1 = backBoxColor1;
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
    markNeedsPaint();
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
    _paintBack(context.canvas, rect, _backBoxSize, _backBoxColor0, _backBoxColor1);
    context.canvas.drawRect(
      rect,
      Paint()
        ..color = _color.toColor()
        ..style = PaintingStyle.fill,
    );
  }
}

class ColorOpacitySlider extends RenderObjectWidget {
  final ColorSliderDirection direction;

  final HSVColor color;

  final HSVColor value;

  final OnColorChanged onChanged;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  const ColorOpacitySlider({
    super.key,
    required this.color,
    required this.value,
    required this.onChanged,
    this.direction = ColorSliderDirection.horizontal,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
  });

  @override
  RenderObjectElement createElement() {
    return _ColorOpacitySliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ColorOpacitySliderRender(
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
  void updateRenderObject(BuildContext context, covariant _ColorOpacitySliderRender renderObject) {
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
    properties.add(EnumProperty<ColorSliderDirection>('direction', direction));
    properties.add(DiagnosticsProperty<HSVColor>('color', color));
    properties.add(DiagnosticsProperty<HSVColor>('value', value));
    properties.add(DoubleProperty('backBoxSize', backBoxSize));
    properties.add(ColorProperty('backBoxColor0', backBoxColor0));
    properties.add(ColorProperty('backBoxColor1', backBoxColor1));
  }
}

class _ColorOpacitySliderElement extends RenderObjectElement {
  _ColorOpacitySliderElement(super.widget);

  @override
  ColorOpacitySlider get widget => super.widget as ColorOpacitySlider;

  @override
  _ColorOpacitySliderRender get renderObject => super.renderObject as _ColorOpacitySliderRender;

  @override
  void update(covariant ColorOpacitySlider newWidget) {
    if (widget.color != newWidget.color) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _ColorOpacitySliderRender extends RenderProxyBox {
  double _alignment = 0;

  late Gradient _gradient;

  _ColorOpacitySliderRender({
    required HSVColor color,
    required ColorSliderDirection direction,
    required HSVColor value,
    required OnColorChanged onChanged,
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

  late OnColorChanged _onChanged;

  set value(HSVColor value) {
    _alignment = value.alpha * 2 - 1;
    markNeedsPaint();
  }

  set onChanged(OnColorChanged value) {
    _onChanged = value;
  }

  late ColorSliderDirection _direction;

  set direction(ColorSliderDirection value) {
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
      begin: ColorSliderDirection.horizontal == _direction ? Alignment.centerLeft : Alignment.topCenter,
      end: ColorSliderDirection.horizontal == _direction ? Alignment.centerRight : Alignment.bottomCenter,
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
    var thumbRect = ColorSliderDirection.horizontal == _direction
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
      _alignment = ColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(_color.withAlpha((_alignment + 1) / 2));
      markNeedsPaint();
    } else if (event is PointerDownEvent) {
      _alignment = ColorSliderDirection.horizontal == _direction
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

class ColorLinearSlider extends RenderObjectWidget {
  final ColorSliderDirection direction;

  final HSVColor value;

  final OnColorChanged onChanged;

  const ColorLinearSlider({
    super.key,
    required this.value,
    this.direction = ColorSliderDirection.vertical,
    required this.onChanged,
  });

  @override
  RenderObjectElement createElement() {
    return _ColorLinearSliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ColorLinearSliderRender(
      direction: direction,
      onChanged: onChanged,
      value: value,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ColorLinearSliderRender renderObject) {
    renderObject.direction = direction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ColorSliderDirection>('direction', direction));
    properties.add(DiagnosticsProperty<HSVColor>('value', value));
  }
}

class _ColorLinearSliderElement extends RenderObjectElement {
  _ColorLinearSliderElement(super.widget);

  @override
  ColorLinearSlider get widget => super.widget as ColorLinearSlider;

  @override
  _ColorLinearSliderRender get renderObject => super.renderObject as _ColorLinearSliderRender;

  @override
  void update(covariant ColorLinearSlider newWidget) {
    if (widget.value != newWidget.value) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _ColorLinearSliderRender extends RenderProxyBox {
  late Gradient _gradient;

  double _alignment = 0;

  late OnColorChanged _onChanged;

  _ColorLinearSliderRender({
    required ColorSliderDirection direction,
    required OnColorChanged onChanged,
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

  late ColorSliderDirection _direction;

  set direction(ColorSliderDirection value) {
    _direction = value;
    createGradient();
    markNeedsPaint();
  }

  set onChanged(OnColorChanged value) {
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
      begin: ColorSliderDirection.horizontal == _direction ? Alignment.centerLeft : Alignment.topCenter,
      end: ColorSliderDirection.horizontal == _direction ? Alignment.centerRight : Alignment.bottomCenter,
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
    var thumbRect = ColorSliderDirection.horizontal == _direction
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
      _alignment = ColorSliderDirection.horizontal == _direction
          ? min(1, max(-1, event.localPosition.dx / (size.width / 2) - 1))
          : min(1, max(-1, event.localPosition.dy / (size.height / 2) - 1));

      _onChanged(HSVColor.fromAHSV(1.0, 360 * (1 - (_alignment + 1) / 2), 1.0, 1.0));
      markNeedsPaint();
    } else if (event is PointerDownEvent) {
      _alignment = ColorSliderDirection.horizontal == _direction
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

class ColorBrightSlider extends RenderObjectWidget {
  final HSVColor color;

  final HSVColor value;

  final OnColorChanged onChanged;

  const ColorBrightSlider({
    super.key,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  RenderObjectElement createElement() {
    return _ColorBrightSliderElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ColorBrightSliderRender(
      color: color,
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ColorBrightSliderRender renderObject) {
    renderObject
      ..onChanged = onChanged
      ..color = color;
  }
}

class _ColorBrightSliderElement extends RenderObjectElement {
  _ColorBrightSliderElement(super.widget);

  @override
  ColorBrightSlider get widget => super.widget as ColorBrightSlider;

  @override
  _ColorBrightSliderRender get renderObject => super.renderObject as _ColorBrightSliderRender;

  @override
  void update(covariant ColorBrightSlider newWidget) {
    if (widget.value != newWidget.value) {
      renderObject.value = newWidget.value;
    }
    super.update(newWidget);
  }
}

class _ColorBrightSliderRender extends RenderProxyBox {
  late Gradient _colorGradient;

  late Gradient _brightGradient;

  late HSVColor _color;

  late Alignment _alignment;

  late OnColorChanged _onChanged;

  _ColorBrightSliderRender({
    required HSVColor color,
    required OnColorChanged onChanged,
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

  set onChanged(OnColorChanged value) {
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

class ColorSelect extends StatefulWidget {
  final HSVColor color;

  final double spacing;

  final OnColorChanged changed;

  final double backBoxSize;

  final Color backBoxColor0;

  final Color backBoxColor1;

  const ColorSelect({
    Key? key,
    required this.color,
    this.spacing = 12,
    required this.changed,
    this.backBoxSize = 6,
    this.backBoxColor0 = Colors.grey,
    this.backBoxColor1 = Colors.white,
  }) : super(key: key);

  @override
  _ColorSelectState createState() => _ColorSelectState();

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

class _ColorSelectState extends State<ColorSelect> {
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
                child: ColorBrightSlider(
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
                  width: 26,
                  child: ColorLinearSlider(
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
            height: 26,
            child: Row(
              children: [
                Expanded(
                  child: ColorOpacitySlider(
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
                    width: 26,
                    height: 26,
                    child: ColorBox(
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
Future<Color> showSelectColorPicker(BuildContext context, {required Color color}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: SelectColorPicker(color: color),
      );
    },
  );
}

class SelectColorPicker extends StatefulWidget {
  final Color color;

  const SelectColorPicker({Key? key, required this.color}) : super(key: key);

  @override
  _SelectColorPickerState createState() => _SelectColorPickerState();
}

class _SelectColorPickerState extends State<SelectColorPicker> {
  Color _color = Color(0);

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
              child: ColorSelect(
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
                    child: TextButton(
                      child: const Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_color);
                    },
                    child: const Text(
                      "确定",
                      style: TextStyle(color: Colors.white),
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
