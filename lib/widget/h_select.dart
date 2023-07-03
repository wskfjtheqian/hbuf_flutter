import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_cascader.dart';

import 'h_menu.dart';

class HSelect<T> extends StatefulWidget {
  final HMenuStyle menuStyle;

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
    this.menuStyle = const HMenuStyle(),
    required this.toText,
  });

  @override
  State<HSelect<T>> createState() => _HSelectState<T>();
}

class _HSelectState<T> extends State<HSelect<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _colorTween = ColorTween(begin: const Color(0xffdcdfe6), end: const Color(0xff409eff)).animate(_controller);
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
    Widget? child;
    if (widget.value.isEmpty) {
      child = Text(
        S.of(context).selectHintLabel,
        style: const TextStyle(color: Color(0xff606266), fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (widget.limit == 1) {
      child = Text(
        widget.toText(context, widget.value.first),
        style: const TextStyle(color: Color(0xff606266), fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      child = Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (var item in widget.value)
            HTag(
              style: HTheme.of(context).tagTheme.miniTag,
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
      style: HLayoutStyle(
        // maxHeight: 30,
        minHeight: 28,
        sizes: {lg: 8},
        maxWidth: 100,
        border: HBorder.all(width: 1, color: _colorTween.value!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 6, right: 10),
                  child: child,
                ),
              ),
              Transform.rotate(
                angle: -pi * _controller.value + pi / 2,
                child: Icon(
                  Icons.chevron_right,
                  color: Color(0xff606266),
                  size: 20,
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
            style: widget.menuStyle,
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
