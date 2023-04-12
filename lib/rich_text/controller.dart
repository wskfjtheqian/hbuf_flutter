import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as h;
import 'package:html/parser.dart' as h;

class RLenReadOnly {}

class RNode {
  RNode? parent;

  int len = 0;

  int select = 0;

  String get tag => "";
}

mixin RColor implements RNode {
  Color? color;
}

class RElement extends RNode implements RLenReadOnly {
  List<RNode> nodes = [];

  @override
  int get len {
    int len = 0;
    for (var item in nodes) {
      len += item.len;
    }
    return len;
  }
}

class RBody extends RElement with RColor {
  @override
  String toString() {
    return "body[len=$len;select=$select]";
  }

  String get tag => "body";
}

class RP extends RElement with RColor {
  String get tag => "p";
}

class RText extends RNode {
  @override
  String toString() {
    return "t[len=$len;select=$select]";
  }
}

class RImg extends RNode implements RLenReadOnly {
  String? src;

  double? width;

  double? height;

  @override
  String toString() {
    return "img[len=$len;select=$select]";
  }

  String get tag => "img";
}

class RA extends RElement {
  String? href;

  @override
  String toString() {
    return "a[len=$len;select=$select]";
  }

  String get tag => "a";
}

class T {
  String text = "";
  int len = 0;
}

class RichTextEditingController extends TextEditingController {
  RBody body = RBody();

  List<RNode> _select = [];

  List<RNode> get select => _select;

  RichTextEditingController({super.text});

  RichTextEditingController.html({required String html}) {
    var document = h.parse(html);
    var t = T();
    body.nodes = toR(body, document.body?.nodes ?? [], t).toList();
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
          r.nodes = toR(r, item.nodes, text).toList();
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
    if (null != body.color) {
      style?.copyWith(color: body.color);
    }
    return TextSpan(
      style: style,
      children: _toTextSpan(body.nodes, t).toList(),
    );
  }

  Iterable<InlineSpan> _toTextSpan(List<RNode> list, T t) sync* {
    for (var item in list) {
      if (item is RText) {
        yield TextSpan(text: t.text.substring(t.len, t.len += item.len));
      } else if (item is RA) {
        yield TextSpan(
          style: a_style,
          children: _toTextSpan(item.nodes, t).toList(),
        );
      } else if (item is RImg) {
        t.len += 1;
        yield WidgetSpan(
          style: TextStyle(height:item.height ),
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
    if (value.text != newValue.text || selection.baseOffset != newValue.selection.baseOffset || selection.extentOffset != newValue.selection.extentOffset) {
      T t = T();
      List<RNode> out = [];
      var base = min(selection.baseOffset, selection.extentOffset);
      var extent = max(selection.baseOffset, selection.extentOffset);
      selectNode(body, base, extent, t, out);
      _select = out;

      if (value.text != newValue.text) {
        var rm = <RNode>[];
        for (var item in out) {
          item.len -= item.select;
          deleteNode(item, rm);
        }
        for (var item in rm) {
          out.remove(item);
        }
        var length = newValue.selection.baseOffset - base;
        var node = out.isEmpty ? body : out[0];
        if (length > 0) {
          if (node is! RLenReadOnly) {
            node.len += length;
          } else {
            addNode(node, RText()..len = length);
          }
        } else {
          node.len += length;
          deleteNode(node, rm);
        }
      }
    }
    super.value = newValue;
  }

  void addNode(RNode node, RNode sub) {
    if (node is RElement) {
      node.nodes.add(sub);
    } else if (null != node.parent) {
      addNode(node.parent!, sub);
    }
  }

  bool selectNode(RNode node, int base, int extent, T t, List<RNode> out) {
    if (node is RElement) {
      for (var item in node.nodes) {
        if (selectNode(item, base, extent, t, out)) {
          return true;
        }
      }
    } else {
      if (base > t.len && base <= t.len + node.len) {
        out.add(node);
        t.len += node.len;
        node.select = t.len - base;
        return t.len > extent;
      } else if (base <= t.len && extent >= t.len + node.len) {
        out.add(node);
        t.len += node.len;
        node.select = node.len;
        return t.len > extent;
      } else if (extent > t.len && extent <= t.len + node.len) {
        out.add(node);
        node.select = extent - t.len;
        t.len += node.len;
        return t.len > extent;
      }
      t.len += node.len;
    }
    return false;
  }

  void deleteNode(RNode out, List<RNode> rm) {
    if (0 >= out.len && null != out.parent && out.parent is RElement) {
      (out.parent as RElement).nodes.remove(out);
      rm.add(out);
      deleteNode(out.parent!, rm);
    }
  }

  void setColor({required Color color}) {
    for (var item in _select) {
      if (item is RColor) {
        item.color = color;
      }
    }
  }
}
