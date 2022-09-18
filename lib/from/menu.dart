import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

class MenuFormBuild<T> {
  Key? key;
  List<DropdownMenuItem<T>>? items;
  DropdownButtonBuilder? selectedItemBuilder;
  T? value;
  Widget? hint;
  Widget? disabledHint;
  ValueChanged<T?>? onChanged;
  VoidCallback? onTap;
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
  double? menuMaxHeight;
  bool? enableFeedback;
  AlignmentGeometry alignment = AlignmentDirectional.centerStart;
  BorderRadius? borderRadius;
  bool readOnly = false;
  double minHeight = 76;
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
          child: DropdownButtonFormField<T>(
            key: key,
            items: items,
            selectedItemBuilder: selectedItemBuilder,
            value: value,
            hint: SizedBox.shrink(),
            disabledHint: disabledHint,
            onChanged: readOnly ? null : (onChanged ?? (val) {}),
            onTap: onTap,
            elevation: elevation,
            style: style,
            icon: icon,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor: iconEnabledColor,
            iconSize: iconSize,
            isDense: isDense,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            focusColor: focusColor,
            focusNode: focusNode,
            autofocus: autofocus,
            dropdownColor: dropdownColor,
            decoration: decoration,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            menuMaxHeight: menuMaxHeight,
            enableFeedback: enableFeedback,
            alignment: alignment,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
