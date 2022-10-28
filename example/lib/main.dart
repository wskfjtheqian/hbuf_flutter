import 'package:example/page/page_chinese_calendar.dart';
import 'package:example/page/page_color_select.dart';
import 'package:example/page/page_from.dart';
import 'package:example/page/page_menu_bar.dart';
import 'package:example/page/page_particle_1.dart';
import 'package:example/page/page_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
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
                return const PageChineseCalendar();
              }));
            },
            child: const Text("chinese calendar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageFrom();
              }));
            },
            child: const Text("from"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageMenuBar();
              }));
            },
            child: const Text("MenuBar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageParticle1();
              }));
            },
            child: const Text("Particle1"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageColorSelect();
              }));
            },
            child: const Text("Color Select"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return const PageRichText();
              }));
            },
            child: const Text("Rich Text"),
          ),
        ],
      ),
    );
  }
}
