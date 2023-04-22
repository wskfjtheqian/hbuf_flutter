import 'package:flutter/material.dart';
import 'package:hbuf_flutter/router/path.dart';

import 'data.dart';
import 'history.dart';
import 'widget.dart';

typedef HRouteWhere = Function(HPath path);

class HBaseDelegate extends RouterDelegate<List<HRouterConfig>> with ChangeNotifier {
  HBaseDelegate? _parent;
  String _prefix = "";

  final List<HBaseDelegate> _subDelegate = [];

  set prefix(String prefix) {
    _prefix = prefix;
  }

  set parent(HBaseDelegate? parent) {
    _parent = parent;
  }

  List<HRouterHistory> _buildHistory = [];

  List<HRouterHistory> get buildHistory => _buildHistory;

  List<HRouterHistory> get parentHistory => [
        if (null != _parent) ..._parent!.parentHistory,
        ..._buildHistory,
      ];

  List<HRouterHistory> get historyList => _parent?.historyList ?? [];

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = [];
    for (var item in buildHistory) {
      pages.add(buildPage(context, item));
    }
    if (pages.isEmpty) {
      return SizedBox();
    }
    return Navigator(
      pages: pages,
      onPopPage: (route, result) {
        return Navigator.of(context).widget.onPopPage!(route, result);
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setNewRoutePath(List<HRouterConfig> configuration) async {
    return;
  }

  void addSubRouterDelegate(HBaseDelegate delegate) {
    _subDelegate.add(delegate);
    _parent?.addSubRouterDelegate(delegate);
    if (null == _parent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => notifyListeners());
    }
  }

  void removeSubRouterDelegate(HBaseDelegate delegate) {
    _subDelegate.remove(delegate);
    _parent?.removeSubRouterDelegate(delegate);
    if (null == _parent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => notifyListeners());
    }
  }

  List<Page<dynamic>> getPages(BuildContext context) {
    List<Page<dynamic>> pages = [];
    for (var item in historyList) {
      pages.add(buildPage(context, item));
    }
    return pages;
  }

  Page buildPage(BuildContext context, HRouterHistory history) {
    return MaterialPage(
      key: history.pageKey,
      name: history.path.path,
      arguments: history,
      child: HRouteModel(
        history: history,
        child: history.path.builder(context),
      ),
    );
  }

  bool checkSubRouter(HRouterHistory router) {
    for (var item in _subDelegate) {
      if (router.path.isSub(item._prefix)) {
        return true;
      }
    }
    return false;
  }

  bool checkParentRouter(HRouterHistory history) {
    for (var item in parentHistory) {
      if (history.uri == item.uri) {
        return true;
      }
    }
    return false;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    createBuildHistory();
    for (var item in _subDelegate) {
      item.notifyListeners();
    }
  }

  void createBuildHistory() {
    _buildHistory = [];
    List<HRouterHistory> list = [];
    for (var item in historyList) {
      if (!checkParentRouter(item)) {
        if (!checkSubRouter(item)) {
          list.add(item);
        }
      }
    }
    _buildHistory = list;
  }
}

class HRouterDelegate extends HBaseDelegate with PopNavigatorRouterDelegateMixin<List<HRouterConfig>> implements RouteInformationParser<List<HRouterConfig>> {
  List<HPath> _routers = [];

  final List<HRouterHistory> _history = [];

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<HRouterHistory> get historyList => _history;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<List<HRouterConfig>> parseRouteInformation(RouteInformation info) async {
    var uri = Uri.parse(info.location!);
    return _paresPath(uri);
  }

  @override
  Future<List<HRouterConfig>> parseRouteInformationWithDependencies(RouteInformation info, BuildContext context) {
    return parseRouteInformation(info);
  }

