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
        style: HFormStyle(
          labelSize: {lg: 4},
          childSize: {lg: 18},
          count: 24,
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                HFormField(
                  label: const Text("Username:"),
                  builder: (context, field) {
                    return TextField();
                  },
                ),
                HSwitchField(
                  label: const Text("HSwitchField"),
                ),
                HRadioField(
                  label: const Text("HRadioField"),
                  items: <HRadioItem<int>>{
                    const HRadioItem(value: 1, text: "111"),
                    const HRadioItem(value: 2, text: "222"),
                  },
                ),
                HCheckBoxField(
                  label: const Text("HRadioField"),
                  items: <HCheckBoxItem<int>>{
                    const HCheckBoxItem(value: 1, text: "111"),
                    const HCheckBoxItem(value: 2, text: "222"),
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
          );
        },
      ),
    );
  }
}
