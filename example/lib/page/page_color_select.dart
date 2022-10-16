import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/color_select.dart';

class PageColorSelect extends StatefulWidget {
  const PageColorSelect({Key? key}) : super(key: key);

  @override
  _PageColorSelectState createState() => _PageColorSelectState();
}

class _PageColorSelectState extends State<PageColorSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Select")),
      body: Container(
        height: 300,
        width: 300,
        margin: EdgeInsets.all(50),

        child: ColorSelect(color: Color(0xff000000),),
      ),
    );
  }
}
