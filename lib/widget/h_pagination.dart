import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/widget/h_menu.dart';

import 'h_cascader.dart';

class HPagination extends StatefulWidget {
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
  });
}

class _HPaginationState extends State<HPagination> {
  int _page = 1;

  late Set<int> _pageNumber;

  late int _limit;

  @override
  void initState() {
    _limit = widget.limit;
    _page = (widget.offset / widget.limit).ceil() + 1;
    _pageNumber = {...widget.pageNumber, widget.limit};
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HPagination oldWidget) {
    _limit = widget.limit;
    _page = (widget.offset / widget.limit).ceil() + 1;
    _pageNumber = {...widget.pageNumber, widget.limit};
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(S.of(context).paginationTotalLabel(widget.total.toString())),
        ),
        _buildPopupMenu(context),
        ..._buildButton(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        width: 105,
        height: 36,
        child: HMenuButton<int>(
          builder: (BuildContext context) {
            return [
              for (var number in _pageNumber)
                HCascaderText<int>(
                  value: number,
                  child: Text(S.of(context).paginationTotalLabel(number.toString())),
                )
            ];
          },
          value: {},
          child: const Text("data"),

          // value: _limit,
          // items: [
          //   for (var e in _pageNumber)
          //     DropdownMenuItem(
          //       value: e,
          //       child: Text(S.of(context).paginationTotalLabel(e.toString())),
          //     )
          // ],
          // onChanged: (val) {
          //   setState(() {
          //     _limit = val ?? 1;
          //   });
          //   int total = (widget.total / _limit).ceil();
          //   _page = max(1, min(total, _page));
          //   widget.onChange.call((_page - 1) * _limit, _limit);
          // },
          // decoration: const InputDecoration(
          //   isDense: true,
          // ),
        ),
      ),
    );
  }

  List<Widget> _buildButton(BuildContext context) {
    var children = <Widget>[];
    int total = (widget.total / _limit).ceil();
    int temp = total < 6 ? total : 6;
    int start = _page - temp ~/ 2;
    start = start < 1 ? 1 : start;
    int end = start + temp;
    end = end < total ? end : total;
    start = end - temp;
    start = start < 1 ? 1 : start;

    for (int i = start; i <= end; i++) {
      if (i == _page) {
        children.add(TextButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          child: Text("$i"),
        ));
      } else if (start == i) {
        children.add(TextButton(
          onPressed: () => page = 1,
          child: const Text("1"),
        ));
      } else if (end == i) {
        children.add(TextButton(
          onPressed: () => page = total,
          child: Text("$total"),
        ));
      } else if ((start + 1 == i && i != 2) || end - 1 == i && i != total - 1) {
        children.add(const TextButton(
          onPressed: null,
          child: Icon(Icons.more_horiz, size: 18),
        ));
      } else {
        children.add(TextButton(
          onPressed: () => page = i,
          child: Text("$i"),
        ));
      }
    }
    return children;
  }

  set page(int val) {
    setState(() => _page = val);
    widget.onChange.call((_page - 1) * _limit, _limit);
  }
}
