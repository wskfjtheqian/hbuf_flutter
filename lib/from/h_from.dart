import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/widget/h_size.dart';

class HFormStyle {
  final double minFieldHeight;
  final double maxFieldHeight;
  final Map<double, int>? labelSize;
  final Map<double, int>? childSize;
  final int count;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry fieldPadding;

  const HFormStyle({
    this.minFieldHeight = 46,
    this.maxFieldHeight = double.infinity,
    this.labelSize,
    this.childSize,
    this.count = 0,
    this.labelStyle = const TextStyle(),
    this.fieldPadding = const EdgeInsets.only(left: 0, bottom: 16, right: 16, top: 16),
  });
}

class HFormFieldStyle {
  final double minFieldHeight;
  final double maxFieldHeight;
  final Map<double, int>? labelSize;
  final Map<double, int>? childSize;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry? fieldPadding;

  const HFormFieldStyle({
    this.minFieldHeight = 46.0,
    this.maxFieldHeight = double.infinity,
    this.labelSize,
    this.childSize,
    this.fieldPadding,
    this.labelStyle = const TextStyle(),
  });
}

class HForm extends StatefulWidget {
  final HFormStyle? style;

  final WidgetBuilder builder;

  final WillPopCallback? onWillPop;

  final VoidCallback? onChanged;

  final HAutoValidateMode autoValidateMode;

  final bool enabled;

  final bool onlyRead;

  const HForm({
    super.key,
    required this.builder,
    this.onWillPop,
    this.onChanged,
    HAutoValidateMode? autoValidateMode,
    this.style,
    this.enabled = true,
    this.onlyRead = false,
  }) : autoValidateMode = autoValidateMode ?? HAutoValidateMode.disabled;

  static HFormState? maybeOf(BuildContext context) {
    final _HFormScope? scope = context.dependOnInheritedWidgetOfExactType<_HFormScope>();
    return scope?._hFormState;
  }

  static HFormState of(BuildContext context) {
    final HFormState? hFormState = maybeOf(context);
    assert(() {
      if (hFormState == null) {
        throw FlutterError(
          'HForm.of() was called with a context that does not contain a HForm widget.\n'
          'No HForm widget ancestor could be found starting from the context that '
          'was passed to HForm.of(). This can happen because you are using a widget '
          'that looks for a HForm ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return hFormState!;
  }

  @override
  HFormState createState() => HFormState();
}

class HFormState extends State<HForm> {
  int _generation = 0;
  bool _hasInteractedByUser = false;
  final Set<HFormFieldState<dynamic>> _fields = <HFormFieldState<dynamic>>{};

  bool _dispose = false;

  HFormStyle get style => widget.style ?? HFormStyle();

  void _fieldDidChange() {
    widget.onChanged?.call();

    _hasInteractedByUser = _fields.any((HFormFieldState<dynamic> field) => field._hasInteractedByUser.value);
    _forceRebuild();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }

  void _register(HFormFieldState<dynamic> field) {
    _fields.add(field);
  }

  void _unregister(HFormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted && !_dispose) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.autoValidateMode) {
      case HAutoValidateMode.always:
        _validate();
        break;
      case HAutoValidateMode.onUserInteraction:
        if (_hasInteractedByUser) {
          _validate();
        }
        break;
      case HAutoValidateMode.disabled:
        break;
    }

    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _HFormScope(
        hFormState: this,
        generation: _generation,
        child: widget.builder(context),
      ),
    );
  }

  void save() {
    for (final HFormFieldState<dynamic> field in _fields) {
      field.save();
    }
  }

  void reset() {
    for (final HFormFieldState<dynamic> field in _fields) {
      field.reset();
    }
    _hasInteractedByUser = false;
    _fieldDidChange();
  }

  Future<bool> validate() {
    _hasInteractedByUser = true;
    _forceRebuild();
    return _validate();
  }

  Future<bool> _validate() async {
    bool hasError = false;
    for (final HFormFieldState<dynamic> field in _fields) {
      hasError = !(await field.validate()) || hasError;
    }
    return !hasError;
  }
}

class _HFormScope extends InheritedWidget {
  const _HFormScope({
    required super.child,
    required HFormState hFormState,
    required int generation,
  })  : _hFormState = hFormState,
        _generation = generation;

  final HFormState _hFormState;

  final int _generation;

  HForm get hForm => _hFormState.widget;

  @override
  bool updateShouldNotify(_HFormScope old) => _generation != old._generation;
}

typedef HFormFieldValidator<T> = Future<String?> Function(T? value);

typedef HFormFieldSetter<T> = void Function(T? newValue);

typedef HFormFieldBuilder<T> = Widget Function(BuildContext context, HFormFieldState<T> field);

class HFormField<T> extends StatefulWidget {
  final HFormFieldStyle? style;

