import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

typedef OnImageFormFieldAdd = void Function(BuildContext context, _OnImageFormField field, double outWidth, double outHeight);
typedef OnImageFormFieldTap = void Function(BuildContext context, List<NetworkImage>? list, NetworkImage item);

OnImageFormFieldAdd? onImageFormFieldAdd;
OnImageFormFieldTap? onImageFormFieldTap;

class _OnImageFormField {
  final void Function(List<NetworkImage>? value)? onChangedHandler;

  _ImageFormFieldState state;

  _OnImageFormField(this.state, this.onChangedHandler);

  List<NetworkImage>? get value => state.value;

  void didChange(List<NetworkImage>? val) {
    if (null != onChangedHandler) {
      onChangedHandler?.call(val);
    }
    state.didChange(val);
  }
}

class ImageFormField extends FormField<List<NetworkImage>> {
  final FocusNode? focusNode;

  final double width;

  final double height;

  final BoxFit fit;

  final OnImageFormFieldAdd? onAdd;

  final OnImageFormFieldTap? onTap;

  final int maxCount;

  final double outWidth;

  final double outHeight;

  final bool readOnly;

  ImageFormField({
    Key? key,
    FormFieldSetter<List<NetworkImage>>? onSaved,
    FormFieldSetter<List<NetworkImage>>? onChanged,
    FormFieldValidator<List<NetworkImage>>? validator,
    List<NetworkImage>? initialValue,
    bool? enabled = true,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
    InputDecoration? decoration = const InputDecoration(),
    this.focusNode,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
    this.onAdd,
    this.onTap,
    this.maxCount = 1,
    required this.outWidth,
    required this.outHeight,
    this.readOnly = false,
  }) : super(
          key: key,
          restorationId: restorationId,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<List<NetworkImage>> field) {
            final _ImageFormFieldState state = field as _ImageFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: _ImageField(
                decoration: effectiveDecoration,
                value: state.value ?? [],
                width: width,
                height: height,
                fit: fit,
                readOnly: readOnly,
                onAdd: (context) {
                  (onAdd ?? onImageFormFieldAdd)?.call(context, _OnImageFormField(field, onChanged), outWidth, outHeight);
                },
                onTap: (context, list, item) {
                  (onTap ?? onImageFormFieldTap)?.call(context, list, item);
                },
                onDel: (context, list, item) {
                  field.value?.remove(item);
                  field.didChange(field.value);
                },
                maxCount: maxCount,
              ),
            );
          },
        );

  @override
  FormFieldState<List<NetworkImage>> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends FormFieldState<List<NetworkImage>> {
  ImageFormField get _formField => super.widget as ImageFormField;

  FocusNode get focusNode => _formField.focusNode ?? FocusNode();
}

class _ImageField extends StatefulWidget {
  final InputDecoration decoration;

  final List<NetworkImage> value;

  final FocusNode? focusNode;

  final double width;

  final double height;

  final BoxFit fit;

  final int maxCount;

  final void Function(BuildContext context) onAdd;

  final OnImageFormFieldTap onTap;

  final OnImageFormFieldTap onDel;

  final bool readOnly;

  const _ImageField({
    Key? key,
    required this.decoration,
    required this.value,
    this.focusNode,
    required this.width,
    required this.height,
    required this.fit,
    this.maxCount = 1,
    required this.onAdd,
    required this.onTap,
    required this.onDel,
    required this.readOnly,
  }) : super(key: key);

  @override
  _ImageFieldState createState() => _ImageFieldState();
}

class _ImageFieldState extends State<_ImageField> {
  FocusNode? _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_onFocusNode);
    super.initState();
  }

  @override
  void didUpdateWidget(_ImageField oldWidget) {
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
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Wrap(
          spacing: 8,
          children: [
            for (var item in widget.value)
              OutlinedButton(
                onPressed: () => widget.onTap(context, widget.value, item),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(widget.width, widget.height)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  visualDensity: const VisualDensity(),
                ),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 1,
                        bottom: 1,
                        right: 1,
                        left: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image(
                            image: item,
                            fit: widget.fit,
                            width: widget.width,
                            height: widget.height,
                          ),
                        ),
                      ),
                      if (!widget.readOnly)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => widget.onDel(context, widget.value, item),
                            child: const Icon(Icons.close),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (widget.value.length < widget.maxCount && !widget.readOnly)
              OutlinedButton(
                onPressed: () => widget.onAdd(context),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(widget.width, widget.height)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: const VisualDensity(),
                ),
                child: const Icon(Icons.add),
              )
          ],
        ),
      ),
    );
  }

  void _onFocusNode() {
    setState(() {});
  }
}

class ImageFormBuild {
  Key? key;
  List<NetworkImage>? initialValue;
  Widget? hint;
  Widget? disabledHint;
  ValueChanged<List<NetworkImage>?>? onChanged;
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
  FormFieldSetter<List<NetworkImage>>? onSaved;
  FormFieldValidator<List<NetworkImage>>? validator;
  AutovalidateMode? autovalidateMode;
  double width = 80;
  double height = 80;
  double outWidth = 300;
  double outHeight = 300;
  bool? enableFeedback;
  AlignmentGeometry alignment = AlignmentDirectional.centerStart;
  BorderRadius? borderRadius;
  int maxCount = 1;
  OnImageFormFieldAdd? onAdd;
  OnImageFormFieldTap? onTap;
  bool enabled = true;
  bool readOnly = true;
  double minHeight = 124;
  int widthCount = 24;
  Map<double, int> widthSizes = {};
  EdgeInsetsGeometry padding = const EdgeInsets.only();

  Widget build(BuildContext context) {
    return AutoLayout(
      minHeight: minHeight,
      sizes: widthSizes,
      count: widthCount,
      child: Padding(
        padding: padding,
        child: Theme(
          data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
          child: ImageFormField(
            key: key,
            onChanged: onChanged ?? (val) {},
            focusNode: focusNode,
            decoration: decoration,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            maxCount: maxCount,
            onAdd: onAdd,
            onTap: onTap,
            initialValue: initialValue,
            width: width,
            height: height,
            outWidth: outWidth,
            outHeight: outHeight,
            enabled: enabled,
            readOnly: readOnly,
          ),
        ),
      ),
    );
  }
}
