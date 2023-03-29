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
                  ),
                  HLink(
                    style: context.brandLink.copyWith(),
                    child: const Text("主要按钮"),
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
                    child: const Text("警告按钮"),
                  ),
                  HLink(
                    style: context.dangerLink.copyWith(),
                    child: const Text("危险按钮"),
                  ),
                ],
              ),
            ),
            //
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Wrap(
            //     spacing: 8,
            //     runSpacing: 8,
            //     children: [
            //       HLink(
            //         style: context.defaultLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //         ),
            //         child: Icon(Icons.search),
            //       ),
            //       HLink(
            //         style: context.defaultLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //           color: MaterialStatePropertyAll(context.brandColor),
            //         ),
            //         child: Icon(Icons.edit_note),
            //       ),
            //       HLink(
            //         style: context.defaultLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //           color: MaterialStatePropertyAll(context.successColor),
            //         ),
            //         child: Icon(Icons.check),
            //       ),
            //       HLink(
            //         style: context.mediumLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //           color: MaterialStatePropertyAll(context.infoColor),
            //         ),
            //         child: Icon(Icons.mail_outline),
            //       ),
            //       HLink(
            //         style: context.smallLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //           color: MaterialStatePropertyAll(context.warningColor),
            //         ),
            //         child: Icon(Icons.star_border),
            //       ),
            //       HLink(
            //         style: context.miniLink.copyWith(
            //           shape: MaterialStatePropertyAll(CircleBorder()),
            //           color: MaterialStatePropertyAll(context.dangerColor),
            //         ),
            //         child: Icon(Icons.delete_forever_outlined),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
