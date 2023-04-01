import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_link.dart';

class PageHLink extends StatelessWidget {
  const PageHLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HLink"),
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
                  HLink(
                    style: context.defaultLink.copyWith(),
                    child: Text("默认按钮"),
                    onTap: () async {},
                  ),
                  HLink(
                    style: context.brandLink.copyWith(),
                    child: const Text("主要按钮"),
                    onTap: () async {
                      await Future.delayed(const Duration(seconds: 5));
                    },
                  ),
                  HLink(
                    style: context.successLink.copyWith(),
                    child: const Text("成功按钮"),
                  ),
                  HLink(
                    style: context.infoLink.copyWith(),
                    child: const Text("信息按键"),
                  ),
                  HLink(
                    style: context.warningLink.copyWith(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber),
                        const Text("警告按钮"),
                      ],
                    ),
                  ),
                  HLink(
                    style: context.dangerLink.copyWith(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.dangerous_outlined),
                        const Text("危险按钮"),
                      ],
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
