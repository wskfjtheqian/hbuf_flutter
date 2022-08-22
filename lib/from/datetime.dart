import 'package:flutter/material.dart';
import 'package:hbuf_flutter/calendar/calendar_select.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class DateTimeFormField extends FormField<List<DateTime>> {
  final FocusNode? focusNode;

  DateTimeFormField({
    Key? key,
    FormFieldSetter<List<DateTime>>? onSaved,
    FormFieldSetter<List<DateTime>>? onChanged,
    FormFieldValidator<List<DateTime>>? validator,
    List<DateTime>? initialValue,
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
          builder: (FormFieldState<List<DateTime>> field) {
            final _DateTimeFormFieldState state = field as _DateTimeFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
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
  FormFieldState<List<DateTime>> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<List<DateTime>> {
  DateTimeFormField get _formField => super.widget as DateTimeFormField;

  FocusNode get focusNode => _formField.focusNode ?? FocusNode();
}

class _DateTimeField extends StatefulWidget {
  final InputDecoration decoration;

  final ValueChanged<List<DateTime>>? onChanged;

  final List<DateTime> value;

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

    return InkWell(
      onTap: () async {
        var ret = await showSelectDateRangePicker(context, initDateTime: DateTime.now());
        if (null == ret || ret.isEmpty) {
          return;
        }
        _controller1.value = TextEditingValue(text: ret[0].format("yyyy/MM/dd"));
        if (1 == ret.length) {
          return;
        }
        _controller2.value = TextEditingValue(text: ret[1].format("yyyy/MM/dd"));
      },
      child: InputDecorator(
        decoration: widget.decoration,
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
            Text("To"),
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
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}

// class _TextFieldSelectionGestureDetectorBuilder extends TextSelectionGestureDetectorBuilder {
//   _TextFieldSelectionGestureDetectorBuilder({
//     required _DateTimeFieldState state,
//   }) : _state = state,
//         super(delegate: state);
//
//   final _DateTimeFieldState _state;
//
//   @override
//   void onForcePressStart(ForcePressDetails details) {
//     super.onForcePressStart(details);
//     if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
//       editableText.showToolbar();
//     }
//   }
//
//   @override
//   void onForcePressEnd(ForcePressDetails details) {
//     // Not required.
//   }
//
//   @override
//   void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
//     if (delegate.selectionEnabled) {
//       switch (Theme.of(_state.context).platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           renderEditable.selectPositionAt(
//             from: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           renderEditable.selectWordsInRange(
//             from: details.globalPosition - details.offsetFromOrigin,
//             to: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//       }
//     }
//   }
//
//   @override
//   void onSingleTapUp(TapUpDetails details) {
//     editableText.hideToolbar();
//     super.onSingleTapUp(details);
//     _state._requestKeyboard();
//     _state.widget.onTap?.call();
//   }
//
//   @override
//   void onSingleLongTapStart(LongPressStartDetails details) {
//     if (delegate.selectionEnabled) {
//       switch (Theme.of(_state.context).platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           renderEditable.selectPositionAt(
//             from: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           renderEditable.selectWord(cause: SelectionChangedCause.longPress);
//           Feedback.forLongPress(_state.context);
//           break;
//       }
//     }
//   }
// }
