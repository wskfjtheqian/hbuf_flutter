import 'package:example/page/page_chinese_calendar.dart';
import 'package:example/page/page_color_select.dart';
import 'package:example/page/page_from.dart';
import 'package:example/page/page_menu_bar.dart';
import 'package:example/page/page_particle_1.dart';
import 'package:example/page/page_rich_text.dart';
import 'package:example/page/page_router.dart';
import 'package:flutter/material.dart';
import 'package:hbuf_flutter/router/delegate.dart';
import 'package:hbuf_flutter/router/path.dart';
import 'package:hbuf_flutter/router/router.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HRouter(
      home: "/",
      routers: {
        HPath("/", (context) => PageInit()),
        HPath("/home", (context) => PageHome()),
        HPath("/home/calendar/:id", (context) => const PageChineseCalendar()),
        HPath("/home/color", (context) => const PageColorSelect()),
        HPath("/home/form", (context) => const PageFrom()),
        HPath("/home/menu", (context) => const PageMenuBar()),
        HPath("/home/particle1", (context) => const PageParticle1()),
        HPath("/home/rich_text", (context) => const PageRichText()),
        HPath("/home/router/:id", (context) => const PageRouter()),
        HPath("/home/router/:id/1", (context) => const PageRouter1()),
        HPath("/home/router/:id/2", (context) => const PageRouter2()),
      },
      builder: (context, HRouterDelegate delegate) {
        return MaterialApp.router(
          routerDelegate: delegate,
          routeInformationParser: delegate,
          title: 'Syncfusion DataGrid Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
        );
      },
    );
  }
}

class PageInit extends StatefulWidget {
  const PageInit({Key? key}) : super(key: key);

  @override
  State<PageInit> createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hbuf flutter")),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ListView(
              children: [
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushName("/home");
                  },
                  child: const Text("chinese calendar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageHome extends StatefulWidget {
  /// Creates the home page.
  PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Hbuf flutter")),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ListView(
              children: [
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushNamedAndRemoveUntil(
                      "/home/calendar/123",
                      (path) => path.isSub("/home"),
                      params: {"name": "name"},
                    );
                  },
                  child: const Text("chinese calendar"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushNamedAndRemoveUntil(
                      "/home/form",
                      (path) => path.isSub("/home"),
                      params: {"name": "name"},
                    );
                  },
                  child: const Text("from"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushNamedAndRemoveUntil(
                      "/home/menu",
                      (path) => path.isSub("/home"),
                      params: {"name": "name"},
                    );
                  },
                  child: const Text("MenuBar"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushName("/home/particle1");
                  },
                  child: const Text("Particle1"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushName("/home/color");
                  },
                  child: const Text("Color Select"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushName("/home/rich_text");
                  },
                  child: const Text("Rich Text"),
                ),
                TextButton(
                  onPressed: () {
                    HRouter.of(context).pushName("/home/router/12");
                  },
                  child: const Text("Multi-level routing"),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width > 600)
            Expanded(
              child: Theme(
                data: theme = Theme.of(context).copyWith(
                  appBarTheme: theme.appBarTheme.copyWith(
                    color: Colors.white,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                ),
                child: HSubRouter(
                  prefix: "/home",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
