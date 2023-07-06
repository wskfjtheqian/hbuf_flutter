import 'package:flutter/material.dart';

import 'h_color.dart';
import 'h_size.dart';
import 'h_theme.dart';

typedef HTagTapCallback = Future<void> Function();

class HTag extends StatefulWidget {
  final Widget child;
  final HTagStyle? style;
  final HTagTapCallback? onTap;

  const HTag({
    Key? key,
    required this.child,
    this.style,
    this.onTap,
  }) : super(key: key);

  @override
  State<HTag> createState() => _HTagState();
}

class _HTagState extends State<HTag> {
  final MaterialStatesController _controller = MaterialStatesController();

  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       if(mounted){
         setState(() {});
       }
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
    var style = widget.style ?? HTagTheme.of(context).defaultTag;

    var textStyle = style.textStyle;
    if (style.plain && null != style.color) {
      textStyle = textStyle.copyWith(color: style.color?.resolve(_controller.value));
    } else if (null == textStyle.color) {
      textStyle = textStyle.copyWith(color: null != style.color ? context.whiteColor : context.textGeneralColor);
    }
    if (_controller.value.contains(MaterialState.disabled) && style.textStyle is MaterialStatePropertyAll) {
      textStyle = textStyle.copyWith(color: textStyle.color?[400]);
    }

    OutlinedBorder shape = style.shape;
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

    Color? color;
    if (style.plain) {
      color = style.color?.resolve(_controller.value)[100];
    } else {
      color = style.color?.resolve(_controller.value);
    }
    if (_controller.value.contains(MaterialState.disabled) && style.textStyle is MaterialStatePropertyAll) {
      color = color?[50];
    }

    Widget icon = InkWell(
      mouseCursor: mouseCursor,
      onTap: null == widget.onTap || _isWaiting ? null : () => onWaitingEvent(widget.onTap!),
      customBorder: const CircleBorder(),
      statesController: _controller,
      hoverColor: textStyle.color,
      child: Padding(
        padding: EdgeInsets.all((textStyle.fontSize ?? 0) / 4),
        child: const Icon(Icons.close),
      ),
    );

    child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: child),
        Padding(
          padding: EdgeInsets.only(left: (style.padding!.left+ style.padding!.right) / 2),
          child: icon,
        ),
      ],
    );

    if (null != style.padding) {
      child = Padding(
        padding: style.padding!,
        child: child,
      );
    }
    child = DefaultTextStyle(
      style: textStyle,
      child: IconTheme(
        data: IconThemeData(
          color: _controller.value.contains(MaterialState.hovered) ? color : textStyle.color,
          size: textStyle.fontSize,
        ),
        child: child,
      ),
    );

    child = Material(
      color: color,
      shadowColor: style.shadowColor,
      shape: shape,
      elevation: style.elevation,
      child: child,
    );

    if (null != style.margin) {
      child = Padding(
        padding: style.margin!,
        child: child,
      );
    }


    return HSize(
      style: HSizeStyle(
        minWidth: style.minWidth,
        minHeight: style.minHeight,
        maxWidth: style.maxWidth,
        maxHeight: style.maxHeight,
        sizes: style.sizes,
        count: style.count,
      ),
      child: child,
    );
  }

  Future<void> onWaitingEvent(HTagTapCallback callback) async {
    try {
      setState(() => _isWaiting = true);
      await callback();
    } finally {
      setState(() => _isWaiting = false);
    }
  }
}

class HTagStyle {
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final Map<double, int>? sizes;
  final int count;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? shadowColor;
  final double elevation;
  final OutlinedBorder shape;
  final TextStyle textStyle;
  final MaterialStateProperty<MouseCursor>? mouseCursor;
  final MaterialStateProperty<Color>? color;
  final bool plain;

  const HTagStyle({
    this.minWidth = 40,
    this.minHeight = 40,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    this.sizes,
    this.count = kHSizeCount,
    this.margin,
    this.padding = const EdgeInsets.all(8),
    this.color,
    this.shadowColor,
    this.elevation = 5,
    this.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
    this.plain = false,
    this.textStyle = const TextStyle(fontSize: 14),
    this.mouseCursor,
  });

  HTagStyle copyWith({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    Map<double, int>? sizes,
    int? count,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? shadowColor,
    double? elevation,
    OutlinedBorder? shape,
    TextStyle? textStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? color,
    bool? plain,
  }) {
    return HTagStyle(
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      sizes: sizes ?? this.sizes,
      count: count ?? this.count,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      textStyle: textStyle ?? this.textStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      color: color ?? this.color,
      plain: plain ?? this.plain,
    );
  }

  HTagStyle copyFill({
    Map<double, int>? sizes,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? shadowColor,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<Color>? color,
  }) {
    return HTagStyle(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      sizes: this.sizes ?? sizes,
      count: count,
      margin: this.margin ?? margin,
      padding: this.padding ?? padding,
      shadowColor: this.shadowColor ?? shadowColor,
      elevation: elevation,
      shape: shape,
      textStyle: textStyle,
      mouseCursor: this.mouseCursor ?? mouseCursor,
      color: this.color ?? color,
      plain: plain,
    );
  }

  HTagStyle merge(HTagStyle? other) {
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
      shadowColor: other.shadowColor,
      elevation: other.elevation,
      shape: other.shape,
      textStyle: other.textStyle,
      mouseCursor: other.mouseCursor,
      color: other.color,
      plain: other.plain,
    );
  }
}

class HTagTheme extends InheritedTheme {
  const HTagTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HTagThemeData data;

  static HTagThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HTagTheme>();
    return theme?.data ?? HTheme.of(context).tagTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HTagTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HTagTheme oldWidget) => data != oldWidget.data;
}

extension HTagContext on BuildContext {
  HTagStyle get defaultTag => HTagTheme.of(this).defaultTag;

  HTagStyle get mediumTag => HTagTheme.of(this).mediumTag;

  HTagStyle get smallTag => HTagTheme.of(this).smallTag;

  HTagStyle get miniTag => HTagTheme.of(this).miniTag;
}

class HTagThemeData {
  final HTagStyle defaultTag;

  final HTagStyle mediumTag;

  final HTagStyle smallTag;

  final HTagStyle miniTag;

  const HTagThemeData({
    this.defaultTag = const HTagStyle(minWidth: 86, minHeight: 32, textStyle: TextStyle(fontSize: 12), padding: EdgeInsets.all(4)),
    this.mediumTag = const HTagStyle(minWidth: 76, minHeight: 28, textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(4)),
    this.smallTag = const HTagStyle(minWidth: 72, minHeight: 24, textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(2)),
    this.miniTag = const HTagStyle(minWidth: 63, minHeight: 20, textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(1)),
  });

  HTagThemeData copyWith({
    HTagStyle? defaultTagStyle,
    HTagStyle? mediumTagStyle,
    HTagStyle? smallTagStyle,
    HTagStyle? miniTagStyle,
  }) {
    return HTagThemeData(
      defaultTag: defaultTagStyle ?? defaultTag,
      mediumTag: mediumTagStyle ?? mediumTag,
      smallTag: smallTagStyle ?? smallTag,
      miniTag: miniTagStyle ?? miniTag,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HTagThemeData &&
          runtimeType == other.runtimeType &&
          defaultTag == other.defaultTag &&
          mediumTag == other.mediumTag &&
          smallTag == other.smallTag &&
          miniTag == other.miniTag;

  @override
  int get hashCode => defaultTag.hashCode ^ mediumTag.hashCode ^ smallTag.hashCode ^ miniTag.hashCode;
}
