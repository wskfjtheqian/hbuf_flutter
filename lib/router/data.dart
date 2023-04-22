import 'path.dart';

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
}
