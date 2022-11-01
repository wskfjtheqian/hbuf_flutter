import 'package:flutter/material.dart';
import 'package:hbuf_flutter/rich_text/rich_text.dart';

class PageRichText extends StatefulWidget {
  const PageRichText({Key? key}) : super(key: key);

  @override
  _PageRichTextState createState() => _PageRichTextState();
}

class _PageRichTextState extends State<PageRichText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RichText"),
      ),
      body: Container(
        child: RichTextField(
          html: ''
              '<html><head></head><body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!</a>'
              '<img src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.huabanimg.com%2F298913890e6272eacccc4045516ee423214eb6a19d52b-1rrvdP_fw658&refer=http%3A%2F%2Fhbimg.huabanimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1669540622&t=49aed042ec37d4cad7ef830fce009707" width="100" height="100">'
              '</body>'
              '</html>'
              '',
        ),
      ),
    );
  }
}
