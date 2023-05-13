import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color_picker.dart';

import 'h_from.dart';

class HColorField extends HFormField<Color?> {
  HColorField({
    super.key,
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
    final HColorButtonStyle? colorStyle,
  }) : super(builder: (context, field) {
          return Align(
            alignment: Alignment.centerLeft,
            child: HColorButton(
              style: colorStyle,
              color: field.value,
              onChanged: (value) {
                field.didChange(value);
              },
            ),
          );
        });
}
