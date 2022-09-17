import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/menu_bar.dart';

class PageMenuBar extends StatelessWidget {
  const PageMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MenuBar"),
      ),
      body: const MenuBar(
        alignment: Alignment.centerRight,
        children: [
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MenuBarItem(
            child: Text(
              "button1",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
