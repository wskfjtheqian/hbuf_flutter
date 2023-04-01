import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_border.dart';

class PageHBorder extends StatelessWidget {
  const PageHBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HBorder"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.thinBorderSide)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.defaultBorderSide)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.wideBorderSide)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.thinDashBorderSide)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.defaultDashBorderSide)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(border: HBorder(bottom: context.wideDashBorderSide)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
