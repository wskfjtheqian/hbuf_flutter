import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hbuf_flutter/widget/h_button.dart';

import 'h_border.dart';
import 'h_cascader.dart';
import 'h_theme.dart';

class HMenuButton<T> extends HButton {
  final HMenuStyle menuStyle;

  final HButtonStyle? style;

  final HCascaderItemBuilder<T> builder;

  final Set<T> value;

  final OnHCascaderChange<T>? onChange;

  final int? limit;

  const HMenuButton({
    super.key,
    this.menuStyle = const HMenuStyle(),
    required super.child,
    this.style,
    required this.builder,
    required this.value,
    this.onChange,
    this.limit,
  });

  @override
  HButtonTapCallback? get onTap => _onTap;

  Future<void> _onTap(BuildContext context) async {
    showHMenu<T>(
      context,
      builder: builder,
      value: value,
      limit: limit,
      onChange: onChange,
      style: menuStyle,
    );
  }
}

void showHMenu<T>(
  BuildContext context, {
  HMenuStyle style = const HMenuStyle(),
  required HCascaderItemBuilder<T> builder,
  required Set<T> value,
  OnHCascaderChange<T>? onChange,
  int? limit = 1,
}) {
  var nav = Navigator.of(context, rootNavigator: true);
  final RenderBox button = context.findRenderObject()! as RenderBox;

  nav.push(_HMenuRoute<T>(
    position: () {
      if (!button.attached) {
        return Rect.zero;
      }
      final RenderBox overlay = nav.overlay!.context.findRenderObject()! as RenderBox;
      return Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      );
    },
    style: style,
    builder: builder,
    value: value,
    onChange: onChange,
    limit: limit,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  ));
}

class _HMenuRoute<T> extends PopupRoute<T> {
  final Rect Function() position;

  final HMenuStyle style;

  final HCascaderItemBuilder<T> builder;

  final Set<T> value;

  final OnHCascaderChange<T>? onChange;

  final int? limit;

  @override
  String? barrierLabel;

