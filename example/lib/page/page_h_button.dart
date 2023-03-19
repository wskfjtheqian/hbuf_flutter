import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_border.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_size.dart';

class PageHButton extends StatelessWidget {
  const PageHButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HButton"),
      ),
      body: Container(
        child: Wrap(
          children: [
            HButton(
              style: context.buttonStyle.copyWith(
                maxHeight: 100,
                minHeight: 100,
                sizes: {lg: 12},
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                color: Colors.red,
                border: HBorder.all(dash: [8, 8],width: 4),
                borderRadius: BorderRadius.circular(16)
              ),
              child: const Text("HButton"),
            ),
          ],
        ),
      ),
    );
  }
}
