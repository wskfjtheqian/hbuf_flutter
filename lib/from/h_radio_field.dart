import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class HRadioItem<T> {
  final T value;
  final String? text;

  const HRadioItem({
    required this.value,
    this.text,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is HRadioItem && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class HRadioField<T> extends HFormField<T> {
  HRadioField({
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
    HRadioStyle? radioStyle,
    required Set<HRadioItem<T>> items,
  }) : super(
          key: key,
          builder: (context, field) {
            return Wrap(
              children: [
                for (var item in items)
                  HSize(
                    child: HRadio(
                      value: item.value,
                      groupValue: field.value,
                      text: item.text,
                      onChanged: (T? value) {
                        field.didChange(value);
                      },
                    ),
                  ),
              ],
            );
          },
        );

  @override
  HFormFieldState<T> createState() => HFormFieldState<T>();
}
