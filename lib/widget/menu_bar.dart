import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MenuBar extends MultiChildRenderObjectWidget {
  final Alignment alignment;
  final Widget? more;

  final PopupMenuPosition menuPosition;

  final Offset menuOffset;

  final EdgeInsetsGeometry menuPadding;

  final double? menuElevation;

  final BoxConstraints? menuConstraints;

  final ShapeBorder? menuShape;

  final Color? menuColor;

  MenuBar({
    this.menuPosition = PopupMenuPosition.over,
    this.menuShape,
    this.menuColor,
    this.menuPadding = const EdgeInsets.all(8.0),
    this.menuOffset = Offset.zero,
    this.menuElevation,
    this.menuConstraints,
    super.key,
    super.children,
    this.alignment = Alignment.centerRight,
    this.more,
  });

  @override
  _RenderMenuBar createRenderObject(BuildContext context) {
    return _RenderMenuBar(alignment: alignment);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuBar renderObject) {
    renderObject.alignment = alignment;
    super.updateRenderObject(context, renderObject);
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _MenuBarElement(this);
  }
}

class _MenuBarElement extends MultiChildRenderObjectElement {
  var _moreKey = GlobalKey();

  _MenuBarElement(super.widget);

  void addMore() {
    var more = widget.more ??
        InkWell(
          key: _moreKey,
          child: Icon(Icons.more_horiz),
          onTap: _onMore,
        );

    widget.children.add(more);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    addMore();
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant MultiChildRenderObjectWidget newWidget) {
    super.update(newWidget);
    addMore();
  }

  @override
  MenuBar get widget => super.widget as MenuBar;

  @override
  _RenderMenuBar get renderObject => super.renderObject as _RenderMenuBar;

  void _onMore() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(this);
    final RenderBox button = _moreKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(this).overlay!.context.findRenderObject()! as RenderBox;
    Offset? offset;
    switch (widget.menuPosition) {
      case PopupMenuPosition.over:
        offset = widget.menuOffset;
        break;
      case PopupMenuPosition.under:
        offset = Offset(0.0, button.size.height - (widget.menuPadding.vertical / 2)) + widget.menuOffset;
        break;
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset!, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    List<PopupMenuEntry> items = [];
    for (int i = renderObject.count; i < renderObject.childCount - 1; i++) {
      items.add(PopupMenuItem(child: widget.children[i]));
    }
    showMenu(
      context: this,
      elevation: widget.menuElevation ?? popupMenuTheme.elevation,
      items: items,
      position: position,
      shape: widget.menuShape ?? popupMenuTheme.shape,
      color: widget.menuColor ?? popupMenuTheme.color,
      constraints: widget.menuConstraints,
    );
  }
}

class _MenuBarParentData extends ContainerBoxParentData<RenderBox> {
  bool _isPaint = false;
}

class _RenderMenuBar extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _MenuBarParentData>, RenderBoxContainerDefaultsMixin<RenderBox, _MenuBarParentData> {
  _RenderMenuBar({
    required Alignment alignment,
  }) {
    _alignment = alignment;
  }

  Alignment _alignment = Alignment.centerRight;

  Alignment get alignment => _alignment;

  set alignment(Alignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MenuBarParentData) {
      child.parentData = _MenuBarParentData();
    }
  }

  int _count = 0;

  int get count => _count;

  @override
  void performResize() {
    size = super.constraints.biggest;
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    double width = 0;
    _count = 0;
    lastChild?.layout(BoxConstraints(maxHeight: size.height), parentUsesSize: true);

    while (child != null && child != lastChild) {
      final _MenuBarParentData childParentData = child.parentData! as _MenuBarParentData;
      child.layout(BoxConstraints(maxHeight: size.height), parentUsesSize: true);
      if (size.width < child.size.width + width) {
        childParentData._isPaint = false;
        break;
      }
      if (childCount > 1 && size.width < child.size.width + lastChild!.size.width + width) {
        childParentData._isPaint = false;
        break;
      }
      childParentData._isPaint = true;
      width += child.size.width;
      _count++;
      child = childParentData.nextSibling;
    }
    if (count < childCount - 1) {
      final _MenuBarParentData lastParentData = lastChild!.parentData! as _MenuBarParentData;
      lastParentData._isPaint = true;
      width += lastChild!.size.width;
    }

    double dx = (size.width - width) / 2;
    dx = (_alignment.x + 1) * dx;

    child = firstChild;
    while (child != null) {
      final _MenuBarParentData childParentData = child.parentData! as _MenuBarParentData;
      if (childParentData._isPaint) {
        double height = (size.height - child.size.height) / 2;
        childParentData.offset = Offset(dx, (_alignment.y + 1) * height);
        dx += child.size.width;
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _MenuBarParentData childParentData = child.parentData! as _MenuBarParentData;
      if (childParentData._isPaint) {
        context.paintChild(child, childParentData.offset + offset);
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _MenuBarParentData childParentData = child.parentData! as _MenuBarParentData;
      if (childParentData._isPaint) {
        final bool isHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - childParentData.offset);
            return child!.hitTest(result, position: transformed);
          },
        );
        if (isHit) {
          return true;
        }
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
