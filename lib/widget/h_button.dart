import 'package:flutter/material.dart';

import 'h_color.dart';
import 'h_size.dart';
import 'h_theme.dart';

typedef HButtonTapCallback = Future<void> Function();
typedef HButtonLongPressCallback = Future<void> Function();

class HButton extends StatefulWidget {
  final Widget child;
  final HButtonStyle? style;
  final HButtonTapCallback? onTap;
  final HButtonTapCallback? onDoubleTap;
  final HButtonLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;

  const HButton({
    Key? key,
    required this.child,
    this.style,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
  }) : super(key: key);

  @override
  State<HButton> createState() => _HButtonState();
}

class _HButtonState extends State<HButton> {
  final MaterialStatesController _controller = MaterialStatesController();

  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    var style = widget.style ?? HButtonTheme.of(context).defaultButton;

    var textStyle = style.textStyle.resolve(_controller.value);
    if (style.plain && null != style.color) {
      textStyle = textStyle.copyWith(color: style.color?.resolve(_controller.value));
    } else if (null == textStyle.color) {
      textStyle = textStyle.copyWith(color: null != style.color ? context.whiteColor : context.textGeneralColor);
    }
    if (_controller.value.contains(MaterialState.disabled) && style.textStyle is MaterialStatePropertyAll) {
      textStyle = textStyle.copyWith(color: textStyle.color?[400]);
    }
    child = DefaultTextStyle(
      style: textStyle,
      child: IconTheme(
        data: IconThemeData(
          color: textStyle.color,
          size: textStyle.fontSize,
        ),
        child: child,
      ),
    );

    if (null != style.padding) {
      child = Padding(
        padding: style.padding!.resolve(_controller.value),
        child: child,
      );
    }
    child = Center(
      widthFactor: 1,
      heightFactor: 1,
      child: child,
    );

    OutlinedBorder shape = style.shape.resolve(_controller.value);
    if (style.plain && (shape.side.width == 0 || shape.side.style == BorderStyle.none)) {
      shape = shape.copyWith(
        side: shape.side.copyWith(
          color: style.color?.resolve(_controller.value),
          width: 0.5,
          style: BorderStyle.solid,
        ),
      );
    }
    if (_controller.value.contains(MaterialState.disabled) && style.textStyle is MaterialStatePropertyAll) {
      shape = shape.copyWith(
        side: shape.side.copyWith(
          color: shape.side.color[50],
          width: 0.5,
          style: BorderStyle.solid,
        ),
      );
    }
    var mouseCursor = (style.mouseCursor ??
            MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return SystemMouseCursors.forbidden;
              }
              return SystemMouseCursors.click;
            }))
        .resolve(_controller.value);
    if (_isWaiting) {
      mouseCursor = SystemMouseCursors.wait;
    }

    child = InkWell(
      mouseCursor: mouseCursor,
      onTap: null == widget.onTap || _isWaiting ? null : () => onWaitingEvent(widget.onTap!),
      onDoubleTap: null == widget.onTap || _isWaiting ? null : () => onWaitingEvent(widget.onDoubleTap!),
      onLongPress: null == widget.onTap || _isWaiting ? null : () => onWaitingEvent(widget.onLongPress!),
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      onHighlightChanged: widget.onHighlightChanged,
      onHover: widget.onHover,
      customBorder: shape,
      statesController: _controller,
      child: child,
    );

    Color? color;
    if (style.plain) {
      color = style.color?.resolve(_controller.value)[100];
    } else {
      color = style.color?.resolve(_controller.value);
    }
    if (_controller.value.contains(MaterialState.disabled) && style.textStyle is MaterialStatePropertyAll) {
      color = color?[50];
    }
    child = Material(
      color: color,
      shadowColor: style.shadowColor?.resolve(_controller.value),
      shape: shape,
      elevation: style.elevation.resolve(_controller.value),
      child: child,
    );

    if (null != style.margin) {
      child = Padding(
        padding: style.margin!.resolve(_controller.value),
        child: child,
      );
    }

    return HSize(
      style: HSizeStyle(
        minWidth: style.minWidth.resolve(_controller.value),
        minHeight: style.minHeight.resolve(_controller.value),
        maxWidth: style.maxWidth.resolve(_controller.value),
        maxHeight: style.maxHeight.resolve(_controller.value),
        sizes: style.sizes?.resolve(_controller.value),
        count: style.count.resolve(_controller.value),
      ),
      child: child,
    );
  }

  Future<void> onWaitingEvent(HButtonTapCallback callback) async {
    try {
      setState(() => _isWaiting = true);
      await callback();
    } finally {
      setState(() => _isWaiting = false);
    }
  }
}

class HButtonStyle {
  final MaterialStateProperty<double> minWidth;
  final MaterialStateProperty<double> minHeight;
  final MaterialStateProperty<double> maxWidth;
  final MaterialStateProperty<double> maxHeight;
  final MaterialStateProperty<Map<double, int>>? sizes;
  final MaterialStateProperty<int> count;
  final MaterialStateProperty<EdgeInsets>? margin;
  final MaterialStateProperty<EdgeInsets>? padding;
  final MaterialStateProperty<Color>? color;
  final MaterialStateProperty<Color>? shadowColor;
  final MaterialStateProperty<double> elevation;
  final MaterialStateProperty<OutlinedBorder> shape;
  final MaterialStateProperty<TextStyle> textStyle;
  final MaterialStateProperty<MouseCursor>? mouseCursor;
  final bool plain;

