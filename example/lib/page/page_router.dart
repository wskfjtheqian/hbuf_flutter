import 'package:flutter/material.dart';
import 'package:hbuf_flutter/router/router.dart';
import 'package:hbuf_flutter/router/widget.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-level routing"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  HRouter.of(context).pushNamedAndRemoveUntil(
                    "/home/router/1",
                    (path) => path.isSub("/home/router"),
                    params: {"name": "name"},
                  );
                },
                child: Text("Page 1"),
              ),
              TextButton(
                onPressed: () {
                  HRouter.of(context).pushNamedAndRemoveUntil(
                    "/home/router/2",
                    (path) => path.isSub("/home/router"),
                    params: {"name": "name"},
                  );
                },
                child: Text("Page 2"),
              ),
            ],
          ),
          const Expanded(
            child: HSubRouter(
              prefix: '/home/router',
            ),
          ),
        ],
      ),
    );
  }
}

class PageRouter1 extends StatefulWidget {
  const PageRouter1({Key? key}) : super(key: key);

  @override
  State<PageRouter1> createState() => _PageRouter1State();
}

class _PageRouter1State extends State<PageRouter1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HRouteModel.of(context).isSub("/home/router")
          ? null
          : AppBar(
              title: const Text("Page1"),
            ),
      body: Container(
        color: Colors.orange,
      ),
    );
  }
}

class PageRouter2 extends StatefulWidget {
  const PageRouter2({Key? key}) : super(key: key);

  @override
  State<PageRouter2> createState() => _PageRouter2State();
}

class _PageRouter2State extends State<PageRouter2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HRouteModel.of(context).isSub("/home/router")
          ? null
          : AppBar(
              title: const Text("Page2"),
            ),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
