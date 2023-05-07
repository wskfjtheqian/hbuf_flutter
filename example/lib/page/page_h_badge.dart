import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_badge.dart';
import 'package:hbuf_flutter/widget/h_button.dart';
import 'package:hbuf_flutter/widget/h_color.dart';

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
                spacing: 16,
                runSpacing: 16,
                children: [
                  HBadge(
                    style: context.dotBadge,
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
                      child: const Text("默认按钮"),
                    ),
                  ),
                  HBadge(
                    style: context.defaultBadge.copyWith(
                      color: context.brandColor,
                    ),
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
                      child: const Text("默认按钮"),
                    ),
                  ),
                  HBadge(
                    style: context.defaultBadge.copyWith(
                      color: context.successColor,
                    ),
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
                      child: const Text("默认按钮"),
                    ),
                  ),
                  HBadge(
                    style: context.defaultBadge.copyWith(
                      color: context.warningColor,
                    ),
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
                      child: const Text("默认按钮"),
                    ),
                  ),
                  HBadge(
                    style: context.defaultBadge.copyWith(
                      color: context.dangerColor,
                    ),
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
                      child: const Text("默认按钮"),
                    ),
                  ),
                  HBadge(
                    style: context.defaultBadge.copyWith(
                      color: context.infoColor,
                    ),
                    value: 99,
                    child: HButton(
                      style: context.defaultButton.copyWith(),
                      onTap: () async {},
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