  final Widget? label;

  final HFormFieldSetter<T>? onSaved;

  final HFormFieldSetter<T>? onChange;

  final HFormFieldValidator<T>? validator;

  final HFormFieldBuilder<T> builder;

  final T? initialValue;

  final HAutoValidateMode autoValidateMode;

  final String? restorationId;

  final bool? enabled;

  final bool? onlyRead;

  const HFormField({
    super.key,
    required this.builder,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.restorationId,
    this.label,
    this.style,
    this.onChange,
    this.enabled = true,
    this.onlyRead,
    HAutoValidateMode? autoValidateMode,
  }) : autoValidateMode = autoValidateMode ?? HAutoValidateMode.disabled;

  @override
  HFormFieldState<T> createState() => HFormFieldState<T>();
}

class HFormFieldState<T> extends State<HFormField<T>> with RestorationMixin {
  late T? _value = widget.initialValue;
  final RestorableStringN _errorText = RestorableStringN(null);
  final RestorableBool _hasInteractedByUser = RestorableBool(false);

  bool _dispose = false;

  T? get value => _value;

  String? get errorText => _errorText.value;

  bool get hasError => _errorText.value != null;

  bool get isValid => widget.validator?.call(_value) == null;

  void save() {
    widget.onSaved?.call(value);
  }

  bool get enabled => widget.enabled ?? HForm.of(context).widget.enabled;

  bool get onlyRead => widget.onlyRead ?? HForm.of(context).widget.onlyRead;

  void reset() {
    setState(() {
      _value = widget.initialValue;
      _hasInteractedByUser.value = false;
      _errorText.value = null;
    });
    HForm.maybeOf(context)?._fieldDidChange();
  }

  Future<bool> validate() async {
    await _validate();
    setState(() {});
    return !hasError;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted && !_dispose) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  Future<void> _validate() async {
    if (widget.validator != null) {
      _errorText.value = await widget.validator!(_value);
    }
  }

  void didChange(T? value) {
    widget.onChange?.call(value);
    setState(() {
      _value = value;
      _hasInteractedByUser.value = true;
    });
    HForm.maybeOf(context)?._fieldDidChange();
  }

  @protected
  // ignore: use_setters_to_change_properties, (API predates enforcing the lint)
  void setValue(T? value) {
    _value = value;
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_errorText, 'error_text');
    registerForRestoration(_hasInteractedByUser, 'has_interacted_by_user');
  }

  @override
  void deactivate() {
    HForm.maybeOf(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      switch (widget.autoValidateMode) {
        case HAutoValidateMode.always:
          _validate();
          break;
        case HAutoValidateMode.onUserInteraction:
          if (_hasInteractedByUser.value) {
            _validate();
          }
          break;
        case HAutoValidateMode.disabled:
          break;
      }
    }
    HForm.maybeOf(context)?._register(this);
    Widget child = widget.builder(context, this);
    Widget? label = widget.label;

    var width = MediaQuery.of(context).size.width;
    var labelSize = widget.style?.labelSize ?? HForm.of(context).style.labelSize;
    var childSize = widget.style?.childSize ?? HForm.of(context).style.childSize;
    var count = HForm.of(context).style.count;

    var labelCount = _getCount(width, labelSize, count);
    var childCount = _getCount(width, childSize, count);

    if (labelCount + childCount <= count) {
      label = Align(
        alignment: Alignment.centerRight,
        child: label,
      );
    }

    child = Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        HSize(
          style: HSizeStyle(
            sizes: labelSize,
            count: count,
          ),
          child: Padding(
            padding: widget.style?.fieldPadding ?? HForm.of(context).style.fieldPadding,
            child: label,
          ),
        ),
        HSize(
          style: HSizeStyle(
            sizes: childSize,
            count: count,
            minHeight: widget.style?.minFieldHeight ?? HForm.of(context).style.minFieldHeight,
            maxHeight: widget.style?.maxFieldHeight ?? HForm.of(context).style.maxFieldHeight,
          ),
          child: child,
        ),
      ],
    );
    return child;
  }

  int _getCount(double width, Map<double, int>? sizes, int count) {
    if (null != sizes) {
      var keys = sizes.keys.toList()..sort((a, b) => (b - a).ceil());
      for (double item in keys) {
        if (width >= item) {
          width = item;
          break;
        }
      }
      if (sizes.containsKey(width)) {
        return sizes[width]!;
      }
    }
    return count;
  }
}

enum HAutoValidateMode {
  disabled,
  always,
  onUserInteraction,
}
