import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_cascader.dart';
import 'package:hbuf_flutter/widget/h_color.dart';
import 'package:hbuf_flutter/widget/h_select.dart';

class PageHSelect extends StatelessWidget {
  const PageHSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HSelect"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            HSelect<int>(
              toText: (context, value) => value.toString(),
              builder: (BuildContext context) {
                return [const HCascaderText<int>(value: 1, child: Text("data"))];
              },
              value: {},
            ),
            HSelect<int>(
              toText: (context, value) => value.toString(),
              builder: (BuildContext context) {
                return [
                  const HCascaderText<int>(value: 1, child: Text("data")),
                  const HCascaderText<int>(value: 2, child: Text("data")),
                  const HCascaderText<int>(value: 8, child: Text("data")),
                  const HCascaderText<int>(value: 3, child: Text("data")),
                  const HCascaderText<int>(value: 4, child: Text("data")),
                  const HCascaderText<int>(value: 5, child: Text("data")),
                  const HCascaderText<int>(value: 6, child: Text("data")),
                  const HCascaderText<int>(value: 7, child: Text("data")),
                ];
              },
              limit: 10,
              value: {},
            ),
          ],
        ),
      ),
    );
  }
}
