import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'h_checkbox.dart';
import 'h_theme.dart';

typedef HCascaderItemBuilder<T> = List<HCascaderItem<T>> Function(BuildContext context);

typedef OnHCascaderChange<T> = void Function(Set<T> value);

class HCascader<T> extends StatefulWidget {
  final HCascaderItemBuilder<T> builder;

  final Set<T> value;

  final int? limit;

  final OnHCascaderChange<T>? onChange;

  final HCascaderStyle? style;

  const HCascader({
    Key? key,
    required this.builder,
    this.style,
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

  HCascaderStyle get style => widget.style ?? HTheme.of(context).cascaderStyle;

  @override
  Widget build(BuildContext context) {
    var style = this.style;
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(minWidth: style.minWidth, maxWidth: style.maxWidth),
      child: Padding(
        padding: style.padding,
        child: SingleChildScrollView(
          key: _scrollKey,
          child: _HConnect(
            minWidth: style.minWidth,
            children: widget.builder(context),
          ),
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
            style: style,
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
      if (null == widget.limit) {
        if (widget.value.contains(value)) {
          widget.value.remove(value);
        } else {
          widget.value.add(value);
        }
      } else if (1 < widget.limit!) {
        if (widget.value.contains(value)) {
          widget.value.remove(value);
        } else if (widget.limit! > widget.value.length) {
          widget.value.add(value);
        }
      } else {
        widget.value.clear();
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

class HCascaderStyle {
  final EdgeInsets padding;

  final double minWidth;

  final double maxWidth;

  final HCascaderItemStyle itemStyle;

  const HCascaderStyle({
    this.minWidth = 180,
    this.maxWidth = 260,
    this.itemStyle = const HCascaderItemStyle(),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  HCascaderStyle copyWith({
    EdgeInsets? padding,
    double? minWidth,
    double? maxWidth,
    HCascaderItemStyle? itemStyle,
  }) {
    return HCascaderStyle(
      padding: padding ?? this.padding,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      itemStyle: itemStyle ?? this.itemStyle,
    );
  }

  HCascaderStyle merge(HCascaderStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      padding: other.padding,
      minWidth: other.minWidth,
      maxWidth: other.maxWidth,
      itemStyle: other.itemStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HCascaderStyle &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          itemStyle == other.itemStyle;

  @override
  int get hashCode => padding.hashCode ^ minWidth.hashCode ^ maxWidth.hashCode ^ itemStyle.hashCode;
}

class HCascaderItem<T> extends StatelessWidget {
  final Widget child;

  const HCascaderItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class HCascaderText<T> extends HCascaderItem<T> {
  final T value;

  final HCascaderItemStyle? style;

  final HCascaderItemBuilder<T>? builder;

  const HCascaderText({
    super.key,
    required this.value,
    required super.child,
    this.style,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    var column = context.findAncestorStateOfType<_HCascaderState<T>>()!;
    var style = this.style ?? column.style.itemStyle;
    Widget child = this.child;
    var textStyle = style.checkBoxStyle.textStyle;
    if (null != textStyle) {
      if (column.hashValue(value) ?? false) {
        textStyle = textStyle.copyWith(color: style.checkBoxStyle.checkColor);
      }
      child = DefaultTextStyle(style: textStyle, child: child);
    }
    return InkWell(
      onTap: () {
        column.onTap(context, value, builder);
      },
      child: SizedBox(
        height: style.height,
        child: _HItem(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Checkbox(
                value: column?.hashValue(value),
                onChanged: (bool? value) {
                  column.onTap(context, this.value, builder);
                },
                tristate: style.checkBoxStyle.tristate,
                mouseCursor: style.checkBoxStyle.mouseCursor,
                activeColor: style.checkBoxStyle.activeColor,
                fillColor: style.checkBoxStyle.fillColor,
                checkColor: style.checkBoxStyle.checkColor,
                focusColor: style.checkBoxStyle.focusColor,
                hoverColor: style.checkBoxStyle.hoverColor,
                overlayColor: style.checkBoxStyle.overlayColor,
                splashRadius: style.checkBoxStyle.splashRadius,
                materialTapTargetSize: style.checkBoxStyle.materialTapTargetSize,
                visualDensity: style.checkBoxStyle.visualDensity,
                focusNode: style.checkBoxStyle.focusNode,
                autofocus: style.checkBoxStyle.autofocus,
                shape: style.checkBoxStyle.shape,
                side: style.checkBoxStyle.side,
                isError: style.checkBoxStyle.isError,
              ),
            ),
            child,
            if (null != builder)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.chevron_right_outlined,
                  color: textStyle?.color,
                  size: (textStyle?.fontSize ?? 1) * 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HCascaderItemStyle {
  final double height;

  final HCheckBoxStyle checkBoxStyle;

  const HCascaderItemStyle({
    this.height = 42,
    this.checkBoxStyle = const HCheckBoxStyle(
      side: BorderSide(color: Color(0x00000000)),
      fillColor: MaterialStatePropertyAll(Color(0x00000000)),
      checkColor: Color(0xff409eff),
      textStyle: TextStyle(color: Color(0xFF606266), fontSize: 14),
    ),
  });

  HCascaderItemStyle copyWith({
    double? height,
    HCheckBoxStyle? checkBoxStyle,
  }) {
    return HCascaderItemStyle(
      height: height ?? this.height,
      checkBoxStyle: checkBoxStyle ?? this.checkBoxStyle,
    );
  }

  HCascaderItemStyle merge(HCascaderItemStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      height: other.height,
      checkBoxStyle: other.checkBoxStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HCascaderItemStyle && runtimeType == other.runtimeType && height == other.height && checkBoxStyle == other.checkBoxStyle;

  @override
  int get hashCode => height.hashCode ^ checkBoxStyle.hashCode;
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
    Size iconSize = Size.zero;
    if (2 < children.length) {
      children[2].layout(const BoxConstraints(), parentUsesSize: true);
      iconSize = children[2].size;
    }

    children[1].layout(const BoxConstraints(), parentUsesSize: true);
    var labelSize = children[1].size;

    var width = checkBoxSize.width + labelSize.width + iconSize.width;
    var height = max(checkBoxSize.height, max(iconSize.height, labelSize.height));
    size = constraints.constrain(Size(width, height));

    (children[0].parentData as _ItemParentData).offset = Offset(0, (size.height - checkBoxSize.height) / 2);
    (children[1].parentData as _ItemParentData).offset = Offset(checkBoxSize.width, (size.height - labelSize.height) / 2);
    if (2 < children.length) {
      (children[2].parentData as _ItemParentData).offset = Offset(size.width - iconSize.width, (size.height - iconSize.height) / 2);
    }
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
