import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kMenuHorizontalPadding = 8.0;

class MenuBarItem<T> extends PopupMenuEntry<T> {
  const MenuBarItem({
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
  })
      : assert(enabled != null),
        assert(height != null);

  final T? value;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  MenuBarItemState<T, MenuBarItem<T>> createState() => MenuBarItemState<T, MenuBarItem<T>>();
}

class MenuBarItemState<T, W extends MenuBarItem<T>> extends State<W> {
  Widget? buildChild() => widget.child;

  void handleTap() {
    widget.onTap?.call();
    if (null == context.findAncestorStateOfType<_MenuBarState>()) {
      Navigator.pop<T>(context, widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.subtitle1!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(widget.mouseCursor, popupMenuTheme.mouseCursor),
          child: item,
        ),
      ),
    );
  }
}

class _EffectiveMouseCursor extends MaterialStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final MaterialStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MaterialStateProperty.resolveAs<MouseCursor?>(widgetCursor, states) ??
        themeCursor?.resolve(states) ??
        MaterialStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => 'MaterialStateMouseCursor(MenuBarItemState)';
}

class MenuBar<T> extends StatefulWidget {
  final Alignment alignment;

  final Widget? more;

  final List<MenuBarItem<T>> children;

  final PopupMenuPosition menuPosition;

  final Offset menuOffset;

  final EdgeInsetsGeometry menuPadding;

  final double? menuElevation;

  final BoxConstraints? menuConstraints;

  final ShapeBorder? menuShape;

  final Color? menuColor;

  const MenuBar({
    super.key,
    this.menuPosition = PopupMenuPosition.over,
    this.menuShape,
    this.menuColor,
    this.menuPadding = const EdgeInsets.all(8.0),
    this.menuOffset = Offset.zero,
    this.menuElevation,
    this.menuConstraints,
    this.alignment = Alignment.centerRight,
    this.more,
    this.children = const [],
  });

  @override
  State<MenuBar<T>> createState() => _MenuBarState<T>();
}

class _MenuBarState<T> extends State<MenuBar<T>> {
  GlobalKey _moreKey = GlobalKey();

  GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _MenuBarRenderWidget(
      key: _menuKey,
      children: [
        ...widget.children,
        MenuBarItem(
          key: _moreKey,
          child: Icon(Icons.more_horiz),
          onTap: () => _onMore(context),
        )
      ],
      alignment: widget.alignment,
      more: widget.more,
      menuPosition: widget.menuPosition,
      menuOffset: widget.menuOffset,
      menuPadding: widget.menuPadding,
      menuElevation: widget.menuElevation,
      menuConstraints: widget.menuConstraints,
      menuShape: widget.menuShape,
      menuColor: widget.menuColor,
    );
  }

  void _onMore(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = _moreKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator
        .of(context)
        .overlay!
        .context
        .findRenderObject()! as RenderBox;
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
        button.localToGlobal(offset! + button.size.bottomRight(Offset.zero) , ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) +button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    List<PopupMenuEntry> items = [];
    for (int i = (_menuKey.currentContext as _MenuBarElement).showCount; i < widget.children.length; i++) {
      items.add(widget.children[i]);
    }
    showMenu(
      context: context,
      elevation: widget.menuElevation ?? popupMenuTheme.elevation,
      items: items,
      position: position,
      shape: widget.menuShape ?? popupMenuTheme.shape,
      color: widget.menuColor ?? popupMenuTheme.color,
      constraints: widget.menuConstraints,
    );
  }
}



class _MenuBarRenderWidget extends MultiChildRenderObjectWidget {
  final Alignment alignment;

  final Widget? more;

  final PopupMenuPosition menuPosition;

  final Offset menuOffset;

  final EdgeInsetsGeometry menuPadding;

  final double? menuElevation;

  final BoxConstraints? menuConstraints;

  final ShapeBorder? menuShape;

  final Color? menuColor;

  _MenuBarRenderWidget({
    super.key,
    this.menuPosition = PopupMenuPosition.over,
    this.menuShape,
    this.menuColor,
    this.menuPadding = const EdgeInsets.all(8.0),
    this.menuOffset = Offset.zero,
    this.menuElevation,
    this.menuConstraints,
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
  _MenuBarElement(super.widget);

  @override
  _RenderMenuBar get renderObject => super.renderObject as _RenderMenuBar;

  int get showCount => renderObject.count;
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
