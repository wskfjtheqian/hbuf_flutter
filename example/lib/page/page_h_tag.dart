import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color.dart';
import 'package:hbuf_flutter/widget/h_tag.dart';

class PageHTag extends StatelessWidget {
  const PageHTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HTag"),
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
                  HTag(
                    style: context.defaultTag.copyWith(),
                    onTap: () async {},
                    child: Text("默认按钮"),
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                    ),
                    onTap: () async {
                      await Future.delayed(const Duration(seconds: 5));
                    },
                    child: const Text("主要按钮"),
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                    ),
                    onTap: () async {},
                    child: const Text("成功按钮"),
                  ),
                  HTag(
                    style: context.mediumTag.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                    ),
                    child: const Text("信息按键"),
                  ),
                  HTag(
                    style: context.smallTag.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HTag(
                    style: context.miniTag.copyWith(
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
                  HTag(
                    style: context.defaultTag.copyWith(
                      plain: true,
                    ),
                    child: Text("默认按钮"),
                    onTap: () async {},
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                      plain: true,
                    ),
                    child: const Text("主要按钮"),
                    onTap: () async {},
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                      plain: true,
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HTag(
                    style: context.mediumTag.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                      plain: true,
                    ),
                    child: const Text("信息按键"),
                  ),
                  HTag(
                    style: context.smallTag.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                      plain: true,
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HTag(
                    style: context.miniTag.copyWith(
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
                  HTag(
                    style: context.defaultTag.copyWith(
                      shape: StadiumBorder(),
                    ),
                    child: Text("默认按钮"),
                    onTap: () async {},
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.brandColor),
                      shape: StadiumBorder(),
                    ),
                    child: const Text("主要按钮"),
                    onTap: () async {},
                  ),
                  HTag(
                    style: context.defaultTag.copyWith(
                      color: MaterialStatePropertyAll(context.successColor),
                      shape: StadiumBorder(),
                    ),
                    child: const Text("成功按钮"),
                  ),
                  HTag(
                    style: context.mediumTag.copyWith(
                      color: MaterialStatePropertyAll(context.infoColor),
                      shape: StadiumBorder(),
                    ),
                    child: const Text("信息按键"),
                  ),
                  HTag(
                    style: context.smallTag.copyWith(
                      color: MaterialStatePropertyAll(context.warningColor),
                      shape: StadiumBorder(),
                    ),
                    child: const Text("警告按钮"),
                  ),
                  HTag(
                    style: context.miniTag.copyWith(
                      color: MaterialStatePropertyAll(context.dangerColor),
                      shape: StadiumBorder(),
                    ),
                    child: const Text("危险按钮"),
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
