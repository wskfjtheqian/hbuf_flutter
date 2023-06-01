import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_cascader.dart';
import 'package:hbuf_flutter/widget/h_menu.dart';

class PageHMenu extends StatelessWidget {
  const PageHMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HMenu"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HMenuButton<int>(
                builder: (BuildContext context) {
                  return [const HCascaderText<int>(value: 1, child: Text("data"))];
                },
                value: {},
                child: const Text("data"),
              ),
              Spacer(),
              HMenuButton<int>(
                builder: (BuildContext context) {
                  return [const HCascaderText<int>(value: 1, child: Text("data"))];
                },
                value: {},
                child: const Text("data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
