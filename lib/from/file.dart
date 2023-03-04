import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

typedef OnFileFormFieldAdd = void Function(BuildContext context, TextEditingController controller, {List<String>? extensions});
typedef OnFileFormBuild = Widget Function(BuildContext context, FileFormBuild field);

Widget onFileFormBuild(BuildContext context, FileFormBuild field) {
  return AutoLayout(
    minHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: FileFormField(
          key: field.key,
          controller: field.controller,
          initialValue: field.initialValue,
          focusNode: field.focusNode,
          decoration: field.decoration,
          keyboardType: field.keyboardType,
          textCapitalization: field.textCapitalization,
          textInputAction: field.textInputAction,
          style: field.style,
          strutStyle: field.strutStyle,
          textDirection: field.textDirection,
          textAlign: field.textAlign,
          textAlignVertical: field.textAlignVertical,
          autofocus: field.autofocus,
          readOnly: field.readOnly,
          showCursor: field.showCursor,
          obscuringCharacter: field.obscuringCharacter,
          obscureText: field.obscureText,
          autocorrect: field.autocorrect,
          smartDashesType: field.smartDashesType,
          smartQuotesType: field.smartQuotesType,
          enableSuggestions: field.enableSuggestions,
          maxLengthEnforcement: field.maxLengthEnforcement,
          maxLines: field.maxLines,
          minLines: field.minLines,
          expands: field.expands,
          maxLength: field.maxLength,
          onChanged: field.onChanged,
          onTap: field.onTap,
          onEditingComplete: field.onEditingComplete,
          onFieldSubmitted: field.onFieldSubmitted,
          onSaved: field.onSaved,
          validator: field.validator,
          inputFormatters: field.inputFormatters,
          enabled: field.enabled,
          cursorWidth: field.cursorWidth,
          cursorHeight: field.cursorHeight,
          cursorRadius: field.cursorRadius,
          cursorColor: field.cursorColor,
          keyboardAppearance: field.keyboardAppearance,
          scrollPadding: field.scrollPadding,
          enableInteractiveSelection: field.enableInteractiveSelection,
          selectionControls: field.selectionControls,
          buildCounter: field.buildCounter,
          scrollPhysics: field.scrollPhysics,
          autofillHints: field.autofillHints,
          autovalidateMode: field.autovalidateMode,
          scrollController: field.scrollController,
          restorationId: field.restorationId,
          enableIMEPersonalizedLearning: field.enableIMEPersonalizedLearning,
          mouseCursor: field.mouseCursor,
          extensions: field.extensions,
        ),
      ),
    ),
  );
}

class FileFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final OnFileFormFieldAdd? onAdd;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final double minHeight = 76;
  final int widthCount = 24;
  final Map<double, int> widthSizes = {};
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final String? buttonText;
  final List<String>? extensions;

  FileFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.onAdd,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.extensions,
    this.buttonText,
  });

  @override
  State<FileFormField> createState() => _FileFormFieldState();

  static Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}

class _FileFormFieldState extends State<FileFormField> {
  TextEditingController? _controller;
  TextEditingController? _back;

  @override
  void initState() {
    _controller ??= (_back = TextEditingController(text: widget.initialValue));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FileFormField oldWidget) {
    if (_controller != widget.controller) {
      if (null != widget.controller) {
        _controller = widget.controller;
      } else {
        _back?.dispose();
        _controller = (_back = TextEditingController(text: _controller?.text));
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _back?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration?.copyWith(suffix: getSuffix(context)) ?? InputDecoration(suffix: getSuffix(context)),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      scrollController: widget.scrollController,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      mouseCursor: widget.mouseCursor,
      contextMenuBuilder: widget.contextMenuBuilder,
    );
  }

  TextButton getSuffix(BuildContext context) {
    return TextButton(
      onPressed: () {
        (widget.onAdd ?? onFileFormFieldAdd)!.call(context, _controller!, extensions: widget.extensions);
      },
      child: Text(widget.buttonText ?? onFileFormFieldButtonText(context)),
    );
  }
}

String Function(BuildContext) onFileFormFieldButtonText = (BuildContext context) {
  return "Select file";
};

OnFileFormFieldAdd? onFileFormFieldAdd;

class FileFormBuild {
  Key? key;
  TextEditingController? controller;
  String? initialValue;
  FocusNode? focusNode;
  InputDecoration? decoration;
  OnFileFormFieldAdd? onAdd;
  TextInputType? keyboardType;
  TextCapitalization textCapitalization = TextCapitalization.none;
  TextInputAction? textInputAction;
  TextStyle? style;
  StrutStyle? strutStyle;
  TextDirection? textDirection;
  TextAlign textAlign = TextAlign.start;
  TextAlignVertical? textAlignVertical;
  bool autofocus = false;
  bool readOnly = false;
  bool? showCursor;
  String obscuringCharacter = '•';
  bool obscureText = false;
  bool autocorrect = true;
  SmartDashesType? smartDashesType;
  SmartQuotesType? smartQuotesType;
  bool enableSuggestions = true;
  MaxLengthEnforcement? maxLengthEnforcement;
  int? maxLines = 1;
  int? minLines;
  bool expands = false;
  int? maxLength;
  ValueChanged<String>? onChanged;
  GestureTapCallback? onTap;
  VoidCallback? onEditingComplete;
  ValueChanged<String>? onFieldSubmitted;
  FormFieldSetter<String>? onSaved;
  FormFieldValidator<String>? validator;
  List<TextInputFormatter>? inputFormatters;
  bool? enabled;
  double cursorWidth = 2.0;
  double? cursorHeight;
  Radius? cursorRadius;
  Color? cursorColor;
  Brightness? keyboardAppearance;
  EdgeInsets scrollPadding = const EdgeInsets.all(20.0);
  bool? enableInteractiveSelection;
  TextSelectionControls? selectionControls;
  InputCounterWidgetBuilder? buildCounter;
  ScrollPhysics? scrollPhysics;
  Iterable<String>? autofillHints;
  AutovalidateMode? autovalidateMode;
  ScrollController? scrollController;
  String? restorationId;
  bool enableIMEPersonalizedLearning = true;
  MouseCursor? mouseCursor;
  double minHeight = 76;
  int widthCount = 24;
  Map<double, int> widthSizes = {};
  EdgeInsetsGeometry padding = const EdgeInsets.only();
  OnFileFormBuild onBuild = onFileFormBuild;
  EditableTextContextMenuBuilder? contextMenuBuilder = _defaultContextMenuBuilder;
  List<String>? extensions;

  Widget build(BuildContext context) {
    return onBuild(context, this);
  }

  static Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}
