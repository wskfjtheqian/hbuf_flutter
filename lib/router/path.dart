import 'package:flutter/widgets.dart';

import 'delegate.dart';

typedef CheckDialog = bool Function(BuildContext context, HBaseRouterDelegate delegate);
typedef RouterWidgetBuilder = Widget Function(BuildContext context, Map<String, dynamic>? params);

class ParamKey {
  final int start;
  final int end;
  final String key;

  ParamKey._({
    required this.key,
    required this.start,
    required this.end,
  });
}

final _paramExp = RegExp(r':\w+');

class HRouterPath {
  final String path;

  final CheckDialog? checkDialog;

  final RouterWidgetBuilder? builder;

  late RegExp _pathReg;

  final Map<String, int> _keys = {};

  HRouterPath(this.path, this.builder, [this.checkDialog]) {
    String regStr = "";
    var list = path.split("/");
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      if (item.isEmpty) {
        continue;
      }
      if (_paramExp.hasMatch(item)) {
        var key = item.substring(1);
        if (_keys.containsKey(key)) {
          throw "Router $path repetitive key : $key";
        }
        _keys[key] = i;
        regStr += "/(\\w+)";
      } else {
        regStr += "/${list[i]}";
      }
    }
    _pathReg = RegExp(regStr);
  }

  Map<String, int> get keys => _keys;

  bool hasPath(String path) {
    return _pathReg.hasMatch(path);
  }
}
