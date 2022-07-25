import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final int count;

  final int page;

  final int pageSize;

  final void Function(int page, int pageSize) onChange;

  final Set<int> pageNumber;

  @override
  _PaginationState createState() => _PaginationState();

  Pagination({
    required this.count,
    required this.page,
    required this.pageSize,
    required this.onChange,
    this.pageNumber = const {10, 20, 40, 80, 100},
  });
}

class _PaginationState extends State<Pagination> {
  late int _page;

  late int _pageSize;

  late TextEditingController _pageController;

  late Set<int> _pageNumber;

  @override
  void initState() {
    super.initState();
    _page = widget.page;
    _pageSize = widget.pageSize;
    _pageNumber = {widget.pageSize, ...widget.pageNumber};
    _pageController = TextEditingController(text: "$_page");
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 36,
      height: 36,
      padding: EdgeInsets.all(4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        children: <Widget>[
          Text("共 ${widget.count} 条  "),
          _buildPopupMenu(context),
          ..._buildButton(context),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Container(
      width: 105,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<int>(
        value: _pageSize,
        items: [
          for (var e in _pageNumber)
            DropdownMenuItem(
              value: e,
              child: Text("$e条/页"),
            )
        ],
        onChanged: (val) {
          setState(() {
            _pageSize = val ?? 1;
          });
          int total = (widget.count / _pageSize).ceil();
          _page = _page < total ? total : _page;
          _pageController.text = _page.toString();
          widget.onChange.call(_page, _pageSize);
        },
      ),
    );
  }

  List<Widget> _buildButton(BuildContext context) {
    var children = <Widget>[];
    int total = (widget.count / _pageSize).ceil();
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
          child: Text("$i"),
        ));
      } else if (start == i) {
        children.add(TextButton(
          child: Text("1"),
          onPressed: () => page = 1,
        ));
      } else if (end == i) {
        children.add(TextButton(
          child: Text("$total"),
          onPressed: () => page = total,
        ));
      } else if ((start + 1 == i && i != 2) || end - 1 == i && i != total - 1) {
        children.add(TextButton(
          onPressed: () {},
          child: Icon(Icons.more_horiz, size: 18),
        ));
      } else {
        children.add(TextButton(
          child: Text("$i"),
          onPressed: () => page = i,
        ));
      }
    }
    return children;
  }

  set page(int val) {
    setState(() => _page = val);
    widget.onChange.call(val, _pageSize);
    _pageController.text = val.toString();
  }
}
