import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

class SwitchFormField extends FormField<bool> {
  final FocusNode? focusNode;

  SwitchFormField({
    Key? key,
    FormFieldSetter<bool>? onSaved,
    FormFieldSetter<bool>? onChanged,
    FormFieldValidator<bool>? validator,
    bool? initialValue,
    bool? enabled = true,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
    InputDecoration? decoration = const InputDecoration(),
    this.focusNode,
    bool readOnly = false,
  }) : super(
          key: key,
          restorationId: restorationId,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<bool> field) {
            final _SwitchFormFieldState state = field as _SwitchFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(bool value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: _SwitchField(
                decoration: effectiveDecoration,
                value: state.value ?? false,
                onChanged: onChangedHandler,
                readOnly: readOnly,
              ),
            );
          },
        );

  @override
  FormFieldState<bool> createState() => _SwitchFormFieldState();
}

class _SwitchFormFieldState extends FormFieldState<bool> {
  SwitchFormField get _formField => super.widget as SwitchFormField;

  FocusNode get focusNode => _formField.focusNode ?? FocusNode();
}

class _SwitchField extends StatefulWidget {
  final InputDecoration decoration;

  final ValueChanged<bool>? onChanged;

  final bool value;

  final FocusNode? focusNode;

  final bool readOnly;

  const _SwitchField({
    Key? key,
    required this.decoration,
    this.onChanged,
    required this.value,
    this.focusNode,
    required this.readOnly,
  }) : super(key: key);

  @override
  _SwitchFieldState createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<_SwitchField> {
  FocusNode? _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_onFocusNode);
    super.initState();
  }

  @override
  void didUpdateWidget(_SwitchField oldWidget) {
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 40,
          child: Switch(
            onChanged: (val) {
              if (!widget.readOnly) {
                _focusNode?.requestFocus();
                widget.onChanged?.call(val);
              }
            },
            value: widget.value,
            focusNode: _focusNode,
          ),
        ),
      ),
    );
  }

  void _onFocusNode() {
    setState(() {});
  }
}

typedef OnSwitchFormBuild = Widget Function(BuildContext context, SwitchFormBuild field);

Widget onSwitchFormBuild(BuildContext context, SwitchFormBuild field) {
  return AutoLayout(
    minHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: SwitchFormField(
          key: field.key,
          onChanged: field.onChanged ?? (val) {},
          focusNode: field.focusNode,
          decoration: field.decoration,
          onSaved: field.onSaved,
          validator: field.validator,
          autovalidateMode: field.autovalidateMode,
          initialValue: field.initialValue,
          enabled: field.enabled,
          readOnly: field.readOnly,
        ),
      ),
    ),
  );
}

class SwitchFormBuild {
  Key? key;
  FormFieldSetter<bool>? onSaved;
  FormFieldSetter<bool>? onChanged;
  FormFieldValidator<bool>? validator;
  bool? initialValue;
  bool? enabled = true;
  AutovalidateMode? autovalidateMode;
  String? restorationId;
  InputDecoration? decoration = const InputDecoration();
  FocusNode? focusNode;
  bool visible = true;
  OnSwitchFormBuild onBuild = onSwitchFormBuild;
  double minHeight = 76;
  int widthCount = 24;
  Map<double, int> widthSizes = {};
  EdgeInsetsGeometry padding = const EdgeInsets.only();
  bool readOnly = true;

  Widget build(BuildContext context) {
    return visible ? onBuild(context, this) : const LimitedBox(maxWidth: 0.0, maxHeight: 0.0);
  }
}
