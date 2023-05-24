import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

typedef OnClickFormFieldTap<T> = void Function(BuildContext context, FormFieldState<T>);

typedef OnClickFormBuild = Widget Function(BuildContext context, ClickFormBuild field);

Widget onClickFormBuild<T>(BuildContext context, ClickFormBuild<T> field) {
  return AutoLayout(
    minHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: ClickFormField<T>(
          key: field.key,
          onChanged: field.onChanged ?? (val) {},
          focusNode: field.focusNode,
          decoration: field.decoration,
          onSaved: field.onSaved,
          validator: field.validator,
          autovalidateMode: field.autovalidateMode,
          onTap: field.onTap,
          initialValue: field.initialValue,
          enabled: field.enabled,
          readOnly: field.readOnly,
        ),
      ),
    ),
  );
}


class ClickFormField<T> extends FormField<T> {
  final FocusNode? focusNode;

  final OnClickFormFieldTap<T>? onTap;

  final bool readOnly;

  ClickFormField({
    Key? key,
    FormFieldSetter<T>? onSaved,
    FormFieldSetter<T>? onChanged,
    FormFieldValidator<T>? validator,
    T? initialValue,
    bool? enabled = true,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
    InputDecoration? decoration = const InputDecoration(),
    this.focusNode,
    this.onTap,
    this.readOnly = false,
  }) : super(
          key: key,
          restorationId: restorationId,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            final _ClickFormFieldState<T> state = field as _ClickFormFieldState<T>;
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: _ClickField<T>(
                decoration: effectiveDecoration,
                value: state.value,
                readOnly: readOnly,
                onTap: null == onTap
                    ? null
                    : (context) {
                        onTap?.call(context, state);
                      },
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _ClickFormFieldState<T>();
}

class _ClickFormFieldState<T> extends FormFieldState<T> {
  ClickFormField get _formField => super.widget as ClickFormField;

  FocusNode get focusNode => _formField.focusNode ?? FocusNode();
}

class _ClickField<T> extends StatefulWidget {
  final InputDecoration decoration;

  final T? value;

  final FocusNode? focusNode;

  final void Function(BuildContext context)? onTap;

  final bool readOnly;

  const _ClickField({
    Key? key,
    required this.decoration,
    required this.value,
    this.focusNode,
    required this.onTap,
    required this.readOnly,
  }) : super(key: key);

  @override
  _ClickFieldState<T> createState() => _ClickFieldState<T>();
}

class _ClickFieldState<T> extends State<_ClickField<T>> {
  FocusNode? _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_onFocusNode);
    super.initState();
  }

  @override
  void didUpdateWidget(_ClickField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (null != widget.focusNode && widget.focusNode != oldWidget.focusNode) {
      _focusNode?.removeListener(_onFocusNode);
      _focusNode = widget.focusNode!;
      _focusNode?.addListener(_onFocusNode);
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusNode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: widget.decoration,
      isFocused: _focusNode?.hasFocus ?? false,
      textAlign: TextAlign.left,
      child: InkWell(
        onTap: null == widget.onTap ? null : () => widget.onTap!.call(context),
        child: Row(
          children: [
            Expanded(child: Text(widget.value?.toString() ?? "")),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  void _onFocusNode() {
    setState(() {});
  }
}

class ClickFormBuild<T> {
  Key? key;
  T? initialValue;
  Widget? hint;
  Widget? disabledHint;
  ValueChanged<T?>? onChanged;
  int elevation = 8;
  TextStyle? style;
  Widget? icon;
  Color? iconDisabledColor;
  Color? iconEnabledColor;
  double iconSize = 24.0;
  bool isDense = true;
  bool isExpanded = false;
  double? itemHeight;
  Color? focusColor;
  FocusNode? focusNode;
  bool autofocus = false;
  Color? dropdownColor;
  InputDecoration? decoration;
  FormFieldSetter<T>? onSaved;
  FormFieldValidator<T>? validator;
  AutovalidateMode? autovalidateMode;
  bool? enableFeedback;
  AlignmentGeometry alignment = AlignmentDirectional.centerStart;
  BorderRadius? borderRadius;
  OnClickFormFieldTap<T>? onTap;
  bool enabled = true;
  bool readOnly = true;
  double minHeight = 124;
  int widthCount = 24;
  Map<double, int> widthSizes = {};
  EdgeInsetsGeometry padding = const EdgeInsets.only();
  OnClickFormBuild onBuild = onClickFormBuild;
  bool visible = true;

  Widget build(BuildContext context) {
    return visible ? onBuild(context, this) : const LimitedBox(maxWidth: 0.0, maxHeight: 0.0);
  }
}
