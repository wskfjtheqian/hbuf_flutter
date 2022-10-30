import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as h;
import 'package:html/parser.dart' as h;

class RNode {
  RNode? parent;
  int len = 0;
  int select = 0;
}

class RElement extends RNode {
  List<RNode> node = [];

  @override
  int get len {
    int len = 0;
    for (var item in node) {
      len += item.len;
    }
    return len;
  }
}

class RBody extends RElement {}

class RP extends RElement {}

class RText extends RNode {}

class RImg extends RNode {
  String? src;

  double? width;

  double? height;
}

class RA extends RElement {
  String? href;
}

class T {
  String text = "";
  int len = 0;
}

class RichTextEditingController extends TextEditingController {
  RBody body = RBody();

  RichTextEditingController({super.text});

  RichTextEditingController.html({required String html}) {
    var document = h.parse(html);
    var t = T();
    body.node = toR(body, document.body?.nodes ?? [], t).toList();
    body.len = t.len;
    text = t.text;
  }

  Iterable<RNode> toR(RNode parent, List<h.Node> list, T text) sync* {
    for (var item in list) {
      if (item is h.Text) {
        text.text += item.text;
        text.len += item.text.length;
        yield RText()
          ..parent = parent
          ..len = item.text.length;
      } else if (item is h.Element) {
        if ("a" == item.localName) {
          var r = RA();
          r.parent = parent;
          r.node = toR(r, item.nodes, text).toList();
          r.href = item.attributes["href"];
          yield r;
        } else if ("img" == item.localName) {
          text.text += " ";
          text.len += 1;
          yield RImg()
            ..parent = parent
            ..len = 1
            ..src = item.attributes["src"]
            ..width = num.tryParse(item.attributes["width"] ?? "")?.toDouble()
            ..height = num.tryParse(item.attributes["height"] ?? "")?.toDouble();
        }
      }
    }
  }

  TextStyle a_style = const TextStyle(color: Colors.indigoAccent);

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);
    T t = T()..text = value.text;
    return TextSpan(
      style: style,
      children: _toTextSpan(body.node, t).toList(),
    );
  }

  Iterable<InlineSpan> _toTextSpan(List<RNode> list, T t) sync* {
    for (var item in list) {
      if (item is RText) {
        yield TextSpan(text: t.text.substring(t.len, t.len += item.len));
      } else if (item is RA) {
        yield TextSpan(
          style: a_style,
          children: _toTextSpan(item.node, t).toList(),
        );
      } else if (item is RImg) {
        t.len += 1;
        yield WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Image.network(
            item.src ?? "",
            width: item.width,
            height: item.height,
            fit: BoxFit.fill,
          ),
        );
      }
    }
  }

  @override
  set text(String newText) {
    super.value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  @override
  set value(TextEditingValue newValue) {
    print(value);
    print(newValue);
    if (value.text != newValue.text) {
      int length = newValue.text.length - value.text.length;
      T t = T();
      List<RNode> out = [];
      selectNode(body.node, selection.baseOffset, selection.extentOffset, t, out);
      if (0 < length) {
        if (out.isNotEmpty && out[0] is! RImg) {
          out[0].len += length;
        } else {
          body.node.add(RText()..len = length);
        }
      } else if (0 > length) {
        for (var item in out) {
          item.len -= item.select;
          deleteNode(item);
        }
      }
    }
    super.value = newValue;
  }

  bool selectNode(List<RNode> list, int base, int extent, T t, List<RNode> out) {
    for (var item in list) {
      if (item is RElement) {
        if (selectNode(item.node, base, extent, t, out)) {
          return true;
        }
      } else {
        if (base >= t.len && base <= t.len + item.len) {
          out.add(item);
          t.len += item.len;
          item.select = t.len - base;
          return t.len > extent;
        } else if (base <= t.len && extent >= t.len + item.len) {
          out.add(item);
          t.len += item.len;
          item.select = item.len;
          return t.len > extent;
        } else if (extent >= t.len && extent <= t.len + item.len) {
          out.add(item);
          item.select = t.len - extent;
          t.len += item.len;
          return t.len > extent;
        }
        t.len += item.len;
      }
    }
    return false;
  }

  void deleteNode(RNode out) {
    if (0 >= out.len && null != out.parent && out.parent is RElement) {
      (out.parent as RElement).node.remove(out);
      deleteNode(out.parent!);
    }
  }
}
