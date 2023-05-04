import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_badge.dart';
import 'package:hbuf_flutter/widget/h_button.dart';

class PageHBadge extends StatelessWidget {
  const PageHBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HBadge"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HBadge(
                    decoration:  BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    value: 505,
                    padding: EdgeInsets.all(0),
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {
                      },
                      child: const Text("默认按钮"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
