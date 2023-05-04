import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HBadge extends SingleChildRenderObjectWidget {
  final Decoration decoration;
  final num value;
  final TextStyle? style;
  final EdgeInsets padding;
  final Alignment align;

  const HBadge({
    super.key,
    super.child,
    required this.decoration,
    required this.value,
    this.style,
    this.align = Alignment.topRight,
    this.padding = const EdgeInsets.all(2),
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HBadgeRenderBox(
      decoration: decoration,
      value: value,
      padding: padding,
      align: align,
      locale: Localizations.maybeLocaleOf(context),
      textDirection: Directionality.of(context),
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _HBadgeRenderBox renderObject) {
    renderObject
      ..decoration = decoration
      ..value = value
      ..align = align
      ..padding = padding
      ..configuration = createLocalImageConfiguration(context);
  }
}

class _HBadgeRenderBox extends RenderProxyBox {
  _HBadgeRenderBox({
    required Decoration decoration,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderBox? child,
    required num value,
    Locale? locale,
    required TextDirection textDirection,
    required EdgeInsets padding,
    required Alignment align,
  })  : _decoration = decoration,
        _configuration = configuration,
        _value = value,
        _padding = padding,
        _align = align,
        _textPainter = TextPainter(
          text: TextSpan(text: value.toStringAsFixed(0), style: const TextStyle(fontSize: 12, color: Colors.white)),
          textAlign: TextAlign.center,
          textDirection: textDirection,
          locale: locale,
        ),
        super(child);

  BoxPainter? _painter;
  TextPainter _textPainter;

  num get value => _value;
  num _value;

  set value(num value) {
    if (value == _value) {
      return;
    }
    _value = value;
    _textPainter?.text = TextSpan(text: value.toStringAsFixed(0));
    markNeedsLayout();
  }

  Alignment get align => _align;
  Alignment _align;

  set align(Alignment value) {
    if (value == _align) {
      return;
    }
    markNeedsLayout();
  }

  EdgeInsets get padding => _padding;
  EdgeInsets _padding;

  set padding(EdgeInsets value) {
    if (value == _padding) {
      return;
    }
    markNeedsLayout();
  }

  Decoration get decoration => _decoration;
  Decoration _decoration;

  set decoration(Decoration value) {
    if (value == _decoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  ImageConfiguration get configuration => _configuration;
  ImageConfiguration _configuration;

  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    markNeedsPaint();
  }

  void dispose() {
    _textPainter.dispose();
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
    markNeedsPaint();
  }

  Size _badgeSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    if (0 < _value) {
      _textPainter.layout(maxWidth: double.infinity);
      _badgeSize = Size(
        _padding.left + _padding.right + _textPainter.width,
        _padding.bottom + _padding.top + _textPainter.height,
      );
      if (_badgeSize.width < _badgeSize.height) {
        _badgeSize = Size(_badgeSize.height, _badgeSize.height);
      }
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return _decoration.hitTest(size, position, textDirection: configuration.textDirection);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    offset = offset + Offset(size.width / 2 * (1 + _align.x) - _badgeSize.width / 2, size.height / 2 * (1 + _align.y) - _badgeSize.height / 2);
    if (0 < _value) {
      _painter ??= _decoration.createBoxPainter(markNeedsPaint);
      final ImageConfiguration filledConfiguration = configuration.copyWith(size: _badgeSize);
      int? debugSaveCount;
      assert(() {
        debugSaveCount = context.canvas.getSaveCount();
        return true;
      }());
      _painter!.paint(context.canvas, offset, filledConfiguration);
      assert(() {
        if (debugSaveCount != context.canvas.getSaveCount()) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('${_decoration.runtimeType} painter had mismatching save and restore calls.'),
            ErrorDescription(
              'Before painting the decoration, the canvas save count was $debugSaveCount. '
              'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
              'Every call to save() or saveLayer() must be matched by a call to restore().',
            ),
            DiagnosticsProperty<Decoration>('The decoration was', decoration, style: DiagnosticsTreeStyle.errorProperty),
            DiagnosticsProperty<BoxPainter>('The painter was', _painter, style: DiagnosticsTreeStyle.errorProperty),
          ]);
        }
        return true;
      }());
      if (decoration.isComplex) {
        context.setIsComplexHint();
      }

      _textPainter.paint(context.canvas, offset + Offset(_padding.left, _padding.top));
    }
  }
}

class HBadgeStyle {}
