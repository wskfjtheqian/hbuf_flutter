import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

typedef OnTextFormBuild = Widget Function(BuildContext context, TextFormBuild field);

Widget onTextFormBuild(BuildContext context, TextFormBuild field) {
  return HSize(
    minFieldHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: TextFormField(
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
          toolbarOptions: field.toolbarOptions,
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
        ),
      ),
    ),
  );
}

class TextFormBuild {
  Key? key;
  TextEditingController? controller;
  String? initialValue;
  FocusNode? focusNode;
  InputDecoration? decoration = const InputDecoration();
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
  ToolbarOptions? toolbarOptions;
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
  OnTextFormBuild onBuild = onTextFormBuild;

  Widget build(BuildContext context) {
    return onBuild(context, this);
  }
}
