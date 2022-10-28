import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as h;
import 'package:html/parser.dart' as h;

class R {
  int len = 0;
}

class RElement extends R {
  List<R> node = [];

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

class RText extends R {}

class RImg extends R {
  String src = "";
  double width = 0;
  double height = 0;
}

class RA extends RElement {
  String src = "";
}


class RichTextEditingController extends TextEditingController {
  RBody body = RBody();

  RichTextEditingController({super.text});

  RichTextEditingController.html({required String html}) {
    var document = h.parse(html);
    text = document.body?.text ?? "";
  }

  Iterable<R> toR(List<h.Node> list) sync*{
    for (var item in list) {
      if (item is h.Text) {
        yield R()..len = item.text.length;
      } else if (item is h.Element) {
        if ("a" == item.localName) {
          yield RA()..node = toR(list);
        } else if ("img" == item.localName) {
          yield img(item);
        }
      }
    }
  }
  
  TextStyle a_style = const TextStyle(color: Colors.indigoAccent);

  // @override
  // TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
  //   assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);
  //
  //   final TextStyle composingStyle =
  //       style?.merge(const TextStyle(decoration: TextDecoration.underline)) ?? const TextStyle(decoration: TextDecoration.underline);
  //   return TextSpan(
  //     style: style,
  //     children: _toTextSpan(document.body?.nodes ?? []).toList(),
  //   );
  // }

  Iterable<InlineSpan> _toTextSpan(List<h.Node> list) sync* {
    for (var item in list) {
      if (item is h.Text) {
        yield TextSpan(text: item.text);
      } else if (item is h.Element) {
        if ("a" == item.localName) {
          yield a(item);
        } else if ("img" == item.localName) {
          yield img(item);
        }
      }
    }
  }

  InlineSpan a(h.Element item) {
    return TextSpan(
      style: a_style,
      children: _toTextSpan(item.nodes).toList(),
    );
  }

  InlineSpan img(h.Element item) {
    return WidgetSpan(
      child: Image.network(
        item.attributes["src"] ?? "",
        fit: BoxFit.fill,
        width: num.tryParse(item.attributes["width"] ?? "")?.toDouble(),
        height: num.tryParse(item.attributes["height"] ?? "")?.toDouble(),
      ),
    );
  }
}
