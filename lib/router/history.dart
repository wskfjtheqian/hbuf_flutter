import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/router/path.dart';
import 'package:hbuf_flutter/router/widget.dart';

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
