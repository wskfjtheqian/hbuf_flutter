import 'package:flutter/material.dart';
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
              HMenuButton(),
              Spacer(),
              HMenuButton(),
            ],
          ),
        ),
      ),
    );
  }
}
