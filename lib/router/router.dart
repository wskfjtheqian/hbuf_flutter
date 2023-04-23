import 'package:flutter/widgets.dart';
import 'package:hbuf_flutter/router/path.dart';

import 'delegate.dart';

typedef HRouterBuilder = Widget Function(BuildContext context, HRouterDelegate delegate);

class HSubRouter extends StatefulWidget {
  final String prefix;

  const HSubRouter({Key? key, required this.prefix}) : super(key: key);

  @override
  State<HSubRouter> createState() => _HSubRouterState<HSubRouter>();
}

class _HSubRouterState<T extends HSubRouter> extends State<T> {
  final HBaseDelegate _baseDelegate = HBaseDelegate();

  HBaseDelegate? _parent;

  HBaseDelegate get delegate => _baseDelegate;

  @override
  void initState() {
    _parent = context.findAncestorStateOfType<_HSubRouterState>()?.delegate;
    delegate.parent = _parent;
    delegate.prefix = widget.prefix;
    _parent?.addSubRouterDelegate(delegate);
    delegate.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _parent?.removeSubRouterDelegate(delegate);
    delegate.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    var parent = context.findAncestorStateOfType<_HSubRouterState>()?.delegate;
    if (_parent != parent) {
      _parent?.removeSubRouterDelegate(delegate);
      _parent = parent;
      delegate.parent = _parent;
      _parent?.addSubRouterDelegate(delegate);
    }
    delegate.prefix = widget.prefix;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Router(routerDelegate: delegate);
  }
}

class HRouter extends HSubRouter {
  final String home;

  final Set<HPath> routers;

  final HRouterBuilder builder;

  const HRouter({
    Key? key,
    required this.builder,
    required this.home,
    required this.routers,
  }) : super(key: key, prefix: "");

  @override
  State<HRouter> createState() => HRouterState();

  static HRouterState of(BuildContext context) {
    return context.findAncestorStateOfType<HRouterState>()!;
  }
}

class HRouterState extends _HSubRouterState<HRouter> with WidgetsBindingObserver {
  final HRouterDelegate _delegate = HRouterDelegate();

  @override
  HRouterDelegate get delegate => _delegate;

  @override
  Future<bool> didPopRoute() {
    return _delegate.didPopRoute();
  }

  @override
  void initState() {
    _delegate.routers = widget.routers.toList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HRouter oldWidget) {
    _delegate.routers = widget.routers.toList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _delegate);
  }

  Future<F?> pushName<F>(String name, {Map<String, dynamic>? params}) {
    return _delegate.pushName<F>(name, params: params?.map((key, value) => MapEntry(key, value?.toString() ?? "")));
  }

  Future<F?> pushNamedAndRemoveUntil<F>(String name, HRouteWhere where, {Map<String, dynamic>? params}) {
    return _delegate.pushNamedAndRemoveUntil<F>(name, where, params: params?.map((key, value) => MapEntry(key, value?.toString() ?? "")));
  }

  void popUntil(HRouteWhere where) {
    return _delegate.popUntil(where);
  }

  void pop<T extends Object>(T? result) {
    return _delegate.pop(result);
  }
}
