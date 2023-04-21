import 'package:flutter/widgets.dart';

import 'delegate.dart';

typedef HCheckRouter = bool Function();
typedef HRouterBuilder = Function(BuildContext context);

class HSubRouter extends StatefulWidget {
  final HCheckRouter? checkRouter;
  final HRouterBuilder? backgroundBuilder;

  const HSubRouter({
    Key? key,
    this.checkRouter,
    this.backgroundBuilder,
  }) : super(key: key);

  static _HSubRouterState? of(BuildContext context) {
    return context.findAncestorStateOfType<_HSubRouterState>();
  }

  @override
  _HSubRouterState createState() => _HSubRouterState<HBaseRouterDelegate, HSubRouter>(HBaseRouterDelegate());
}

class _HSubRouterState<E extends HBaseRouterDelegate, T extends HSubRouter> extends State<T> {
  final E _delegate;
  _HSubRouterState? _routerState;

  _HSubRouterState(this._delegate);

  @override
  void initState() {
    _routerState = context.findAncestorStateOfType<_HSubRouterState>();
    if (null != _routerState) {
      _delegate.parent = _routerState!._delegate;
      _routerState!._addSubRouterDelegate(_delegate);
    }
    _delegate.checkRouter = widget.checkRouter ?? _checkRouter;
    _delegate.backgroundBuilder = widget.backgroundBuilder;
    super.initState();
  }

  @override
  void dispose() {
    _routerState?._removeSubRouterDelegate(_delegate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    _delegate._checkRouter = oldWidget.checkRouter ?? _checkRouter;
    _delegate._backgroundBuilder = oldWidget.backgroundBuilder;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Router(routerDelegate: _delegate);
  }

  void _addSubRouterDelegate(HBaseRouterDelegate delegate) {
    _delegate.addSubRouterDelegate(delegate);
  }

  void _removeSubRouterDelegate(HBaseRouterDelegate delegate) {
    _delegate.removeSubRouterDelegate(delegate);
  }

  Future<F?> pushNamed<F>(
    String name, {
    Map<String, dynamic>? params,
  }) {
    return _routerState!.pushNamed(name, params: params);
  }

  Future<F?> pushNamedAndRemoveUntil<F>(
    String path, {
    HRouteWhere? where,
    Map<String, dynamic>? params,
  }) {
    return _routerState!.pushNamedAndRemoveUntil(path, where: where, params: params);
  }

  void pop<F>([F? result]) {
    return _routerState!.popUntil((routerData) {
      return _delegate._checkRouter(routerData.path, routerData.params);
    });
  }

  void popUntil(HCheckRouter predicate) {
    return _routerState!.popUntil(predicate);
  }

  Size? get size {
    return context.findRenderObject()?.paintBounds.size;
  }
}

class HRouter extends HSubRouter {
  final Widget Function(BuildContext context, AppRouterDelegate appRouter) builder;
  final List<AutoPath> routers;
  final String? home;

  const HRouter({
    Key? key,
    required this.builder,
    required this.routers,
    this.home,
    RouterBuilder? backgroundBuilder,
  }) : super(
          key: key,
          prefixPath: home,
          backgroundBuilder: backgroundBuilder,
        );

  static AutoRouterState of(BuildContext context) {
    if (context is StatefulElement && context.state is _HSubRouterState) {
      return context.state as AutoRouterState;
    }

    return context.findAncestorStateOfType<AutoRouterState>()!;
  }

  @override
  AutoRouterState createState() => AutoRouterState(AppRouterDelegate._());
}

class AutoRouterState extends _HSubRouterState<AppRouterDelegate, HRouter> with WidgetsBindingObserver {
  AutoRouterState(AppRouterDelegate delegate) : super(delegate);

  String _home = WidgetsBinding.instance.window.defaultRouteName;

  bool hashRouter(HashRoute hashRoute) {
    return _delegate.hashRouter(hashRoute);
  }

  void addListener(VoidCallback listener) {
    return _delegate.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    return _delegate.removeListener(listener);
  }

  @override
  Future<bool> didPopRoute() {
    return _delegate.didPopRoute();
  }

  @override
  void initState() {
    if (null != widget.home) {
      _home = widget.home!;
    }
    _delegate._provider = PlatformRouteInformationProvider(initialRouteInformation: RouteInformation(location: _home));
    _delegate._routers = widget.routers;
    _delegate._backgroundBuilder = widget.backgroundBuilder;
    _delegate._routers.sort((a, b) => b.path.compareTo(a.path));

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HRouter oldWidget) {
    _delegate._routers = widget.routers;
    _delegate._backgroundBuilder = widget.backgroundBuilder;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _delegate);
  }

  @override
  Future<T?> pushNamed<T extends Object>(String name, {Map<String, dynamic>? params}) {
    return _delegate.pushNamed(name, params);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object>(String path, {AutoRoutePredicate? predicate, Map<String, dynamic>? params}) {
    return _delegate.pushNamedAndRemoveUntil<T>(path, predicate, params);
  }

  @override
  void pop<T extends Object>([T? result]) {
    _delegate.pop(result);
  }

  @override
  void popUntil(AutoRoutePredicate predicate) {
    return _delegate.popUntil(predicate);
  }
}
