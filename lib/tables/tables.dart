// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef HeaderBuilder = TablesCell Function(BuildContext context);
typedef CellBuilder<T> = TablesCell Function(BuildContext context, int x, int y, T data);
typedef RowBuilder<T> = TablesRow<T> Function(BuildContext context, int y);

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

  const _TablesCellRenderWidget({
    Key? key,
    this.color,
    required this.x,
    required this.y,
    required this.child,
    this.border,
    this.widthFactor,
    this.heightFactor,
    this.alignment = Alignment.center,
  }) : super(key: key);

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
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderTablesCell renderObject) {
    renderObject
      ..x = x
      ..y = y
      ..color = color
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
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  int get y => _y;
  int _y = 0;

  set y(int value) {
    if (value != _y) {
      _y = value;
      markNeedsPaint();
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

  TablesRow({
    this.color,
    this.border,
    this.padding,
    required this.data,
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });
}

class TablesColumn<T> {
  final bool isLock;
  final HeaderBuilder headerBuilder;
  final CellBuilder<T> cellBuilder;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final double width;
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
    this.isLock = false,
    this.border,
    this.padding,
    this.color,
    this.width = 160,
  });
}

class Tables<T> extends RenderObjectWidget {
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
    this.color,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  TablesElement createElement() => TablesElement<T>(this);

  @override
  RenderTables createRenderObject(BuildContext context) {
    return RenderTables(
      clipBehavior: clipBehavior,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
      columnWidths: columns.map((e) => e.width).toList(),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTables renderObject) {
    renderObject
      ..clipBehavior = clipBehavior
      ..headerHeight = headerHeight
      ..rowHeight = rowHeight
      ..columnWidths = columns.map((e) => e.width).toList();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

class TablesElement<T> extends RenderObjectElement {
  final List<Widget> _widgetList = [];

  TablesElement(Tables widget) : super(widget);

  @override
  RenderTables get renderObject {
    return super.renderObject as RenderTables;
  }

  @override
  Tables<T> get widget => super.widget as Tables<T>;

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
  void update(Tables newWidget) {
    super.update(newWidget);
    renderObject.updateCallback(_layout);
    assert(widget == newWidget);
    assert(!debugChildrenHaveDuplicateKeys(widget, _widgetList));
    _children = updateChildren(_children, _widgetList, forgottenChildren: _forgottenChildren);
    _forgottenChildren.clear();
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
          alignment: cell.alignment ?? column.alignment ?? row.alignment ?? widget.alignment,
          widthFactor: cell.widthFactor ?? column.widthFactor ?? row.widthFactor ?? widget.widthFactor,
          heightFactor: cell.heightFactor ?? column.heightFactor ?? row.heightFactor ?? widget.heightFactor,
          color: cell.color ?? column.color ?? row.color ?? widget.color,
          border: cell.border ?? column.border ?? widget.border,
          child: null == padding ? cell.child : Padding(padding: padding, child: cell.child),
        ));
      }
    }
    assert(!debugChildrenHaveDuplicateKeys(widget, _widgetList));
  }
}

class TablesParentData extends ContainerBoxParentData<RenderBox> {
  int x;

  int y;

  TablesParentData({required this.x, required this.y});
}

class RenderTables extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, TablesParentData>, RenderBoxContainerDefaultsMixin<RenderBox, TablesParentData> {
  RenderTables({
    required Clip clipBehavior,
    required List<double> columnWidths,
    required double headerHeight,
    required double rowHeight,
  })  : _columnWidths = columnWidths,
        _headerHeight = headerHeight,
        _rowHeight = rowHeight,
        _clipBehavior = clipBehavior;

  double get headerHeight => _headerHeight;
  double _headerHeight = 0;

  set headerHeight(double value) {
    if (value != _headerHeight) {
      _headerHeight = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  double get rowHeight => _rowHeight;
  double _rowHeight = 0;

  set rowHeight(double value) {
    if (value != _rowHeight) {
      _rowHeight = value;
      markNeedsPaint();
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

  List<double> get columnWidths => _columnWidths;
  List<double> _columnWidths = [];
  List<double> _columnOffset = [];

  set columnWidths(List<double> value) {
    if (value != _columnWidths) {
      _columnWidths = value;
      double width = 0;
      for (var item in _columnWidths) {
        _columnOffset.add(width);
        width += item;
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

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

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    rebuildIfNecessary();

    RenderBox? child = firstChild;
    size = constraints.smallest;

    while (child != null) {
      final TablesParentData childParentData = child.parentData! as TablesParentData;
      final width = columnWidths[childParentData.x];
      final height = -1 == childParentData.y ? _headerHeight : _rowHeight;
      child.layout(
        BoxConstraints(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height),
        parentUsesSize: true,
      );
      childParentData.offset = Offset(_columnOffset[childParentData.x], _headerHeight + height * childParentData.y);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (clipBehavior != Clip.none) {
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        defaultPaint,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      defaultPaint(context, offset);
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer = LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
