import 'package:example/page/page_h_button.dart';
import 'package:example/page/page_h_layout.dart';
import 'package:example/page/page_h_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HTheme(
      child: MaterialApp(
        title: 'Syncfusion DataGrid Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageHSize();
              }));
            },
            child: const Text("HSize"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageHLayout();
              }));
            },
            child: const Text("PageHLayout"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageHButton();
              }));
            },
            child: const Text("PageHButton"),
          ),
        ],
      ),
    );
  }
}
