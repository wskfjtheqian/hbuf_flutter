import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/tables/tables.dart';

class TablesBuild<T> {
  final double headerHeight;
  final Color? headerColor;
  final double rowHeight;
  final List<TablesColumn<T>> columns;
  final Border? border;
  final RowBuilder<T> rowBuilder;
  final EdgeInsetsGeometry? padding;
  final int rowCount;
  final Color? color;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final Key? key;

  TablesBuild({
    this.key,
    this.widthFactor,
    this.heightFactor,
    this.alignment = Alignment.center,
    this.headerColor,
    this.headerHeight = 50,
    this.rowHeight = 35,
    required this.rowCount,
    required this.columns,
    required this.rowBuilder,
    this.border,
    this.padding,
    this.color,
    this.clipBehavior = Clip.none,
  });

  Tables build(BuildContext context) {
    return Tables(
      key: key,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      headerColor: headerColor,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
      rowCount: rowCount,
      columns: columns,
      rowBuilder: rowBuilder,
      border: border,
      padding: padding,
      color: color,
      clipBehavior: clipBehavior,
    );
  }
}
