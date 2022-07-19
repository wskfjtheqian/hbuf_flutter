import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hbuf_flutter/tables/tables.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;
  final String name;
  final String designation;
  final int salary;
}

class _MyHomePageState extends State<MyHomePage> {
  var list = [
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 15000),
    Employee(10005, 'Martin', 'Developer', 15000),
    Employee(10006, 'Newberry', 'Developer', 15000),
    Employee(10007, 'Balnc', 'Developer', 15000),
    Employee(10008, 'Perry', 'Developer', 15000),
    Employee(10009, 'Gable', 'Developer', 15000),
    Employee(10010, 'Grimes', 'Developer', 15000),
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 15000),
    Employee(10005, 'Martin', 'Developer', 15000),
    Employee(10006, 'Newberry', 'Developer', 15000),
    Employee(10007, 'Balnc', 'Developer', 15000),
    Employee(10008, 'Perry', 'Developer', 15000),
    Employee(10009, 'Gable', 'Developer', 15000),
    Employee(10010, 'Grimes', 'Developer', 15000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tables<Employee>(
        rowCount: list.length,
        headerColor: Colors.deepOrangeAccent,
        alignment: Alignment.centerLeft,
        headerLean: VerticalLean.top,
        padding: EdgeInsets.all(4),
        rowBuilder: (context, y) {
          return TablesRow(
            data: list[y],
            // color: (1 == (y % 2)) ? const Color(0xffaaaaff) : const Color(0xffaaffaa),
          );
        },
        border: Border.all(color: const Color(0xffaaaaaa)),
        columns: [
          TablesColumn<Employee>(
            width: ColumnWidth( max: 90),
            lean: HorizontalLean.left,
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Id"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: Text("${data.id}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Name"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: SelectableText("${data.name}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Designation"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: Text("${data.designation}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Id"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: Text("${data.id}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Name"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: SelectableText("${data.name}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),
            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Designation"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(child: Text("${data.designation}"));
            },
          ),
          TablesColumn<Employee>(
            width: ColumnWidth( min: 200),

            headerBuilder: (BuildContext context) {
              return const TablesCell(child: Text("Salary"));
            },
            cellBuilder: (context, int x, int y, Employee data) {
              return TablesCell(
                child: InkWell(
                  child: Text("${data.salary}"),
                  onTap: () {
                    print("object");
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
