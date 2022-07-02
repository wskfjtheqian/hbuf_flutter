import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/tables/tables.dart';

class TablesBuild<T> {
  double headerHeight = 50;
  Color? headerColor;
  double rowHeight = 35;
  List<TablesColumn<T>> columns = [];
  Border? border;
  RowBuilder<T>? rowBuilder;
  EdgeInsetsGeometry? padding;
  int rowCount = 0;
  Color? color;
  double? widthFactor;
  double? heightFactor;
  AlignmentGeometry alignment = Alignment.center;
  Clip clipBehavior = Clip.none;
  Key? key;

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
      rowBuilder: rowBuilder!,
      border: border,
      padding: padding,
      color: color,
      clipBehavior: clipBehavior,
    );
  }
}
