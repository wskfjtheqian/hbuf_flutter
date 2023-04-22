import 'package:flutter/widgets.dart';

typedef HRouterWidgetBuilder = Widget Function(BuildContext context);

RegExp _paramRegExp = RegExp(r':\w+');

class HPath {
  final String path;
  final HRouterWidgetBuilder builder;
  late RegExp _pathReg;
  final Map<String, int> _keys = {};

  HPath(this.path, this.builder) {
    String regStr = "";
    var list = path.split("/");
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      if (item.isEmpty) {
        continue;
      }
      if (_paramRegExp.hasMatch(item)) {
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

  RegExp get pathReg => _pathReg;

  @override
  String toString() {
    return path;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HPath && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;

  bool hasMatch(String path) {
    return _pathReg.hasMatch(path);
  }

  void getPathParams(String name, Map<String, String> params) {
    var list = name.split("/");
    for (var item in _keys.entries) {
      if (params.containsKey(item.key)) {
        throw "Router $name and params repetitive key : ${item.key}";
      }
      params[item.key] = list[item.value];
    }
  }

  bool isSub(String prefix) {
    var parent = prefix.split("/");
    var subs = path.split("/");
    if (subs.length <= parent.length) {
      return false;
    }
    for (var i = 0; i < parent.length; i++) {
      if (parent[i] != subs[i]) {
        if (!(_paramRegExp.hasMatch(subs[i]) && !_paramRegExp.hasMatch(parent[i]))) {
          return false;
        }
      }
    }
    return true;
  }
}
