import 'package:flutter/material.dart';

import 'h_color.dart';
import 'h_text.dart';
import 'h_theme.dart';

class HLink extends StatefulWidget {
  final HLinkStyle? style;
  final Widget? child;

  const HLink({Key? key, this.style, this.child}) : super(key: key);

  @override
  State<HLink> createState() => _HLinkState();
}

class _HLinkState extends State<HLink> {
  final MaterialStatesController _controller = MaterialStatesController();

  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? context.defaultLink;
    Widget? child = widget.child;
    if (null != child && null != style.textStyle) {
      var textStyle = style.textStyle!.resolve(_controller.value);
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
    return InkWell(
      child: child,
    );
  }
}

class HLinkStyle {
  final MaterialStateProperty<TextStyle>? textStyle;

  const HLinkStyle({this.textStyle});

  HLinkStyle copyWith({
    MaterialStateProperty<TextStyle>? textStyle,
  }) {
    return HLinkStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HLinkStyle && runtimeType == other.runtimeType && textStyle == other.textStyle;

  @override
  int get hashCode => textStyle.hashCode;

  HLinkStyle copyFill({
    MaterialStateProperty<TextStyle>? textStyle,
  }) {
    return HLinkStyle(
      textStyle: this.textStyle ?? textStyle,
    );
  }
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
