import 'package:flutter/widgets.dart';

class HPage<T> extends Page<T> {
  final Widget child;

  HPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super();

  @override
  Route<T> createRoute(BuildContext context) {
    return HPageRoute<T>(settings: this);
  }
}

class HPageRoute<T> extends PageRoute<T> {
  HPageRoute({super.settings}) : super();

  @override
  HPage<T> get settings => super.settings as HPage<T>;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return settings.child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;
}
