import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_button.dart';

class PageHButton extends StatelessWidget {
  const PageHButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HButton"),
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
                  HButton(
                    style: context.defaultButton.copyWith(),
                    child: Text("默认按钮"),
                  ),
                  HButton(
                    style: context.brandButton.copyWith(),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.successButton.copyWith(),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.infoButton.copyWith(),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.warningButton.copyWith(),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.dangerButton.copyWith(),
                    child: const Text("危险按钮"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HButton(
                    style: context.defaultButton.copyWith(
                      plain: true,
                    ),
                    child: Text("默认按钮"),
                  ),
                  HButton(
                    style: context.brandButton.copyWith(
                      plain: true,
                    ),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.successButton.copyWith(
                      plain: true,
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.infoButton.copyWith(
                      plain: true,
                    ),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.warningButton.copyWith(
                      plain: true,
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.dangerButton.copyWith(
                      plain: true,
                    ),
                    child: const Text("危险按钮"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HButton(
                    style: context.defaultButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: Text("默认按钮"),
                  ),
                  HButton(
                    style: context.brandButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.successButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.infoButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.warningButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.dangerButton.copyWith(
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("危险按钮"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HButton(
                    style: context.defaultButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.search),
                  ),
                  HButton(
                    style: context.brandButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.edit_note),
                  ),
                  HButton(
                    style: context.successButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.check),
                  ),
                  HButton(
                    style: context.infoButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.mail_outline),
                  ),
                  HButton(
                    style: context.warningButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.star_border),
                  ),
                  HButton(
                    style: context.dangerButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(Icons.delete_forever_outlined),
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
