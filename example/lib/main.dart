import 'package:example/page/page_color_select.dart';
import 'package:example/page/page_h_badge.dart';
import 'package:example/page/page_h_border.dart';
import 'package:example/page/page_h_button.dart';
import 'package:example/page/page_h_cascader.dart';
import 'package:example/page/page_h_from.dart';
import 'package:example/page/page_h_layout.dart';
import 'package:example/page/page_h_link.dart';
import 'package:example/page/page_h_menu.dart';
import 'package:example/page/page_h_pagination.dart';
import 'package:example/page/page_h_select.dart';
import 'package:example/page/page_h_size.dart';
import 'package:example/page/page_h_tag.dart';
import 'package:flutter/material.dart';
import 'package:hbuf_flutter/generated/l10n.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HTheme(
      child: HRouter(
        home: "/",
        routers: {
          HPath("/", (context) => const PageInit()),
          HPath("/home", (context) => PageHome()),
          HPath("/home/size", (context) => const PageHSize()),
          HPath("/home/layout", (context) => const PageHLayout()),
          HPath("/home/border", (context) => const PageHBorder()),
          HPath("/home/button", (context) => const PageHButton()),
          HPath("/home/link", (context) => const PageHLink()),
          HPath("/home/tag", (context) => const PageHTag()),
          HPath("/home/badge", (context) => const PageHBadge()),
          HPath("/home/from", (context) => const PageHFrom()),
          HPath("/home/color", (context) => const PageHColorSelect()),
          HPath("/home/menu", (context) => const PageHMenu()),
          HPath("/home/cascader", (context) => const PageHCascader()),
          HPath("/home/pagination", (context) => const PageHPagination()),
          HPath("/home/select", (context) => const PageHSelect()),

          // HPath("/home/calendar/:id", (context) => const PageChineseCalendar()),
          // HPath("/home/color", (context) => const PageColorSelect()),
          // HPath("/home/form", (context) => const PageFrom()),
          // HPath("/home/menu", (context) => const PageMenuBar()),
          // HPath("/home/particle1", (context) => const PageParticle1()),
          // HPath("/home/rich_text", (context) => const PageRichText()),
          // HPath("/home/router/:id", (context) => const PageRouter()),
          // HPath("/home/router/:id/1", (context) => const PageRouter1()),
          // HPath("/home/router/:id/2", (context) => const PageRouter2()),
        },
        builder: (context, HRouterDelegate delegate) {
          return MaterialApp.router(
            routerDelegate: delegate,
            routeInformationParser: delegate,
            title: 'Syncfusion DataGrid Demo',
            theme: ThemeData(primarySwatch: Colors.blue),
            localizationsDelegates: [
              S.delegate,
            ],
          );
        },
      ),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HRouter.of(context).pushNamedAndRemoveUntil("/home", (route) => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
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
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black87),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: ListView(
                children: [
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/size",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HSize"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/layout",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HLayout"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/border",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HBorder"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/link",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HLink"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/button",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HButton"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/badge",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HBadge"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/tag",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HTag"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/from",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HFrom"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/color",
                        (path) => path.isSub("/home"),
                      );
                    },
                    child: const Text("HColorSelect"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/cascader",
                        (path) => path.isSub("/home"),
                        params: {"name": "name"},
                      );
                    },
                    child: const Text("HCascader"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/pagination",
                        (path) => path.isSub("/home"),
                        params: {"name": "name"},
                      );
                    },
                    child: const Text("HPagination"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/select",
                        (path) => path.isSub("/home"),
                        params: {"name": "name"},
                      );
                    },
                    child: const Text("HSelect"),
                  ),
                  TextButton(
                    onPressed: () {
                      HRouter.of(context).pushNamedAndRemoveUntil(
                        "/home/menu",
                        (path) => path.isSub("/home"),
                        params: {"name": "name"},
                      );
                    },
                    child: const Text("HMenu"),
                  ),
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
                      elevation: 0.5,
                    ),
                  ),
                  child: HSubRouter(
                    prefix: "/home",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
