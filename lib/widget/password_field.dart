import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordController {
  List<String?> _textList = [];
  _PasswordFieldState? _state;

  PasswordController(int count) {
    _textList = List.filled(count, null);
  }

  void clear() {
    for (var i = 0; i < _textList.length; i++) {
      _textList[i] = null;
    }
    _state?.clear();
  }

  Future<dynamic> showTextInput() {
    _state?._node.requestFocus();
    return SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  Future<dynamic> hideTextInput() {
    _state?._node.unfocus();
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  String get text => _textList.join();
}

class PasswordField extends StatefulWidget {
  final int count;
  final double size;
  final double width;
  final double height;

  final double spacing;

  final TextStyle? style;

  final List<TextInputFormatter> inputFormatters;

  final TextAlign textAlign;

  final void Function(String value)? onSubmit;

  final PasswordController? controller;

  final bool autofocus;

  final TextInputType keyboardType;

  const PasswordField({
    Key? key,
    this.count = 6,
    this.size = 40,
    this.spacing = 20,
    this.width = 30,
    this.height = 40,
    this.style,
    this.inputFormatters = const [],
    this.textAlign = TextAlign.center,
    this.onSubmit,
    this.controller,
    this.autofocus = true,
    this.keyboardType = TextInputType.number,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final FocusScopeNode _node = FocusScopeNode();
  late PasswordController _controller;

  final GlobalKey<FormState> _formKey = GlobalKey();

  get style {
    var s = const TextStyle(fontSize: 20, color: Color(0xff555555));
    if (null != widget.style) {
      s.merge(widget.style);
    }
    return s;
  }

  @override
  void initState() {
    _controller = widget.controller ?? PasswordController(widget.count);
    _controller._state = this;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PasswordField oldWidget) {
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? PasswordController(widget.count);
      _controller._state = this;
    } else if (widget.count != oldWidget.count) {
      _controller._textList = List.generate(widget.count, (index) => index < _controller._textList.length ? _controller._textList[index] : null);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FocusScope(
        node: _node,
        onKey: (node, event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace && !node.children.first.hasFocus) {
            node.previousFocus();
          }
          return KeyEventResult.ignored;
        },
        child: Wrap(
          spacing: widget.spacing,
          children: [
            for (var i = 0; i < widget.count; i++)
              SizedBox(
                width: widget.width,
                height: widget.height,
                child: TextFormField(
                  autofocus: widget.autofocus ? 0 == i : false,
                  style: style,
                  textAlign: widget.textAlign,
                  onChanged: (val) => onChanged(context, val, i),
                  cursorColor: const Color(0xff555555),
                  keyboardType: widget.keyboardType,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    ...widget.inputFormatters,
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEFEFEF),
                    focusColor: Color(0xffEFEFEF),
                    contentPadding: EdgeInsets.all(0),
                    isCollapsed: false,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      /*边角*/
                      borderRadius: BorderRadius.all(
                        Radius.circular(6), //边角为5
                      ),
                      borderSide: BorderSide(
                        color: Color(0xffEFEFEF), //边线颜色为白色
                        width: 1, //边线宽度为2
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffEFEFEF), //边框颜色为白色
                        width: 1, //宽度为5
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6), //边角为30
                      ),
                    ),
                    // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffDD1EA7 ))),
                    // enabledBorder: null == _controller._textList[i] ? null : UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff009FE8))),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onChanged(BuildContext context, String text, int index) {
    if (text.isNotEmpty) {
      if (index < _controller._textList.length - 1) {
        _node.nextFocus();
      }
      _controller._textList[index] = text;
    } else {
      _controller._textList[index] = null;
    }

    if (!_controller._textList.contains(null)) {
      widget.onSubmit?.call(_controller._textList.join());
    }
    setState(() {});
  }

  void clear() {
    _node.children.first.requestFocus();
    _formKey.currentState?.reset();
  }
}
