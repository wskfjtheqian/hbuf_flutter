import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color_picker.dart';

class PageHColorSelect extends StatefulWidget {
  const PageHColorSelect({Key? key}) : super(key: key);

  @override
  _PageHColorSelectState createState() => _PageHColorSelectState();
}

class _PageHColorSelectState extends State<PageHColorSelect> {
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
          Wrap(
            spacing: 8,
            children: [
              HColorButton(
                style: context.defaultColorButton,
              ),
              HColorButton(
                style: context.mediumColorButton,
              ),
              HColorButton(
                style: context.smallColorButton,
              ),
              HColorButton(
                style: context.miniColorButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
