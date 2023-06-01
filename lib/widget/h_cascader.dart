import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef HCascaderItemBuilder<T> = List<HCascaderItem<T>> Function(BuildContext context);

typedef OnHCascaderChange<T> = void Function(Set<T> value);

class HCascader<T> extends StatefulWidget {
  final double minWidth;

  final double maxWidth;

  final HCascaderItemBuilder<T> builder;

  final Set<T> value;

  final OnHCascaderChange<T>? onChange;

  final int? limit;

  const HCascader({
    Key? key,
    required this.builder,
    required this.minWidth,
    required this.maxWidth,
    required this.value,
    required this.onChange,
    this.limit,
  }) : super(key: key);

  @override
  State<HCascader<T>> createState() => _HCascaderState<T>();
}

class _HCascaderState<T> extends State<HCascader<T>> {
  HCascaderItemBuilder<T>? _builder;

  final _scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(minWidth: widget.minWidth, maxWidth: widget.maxWidth),
      child: SingleChildScrollView(
        key: _scrollKey,
        child: _HConnect(
          minWidth: widget.minWidth,
          children: widget.builder(context),
        ),
      ),
    );

    if (null != _builder) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const VerticalDivider(width: 1),
          HCascader<T>(
            builder: _builder!,
            minWidth: widget.minWidth,
            maxWidth: widget.maxWidth,
            value: widget.value,
            onChange: widget.onChange,
            limit: widget.limit,
          ),
        ],
      );
    }
    return child;
  }

  void onTap(BuildContext context, T value, HCascaderItemBuilder<T>? builder) {
    setState(() {
      _builder = builder;
      if (widget.value.contains(value)) {
        widget.value.remove(value);
      } else {
        widget.value.add(value);
      }
    });
    widget.onChange?.call(widget.value);
    if (1 == widget.limit) {
      Navigator.of(context).pop();
    }
  }

  bool hashValue(T value) {
    return widget.value.contains(value);
  }
}

class HCascaderItem<T> extends StatelessWidget {
  final T value;

  final Widget child;

  final HCascaderStyle? style;

  final HCascaderItemBuilder<T>? builder;

  const HCascaderItem({
    Key? key,
    required this.value,
    required this.child,
    this.style,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? const HCascaderStyle();
    var column = context.findAncestorStateOfType<_HCascaderState<T>>();
    return InkWell(
      onTap: () {
        column?.onTap(context, value, builder);
      },
      child: SizedBox(
        height: 40,
        child: _HItem(
          children: [
            Checkbox(
              value: column?.hashValue(value),
              onChanged: (bool? v) {
                column?.onTap(context, value, builder);
              },
            ),
            child,
            const Icon(Icons.chevron_right_outlined),
          ],
        ),
      ),
    );
  }
}

class HCascaderStyle {
  final EdgeInsets padding;

  final double height;

  final TextStyle textStyle;

  const HCascaderStyle({
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.height = 42,
    this.textStyle = const TextStyle(color: Color(0xFF606266), fontSize: 14),
  });
}

class _HItem extends MultiChildRenderObjectWidget {
  _HItem({super.key, super.children = const <Widget>[]});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ItemRenderBox();
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ItemRenderBox renderObject) {}
}

class _ItemParentData extends ContainerBoxParentData<RenderBox> {}

class _ItemRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _ItemParentData>, RenderBoxContainerDefaultsMixin<RenderBox, _ItemParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ItemParentData) {
      child.parentData = _ItemParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    var children = getChildrenAsList();
    children[0].layout(const BoxConstraints(), parentUsesSize: true);
    var checkBoxSize = children[0].size;

    children[2].layout(const BoxConstraints(), parentUsesSize: true);
    var iconSize = children[2].size;

    children[1].layout(const BoxConstraints(), parentUsesSize: true);
    var labelSize = children[1].size;

    var width = checkBoxSize.width + labelSize.width + iconSize.width;
    var height = max(checkBoxSize.height, max(iconSize.height, labelSize.height));
    size = constraints.constrain(Size(width, height));

    (children[0].parentData as _ItemParentData).offset = Offset(0, (size.height - checkBoxSize.height) / 2);
    (children[1].parentData as _ItemParentData).offset = Offset(checkBoxSize.width, (size.height - labelSize.height) / 2);
    (children[2].parentData as _ItemParentData).offset = Offset(size.width - iconSize.width, (size.height - iconSize.height) / 2);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class _HConnect extends MultiChildRenderObjectWidget {
  final double minWidth;

  _HConnect({super.key, super.children = const <Widget>[], required this.minWidth});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ConnectRenderBox(minWidth: minWidth);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _ConnectRenderBox renderObject) {
    renderObject..minWidth = minWidth;
  }
}

class _ConnectParentData extends ContainerBoxParentData<RenderBox> {}

class _ConnectRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _ConnectParentData>, RenderBoxContainerDefaultsMixin<RenderBox, _ConnectParentData> {
  _ConnectRenderBox({required double minWidth}) {
    _minWidth = minWidth;
  }

  double _minWidth = 0;

  double get minWidth => _minWidth;

  set minWidth(double value) {
    if (_minWidth != value) {
      _minWidth = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ConnectParentData) {
      child.parentData = _ConnectParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    double width = 0;
    var child = firstChild;
    while (child != null) {
      final _ConnectParentData childParentData = child.parentData! as _ConnectParentData;
      child.layout(const BoxConstraints(), parentUsesSize: true);
      if (width < child.size.width) {
        width = child.size.width;
      }
      child = childParentData.nextSibling;
    }

    width = max(width, _minWidth);
    double dy = 0;
    child = firstChild;
    while (child != null) {
      final _ConnectParentData childParentData = child.parentData! as _ConnectParentData;
      child.layout(BoxConstraints(minWidth: width), parentUsesSize: true);
      childParentData.offset = Offset(0, dy);
      dy += child.size.height;
      child = childParentData.nextSibling;
    }

    size = constraints.constrain(Size(width, dy));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