  const HButtonStyle({
    this.minWidth = const MaterialStatePropertyAll(40),
    this.minHeight = const MaterialStatePropertyAll(40),
    this.maxWidth = const MaterialStatePropertyAll(double.infinity),
    this.maxHeight = const MaterialStatePropertyAll(double.infinity),
    this.sizes,
    this.count = const MaterialStatePropertyAll(kHSizeCount),
    this.margin,
    this.padding = const MaterialStatePropertyAll(EdgeInsets.all(8)),
    this.color,
    this.shadowColor,
    this.elevation = const MaterialStatePropertyAll(5),
    this.shape = const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
    this.plain = false,
    this.textStyle = const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
    this.mouseCursor,
  });

  HButtonStyle copyWith({
    MaterialStateProperty<double>? minWidth,
    MaterialStateProperty<double>? minHeight,
    MaterialStateProperty<double>? maxWidth,
    MaterialStateProperty<double>? maxHeight,
    MaterialStateProperty<Map<double, int>>? sizes,
    MaterialStateProperty<int>? count,
    MaterialStateProperty<EdgeInsets>? margin,
    MaterialStateProperty<EdgeInsets>? padding,
    MaterialStateProperty<Color>? color,
    MaterialStateProperty<Color>? shadowColor,
    MaterialStateProperty<double>? elevation,
    MaterialStateProperty<OutlinedBorder>? shape,
    MaterialStateProperty<TextStyle>? textStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    bool? plain,
  }) {
    return HButtonStyle(
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      sizes: sizes ?? this.sizes,
      count: count ?? this.count,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      color: color ?? this.color,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      textStyle: textStyle ?? this.textStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      plain: plain ?? this.plain,
    );
  }

  HButtonStyle copyFill({
    MaterialStateProperty<Map<double, int>>? sizes,
    MaterialStateProperty<EdgeInsets>? margin,
    MaterialStateProperty<EdgeInsets>? padding,
    MaterialStateProperty<Color>? color,
    MaterialStateProperty<Color>? shadowColor,
    MaterialStateProperty<MouseCursor>? mouseCursor,
  }) {
    return HButtonStyle(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      sizes: this.sizes ?? sizes,
      count: count,
      margin: this.margin ?? margin,
      padding: this.padding ?? padding,
      color: this.color ?? color,
      shadowColor: this.shadowColor ?? shadowColor,
      elevation: elevation,
      shape: shape,
      textStyle: textStyle,
      mouseCursor: this.mouseCursor ?? mouseCursor,
      plain: plain,
    );
  }

  HButtonStyle merge(HButtonStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      minWidth: other.minWidth,
      minHeight: other.minHeight,
      maxWidth: other.maxWidth,
      maxHeight: other.maxHeight,
      sizes: other.sizes,
      count: other.count,
      margin: other.margin,
      padding: other.padding,
      color: other.color,
      shadowColor: other.shadowColor,
      elevation: other.elevation,
      shape: other.shape,
      textStyle: other.textStyle,
      mouseCursor: other.mouseCursor,
      plain: other.plain,
    );
  }
}

class HButtonTheme extends InheritedTheme {
  const HButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HButtonThemeData data;

  static HButtonThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HButtonTheme>();
    return theme?.data ?? HTheme.of(context).buttonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HButtonTheme oldWidget) => data != oldWidget.data;
}

extension HButtonContext on BuildContext {
  HButtonStyle get defaultButton => HButtonTheme.of(this).defaultButton;

  HButtonStyle get mediumButton => HButtonTheme.of(this).mediumButton;

  HButtonStyle get smallButton => HButtonTheme.of(this).smallButton;

  HButtonStyle get miniButton => HButtonTheme.of(this).miniButton;
}

class HButtonThemeData {
  final HButtonStyle defaultButton;

  final HButtonStyle mediumButton;

  final HButtonStyle smallButton;

  final HButtonStyle miniButton;

  const HButtonThemeData({
    this.defaultButton = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(104),
        minHeight: MaterialStatePropertyAll(40),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(8))),
    this.mediumButton = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(98),
        minHeight: MaterialStatePropertyAll(36),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(8))),
    this.smallButton = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(80),
        minHeight: MaterialStatePropertyAll(32),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(4))),
    this.miniButton = const HButtonStyle(
        minWidth: MaterialStatePropertyAll(80),
        minHeight: MaterialStatePropertyAll(28),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
        padding: MaterialStatePropertyAll(EdgeInsets.all(2))),
  });

  HButtonThemeData copyWith({
    HButtonStyle? defaultButtonStyle,
    HButtonStyle? mediumButtonStyle,
    HButtonStyle? smallButtonStyle,
    HButtonStyle? miniButtonStyle,
  }) {
    return HButtonThemeData(
      defaultButton: defaultButtonStyle ?? this.defaultButton,
      mediumButton: mediumButtonStyle ?? this.mediumButton,
      smallButton: smallButtonStyle ?? this.smallButton,
      miniButton: miniButtonStyle ?? this.miniButton,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HButtonThemeData &&
          runtimeType == other.runtimeType &&
          defaultButton == other.defaultButton &&
          mediumButton == other.mediumButton &&
          smallButton == other.smallButton &&
          miniButton == other.miniButton;

  @override
  int get hashCode => defaultButton.hashCode ^ mediumButton.hashCode ^ smallButton.hashCode ^ miniButton.hashCode;
}
