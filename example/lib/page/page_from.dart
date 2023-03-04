import 'package:flutter/material.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class PageFrom extends StatefulWidget {
  /// Creates the home page.
  const PageFrom({Key? key}) : super(key: key);

  @override
  _PageFromState createState() => _PageFromState();
}

class _PageFromState extends State<PageFrom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("From"),
      ),
      body: Form(
        child: Column(
          children: [
            ImageFormField(
              maxCount: 4,
              onAdd: (context, field, width, height, {extensions}) async {},
              outWidth: 300,
              outHeight: 300,
            ),
            FileFormField(
              onAdd: (context, field, {extensions}) async {},
            ),
            DateTimeFormField(),
          ],
        ),
      ),
    );
  }
}
