import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

import 'h_size.dart';
import 'h_theme.dart';

class HButton extends StatefulWidget {
  final Widget child;
  final HButtonStyle? style;

  const HButton({
    Key? key,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  State<HButton> createState() => _HButtonState();
}

class _HButtonState extends State<HButton> {
  final MaterialStatesController _controller = MaterialStatesController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
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
    var style = widget.style ?? HButtonTheme.of(context);

    var textStyle = style.textStyle.resolve(_controller.value);
    if (style.plain && null != style.color) {
      textStyle = textStyle.copyWith(color: style.color?.resolve(_controller.value));
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
    child = InkWell(
      onTap: () {},
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
}

class HButtonTheme extends InheritedTheme {
  const HButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HButtonStyle data;

  static HButtonStyle of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HButtonTheme>();
    return theme?.data ?? HTheme.of(context).defaultButtonStyle;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HButtonTheme oldWidget) => data != oldWidget.data;
}

extension HButtonContext on BuildContext {
  HButtonStyle get defaultButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: textColor)),
    );
  }

  HButtonStyle get brandButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor)),
      color: MaterialStatePropertyAll(brandColor),
    );
  }

  HButtonStyle get successButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor)),
      color: MaterialStatePropertyAll(successColor),
    );
  }

  HButtonStyle get warningButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor)),
      color: MaterialStatePropertyAll(warningColor),
    );
  }

  HButtonStyle get dangerButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor)),
      color: MaterialStatePropertyAll(dangerColor),
    );
  }

  HButtonStyle get infoButton {
    return HButtonTheme.of(this).copyWith(
      textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor)),
      color: MaterialStatePropertyAll(infoColor),
    );
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
    this.textStyle = const MaterialStatePropertyAll(TextStyle(fontSize: 14, color: Colors.black87)),
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
    MaterialStateProperty<BorderRadius>? borderRadius,
    MaterialStateProperty<Color>? color,
    MaterialStateProperty<Color>? shadowColor,
    MaterialStateProperty<double>? elevation,
    MaterialStateProperty<OutlinedBorder>? shape,
    MaterialStateProperty<TextStyle>? textStyle,
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
      plain: plain ?? this.plain,
    );
  }
}
