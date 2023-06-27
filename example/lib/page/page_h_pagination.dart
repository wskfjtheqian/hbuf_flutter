import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_color.dart';
import 'package:hbuf_flutter/widget/h_pagination.dart';

class PageHPagination extends StatelessWidget {
  const PageHPagination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HPagination"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            HPagination(
              total: 2000,
              limit: 50,
              offset: 0,
              onChange: (int offset, int limit) {
                print("offset $offset, limit $limit");
              },
            ),
          ],
        ),
      ),
    );
  }
}
