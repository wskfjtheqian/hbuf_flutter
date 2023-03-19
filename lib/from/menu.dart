import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_size.dart';

typedef OnMenuFormBuild<T> = Widget Function(BuildContext context, MenuFormBuild<T> field);

Widget onMenuFormBuild<T>(BuildContext context, MenuFormBuild<T> field) {
  return HSize(
    minHeight: field.minHeight,
    sizes: field.widthSizes,
    count: field.widthCount,
    child: Padding(
      padding: field.padding,
      child: Theme(
        data: Theme.of(context).copyWith(visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
        child: DropdownButtonFormField<T>(
          key: field.key,
          items: field.items,
          selectedItemBuilder: field.selectedItemBuilder,
          value: field.value,
          hint: SizedBox.shrink(),
          disabledHint: field.disabledHint,
          onChanged: field.readOnly ? null : (field.onChanged ?? (val) {}),
          onTap: field.onTap,
          elevation: field.elevation,
          style: field.style,
          icon: field.icon,
          iconDisabledColor: field.iconDisabledColor,
          iconEnabledColor: field.iconEnabledColor,
          iconSize: field.iconSize,
          isDense: field.isDense,
          isExpanded: field.isExpanded,
          itemHeight: field.itemHeight,
          focusColor: field.focusColor,
          focusNode: field.focusNode,
          autofocus: field.autofocus,
          dropdownColor: field.dropdownColor,
          decoration: field.decoration,
          onSaved: field.onSaved,
          validator: field.validator,
          autovalidateMode: field.autovalidateMode,
          menuMaxHeight: field.menuMaxHeight,
          enableFeedback: field.enableFeedback,
          alignment: field.alignment,
          borderRadius: field.borderRadius,
        ),
      ),
    ),
  );
}

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
  OnMenuFormBuild<T> onBuild = onMenuFormBuild<T>;

  Widget build(BuildContext context) {
    return onBuild(context, this);
  }
}
