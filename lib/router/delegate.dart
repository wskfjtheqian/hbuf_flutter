import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/router/path.dart';

import 'data.dart';
import 'history.dart';

typedef HRouteWhere = Function();

class HBaseRouterDelegate extends RouterDelegate<List<HRouterData>> with ChangeNotifier {
  final List<HBaseRouterDelegate> _usbDelegates = [];

  HBaseRouterDelegate? _parent;

  set parent(HBaseRouterDelegate? value) {
    _parent = value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setNewRoutePath(List<HRouterData> configuration) {}
}

class HRouterDelegate extends HBaseRouterDelegate with PopNavigatorRouterDelegateMixin<List<HRouterData>> implements RouteInformationParser<List<HRouterData>> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<HHistoryRouter> _history = [];

  List<HRouterPath> _routers = [];

  set routers(List<HRouterPath> value) {
    _routers = value;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;


  HRouterPath? _findPath(String path) {
    for (var item in _routers) {
      if (item.hasPath(path)) {
        return item;
      }
    }
    return null;
  }

  Future<T?> pushNamed<T>(String name, Map<String, dynamic>? params) async {
    var router = _findPath(name);
    if (null == router) {
      throw "Not fond Router by $name";
    }

    params ??= {};
    var list = name.split("/");
    for (var item in router.keys.entries) {
      if (params.containsKey(item.key)) {
        throw "Router $name and params repetitive key : ${item.key}";
      }
      params[item.key] = list[item.value];
    }
    var history = await _addHistoryList(_paresPath(name, params));
    return await history!.result.future;
  }

  Future<T?> pushNamedAndRemoveUntil<T>(String name, HRouteWhere? where, Map<String, dynamic>? params) async {
    _history.removeWhere((element) {
      if (where?.call(element._routerData) ?? false) {
        if (!element.result.isCompleted) {
          element.result.complete(null);
        }
        element.data?.dispose();
        return true;
      }
      return false;
    });
    return await pushNamed(name, params);
  }

  void popUntil(HRouteWhere predicate) {
    _history.removeWhere((element) {
      if (predicate.call(element._routerData)) {
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
    if (_history.isNotEmpty) {
      var last = _history.last;
      _history.removeLast();
      if (!last.result.isCompleted) {
        last.result.complete(result);
      }
      last.data?.dispose();
    }
    notifyListeners();
  }

  @override
  Future<List<HRouterData>> parseRouteInformation(RouteInformation routeInformation) {
    var uri = Uri.parse(routeInformation.location!);

  }


  @override
  Future<List<HRouterData>> parseRouteInformationWithDependencies(RouteInformation routeInformation, BuildContext context) {
    // TODO: implement parseRouteInformationWithDependencies
    throw UnimplementedError();
  }

  @override
  RouteInformation? restoreRouteInformation(List<HRouterData> configuration) {
    // TODO: implement restoreRouteInformation
    throw UnimplementedError();
  }


}
