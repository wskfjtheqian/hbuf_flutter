import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class PageHSize extends StatelessWidget {
  const PageHSize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HSize"),
      ),
      body: Container(
        child: Wrap(
          children: [
            HSize(
              style: context.defaultSize.copyWith(maxHeight: 100, minHeight: 50, sizes: {lg: 12}),
              child: ColoredBox(color: Colors.red),
            ),
            HSize(
              style: context.defaultSize.copyWith(maxHeight: 100, minHeight: 50, sizes: {lg: 12}),
              child: ColoredBox(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
