import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/auto_layout.dart';

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
      body: AutoLayout(
        child: ColoredBox(
          child: Text("adfasd"),
          color: Colors.blue,
        ),
        maxHeight: 80,
        sizes: {
          400: 24,
          800: 12,
        },
      ),
    );
  }
}