  _HMenuRoute({
    required this.position,
    required this.style,
    required this.builder,
    required this.onChange,
    required this.value,
    this.limit,
    this.barrierLabel,
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return LayoutBuilder(builder: (context, covariant) {
      return _HMenu(
        minHeight: style.minHeight,
        maxHeight: style.maxHeight,
        position: position(),
        boxShadow: 0 == style.elevation
            ? null
            : BoxShadow(
                color: style.shadowColor ?? const Color(0x30000000),
                offset: Offset(0, style.elevation / 6),
                blurRadius: style.elevation,
              ),
        shape: style.shape,
        color: style.color,
        child: Material(
          color: Colors.transparent,
          child: HCascader<T>(
            style: style.cascaderStyle,
            builder: builder,
            value: value,
            onChange: onChange,
            limit: limit,
          ),
        ),
      );
    });
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

class _HMenu extends SingleChildRenderObjectWidget {
  final double minHeight;

  final double maxHeight;

  final Rect position;

  final ShapeBorder shape;

  final Color? color;

  final BoxShadow? boxShadow;

  const _HMenu({
    super.key,
    super.child,
    required this.minHeight,
    required this.maxHeight,
    required this.position,
    required this.shape,
    this.color,
    this.boxShadow,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HMenuRenderBox(
      position: position,
      minHeight: minHeight,
      maxHeight: maxHeight,
      shape: shape,
      color: color,
      boxShadow: boxShadow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _HMenuRenderBox renderObject) {
    renderObject
      ..position = position
      ..minHeight = minHeight
      ..shape = shape
      ..color = color
      ..boxShadow = boxShadow
      ..maxHeight = maxHeight;
  }
}

class _HMenuRenderBox extends RenderProxyBoxWithHitTestBehavior {
  _HMenuRenderBox({
    required double minHeight,
    required double maxHeight,
    required Rect position,
    required ShapeBorder shape,
    required Color? color,
    required BoxShadow? boxShadow,
  }) {
    _minHeight = minHeight;
    _maxHeight = maxHeight;
    _position = position;
    _shape = shape;
    _color = color;
    _boxShadow = boxShadow;
  }

  BoxShadow? _boxShadow;

  BoxShadow? get boxShadow => _boxShadow;

  set boxShadow(BoxShadow? value) {
    if (_boxShadow != value) {
      _boxShadow = value;
      markNeedsPaint();
    }
  }

  Color? _color;

  Color? get color => _color;

  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  late ShapeBorder _shape;

  ShapeBorder get shape => _shape;

  set shape(ShapeBorder value) {
    if (_shape != value) {
      _shape = value;
      markNeedsLayout();
    }
  }

  Rect _position = Rect.zero;

  Rect get position => _position;

  set position(Rect value) {
    if (_position != value) {
      _position = value;
      markNeedsLayout();
    }
  }

  double _minHeight = 0;

  double get minHeight => _minHeight;

  set minHeight(double value) {
    if (_minHeight != value) {
      _minHeight = value;
      markNeedsLayout();
    }
  }

  double _maxHeight = double.infinity;

  double get maxHeight => _maxHeight;

  set maxHeight(double value) {
    if (_maxHeight != value) {
      _maxHeight = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    var temp = parent;
    var winSize = Size.zero;
    do {
      temp = temp!.parent;
      if (temp is RenderView) {
        winSize = temp.size;
      }
    } while (null != temp!.parent);

    final BoxConstraints constraints = this.constraints;
    final bool shrinkWrapWidth = constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight = constraints.maxHeight == double.infinity;

    if (child != null) {
      child!.layout(
        BoxConstraints(
          maxWidth: winSize.width,
          minHeight: _minHeight,
          maxHeight: _maxHeight,
        ).enforce(constraints.loosen()),
        parentUsesSize: true,
      );
      size = constraints.constrain(Size(
        shrinkWrapWidth ? child!.size.width * 1.0 : double.infinity,
        shrinkWrapHeight ? child!.size.height * 1.0 : double.infinity,
      ));

      HBubblePosition? pos;
      double top;
      double offset = shape is HBubbleBorder ? (shape as HBubbleBorder).arrowSize.height : 0;
      if (winSize.height < position.bottom + child!.size.height) {
        top = position.top - child!.size.height - offset;
        pos = HBubblePosition.bottom;
      } else {
        top = position.bottom + offset;
        pos = HBubblePosition.top;
      }

      double left = winSize.width - position.left - child!.size.width;
      if (left < 0) {
        left = position.left + left;
      } else {
        left = position.left;
      }

      double align = ((position.left + position.width / 2 - left) - (child!.size.width / 2)) / (child!.size.width / 2);

      (child!.parentData as BoxParentData).offset = Offset(left, top);
      if (shape is HBubbleBorder) {
        _shape = (shape as HBubbleBorder).copyWith(position: pos, align: ArrowAlign(align));
      }
    } else {
      size = constraints.constrain(Size(
        shrinkWrapWidth ? 0.0 : double.infinity,
        shrinkWrapHeight ? 0.0 : double.infinity,
      ));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      var rect = (child!.parentData as BoxParentData).offset & child!.size;
      if (null != boxShadow) {
        final Paint paint = boxShadow!.toPaint();
        final Rect bounds = rect.shift(boxShadow!.offset).inflate(boxShadow!.spreadRadius);
        var path = shape.getInnerPath(bounds);
        context.canvas.drawPath(path, paint);
      }
      var path = shape.getInnerPath(rect);
      if (color != null) {
        context.canvas.drawPath(
          path,
          Paint()
            ..color = color!
            ..style = PaintingStyle.fill,
        );
      }
      shape.paint(context.canvas, rect);
      context.clipPathAndPaint(path, Clip.antiAlias, offset & child!.size, () => painter(context, Offset.zero));
    }
  }

  painter(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset + (child!.parentData as BoxParentData).offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (null != child) {
      return child!.hitTest(result, position: position - (child!.parentData as BoxParentData).offset);
    }
    return false;
  }
}

class HMenuStyle {
  final double elevation;

  final Color? color;

  final Color? shadowColor;

  final ShapeBorder shape;

  final double minHeight;

  final double maxHeight;

  final HCascaderStyle cascaderStyle;

  const HMenuStyle({
    this.elevation = 12.0,
    this.color = const Color(0xffffffff),
    this.shadowColor = const Color(0x10000000),
    this.shape = const HBubbleBorder(position: HBubblePosition.top, side: BorderSide(color: Color(0xffe4e7ed), width: 1)),
    this.minHeight = 1,
    this.maxHeight = 200,
    this.cascaderStyle = const HCascaderStyle(),
  });
}

class HMenuTheme extends InheritedTheme {
  const HMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HMenuThemeData data;

  static HMenuThemeData _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<HMenuTheme>();
    return theme?.data ?? HTheme.of(context).menuTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HMenuTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HMenuTheme oldWidget) => data != oldWidget.data;
}

extension HMenuContext on BuildContext {
  HMenuStyle get defaultMenu {
    return HMenuTheme._of(this).defaultMenu;
  }
}

class HMenuThemeData {
  final HMenuStyle defaultMenu;

  const HMenuThemeData({
    this.defaultMenu = const HMenuStyle(),
  });

  HMenuThemeData copyWith({
    HMenuStyle? defaultMenu,
  }) {
    return HMenuThemeData(
      defaultMenu: defaultMenu ?? this.defaultMenu,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HMenuThemeData && runtimeType == other.runtimeType && defaultMenu == other.defaultMenu;

  @override
  int get hashCode => defaultMenu.hashCode;
}
