import 'package:fixnum/fixnum.dart';
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

class HRouteModel extends StatefulWidget {
  final Widget child;

  final HRouterHistory history;

  const HRouteModel({Key? key, required this.child, required this.history}) : super(key: key);

  @override
  State<HRouteModel> createState() => _HRouteModelState();

  static _HRouteModelState of(BuildContext context) {
    return context.findAncestorStateOfType<_HRouteModelState>()!;
  }
}

class _HRouteModelState extends State<HRouteModel> {
  HRouterHistory get history => widget.history;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  bool isSub(String prefix) {
    return history.path.isSub(prefix);
  }

  String? getString(String key) {
    return history.params[key];
  }

  int? getInt(key) {
    return null == history.params[key] ? null : num.tryParse(history.params[key]!)?.toInt();
  }

  Int64? getInt64(key) {
    return null == history.params[key] ? null : Int64.tryParseInt(history.params[key]!);
  }

  bool? getBool(key) {
    return null == history.params[key] ? null : history.params[key] == "true";
  }

  DateTime? getDateTime(key) {
    return null == history.params[key] ? null : DateTime.tryParse(history.params[key]!);
  }
}

abstract class HRouterData extends ValueNotifier<bool> {
  bool _isDispose = false;

  HRouterData() : super(false);

  Future<void> init(BuildContext context);

  bool get isDispose => _isDispose;

  @override
  void dispose() {
    if (!_isDispose) {
      super.dispose();
      _isDispose = true;
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (!_isDispose) {
      super.addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (!_isDispose) {
      super.removeListener(listener);
    }
  }

  @override
  set value(bool newValue) {
    if (!_isDispose) {
      super.value = newValue;
    }
  }

  @override
  void notifyListeners() {
    if (!_isDispose) {
      super.notifyListeners();
    }
  }
}

abstract class RouterDataWidgetState<T extends StatefulWidget, E extends HRouterData> extends State<T> {
  HRouterHistory? _history;

  E? initData(BuildContext context);

  E? get data {
    return context.findAncestorStateOfType<_HRouteModelState>()?.history?.data as E?;
  }

  @override
  void initState() {
    _history = context.findAncestorStateOfType<_HRouteModelState>()?.history;
    if (null != _history) {
      if (!_history!.isInitData) {
        _history!.isInitData = true;
        _history!.data = initData(context);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _history!.data?.init(context);
        });
      }
      _history!.data?.addListener(_onListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _history?.data?.removeListener(_onListener);
  }

  @override
  Widget build(BuildContext context) {
    if (null == data || data!.value) {
      return buildContent(context);
    }
    return buildInit(context);
  }

  Widget buildInit(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
    );
  }

  Widget buildContent(BuildContext context);

  void _onListener() {
    setState(() {});
  }
}
