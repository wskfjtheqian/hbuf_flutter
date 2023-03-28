import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

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
                    style: context.defaultButton.copyWith(
                    ),
                    child: Text("默认按钮"),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                    ),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.mediumButton.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                    ),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.smallButton.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.miniButton.copyWith(
                      color: MaterialStatePropertyAll(context.dangerColor),
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
                      plain: true,
                    ),
                    child: Text("默认按钮"),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                      plain: true,
                    ),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                      plain: true,
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.mediumButton.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                      plain: true,
                    ),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.smallButton.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                      plain: true,
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.miniButton.copyWith(
                      color: MaterialStatePropertyAll(context.dangerColor),
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
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("主要按钮"),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HButton(
                    style: context.mediumButton.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("信息按键"),
                  ),
                  HButton(
                    style: context.smallButton.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                      shape: MaterialStatePropertyAll(StadiumBorder()),
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HButton(
                    style: context.miniButton.copyWith(
                      color: MaterialStatePropertyAll(context.dangerColor),
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
                    style: context.defaultButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      color: MaterialStatePropertyAll(context.brandColor),
                    ),
                    child: Icon(Icons.edit_note),
                  ),
                  HButton(
                    style: context.defaultButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      color: MaterialStatePropertyAll(context.successColor),
                    ),
                    child: Icon(Icons.check),
                  ),
                  HButton(
                    style: context.mediumButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      color: MaterialStatePropertyAll(context.infoColor),
                    ),
                    child: Icon(Icons.mail_outline),
                  ),
                  HButton(
                    style: context.smallButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      color: MaterialStatePropertyAll(context.warningColor),
                    ),
                    child: Icon(Icons.star_border),
                  ),
                  HButton(
                    style: context.miniButton.copyWith(
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      color: MaterialStatePropertyAll(context.dangerColor),
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
