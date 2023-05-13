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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HPopupMenuButton<int>(
                    itemBuilder: (BuildContext context) {
                      return [
                        const HPopupMenuItem<int>(
                          child: Text("1"),
                          value: 1,
                        ),
                      ];
                    },
                    initialValue: {},
                    onChanged: (value) {
                      print(value);
                    },
                    child: Text("默认按钮"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
