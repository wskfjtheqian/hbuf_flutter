import 'package:flutter/material.dart';
import 'package:hbuf_flutter/from/h_from.dart';
import 'package:hbuf_flutter/widget/h_switch.dart';

class HSwitchField extends HFormField<bool> {
  HSwitchField({
    Key? key,
    super.onSaved,
    super.onChange,
    super.validator,
    super.initialValue,
    super.enabled = true,
    super.onlyRead,
    super.restorationId,
    super.label,
    super.style,
    super.autoValidateMode,
    ImageErrorListener? onInactiveThumbImageError,
    ValueChanged<bool>? onFocusChange,
    ImageErrorListener? onActiveThumbImageError,
    HSwitchStyle? switchStyle,
  }) : super(
          key: key,
          builder: (context, field) {
            return Align(
              alignment: Alignment.centerLeft,
              child: HSwitch(
                value: field.value ?? false,
                style: switchStyle,
                onChanged: (field.enabled && !field.onlyRead) ? (value) => field.didChange(value) : null,
                onInactiveThumbImageError: onInactiveThumbImageError,
                onFocusChange: onFocusChange,
                onActiveThumbImageError: onActiveThumbImageError,
              ),
            );
          },
        );

  @override
  HFormFieldState<bool> createState() => HFormFieldState<bool>();
}
