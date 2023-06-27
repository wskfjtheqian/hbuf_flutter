import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_menu.dart';
import 'package:hbuf_flutter/widget/h_select.dart';

import 'h_cascader.dart';
import 'h_theme.dart';

class HPagination extends StatefulWidget {
  final HPaginationStyle? style;
  final int total;

  final int limit;

  final int offset;

  final void Function(int offset, int limit) onChange;

  final Set<int> pageNumber;

  @override
  _HPaginationState createState() => _HPaginationState();

  const HPagination({
    super.key,
    required this.total,
    required this.limit,
    required this.offset,
    required this.onChange,
    this.pageNumber = const {10, 20, 40, 80, 100},
    this.style,
  });
}

class _HPaginationState extends State<HPagination> {
  int _page = 1;

  late List<int> _pageNumber;

  late Set<int> _limit;

  @override
  void initState() {
    _limit = {widget.limit};
    _page = (widget.offset / widget.limit).ceil() + 1;
    _pageNumber = {...widget.pageNumber, widget.limit}.toList()..sort((a, b) => a.compareTo(b));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HPagination oldWidget) {
    _limit = {widget.limit};
    _page = (widget.offset / widget.limit).ceil() + 1;
    _pageNumber = {...widget.pageNumber, widget.limit}.toList()..sort((a, b) => a.compareTo(b));
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? HTheme.of(context).paginationTheme.defaultPagination;

    var children = <Widget>[];
    if (style.showButton) {
      int total = (widget.total / _limit.first).ceil();
      int temp = total < 6 ? total : 6;
      int start = _page - temp ~/ 2;
      start = start < 1 ? 1 : start;
      int end = start + temp;
      end = end < total ? end : total;
      start = end - temp;
      start = start < 1 ? 1 : start;

      for (int i = start; i <= end; i++) {
        if (i == _page) {
          children.add(Padding(
            padding: style.itemPadding,
            child: HButton(
              onTap: (context) async {},
              style: style.activeStyle,
              child: Text("$i"),
            ),
          ));
        } else if (start == i) {
          children.add(Padding(
            padding: style.itemPadding,
            child: HButton(
              onTap: (context) async => page = 1,
              style: style.buttonStyle,
              child: const Text("1"),
            ),
          ));
        } else if (end == i) {
          children.add(Padding(
            padding: style.itemPadding,
            child: HButton(
              onTap: (context) async => page = total,
              style: style.buttonStyle,
              child: Text("$total"),
            ),
          ));
        } else if ((start + 1 == i && i != 2) || end - 1 == i && i != total - 1) {
          children.add(Padding(
            padding: style.itemPadding,
            child: HButton(
              style: style.buttonStyle,
              child: const Icon(Icons.more_horiz, size: 18),
            ),
          ));
        } else {
          children.add(Padding(
            padding: style.itemPadding,
            child: HButton(
              style: style.buttonStyle,
              onTap: (context) async => page = i,
              child: Text("$i"),
            ),
          ));
        }
      }
    }

    return Row(
      children: <Widget>[
        if (style.showTotal)
          Padding(
            padding: style.itemPadding,
            child: Text(
              S.of(context).paginationTotalLabel(widget.total.toString()),
              style: style.textTotal,
            ),
          ),
        if (style.showMenu)
          Padding(
            padding: style.itemPadding,
            child: HSelect<int>(
              toText: (context, value) {
                return (S.of(context).paginationTotalLabel(value.toString()));
              },
              builder: (BuildContext context) {
                return [
                  for (var number in _pageNumber)
                    HCascaderText<int>(
                      value: number,
                      child: Text(S.of(context).paginationTotalLabel(number.toString())),
                    )
                ];
              },
              value: _limit,
              onChange: (val) {
                setState(() {
                  _limit = val;
                });
                var value = val.first;
                int total = (widget.total / value).ceil();
                _page = max(1, min(total, _page));
                widget.onChange.call((_page - 1) * value, value);
              },
            ),
          ),
        ...children,
      ],
    );
  }

  set page(int val) {
    setState(() => _page = val);
    widget.onChange.call((_page - 1) * _limit.first, _limit.first);
  }
}

class HPaginationStyle {
  final HButtonStyle buttonStyle;

  final HButtonStyle activeStyle;

  final EdgeInsets itemPadding;

  final TextStyle textTotal;

  final bool showTotal;

  final bool showMenu;

  final bool showButton;

  const HPaginationStyle({
    this.buttonStyle = const HButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      minWidth: MaterialStatePropertyAll(28),
      minHeight: MaterialStatePropertyAll(28),
      padding: MaterialStatePropertyAll(EdgeInsets.all(4)),
      color: MaterialStatePropertyAll(Color(0xfff4f4f5)),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Color(0xff606266), fontSize: 13)),
    ),
    this.activeStyle = const HButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      minWidth: MaterialStatePropertyAll(28),
      minHeight: MaterialStatePropertyAll(28),
      padding: MaterialStatePropertyAll(EdgeInsets.all(4)),
      color: MaterialStatePropertyAll(Color(0xff409eff)),
      textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 13)),
    ),
    this.itemPadding = const EdgeInsets.only(right: 10),
    this.textTotal = const TextStyle(color: Color(0xff606266), fontSize: 13),
    this.showTotal = true,
    this.showMenu = true,
    this.showButton = true,
  });
}

class HPaginationTheme extends InheritedTheme {
  const HPaginationTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HPaginationThemeData data;

  static HPaginationThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HPaginationTheme>();
    return theme?.data ?? HTheme.of(context).paginationTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HPaginationTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HPaginationTheme oldWidget) => data != oldWidget.data;
}

extension HPaginationContext on BuildContext {
  HPaginationStyle get defaultPagination => HPaginationTheme.of(this).defaultPagination;
}

class HPaginationThemeData {
  final HPaginationStyle defaultPagination;

  const HPaginationThemeData({
    this.defaultPagination = const HPaginationStyle(),
  });
}
