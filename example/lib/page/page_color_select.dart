import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color_picker.dart';

class PageColorSelect extends StatefulWidget {
  const PageColorSelect({Key? key}) : super(key: key);

  @override
  _PageColorSelectState createState() => _PageColorSelectState();
}

class _PageColorSelectState extends State<PageColorSelect> {
  Color? _color = Colors.green;

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
            child: HColorSelect(
              color: HSVColor.fromColor(Color(0xff000000)),
              changed: (HSVColor color) {},
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: HColorBox(color: HSVColor.fromColor(_color!)),
          ),
          TextButton(
            onPressed: () async {
              var color = await showSelectHColorPicker(context, color: Colors.green);
              if (null != _color) {
                setState(() {
                  _color = color;
                });
              }
            },
            child: Text("选择颜色"),
          )
        ],
      ),
    );
  }
}
