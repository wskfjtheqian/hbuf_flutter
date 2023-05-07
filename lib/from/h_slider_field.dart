import 'package:flutter/material.dart';
import 'package:hbuf_flutter/from/h_from.dart';
import 'package:hbuf_flutter/widget/h_slider.dart';

class HSliderField extends HFormField<double> {
  HSliderField({
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
    HSliderStyle? sliderStyle,
    ValueChanged<double>? onChanged,
    double? secondaryTrackValue,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    double min = 0,
    double max = 1.0,
  }) : super(
          key: key,
          builder: (context, field) {
            return HSlider(
              value: field.value ?? min,
              secondaryTrackValue: secondaryTrackValue,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              min: min,
              max: max,
              style: sliderStyle,
              onChanged: (field.enabled && !field.onlyRead) ? (value) => field.didChange(value) : null,
            );
          },
        );

  @override
  HFormFieldState<double> createState() => HFormFieldState<double>();
}