  List<HRouterConfig> _paresPath(Uri uri) {
    List<HRouterConfig> ret = [];
    var path = _findPath(uri.path);

    var paths = uri.path.split("/");
    for (var i = _routers.length - 1; i >= 0; i--) {
      var router = _routers[i];
      if (path!.path != router.path && 0 == path.path.indexOf(router.path)) {
        var items = router.path.split("/");
        var newPath = StringBuffer();
        for (var j = 0; j < items.length; j++) {
          newPath.write(paths[j]);
          if (j < items.length - 1) {
            newPath.write("/");
          }
        }
        ret.add(HRouterConfig(name: newPath.toString(), params: {}, path: router, candidate: true));
      }
    }
    ret.add(HRouterConfig(name: uri.path, params: uri.queryParameters, path: path!, candidate: false));
    return ret;
  }

  @override
  RouteInformation? restoreRouteInformation(List<HRouterConfig> configuration) {
    var last = configuration.last;
    var uri = Uri(path: last.name, queryParameters: last.params);
    return RouteInformation(location: uri.toString());
  }

  @override
  Future<void> setNewRoutePath(List<HRouterConfig> configuration) async {
    for (var item in configuration) {
      _history.add(HRouterHistory(
        candidate: item.candidate,
        name: item.name,
        path: item.path,
        params: {...item.params},
      ));
    }
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = [];
    for (var item in buildHistory) {
      pages.add(buildPage(context, item));
    }
    if (pages.isEmpty) {
      return SizedBox();
    }
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _history.removeWhere((element) {
          if (route.settings.arguments is HRouterHistory) {
            var arguments = route.settings.arguments as HRouterHistory;
            if (arguments.pageKey == element.pageKey) {
              if (!element.result.isCompleted) {
                element.result.complete(result);
              }
              element.data?.dispose();
              return true;
            }
            if (element.path.isSub(arguments.path.path)) {
              if (!element.result.isCompleted) {
                element.result.complete(null);
              }
              element.data?.dispose();
              return true;
            }
          }

          return false;
        });

        notifyListeners();
        return true;
      },
    );
  }

  set routers(List<HPath> value) {
    _routers = value;
    _routers.sort((a, b) => b.path.compareTo(a.path));
  }

  Future<F?> pushName<F>(String name, {Map<String, String>? params}) async {
    var path = _findPath(name);
    if (null == path) {
      throw "Not fond Router by $name";
    }

    for (var item in _paresPath(Uri(path: name, queryParameters: params))) {
      if (!checkHistory(item)) {
        _history.add(HRouterHistory(
          candidate: item.candidate,
          name: item.name,
          path: item.path,
          params: {...item.params},
        ));
      }
    }

    var history = _history.last;
    notifyListeners();
    return await history.result.future;
  }

  Future<F?> pushNamedAndRemoveUntil<F>(String name, HRouteWhere where, {Map<String, String>? params}) async {
    historyList.removeWhere((element) {
      if (where.call(element.path)) {
        if (!element.result.isCompleted) {
          element.result.complete(null);
        }
        element.data?.dispose();
        return true;
      }
      return false;
    });
    return await pushName<F>(name, params: params);
  }

  void popUntil(HRouteWhere where) {
    historyList.removeWhere((element) {
      if (where.call(element.path)) {
        if (!element.result.isCompleted) {
          element.result.complete(null);
        }
        element.data?.dispose();
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  void pop<T extends Object>(T? result) {
    if (historyList.isNotEmpty) {
      var last = historyList.last;
      historyList.removeLast();
      if (!last.result.isCompleted) {
        last.result.complete(result);
      }
      last.data?.dispose();
    }
    notifyListeners();
  }

  bool checkHistory(HRouterConfig config) {
    for (var item in _history) {
      if (config.candidate && item.path == config.path) {
        return true;
      }
    }
    return false;
  }

  HPath? _findPath(String path) {
    for (var item in _routers) {
      if (item.hasMatch(path)) {
        return item;
      }
    }
    return null;
  }

  Future<bool> didPopRoute() async {
    if (historyList.isNotEmpty) {
      var last = historyList.last;
      // for (final WillPopCallback callback in List<WillPopCallback>.from(last._willPopCallbacks)) {
      //   if (await callback() != true) return true;
      // }

      historyList.removeLast();
      if (!last.result.isCompleted) {
        last.result.complete(null);
      }
      last.data?.dispose();
    }
    notifyListeners();

    if (historyList.isEmpty) {
      return false;
    }
    return true;
  }
}
