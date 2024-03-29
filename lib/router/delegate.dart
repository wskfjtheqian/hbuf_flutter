import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

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
    for (var i = 0; i < buildHistory.length; i++) {
      pages.add(buildPage(context, buildHistory[i], i == buildHistory.length - 1));
    }
    if (pages.isEmpty) {
      return const SizedBox();
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
  }

  void removeSubRouterDelegate(HBaseDelegate delegate) {
    _subDelegate.remove(delegate);
    _parent?.removeSubRouterDelegate(delegate);
  }

  Page buildPage(BuildContext context, HRouterHistory history, bool isFast) {
    return HPage(
      key: history.pageKey,
      name: history.path.path,
      arguments: history,
      child: Offstage(
        offstage: !isFast,
        child: HRouteModel(
          history: history,
          child: history.path.builder(context),
        ),
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
    createBuildHistory();
    super.notifyListeners();
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
      if (router.autoCreate && path!.path != router.path && 0 == path.path.indexOf(router.path)) {
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

  Page buildPage(BuildContext context, HRouterHistory history, bool isFast) {
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

  @override
  void addSubRouterDelegate(HBaseDelegate delegate) {
    super.addSubRouterDelegate(delegate);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => notifyListeners());
  }

  @override
  void removeSubRouterDelegate(HBaseDelegate delegate) {
    super.removeSubRouterDelegate(delegate);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => notifyListeners());
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    for (var item in _subDelegate) {
      item.notifyListeners();
    }
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
      pages.add(buildPage(context, item, true));
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

    return await _push<F>(name, params);
  }

  bool hashRouter<F>(String name, {Map<String, String>? params}) {
    if (_history.isNotEmpty) {
      var uri = Uri(path: name, queryParameters: params ?? {});
      var ret = _history.last.uri.toString() == uri.toString();
      return ret;
    }
    return false;
  }

  Future<F?> pushOrActivationNamed<F>(String name, {Map<String, String>? params}) async {
    var path = _findPath(name);
    if (null == path) {
      throw "Not fond Router by $name";
    }

    var uri = Uri(path: name, queryParameters: params ?? {});
    var index = _history.indexWhere((element) {
      return element.uri.toString() == uri.toString();
    });
    if (-1 != index) {
      var temp = _history[index];
      _history.removeAt(index);
      _history.add(temp);
      notifyListeners();
      return null;
    }
    return await _push<F>(name, params);
  }

  Future<F?> _push<F>(String name, Map<String, String>? params) async {
    var list = _paresPath(Uri(path: name, queryParameters: params));
    for (var item in list) {
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
    var path = _findPath(name);
    if (null == path) {
      throw "Not fond Router by $name";
    }

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

    return await _push<F>(name, params);
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
      if (item.uri.toString() == config.uri.toString()) {
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
