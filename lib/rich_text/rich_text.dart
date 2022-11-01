import 'package:flutter/material.dart';
import 'package:hbuf_flutter/rich_text/controller.dart';

class RichTextField extends StatefulWidget {
  final String html;

  const RichTextField({
    Key? key,
    required this.html,
  }) : super(key: key);

  @override
  _RichTextFieldState createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  late RichTextEditingController _controller;

  @override
  void initState() {
    _controller = RichTextEditingController.html(html: widget.html);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButtonTheme(
          data: const TextButtonThemeData(
            style: ButtonStyle(
              visualDensity: VisualDensity(),
              minimumSize: MaterialStatePropertyAll(Size(45, 45)),
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
            ),
          ),
          child: Wrap(
            children: [
              OutlinedButton(
                onPressed: () {
                  _controller.setColor(color: Colors.indigoAccent);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            maxLines: 100,
          ),
        ),
        const Text("data")
      ],
    );
  }
}
