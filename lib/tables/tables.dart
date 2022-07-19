// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef HeaderBuilder = TablesCell Function(BuildContext context);
typedef CellBuilder<T> = TablesCell Function(BuildContext context, int x, int y, T data);
typedef RowBuilder<T> = TablesRow<T> Function(BuildContext context, int y);

enum HorizontalLean {
  left,
  right,
}

enum VerticalLean {
  top,
  bottom,
}

enum CellTablesLean {
  left,
  right,
  top,
  bottom,
  leftTop,
  rightTop,
  leftBottom,
  rightBottom,
}

class TablesCell {
  final Color? color;
  final Widget child;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Key? key;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  const TablesCell({
    this.key,
    this.color,
    required this.child,
    this.border,
    this.padding,
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });
}

class _TablesCellRenderWidget extends SingleChildRenderObjectWidget {
  final Color? color;
  final Widget child;
  final Border? border;
  final int x;
  final int y;
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;
  final CellTablesLean? lean;

  const _TablesCellRenderWidget({
    Key? key,
    this.color,
    required this.x,
    required this.y,
    required this.child,
    this.border,
    this.lean,
    this.widthFactor,
    this.heightFactor,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  _RenderTablesCell createRenderObject(BuildContext context) {
    return _RenderTablesCell(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      textDirection: Directionality.maybeOf(context),
      y: y,
      border: border,
      x: x,
      color: color,
      lean: lean,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderTablesCell renderObject) {
    renderObject
      ..x = x
      ..y = y
      ..color = color
      ..lean = lean
      ..border = border
      ..alignment = alignment
      ..widthFactor = widthFactor
      ..heightFactor = heightFactor
      ..textDirection = Directionality.maybeOf(context);
  }
}

class _RenderTablesCell extends RenderPositionedBox {
  _RenderTablesCell({
    required int x,
    required int y,
    required CellTablesLean? lean,
    Color? color,
    Border? border,
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
    TextDirection? textDirection,
  }) : super(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          textDirection: textDirection,
          alignment: alignment,
        ) {
    _x = x;
    _y = y;
    _color = color;
    _border = border;
    _lean = lean;
  }

  CellTablesLean? get lean => _lean;
  CellTablesLean? _lean;

  set lean(CellTablesLean? value) {
    if (value != _lean) {
      _lean = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  Color? get color => _color;
  Color? _color;

  set color(Color? value) {
    if (value != _color) {
      _color = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  int get x => _x;
  int _x = 0;

  set x(int value) {
    if (value != _x) {
      _x = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  int get y => _y;
  int _y = 0;

  set y(int value) {
    if (value != _y) {
      _y = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  Border? get border => _border;
  Border? _border;

  set border(Border? value) {
    if (value != _border) {
      _border = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool shrinkWrapWidth = widthFactor != null || constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight = heightFactor != null || constraints.maxHeight == double.infinity;

    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
      size = constraints.constrain(Size(
        shrinkWrapWidth ? child!.size.width * (widthFactor ?? 1.0) : double.infinity,
        shrinkWrapHeight ? child!.size.height * (heightFactor ?? 1.0) : double.infinity,
      ));
      alignChild();
    } else {
      size = constraints.constrain(Size(
        shrinkWrapWidth ? 0.0 : double.infinity,
        shrinkWrapHeight ? 0.0 : double.infinity,
      ));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    if (null != _color) {
      context.canvas.drawRect(rect, Paint()..color = _color!);
    }

    super.paint(context, offset);
    if (null != _border) {
      rect = Rect.fromLTRB(
        rect.left - _border!.left.width / 2,
        rect.top - _border!.top.width / 2,
        rect.right + _border!.right.width / 2,
        rect.bottom + _border!.bottom.width / 2,
      );
      _border!.paint(context.canvas, rect);
    }
  }
}

class TablesRow<T> {
  final Color? color;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final T data;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;
  final VerticalLean? lean;

  TablesRow({
    this.color,
    this.border,
    this.padding,
    required this.data,
    this.widthFactor,
    this.heightFactor,
    this.alignment,
    this.lean,
  });
}

class TablesColumn<T> {
  final HorizontalLean? lean;
  final HeaderBuilder headerBuilder;
  final CellBuilder<T> cellBuilder;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final ColumnWidth width;
  final Color? color;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  TablesColumn({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
    required this.headerBuilder,
    required this.cellBuilder,
    this.lean,
    this.border,
    this.padding,
    this.color,
    this.width = const ColumnWidth(),
  });
}

class _TablesView<T> extends RenderObjectWidget {
  final double headerHeight;
  final Color? headerColor;
  final double rowHeight;
  final List<TablesColumn<T>> columns;
  final Border? border;
  final RowBuilder<T> rowBuilder;
  final EdgeInsetsGeometry? padding;
  final int rowCount;
  final Color color;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final ViewportOffset xOffset;
  final ViewportOffset yOffset;
  final VerticalLean? headerLean;

  const _TablesView({
    Key? key,
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
    this.headerLean,
    this.color = const Color(0xffffffff),
    this.clipBehavior = Clip.none,
    required this.xOffset,
    required this.yOffset,
  }) : super(key: key);

  @override
  TablesElement createElement() => TablesElement<T>(this);

  @override
  RenderTables createRenderObject(BuildContext context) {
    return RenderTables(
      clipBehavior: clipBehavior,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
      rowCount: rowCount,
      color: color,
      xOffset: xOffset,
      yOffset: yOffset,
      widths: columns.map((e) => _RanderColumnWidth(width: e.width, lean: e.lean)).toList(),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTables renderObject) {
    renderObject
      ..clipBehavior = clipBehavior
      ..headerHeight = headerHeight
      ..rowHeight = rowHeight
      .._rowCount = rowCount
      ..color = color
      ..xOffset = xOffset
      ..yOffset = yOffset
      ..widths = columns.map((e) => _RanderColumnWidth(width: e.width, lean: e.lean)).toList();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

class TablesElement<T> extends RenderObjectElement {
  final List<_TablesCellRenderWidget> _widgetList = [];

  TablesElement(_TablesView<T> widget) : super(widget);

  @override
  RenderTables get renderObject {
    return super.renderObject as RenderTables;
  }

  @override
  _TablesView<T> get widget => super.widget as _TablesView<T>;

  @protected
  @visibleForTesting
  Iterable<Element> get children => _children.where((Element child) => !_forgottenChildren.contains(child));

  late List<Element> _children;

  final Set<Element> _forgottenChildren = HashSet<Element>();

  @override
  void insertRenderObjectChild(RenderObject child, IndexedSlot<Element?> slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child, after: slot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, IndexedSlot<Element?> oldSlot, IndexedSlot<Element?> newSlot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.move(child, after: newSlot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.remove(child);
    assert(renderObject == this.renderObject);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    for (final Element child in _children) {
      if (!_forgottenChildren.contains(child)) visitor(child);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(_children.contains(child));
    assert(!_forgottenChildren.contains(child));
    _forgottenChildren.add(child);
    super.forgetChild(child);
  }

  bool _debugCheckHasAssociatedRenderObject(Element newChild) {
    assert(() {
      if (newChild.renderObject == null) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('The children of `TablesElement` must each has an associated render object.'),
              ErrorHint(
                'This typically means that the `${newChild.widget}` or its children\n'
                'are not a subtype of `RenderObjectWidget`.',
              ),
              newChild.describeElement('The following element does not have an associated render object'),
              DiagnosticsDebugCreator(DebugCreator(newChild)),
            ]),
          ),
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Element inflateWidget(Widget newWidget, Object? newSlot) {
    final Element newChild = super.inflateWidget(newWidget, newSlot);
    assert(_debugCheckHasAssociatedRenderObject(newChild));
    return newChild;
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject.updateCallback(_layout);
    _children = List<Element>.filled(0, _NullElement.instance);
  }

  @override
  void unmount() {
    renderObject.updateCallback(null);
    super.unmount();
  }

  @override
  void update(_TablesView newWidget) {
    super.update(newWidget);
    renderObject.updateCallback(_layout);
    assert(widget == newWidget);
    renderObject.markNeedsBuild();
  }

  @override
  void performRebuild() {
    renderObject.markNeedsBuild();
    super.performRebuild();
  }

  void _layout(Constraints constraints) {
    owner!.buildScope(this, () => layoutCallback(constraints));
  }

  void layoutCallback(Constraints constraints) {
    _widgetList.clear();
    for (var x = 0; x < widget.columns.length; x++) {
      var column = widget.columns[x];
      var cell = column.headerBuilder(this);

      var padding = cell.padding ?? column.padding ?? widget.padding;
      _widgetList.add(_TablesCellRenderWidget(
        x: x,
        y: -1,
        key: cell.key,
        lean: _getLean(column.lean, widget.headerLean),
        color: cell.color ?? column.color ?? widget.headerColor,
        alignment: cell.alignment ?? column.alignment ?? widget.alignment,
        widthFactor: cell.widthFactor ?? column.widthFactor ?? widget.widthFactor,
        heightFactor: cell.heightFactor ?? column.heightFactor ?? widget.heightFactor,
        border: cell.border ?? column.border ?? widget.border,
        child: null == padding ? cell.child : Padding(padding: padding, child: cell.child),
      ));
    }
    for (var y = 0; y < widget.rowCount; y++) {
      var row = widget.rowBuilder(this, y);
      for (var x = 0; x < widget.columns.length; x++) {
        var column = widget.columns[x];
        var cell = column.cellBuilder(this, x, y, row.data);

        var padding = cell.padding ?? column.padding ?? widget.padding;
        _widgetList.add(_TablesCellRenderWidget(
          x: x,
          y: y,
          key: cell.key,
          lean: _getLean(column.lean, row.lean),
          alignment: cell.alignment ?? column.alignment ?? row.alignment ?? widget.alignment,
          widthFactor: cell.widthFactor ?? column.widthFactor ?? row.widthFactor ?? widget.widthFactor,
          heightFactor: cell.heightFactor ?? column.heightFactor ?? row.heightFactor ?? widget.heightFactor,
          color: cell.color ?? column.color ?? row.color ?? widget.color,
          border: cell.border ?? column.border ?? widget.border,
          child: null == padding ? cell.child : Padding(padding: padding, child: cell.child),
        ));
      }
    }

    _widgetList.sort((a, b) {
      return (a.lean?.index ?? -1) - (b.lean?.index ?? -1);
    });
    assert(!debugChildrenHaveDuplicateKeys(widget, _widgetList));
    _children = updateChildren(_children, _widgetList, forgottenChildren: _forgottenChildren);
    _forgottenChildren.clear();
    renderObject.markNeedsBuild();
  }

  CellTablesLean? _getLean(HorizontalLean? horizontalLean, VerticalLean? verticalLean) {
    if (null == horizontalLean && null == verticalLean) {
      return null;
    } else if (null != horizontalLean && null == verticalLean) {
      switch (horizontalLean) {
        case HorizontalLean.left:
          return CellTablesLean.left;
        case HorizontalLean.right:
          return CellTablesLean.right;
      }
    } else if (null == horizontalLean && null != verticalLean) {
      switch (verticalLean) {
        case VerticalLean.top:
          return CellTablesLean.top;
        case VerticalLean.bottom:
          return CellTablesLean.bottom;
      }
    } else {
      switch (horizontalLean) {
        case HorizontalLean.left:
          switch (verticalLean) {
            case VerticalLean.top:
              return CellTablesLean.leftTop;
            case VerticalLean.bottom:
              return CellTablesLean.leftBottom;
          }
          break;
        case HorizontalLean.right:
          switch (verticalLean) {
            case VerticalLean.top:
              return CellTablesLean.rightTop;
            case VerticalLean.bottom:
              return CellTablesLean.rightBottom;
          }
          break;
      }
    }
    return null;
  }
}

class TablesParentData extends ContainerBoxParentData<RenderBox> {
  int x;

  int y;

  TablesParentData({
    required this.x,
    required this.y,
    required this.lean,
  });

  Offset scroll = Offset.zero;

  CellTablesLean? lean;

  @override
  Offset get offset {
    double x = 0;
    double y = 0;
    if (null != lean) {
      switch (lean) {
        case CellTablesLean.left:
        case CellTablesLean.right:
          y = scroll.dy;
          break;
        case CellTablesLean.top:
        case CellTablesLean.bottom:
          x = scroll.dx;
          break;
        case CellTablesLean.leftTop:
        case CellTablesLean.rightTop:
        case CellTablesLean.leftBottom:
        case CellTablesLean.rightBottom:
      }
    } else {
      y = scroll.dy;
      x = scroll.dx;
    }
    return super.offset + Offset(x, y);
  }
}

class RenderTables extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, TablesParentData>, RenderBoxContainerDefaultsMixin<RenderBox, TablesParentData> {
  RenderTables({
    required Clip clipBehavior,
    required double headerHeight,
    required double rowHeight,
    required int rowCount,
    required Color color,
    required ViewportOffset xOffset,
    required ViewportOffset yOffset,
    required List<_RanderColumnWidth> widths,
  })  : _widths = widths,
        _headerHeight = headerHeight,
        _rowHeight = rowHeight,
        _rowCount = rowCount,
        _color = color,
        _xOffset = xOffset,
        _yOffset = yOffset,
        _clipBehavior = clipBehavior;

  double get headerHeight => _headerHeight;
  double _headerHeight = 0;

  set headerHeight(double value) {
    if (value != _headerHeight) {
      _headerHeight = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  Color get color => _color;
  Color _color = const Color(0xffffffff);

  set color(Color value) {
    if (value != _color) {
      _color = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  ViewportOffset get xOffset => _xOffset;
  ViewportOffset _xOffset;

  set xOffset(ViewportOffset value) {
    assert(value != null);
    if (value == _xOffset) return;
    if (attached) _xOffset.removeListener(_hasScrolled);
    _xOffset = value;
    if (attached) _xOffset.addListener(_hasScrolled);
    markNeedsLayout();
  }

  ViewportOffset get yOffset => _yOffset;
  ViewportOffset _yOffset;

  set yOffset(ViewportOffset value) {
    assert(value != null);
    if (value == _yOffset) return;
    if (attached) _yOffset.removeListener(_hasScrolled);
    _yOffset = value;
    if (attached) _yOffset.addListener(_hasScrolled);
    markNeedsLayout();
  }

  void _hasScrolled() {
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  double get rowHeight => _rowHeight;
  double _rowHeight = 0;

  set rowHeight(double value) {
    if (value != _rowHeight) {
      _rowHeight = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  int get rowCount => _rowCount;
  int _rowCount = 0;

  set rowCount(int value) {
    if (value != _rowCount) {
      _rowCount = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;

  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  List<_RanderColumnWidth> get widths => _widths;
  List<_RanderColumnWidth> _widths = [];

  set widths(List<_RanderColumnWidth> value) {
    if (value != _widths) {
      _widths = value;
      _columnWidths = null;
      _columnOffset = null;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  double _totalWidth = 0;
  List<double>? _columnWidths;
  List<double>? _columnOffset;

  LayoutCallback<BoxConstraints>? _callback;

  void updateCallback(LayoutCallback<BoxConstraints>? value) {
    if (value == _callback) return;
    _callback = value;
    markNeedsLayout();
  }

  bool _needsBuild = true;

  void markNeedsBuild() {
    _needsBuild = true;
    markNeedsLayout();
  }

  Constraints? _previousConstraints;

  void rebuildIfNecessary() {
    assert(_callback != null);
    if (_needsBuild || constraints != _previousConstraints) {
      _previousConstraints = constraints;
      _needsBuild = false;
      invokeLayoutCallback(_callback!);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TablesParentData) {
      child.parentData = TablesParentData(
        x: (child as _RenderTablesCell).x,
        y: (child).y,
        lean: child.lean,
      );
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return constraints.maxHeight;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  double get _xViewportExtent {
    assert(hasSize);
    return size.height;
  }

  double get _xMinScrollExtent {
    assert(hasSize);
    return 0.0;
  }

  double get _xMaxScrollExtent {
    assert(hasSize);
    return max(0, _totalWidth - size.width);
  }

  double get _yViewportExtent {
    assert(hasSize);
    return size.height;
  }

  double get _yMinScrollExtent {
    assert(hasSize);
    return 0.0;
  }

  double get _yMaxScrollExtent {
    assert(hasSize);
    return max(0, (_headerHeight + _rowHeight * _rowCount) - size.height);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _xOffset.addListener(_hasScrolled);
    _yOffset.addListener(_hasScrolled);
  }

  @override
  void detach() {
    _xOffset.removeListener(_hasScrolled);
    _yOffset.removeListener(_hasScrolled);
    super.detach();
  }

  Offset get _offset => Offset(-_xOffset.pixels, -_yOffset.pixels);

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    RenderBox? child = firstChild;
    size = constraints.biggest;
    if (null == _columnWidths) {
      _performWidth();
    }
    rebuildIfNecessary();

    while (child != null) {
      final TablesParentData childParentData = child.parentData! as TablesParentData;
      final width = _columnWidths![childParentData.x];
      final height = -1 == childParentData.y ? _headerHeight : _rowHeight;
      child.layout(
        BoxConstraints(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height),
        parentUsesSize: true,
      );
      childParentData.offset = Offset(_columnOffset![childParentData.x], _headerHeight + height * childParentData.y);
      childParentData.scroll = _offset;
      child = childParentData.nextSibling;
    }

    xOffset.applyViewportDimension(_xViewportExtent);
    xOffset.applyContentDimensions(_xMinScrollExtent, _xMaxScrollExtent);

    yOffset.applyViewportDimension(_yViewportExtent);
    yOffset.applyContentDimensions(_yMinScrollExtent, _yMaxScrollExtent);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, { required Offset position }) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(offset & size, Paint()..color = color);
    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipRectLayer.layer,
    );
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer = LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  void _performWidth() {
    double total = 0;
    for (var item in _widths) {
      total += item.flex;
    }
    double flexWidth = size.width / total;

    List<double> cw = List.filled(_widths.length, -1);
    List<double> of = List.filled(_widths.length, -1);
    double tw = 0;
    int count = 0;
    for (var i = 0; i < _widths.length; i++) {
      var item = _widths[i];
      double width = item.flex * flexWidth;
      if (null != item.min && item.min! > width) {
        cw[i] = max(item.min!, width);
        tw += cw[i];
        count++;
      } else if (null != item.max && item.max! < width) {
        cw[i] = min(item.max!, width);
        tw += cw[i];
        count++;
      }
    }

    if (count < _widths.length) {
      flexWidth = (size.width - tw) / (_widths.length - count);
      for (var i = 0; i < cw.length; i++) {
        if (-1 == cw[i]) {
          cw[i] = flexWidth * _widths[i].flex;
        }
      }
    }
    double offset = 0;
    tw = 0;
    for (var i = 0; i < cw.length; i++) {
      tw += cw[i];
      of[i] = offset;
      offset += cw[i];
    }
    _totalWidth = tw;
    _columnWidths = cw;
    _columnOffset = of;
  }
}

class _NullWidget extends Widget {
  const _NullWidget();

  @override
  Element createElement() => throw UnimplementedError();
}

class _NullElement extends Element {
  _NullElement() : super(const _NullWidget());

  static _NullElement instance = _NullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  void performRebuild() => throw UnimplementedError();
}

class Tables<T> extends StatefulWidget {
  final double headerHeight;
  final Color? headerColor;
  final double rowHeight;
  final List<TablesColumn<T>> columns;
  final Border? border;
  final RowBuilder<T> rowBuilder;
  final EdgeInsetsGeometry? padding;
  final int rowCount;
  final Color color;
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final TablesController? controller;
  final VerticalLean? headerLean;

  const Tables({
    Key? key,
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
    this.color = const Color(0xffffffff),
    this.clipBehavior = Clip.none,
    this.controller,
    this.headerLean,
  }) : super(key: key);

  @override
  _TablesState<T> createState() => _TablesState<T>();
}

class _TablesState<T> extends State<Tables<T>> {
  ScrollController? _xController;
  ScrollController? _yController;

  @override
  void initState() {
    _xController = ScrollController();
    _yController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _yController,
      axisDirection: AxisDirection.down,
      viewportBuilder: (context, yOffset) {
        return Scrollable(
          controller: _xController,
          axisDirection: AxisDirection.right,
          viewportBuilder: (context, xOffset) {
            return _TablesView<T>(
              xOffset: xOffset,
              yOffset: yOffset,
              padding: widget.padding,
              border: widget.border,
              widthFactor: widget.widthFactor,
              heightFactor: widget.heightFactor,
              alignment: widget.alignment,
              headerColor: widget.headerColor,
              headerHeight: widget.headerHeight,
              rowHeight: widget.rowHeight,
              rowCount: widget.rowCount,
              columns: widget.columns,
              rowBuilder: widget.rowBuilder,
              clipBehavior: widget.clipBehavior,
              headerLean: widget.headerLean,
            );
          },
        );
      },
    );
  }
}

class TablesController extends ScrollController {}

class ColumnWidth {
  final double flex;
  final double? min;
  final double? max;

  const ColumnWidth({this.flex = 1, this.min, this.max});
}

class _RanderColumnWidth extends ColumnWidth {
  final HorizontalLean? lean;

  _RanderColumnWidth({
    required ColumnWidth width,
    required this.lean,
  }) : super(
          flex: width.flex,
          max: width.max,
          min: width.min,
        );
}
