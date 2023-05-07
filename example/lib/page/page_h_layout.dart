import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_border.dart';
import 'package:hbuf_flutter/widget/h_layout.dart';

class PageHLayout extends StatelessWidget {
  const PageHLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HLayout"),
      ),
      body: Container(
        child: Wrap(
          children: [
            HLayout(
              style: context.defaultLayout.copyWith(
                maxHeight: 100,
                minHeight: 100,
                sizes: {lg: 12},
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                color: Colors.red,
                border: HBorder.all(dash: [8, 8], width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text("HLayout"),
            ),
          ],
        ),
      ),
    );
  }
}
