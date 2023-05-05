import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'h_theme.dart';

class HBadge extends SingleChildRenderObjectWidget {
  final num value;
  final num max;
  final HBadgeStyle? style;
  final Alignment align;

  const HBadge({
    super.key,
    super.child,
    required this.value,
    this.max = 100,
    this.style,
    this.align = Alignment.topRight,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    var style = this.style ?? HBadgeTheme.of(context).defaultBadge;
    return _HBadgeRenderBox(
      decoration: BoxDecoration(
        color: style.color,
        image: style.image,
        border: style.border,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
        gradient: style.gradient,
        backgroundBlendMode: style.backgroundBlendMode,
        shape: style.shape,
      ),
      value: value,
      padding: style.padding,
      align: align,
      max: max,
      style: style.style,
      isDot: style.isDot,
      locale: Localizations.maybeLocaleOf(context),
      textDirection: Directionality.of(context),
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _HBadgeRenderBox renderObject) {
    var style = this.style ?? HBadgeTheme.of(context).defaultBadge;
    renderObject
      ..decoration = BoxDecoration(
        color: style.color,
        image: style.image,
        border: style.border,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
        gradient: style.gradient,
        backgroundBlendMode: style.backgroundBlendMode,
        shape: style.shape,
      )
      ..value = value
      ..align = align
      ..padding = style.padding
      ..max = max
      ..style = style.style
      ..isDot = style.isDot
      ..configuration = createLocalImageConfiguration(context);
  }
}

class _HBadgeRenderBox extends RenderProxyBox {
  _HBadgeRenderBox({
    required Decoration decoration,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderBox? child,
    required num value,
    required num max,
    Locale? locale,
    required bool isDot,
    required TextDirection textDirection,
    required EdgeInsets padding,
    required Alignment align,
    TextStyle? style,
  })  : _decoration = decoration,
        _configuration = configuration,
        _value = value,
        _padding = padding,
        _align = align,
        _max = max,
        _style = style,
        _isDot = isDot,
        _textPainter = TextPainter(
          text: TextSpan(
            text: value < max ? value.toStringAsFixed(0) : (max - 1).toStringAsFixed(0),
            style: style,
          ),
          textAlign: TextAlign.center,
          textDirection: textDirection,
          locale: locale,
        ),
        super(child);

  BoxPainter? _painter;
  TextPainter _textPainter;

  bool get isDot => _isDot;
  bool _isDot;

  set isDot(bool isDot) {
    if (isDot == _isDot) {
      return;
    }
    _isDot = isDot;
    markNeedsLayout();
  }

  num get value => _value;
  num _value;

  set value(num value) {
    if (value == _value) {
      return;
    }
    _value = value;
    _textPainter.text = TextSpan(
      text: _value < _max ? value.toStringAsFixed(0) : (_max - 1).toStringAsFixed(0),
      style: _style,
    );
    markNeedsLayout();
  }

  TextStyle? get style => _style;
  TextStyle? _style;

  set style(TextStyle? style) {
    if (style == _style) {
      return;
    }
    _style = style;
    _textPainter.text = TextSpan(
      text: _value < _max ? _value.toStringAsFixed(0) : (_max - 1).toStringAsFixed(0),
      style: _style,
    );
    markNeedsLayout();
  }

  num get max => _max;
  num _max;

  set max(num max) {
    if (max == _max) {
      return;
    }
    _max = max;
    _textPainter.text = TextSpan(
      text: _value < _max ? _value.toStringAsFixed(0) : (_max - 1).toStringAsFixed(0),
      style: _style,
    );
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
    _padding = value;
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
      if (!_isDot) {
        _textPainter.layout(maxWidth: double.infinity);
        _badgeSize = Size(
          _padding.left + _padding.right + _textPainter.width,
          _padding.bottom + _padding.top + _textPainter.height,
        );
      } else {
        _badgeSize = Size(
          _padding.left + _padding.right,
          _padding.bottom + _padding.top,
        );
      }

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
      if (!_isDot) {
        _textPainter.paint(context.canvas, offset + Offset(_padding.left, _padding.top));
      }
    }
  }
}

class HBadgeStyle {
  final Color? color;
  final DecorationImage? image;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape shape;
  final TextStyle? style;
  final EdgeInsets padding;
  final bool isDot;

  const HBadgeStyle({
    this.color = Colors.red,
    this.image,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
    this.style = const TextStyle(fontSize: 10),
    this.padding = const EdgeInsets.all(3),
    this.isDot = false,
  });

  HBadgeStyle copyWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
    TextStyle? style,
    EdgeInsets? padding,
    bool? isDot,
  }) {
    return HBadgeStyle(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
      style: style ?? this.style,
      padding: padding ?? this.padding,
      isDot: isDot ?? this.isDot,
    );
  }

  HBadgeStyle copyFill({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    TextStyle? style,
  }) {
    return HBadgeStyle(
      color: this.color ?? color,
      image: this.image ?? image,
      border: this.border ?? border,
      borderRadius: this.borderRadius ?? borderRadius,
      boxShadow: this.boxShadow ?? boxShadow,
      gradient: this.gradient ?? gradient,
      backgroundBlendMode: this.backgroundBlendMode ?? backgroundBlendMode,
      shape: shape,
      style: this.style ?? style,
      padding: padding,
      isDot: isDot,
    );
  }

  HBadgeStyle merge(HBadgeStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      color: other.color,
      image: other.image,
      border: other.border,
      borderRadius: other.borderRadius,
      boxShadow: other.boxShadow,
      gradient: other.gradient,
      backgroundBlendMode: other.backgroundBlendMode,
      shape: other.shape,
      style: other.style,
      padding: other.padding,
      isDot: other.isDot,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HBadgeStyle &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          image == other.image &&
          border == other.border &&
          borderRadius == other.borderRadius &&
          boxShadow == other.boxShadow &&
          gradient == other.gradient &&
          backgroundBlendMode == other.backgroundBlendMode &&
          shape == other.shape &&
          style == other.style &&
          padding == other.padding &&
          isDot == other.isDot;

  @override
  int get hashCode =>
      color.hashCode ^
      image.hashCode ^
      border.hashCode ^
      borderRadius.hashCode ^
      boxShadow.hashCode ^
      gradient.hashCode ^
      backgroundBlendMode.hashCode ^
      shape.hashCode ^
      style.hashCode ^
      padding.hashCode ^
      isDot.hashCode;
}

class HBadgeTheme extends InheritedTheme {
  const HBadgeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HBadgeThemeData data;

  static HBadgeThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HBadgeTheme>();
    return theme?.data ?? HTheme.of(context).badgeTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HBadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HBadgeTheme oldWidget) => data != oldWidget.data;
}

extension HBadgeContext on BuildContext {
  HBadgeStyle get defaultBadge => HBadgeTheme.of(this).defaultBadge;

  HBadgeStyle get dotBadge => HBadgeTheme.of(this).dotBadge;
}

class HBadgeThemeData {
  final HBadgeStyle defaultBadge;
  final HBadgeStyle dotBadge;

  const HBadgeThemeData({
    this.defaultBadge = const HBadgeStyle(),
    this.dotBadge = const HBadgeStyle(
      isDot: true,
      padding: EdgeInsets.all(4),
    ),
  });
}
