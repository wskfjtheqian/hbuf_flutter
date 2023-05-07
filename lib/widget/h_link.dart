import 'package:flutter/material.dart';

import 'h_color.dart';
import 'h_text.dart';
import 'h_theme.dart';

typedef HLinkTapCallback = Future<void> Function();
typedef HLinkLongPressCallback = Future<void> Function();

class HLink extends StatefulWidget {
  final HLinkStyle? style;
  final Widget? child;
  final HLinkTapCallback? onTap;
  final HLinkTapCallback? onDoubleTap;
  final HLinkLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;

  const HLink({
    Key? key,
    this.style,
    this.child,
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
  State<HLink> createState() => _HLinkState();
}

class _HLinkState extends State<HLink> {
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
    var style = widget.style ?? context.defaultLink;
    Widget? child = widget.child;
    if (null != child && null != style.textStyle) {
      var textStyle = style.textStyle!.resolve(_controller.value);
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

    return InkWell(
      statesController: _controller,
      mouseCursor: mouseCursor,
      onTap: null == widget.onTap || _isWaiting ? null : () => onWaitingEvent(widget.onTap!),
      onDoubleTap: null == widget.onDoubleTap || _isWaiting ? null : () => onWaitingEvent(widget.onDoubleTap!),
      onLongPress: null == widget.onLongPress || _isWaiting ? null : () => onWaitingEvent(widget.onLongPress!),
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      onHighlightChanged: widget.onHighlightChanged,
      onHover: widget.onHover,
      child: child,
    );
  }

  Future<void> onWaitingEvent(HLinkTapCallback callback) async {
    try {
      setState(() => _isWaiting = true);
      await callback();
    } finally {
      setState(() => _isWaiting = false);
    }
  }
}

class HLinkStyle {
  final MaterialStateProperty<TextStyle>? textStyle;
  final MaterialStateProperty<MouseCursor>? mouseCursor;

  const HLinkStyle({
    this.textStyle,
    this.mouseCursor,
  });

  HLinkStyle copyWith({
    MaterialStateProperty<TextStyle>? textStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
  }) {
    return HLinkStyle(
      textStyle: textStyle ?? this.textStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  HLinkStyle copyFill({
    MaterialStateProperty<TextStyle>? textStyle,
    MaterialStateProperty<MouseCursor>? mouseCursor,
  }) {
    return HLinkStyle(
      textStyle: this.textStyle ?? textStyle,
      mouseCursor: this.mouseCursor ?? mouseCursor,
    );
  }

  HLinkStyle merge(HLinkStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      textStyle: other.textStyle,
      mouseCursor: other.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HLinkStyle && runtimeType == other.runtimeType && textStyle == other.textStyle && mouseCursor == other.mouseCursor;

  @override
  int get hashCode => textStyle.hashCode ^ mouseCursor.hashCode;
}

class HLinkTheme extends InheritedTheme {
  const HLinkTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HLinkThemeData data;

  static HLinkThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HLinkTheme>();
    return theme?.data ?? HTheme.of(context).linkTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HLinkTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HLinkTheme oldWidget) => data != oldWidget.data;
}

extension HLinkContext on BuildContext {
  HLinkStyle get defaultLink {
    return HLinkTheme._of(this).defaultLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: textColor)));
  }

  HLinkStyle get brandLink {
    return HLinkTheme._of(this).brandLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: brandColor)));
  }

  HLinkStyle get successLink {
    return HLinkTheme._of(this).successLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: successColor)));
  }

  HLinkStyle get warningLink {
    return HLinkTheme._of(this).warningLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: warningColor)));
  }

  HLinkStyle get dangerLink {
    return HLinkTheme._of(this).dangerLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: dangerColor)));
  }

  HLinkStyle get infoLink {
    return HLinkTheme._of(this).infoLink.copyFill(textStyle: MaterialStatePropertyAll(bodyText.copyWith(color: infoColor)));
  }
}

class HLinkThemeData {
  final HLinkStyle defaultLink;

  final HLinkStyle brandLink;

  final HLinkStyle successLink;

  final HLinkStyle warningLink;

  final HLinkStyle dangerLink;

  final HLinkStyle infoLink;

  const HLinkThemeData({
    this.defaultLink = const HLinkStyle(),
    this.brandLink = const HLinkStyle(),
    this.successLink = const HLinkStyle(),
    this.warningLink = const HLinkStyle(),
    this.dangerLink = const HLinkStyle(),
    this.infoLink = const HLinkStyle(),
  });

  HLinkThemeData copyWith({
    HLinkStyle? brandLink,
    HLinkStyle? successLink,
    HLinkStyle? warningLink,
    HLinkStyle? dangerLink,
    HLinkStyle? infoLink,
  }) {
    return HLinkThemeData(
      brandLink: brandLink ?? this.brandLink,
      successLink: successLink ?? this.successLink,
      warningLink: warningLink ?? this.warningLink,
      dangerLink: dangerLink ?? this.dangerLink,
      infoLink: infoLink ?? this.infoLink,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HLinkThemeData &&
          runtimeType == other.runtimeType &&
          brandLink == other.brandLink &&
          successLink == other.successLink &&
          warningLink == other.warningLink &&
          dangerLink == other.dangerLink &&
          infoLink == other.infoLink;

  @override
  int get hashCode => brandLink.hashCode ^ successLink.hashCode ^ warningLink.hashCode ^ dangerLink.hashCode ^ infoLink.hashCode;
}
