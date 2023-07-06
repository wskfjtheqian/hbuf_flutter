import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_cascader.dart';

import 'h_menu.dart';

class HSelect<T> extends StatefulWidget {
  final HSelectStyle? style;

  final HCascaderItemBuilder<T> builder;

  final Set<T> value;

  final OnHCascaderChange<T>? onChange;

  final int limit;

  final String Function(BuildContext context, T value) toText;

  const HSelect({
    super.key,
    required this.builder,
    required this.value,
    this.onChange,
    this.limit = 1,
    this.style,
    required this.toText,
  });

  @override
  State<HSelect<T>> createState() => _HSelectState<T>();
}

class _HSelectState<T> extends State<HSelect<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
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
    var style = widget.style ?? HSelectTheme.of(context).defaultSelect;
    Widget? child;
    if (widget.value.isEmpty) {
      child = Text(
        S.of(context).selectHintLabel,
        style: style.hintStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (widget.limit == 1) {
      child = Text(
        widget.toText(context, widget.value.first),
        style: style.textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      child = Wrap(
        spacing: style.spacing,
        runSpacing: style.runSpacing,
        children: [
          for (var item in widget.value)
            HTag(
              style: style.tagStyle,
              child: Text(widget.toText(context, item)),
              onTap: () async {
                setState(() {
                  widget.value.remove(item);
                });
              },
            ),
        ],
      );
    }

    return HLayout(
      style: HLayoutStyleTween(begin: style.layoutStyle, end: style.activateStyle).evaluate(_controller),
      child: InkWell(
        child: Padding(
          padding: style.padding,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: style.padding.copyWith(left: 0, top: 0, bottom: 0),
                  child: child,
                ),
              ),
              Transform.rotate(
                angle: -pi * _controller.value + pi / 2,
                child: Icon(
                  Icons.chevron_right,
                  color: style.iconColor,
                  size: style.iconSize,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          _controller.forward();
          await showHMenu<T>(
            context,
            builder: widget.builder,
            value: widget.value,
            limit: widget.limit,
            onChange: _onChange,
            style: style.menuStyle,
          );
          _controller.reverse();
        },
      ),
    );
  }

  void _onChange(Set<T> value) {
    widget.onChange?.call(value);
    setState(() {});
  }
}

class HSelectStyle {
  final HMenuStyle menuStyle;

  final TextStyle hintStyle;

  final TextStyle textStyle;

  final HLayoutStyle layoutStyle;

  final HLayoutStyle activateStyle;

  final EdgeInsets padding;

  final double spacing;

  final double runSpacing;

  final Color iconColor;

  final double iconSize;

  final HTagStyle tagStyle;

  const HSelectStyle({
    this.tagStyle = const HTagStyle(minWidth: 63, minHeight: 20, textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(1)),
    this.iconColor = const Color(0xff606266),
    this.iconSize = 20,
    this.spacing = 4,
    this.runSpacing = 4,
    this.padding = const EdgeInsets.all(6),
    this.menuStyle = const HMenuStyle(),
    this.hintStyle = const TextStyle(color: Color(0xff606266), fontSize: 13),
    this.textStyle = const TextStyle(color: Color(0xff606266), fontSize: 13),
    this.layoutStyle = const HLayoutStyle(
      minHeight: 28,
      maxWidth: 100,
      border: HBorder.symmetric(vertical: HBorderSide(width: 1, color: Color(0xffDCDFE6)), horizontal: HBorderSide(width: 1, color: Color(0xffDCDFE6))),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    this.activateStyle = const HLayoutStyle(
      minHeight: 28,
      maxWidth: 100,
      border: HBorder.symmetric(vertical: HBorderSide(width: 1, color: Color(0xff409eff)), horizontal: HBorderSide(width: 1, color: Color(0xff409eff))),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),

  });

  static lerp(HSelectStyle begin, HSelectStyle end, double t) {}
}

class HSelectTheme extends InheritedTheme {
  const HSelectTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HSelectThemeData data;

  static HSelectThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HSelectTheme>();
    return theme?.data ?? HTheme.of(context).selectTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HSelectTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HSelectTheme oldWidget) => data != oldWidget.data;
}

extension HSelectContext on BuildContext {
  HSelectStyle get defaultSelect => HSelectTheme.of(this).defaultSelect;
}

class HSelectThemeData {
  final HSelectStyle defaultSelect;

  const HSelectThemeData({
    this.defaultSelect = const HSelectStyle(),
  });
}
