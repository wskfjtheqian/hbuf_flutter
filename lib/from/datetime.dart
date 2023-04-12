import 'package:flutter/material.dart';
import 'package:hbuf_flutter/calendar/calendar_select.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

class DateTimeFormField extends FormField<List<DateTime?>?> {
  final FocusNode? focusNode;

  DateTimeFormField({
    Key? key,
    FormFieldSetter<List<DateTime?>?>? onSaved,
    FormFieldSetter<List<DateTime?>?>? onChanged,
    FormFieldValidator<List<DateTime?>?>? validator,
    List<DateTime?>? initialValue,
    bool? enabled = true,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
    InputDecoration? decoration = const InputDecoration(),
    this.focusNode,
  }) : super(
          key: key,
          restorationId: restorationId,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<List<DateTime?>?> field) {
            final _DateTimeFormFieldState state = field as _DateTimeFormFieldState;
            InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(List<DateTime> value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: _DateTimeField(
                decoration: effectiveDecoration,
                value: state.value ?? [],
                onChanged: onChangedHandler,
              ),
            );
          },
        );

  @override
  FormFieldState<List<DateTime?>?> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<List<DateTime?>?> {
  DateTimeFormField get _formField => super.widget as DateTimeFormField;

  FocusNode get focusNode => _formField.focusNode ?? FocusNode();
}

class _DateTimeField extends StatefulWidget {
  final InputDecoration decoration;

  final ValueChanged<List<DateTime>>? onChanged;

  final List<DateTime?>? value;

  final FocusNode? focusNode;

  final TextStyle? style;

  final bool readOnly;

  final bool? enabled;

  final String? restorationId;

  const _DateTimeField({
    Key? key,
    required this.decoration,
    this.onChanged,
    required this.value,
    this.focusNode,
    this.style,
    this.readOnly = false,
    this.enabled,
    this.restorationId,
  }) : super(key: key);

  @override
  _DateTimeFieldState createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<_DateTimeField> with RestorationMixin {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  final GlobalKey<EditableTextState> editableTextKey1 = GlobalKey<EditableTextState>();
  final GlobalKey<EditableTextState> editableTextKey2 = GlobalKey<EditableTextState>();

  // late _TextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;

  EditableTextState? get _editableText1 => editableTextKey1.currentState;

  EditableTextState? get _editableText2 => editableTextKey1.currentState;

  bool _showSelectionHandles = false;

  bool get _isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  @override
  void initState() {
    _focusNode1.addListener(_onFocusNode);
    _focusNode2.addListener(_onFocusNode);
    super.initState();
  }

  @override
  void didUpdateWidget(_DateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (null != widget.focusNode && widget.focusNode != oldWidget.focusNode) {
    //   _focusNode?.removeListener(_onFocusNode);
    //   _focusNode = widget.focusNode!;
    //   _focusNode?.addListener(_onFocusNode);
    // }
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFocusNode);
    _focusNode2.removeListener(_onFocusNode);
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextSelectionThemeData selectionTheme = TextSelectionTheme.of(context);
    final TextStyle style = theme.textTheme.subtitle1!.merge(widget.style);

    var decoration = widget.decoration.copyWith(
      suffixIcon: InkWell(
        child: const Icon(Icons.calendar_month_outlined),
        onTap: () => _onSelect(context),
      ),
    );
    return InputDecorator(
      decoration: decoration,
      isFocused: _focusNode1.hasFocus || _focusNode2.hasFocus,
      textAlign: TextAlign.left,
      child: Row(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: UnmanagedRestorationScope(
                bucket: bucket,
                child: EditableText(
                  key: editableTextKey1,
                  backgroundCursorColor: Colors.white,
                  controller: _controller1,
                  cursorColor: Colors.blue,
                  style: style,
                  focusNode: _focusNode1,
                  onSelectionChanged: (selection, cause) => _handleSelectionChanged(selection, cause, _editableText1, _controller1),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 30,
            child: Divider(
              height: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: RepaintBoundary(
              child: UnmanagedRestorationScope(
                bucket: bucket,
                child: EditableText(
                  key: editableTextKey2,
                  backgroundCursorColor: Colors.white,
                  controller: _controller2,
                  cursorColor: Colors.blue,
                  style: style,
                  focusNode: _focusNode2,
                  onSelectionChanged: (selection, cause) => _handleSelectionChanged(selection, cause, _editableText2, _controller2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onFocusNode() {
    setState(() {});
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause, TextEditingController controller) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    // if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
    //   return false;
    // }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (widget.readOnly && controller.selection.isCollapsed) {
      return false;
    }

    if (!_isEnabled) {
      return false;
    }

    if (cause == SelectionChangedCause.longPress || cause == SelectionChangedCause.scribble) {
      return true;
    }

    if (controller.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause? cause, EditableTextState? textState, TextEditingController controller) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause, controller);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress || cause == SelectionChangedCause.drag) {
          textState?.bringIntoView(selection.extent);
        }
        return;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        if (cause == SelectionChangedCause.drag) {
          textState?.bringIntoView(selection.extent);
        }
        return;
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  _onSelect(BuildContext context) async {
    var ret = await showSelectDateRangePicker(context, initDateTime: DateTime.now());
    if (null != ret) {
      if (ret.isNotEmpty) {
        _controller1.text = ret[0].toString().substring(0, 10);
      }
      if (1 < ret.length) {
        var end = ret[1].add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
        _controller2.text = end.toString().substring(0, 10);
      }
      widget.onChanged?.call(ret);
    }
  }
}

typedef OnDatetimeFormBuild = Widget Function(BuildContext context, DatetimeFormBuild field);

Widget onDatetimeFormBuild(BuildContext context, DatetimeFormBuild field) {
  return AutoLayout(
    minHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: DateTimeFormField(
          key: field.key,
          initialValue: field.initialValue,
          focusNode: field.focusNode,
          decoration: field.decoration,
          onChanged: field.onChanged,
          onSaved: field.onSaved,
          validator: field.validator,
          enabled: field.enabled,
          autovalidateMode: field.autovalidateMode,
          restorationId: field.restorationId,
        ),
      ),
    ),
  );
}

class DatetimeFormBuild {
  Key? key;
  FocusNode? focusNode;
  FormFieldSetter<List<DateTime?>?>? onSaved;
  FormFieldSetter<List<DateTime?>?>? onChanged;
  FormFieldValidator<List<DateTime?>?>? validator;
  List<DateTime?>? initialValue;
  bool? enabled = true;
  AutovalidateMode? autovalidateMode;
  String? restorationId;
  InputDecoration? decoration = const InputDecoration();
  OnDatetimeFormBuild onBuild = onDatetimeFormBuild;
  double minHeight = 76;
  int widthCount = 24;
  Map<double, int> widthSizes = {};
  bool readOnly = false;
  EdgeInsetsGeometry padding = const EdgeInsets.only();
  bool visible = true;

  Widget build(BuildContext context) {
    return visible ? onBuild(context, this) : const LimitedBox(maxWidth: 0.0, maxHeight: 0.0);
  }
}
