import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/h_cascader.dart';

class PageHCascader extends StatelessWidget {
  const PageHCascader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HCascader"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: HCascader<int>(
          minWidth: 50,
          builder: (BuildContext context) {
            return [
              HCascaderItem<int>(
                value: 1,
                child: Text("HCascaderItem1"),
              ),
              HCascaderItem<int>(
                value: 2,
                child: Text("HCascaderItem2"),
              ),
              HCascaderItem<int>(
                value: 3,
                child: Text("HCascaderItem3"),
              ),
              HCascaderItem<int>(
                value: 4,
                child: Text("HCascaderItem4"),
              ),
              HCascaderItem<int>(
                value: 5,
                child: Text("HCascaderItem5"),
                builder: (context) {
                  return [
                    HCascaderItem<int>(
                      value: 6,
                      child: Text("HCascaderItem6"),
                      builder: (context) {
                        return [
                          HCascaderItem<int>(
                            value: 7,
                            child: Text("HCascaderItem7"),
                          ),
                          HCascaderItem<int>(
                            value: 8,
                            child: Text("HCascaderItem8"),
                          ),
                          HCascaderItem<int>(
                            value: 9,
                            child: Text("HCascaderItem9"),
                          ),
                          HCascaderItem<int>(
                            value: 10,
                            child: Text("HCascaderItem10"),
                          ),
                          HCascaderItem<int>(
                            value: 11,
                            child: Text("HCascaderItem11"),
                          ),
                        ];
                      },
                    ),
                    HCascaderItem<int>(
                      value: 12,
                      child: Text("HCascaderItem12"),
                    ),
                    HCascaderItem<int>(
                      value: 13,
                      child: Text("HCascaderItem13"),
                    ),
                    HCascaderItem<int>(
                      value: 14,
                      child: Text("HCascaderItem14"),
                    ),
                    HCascaderItem<int>(
                      value: 15,
                      child: Text("HCascaderItem15"),
                    ),
                    HCascaderItem<int>(
                      value: 16,
                      child: Text("HCascaderItem16"),
                    ),
                  ];
                },
              ),
              HCascaderItem<int>(
                value: 17,
                child: Text("HCascaderItem"),
              ),
              HCascaderItem<int>(
                value: 18,
                child: Text("HCascaderItem"),
              ),
              HCascaderItem<int>(
                value: 19,
                child: Text("HCascaderItem"),
              ),
              HCascaderItem<int>(
                value: 20,
                child: Text("HCascaderItem"),
              ),
            ];
          },
          maxWidth: 200,
          value: {},
          onChange: (Set<dynamic> value) {},
        ),
      ),
    );
  }
}
