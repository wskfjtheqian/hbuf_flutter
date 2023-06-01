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
          builder: (BuildContext context) {
            return [
              HCascaderText<int>(
                value: 1,
                child: Text("HCascaderItem1"),
              ),
              HCascaderText<int>(
                value: 2,
                child: Text("HCascaderItem2"),
              ),
              HCascaderText<int>(
                value: 3,
                child: Text("HCascaderItem3"),
              ),
              HCascaderText<int>(
                value: 4,
                child: Text("HCascaderItem4"),
              ),
              HCascaderText<int>(
                value: 5,
                child: Text("HCascaderItem5"),
                builder: (context) {
                  return [
                    HCascaderText<int>(
                      value: 6,
                      child: Text("HCascaderItem6"),
                      builder: (context) {
                        return [
                          HCascaderText<int>(
                            value: 7,
                            child: Text("HCascaderItem7"),
                          ),
                          HCascaderText<int>(
                            value: 8,
                            child: Text("HCascaderItem8"),
                          ),
                          HCascaderText<int>(
                            value: 9,
                            child: Text("HCascaderItem9"),
                          ),
                          HCascaderText<int>(
                            value: 10,
                            child: Text("HCascaderItem10"),
                          ),
                          HCascaderText<int>(
                            value: 11,
                            child: Text("HCascaderItem11"),
                          ),
                        ];
                      },
                    ),
                    HCascaderText<int>(
                      value: 12,
                      child: Text("HCascaderItem12"),
                    ),
                    HCascaderText<int>(
                      value: 13,
                      child: Text("HCascaderItem13"),
                    ),
                    HCascaderText<int>(
                      value: 14,
                      child: Text("HCascaderItem14"),
                    ),
                    HCascaderText<int>(
                      value: 15,
                      child: Text("HCascaderItem15"),
                    ),
                    HCascaderText<int>(
                      value: 16,
                      child: Text("HCascaderItem16"),
                    ),
                  ];
                },
              ),
              HCascaderText<int>(
                value: 17,
                child: Text("HCascaderItem"),
              ),
              HCascaderText<int>(
                value: 18,
                child: Text("HCascaderItem"),
              ),
              HCascaderText<int>(
                value: 19,
                child: Text("HCascaderItem"),
              ),
              HCascaderText<int>(
                value: 20,
                child: Text("HCascaderItem"),
              ),
            ];
          },
          value: {},
          onChange: (Set<dynamic> value) {},
        ),
      ),
    );
  }
}
