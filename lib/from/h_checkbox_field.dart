import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class HCheckBoxItem<T> {
  final T value;
  final String? text;

  const HCheckBoxItem({
    required this.value,
    this.text,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HCheckBoxItem && runtimeType == other.runtimeType && value == other.value && text == other.text;

  @override
  int get hashCode => value.hashCode ^ text.hashCode;
}

class HCheckBoxField<T> extends HFormField<Set<T>> {
  HCheckBoxField({
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
    HCheckBoxStyle? checkBoxStyle,
    required Set<HCheckBoxItem<T>> items,
  }) : super(
          key: key,
          builder: (context, field) {
            return Wrap(
              children: [
                for (var item in items)
                  HSize(
                    child: HCheckBox(
                      value: (field.value ?? {}).contains(item.value),
                      text: item.text,
                      onChanged: (bool? value) {
                        var temp = field.value ?? {};
                        if (true == value) {
                          temp.add(item.value);
                        } else {
                          temp.remove(item.value);
                        }
                        field.didChange(temp);
                      },
                    ),
                  ),
              ],
            );
          },
        );

  @override
  HFormFieldState<Set<T>> createState() => HFormFieldState<Set<T>>();
}
