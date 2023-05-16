import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hbuf_flutter/shape/h_bubble_border.dart';

class HMenuButton extends StatelessWidget {
  const HMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Text("data"),
      onTap: () {
        showHMenu<int>(
          context,
          limit: null,
          builder: (BuildContext context) {
            return [
              HMenuItem<int>(
                value: 1,
                child: Text("HMenuItem1"),
              ),
              HMenuItem<int>(
                value: 2,
                child: Text("HMenuItem2"),
              ),
              HMenuItem<int>(
                value: 3,
                child: Text("HMenuItem3"),
              ),
              HMenuItem<int>(
                value: 4,
                child: Text("HMenuItem4"),
              ),
              HMenuItem<int>(
                value: 5,
                child: Text("HMenuItem5"),
                builder: (context) {
                  return [
                    HMenuItem<int>(
                      value: 6,
                      child: Text("HMenuItem6"),
                      builder: (context) {
                        return [
                          HMenuItem<int>(
                            value: 7,
                            child: Text("HMenuItem7"),
                          ),
                          HMenuItem<int>(
                            value: 8,
                            child: Text("HMenuItem8"),
                          ),
                          HMenuItem<int>(
                            value: 9,
                            child: Text("HMenuItem9"),
                          ),
                          HMenuItem<int>(
                            value: 10,
                            child: Text("HMenuItem10"),
                          ),
                          HMenuItem<int>(
                            value: 11,
                            child: Text("HMenuItem11"),
                          ),
                        ];
                      },
                    ),
                    HMenuItem<int>(
                      value: 12,
                      child: Text("HMenuItem12"),
                    ),
                    HMenuItem<int>(
                      value: 13,
                      child: Text("HMenuItem13"),
                    ),
                    HMenuItem<int>(
                      value: 14,
                      child: Text("HMenuItem14"),
                    ),
                    HMenuItem<int>(
                      value: 15,
                      child: Text("HMenuItem15"),
                    ),
                    HMenuItem<int>(
                      value: 16,
                      child: Text("HMenuItem16"),
                    ),
                  ];
                },
              ),
              HMenuItem<int>(
                value: 17,
                child: Text("HMenuItem"),
              ),
              HMenuItem<int>(
                value: 18,
                child: Text("HMenuItem"),
              ),
              HMenuItem<int>(
                value: 19,
                child: Text("HMenuItem"),
              ),
              HMenuItem<int>(
                value: 20,
                child: Text("HMenuItem"),
              ),
            ];
          },
          value: {},
        );
      },
    );
  }
}

typedef HMenuItemBuilder<T> = List<HMenuItem<T>> Function(BuildContext context);
typedef OnHMenuChange<T> = void Function(Set<T> value);

void showHMenu<T>(
  BuildContext context, {
  HMenuStyle style = const HMenuStyle(),
  required HMenuItemBuilder<T> builder,
  required Set<T> value,
  OnHMenuChange<T>? onChange,
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

  final HMenuItemBuilder<T> builder;

  final Set<T> value;

  final OnHMenuChange<T>? onChange;

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
                color: style.shadowColor ?? const Color(0x80000000),
                offset: Offset(style.elevation / 2, style.elevation / 2),
                blurRadius: style.elevation,
              ),
        textStyle: style.textStyle,
        shape: style.shape,
        color: style.color,
        child: Material(
          color: Colors.transparent,
          child: RawScrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _HMenuColumn<T>(
                minWidth: style.minWidth,
                maxWidth: style.maxWidth,
                builder: builder,
                value: value,
                onChange: onChange,
                limit: limit,
              ),
            ),
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
    TextStyle? textStyle,
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

      double top;
      if (winSize.height < _position.bottom + child!.size.height) {
        top = _position.top - child!.size.height;
      } else {
        top = _position.bottom;
      }

      double left = winSize.width - _position.left - child!.size.width;
      if (left < 0) {
        left = _position.left + left;
      } else {
        left = _position.left;
      }

      (child!.parentData as BoxParentData).offset = Offset(left, top);
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

      // for (final BoxShadow boxShadow in _decoration.boxShadow!) {
      //
      //   final Rect bounds = rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      //   _paintBox(canvas, bounds, paint, textDirection);
      // }

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

class _HMenuColumn<T> extends StatefulWidget {
  final double minWidth;

  final double maxWidth;

  final HMenuItemBuilder builder;

  final Set<T> value;

  final OnHMenuChange<T>? onChange;

  final int? limit;

  const _HMenuColumn({
    Key? key,
    required this.builder,
    required this.minWidth,
    required this.maxWidth,
    required this.value,
    required this.onChange,
    this.limit,
  }) : super(key: key);

  @override
  State<_HMenuColumn<T>> createState() => _HMenuColumnState<T>();
}

class _HMenuColumnState<T> extends State<_HMenuColumn<T>> {
  HMenuItemBuilder? _builder;

  final _scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(minWidth: widget.minWidth, maxWidth: widget.maxWidth),
      child: SingleChildScrollView(
        key: _scrollKey,
        child: Column(
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
          _HMenuColumn<T>(
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

  void onTap(BuildContext context, T value, HMenuItemBuilder? builder) {
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

class HMenuItem<T> extends StatelessWidget {
  final T value;

  final Widget child;

  final HMenuItemStyle? style;

  final HMenuItemBuilder<T>? builder;

  const HMenuItem({
    Key? key,
    required this.value,
    required this.child,
    this.style,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? const HMenuItemStyle();
    var column = context.findAncestorStateOfType<_HMenuColumnState<T>>()!;
    return SizedBox(
      height: style.height,
      child: InkWell(
        onTap: () {
          column.onTap(context, value, builder);
        },
        child: Padding(
          padding: style.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (column.widget.limit != 1)
                Checkbox(
                  value: column.hashValue(value),
                  onChanged: (_) {
                    column.onTap(context, value, builder);
                  },
                ),
              child,
              SizedBox(
                width: 24,
                height: 24,
                child: null != builder
                    ? const Icon(
                        Icons.chevron_right_outlined,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HMenuStyle {
  final double elevation;

  final Color? color;

  final Color? shadowColor;

  final TextStyle? textStyle;

  final ShapeBorder shape;

  final double minHeight;

  final double maxHeight;

  final double minWidth;

  final double maxWidth;

  final HMenuItemStyle itemStyle;

  const HMenuStyle({
    this.elevation = 4.0,
    this.color = Colors.greenAccent,
    this.shadowColor,
    this.textStyle,
    this.shape = const HBubbleBorder(position: HBubblePosition.top),
    this.minHeight = 100,
    this.maxHeight = 200,
    this.minWidth = 100,
    this.maxWidth = 200,
    this.itemStyle = const HMenuItemStyle(),
  });
}

class HMenuItemStyle {
  final EdgeInsets padding;

  final double height;

  const HMenuItemStyle({
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.height = 42,
  });
}
