import 'dart:async';

import 'data.dart';

class HHistoryRouter {
  final Completer result = Completer.sync();

  HRouterData? _data;

  HRouterData? get data => _data;
}
