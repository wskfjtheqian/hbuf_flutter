import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/color_select.dart';

class PageColorSelect extends StatefulWidget {
  const PageColorSelect({Key? key}) : super(key: key);

  @override
  _PageColorSelectState createState() => _PageColorSelectState();
}

class _PageColorSelectState extends State<PageColorSelect> {
  var _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Select")),
      body: Column(
        children: [
          Container(
            height: 260,
            width: 260,
            margin: EdgeInsets.all(50),
            child: ColorSelect(
              color: Color(0xff000000),
              changed: (HSVColor color) {},
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: ColorBox(color: HSVColor.fromColor(_color)),
          ),
          TextButton(
              onPressed: () {
                showSelectColorPicker(context, color: Colors.green);
              },
              child: Text("选择颜色"))
        ],
      ),
    );
  }
}
