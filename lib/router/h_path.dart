import 'dart:async';

import 'package:flutter/widgets.dart';

import 'h_router.dart';



typedef HRouterWidgetBuilder = Widget Function(BuildContext context);

RegExp _paramRegExp = RegExp(r':\w+');

class HPath {
  final String path;
  final HRouterWidgetBuilder builder;
  late RegExp _pathReg;
  final Map<String, int> _keys = {};
  final bool autoCreate;

  HPath(this.path, this.builder, {this.autoCreate = false}) {
    String regStr = "";
    var list = path.split("/");
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
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
    regStr += "\$";
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
    return _pathReg.hasMatch("/" + path);
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

  bool isEqualSub(String prefix) {
    return path.startsWith(prefix);
  }
}

class HRouterConfig {
  final String name;

  final HPath path;

  final Map<String, String> params;

  final bool candidate;

  HRouterConfig({
    required this.name,
    required this.params,
    required this.path,
    required this.candidate,
  });

  Uri get uri => Uri(path: name, queryParameters: params);
}

class HRouterHistory {
  final HPath path;
  final Completer result = Completer.sync();
  late Map<String, String> _params;
  final bool candidate;
  late Uri uri;
  late ValueKey _pageKey;

  HRouterData? data;

  bool isInitData = false;

  HRouterHistory({
    required this.path,
    required this.candidate,
    required Map<String, String>? params,
    required String name,
  }) {
    _params = params ?? {};
    uri = Uri(path: name, queryParameters: _params);
    path.getPathParams(name, _params);
    _pageKey = ValueKey(hashCode.toString() + uri.toString());
  }

  Map<String, String> get params => _params;

  ValueKey get pageKey => _pageKey;
}
