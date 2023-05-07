import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

class PageHFrom extends StatefulWidget {
  /// Creates the home page.
  const PageHFrom({Key? key}) : super(key: key);

  @override
  _PageHFromState createState() => _PageHFromState();
}

class _PageHFromState extends State<PageHFrom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HFrom"),
      ),
      body: HForm(
        labelSize: HSizeStyle(sizes: {lg: 4}),
        childSize: HSizeStyle(sizes: {lg: 18}),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HFormField(
                label: const Text("Username:"),
                builder: (context, field) {
                  return TextField();
                },
              ),
              HFormField(
                builder: (context, field) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        HButton(
                          style: context.defaultButton.copyWith(
                            color: MaterialStatePropertyAll(context.brandColor),
                          ),
                          child: Text("Save"),
                          onTap: () async {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
