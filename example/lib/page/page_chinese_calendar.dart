import 'package:flutter/material.dart';
import 'package:hbuf_flutter/calendar/calendar_select.dart';
import 'package:hbuf_flutter/calendar/calendar_utils.dart';
import 'package:hbuf_flutter/calendar/calendar_view.dart';
import 'package:hbuf_flutter/hbuf_flutter.dart';

class PageChineseCalendar extends StatefulWidget {
  const PageChineseCalendar({Key? key}) : super(key: key);

  @override
  _PageChineseCalendarState createState() => _PageChineseCalendarState();
}

class _PageChineseCalendarState extends State<PageChineseCalendar> {
  @override
  Widget build(BuildContext context) {
    var id = HRouteModel.of(context).getString("id");
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text("日历控件"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BasePage();
              }));
            },
          ),
          ListTile(
            title: const Text("选择日期范围"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SelelctDatePage();
              }));
            },
          ),
          ListTile(
            title: const Text("选择日期对话框"),
            onTap: () {
              showSelectDateRangePicker(context, initDateTime: DateTime.now());
            },
          ),
        ],
      ),
    );
  }
}

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  CalendarInfo? _clickInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24),
            child: CalendarView(
              initDateTime: DateTime.now(),
              builderItem: _builderItem,
            ),
          ),
          const Text(""),
          Text("${_clickInfo?.solarDate?.toString()?.substring(0, 10)}"),
          Text("${_clickInfo?.lunarYearName}年${_clickInfo?.lunarMonthName}${_clickInfo?.lunarDayName}"),
          Text("${_clickInfo?.animal}"),
          Text("${_clickInfo?.astro}"),
          Text("${_clickInfo?.term}"),
          Text("${_clickInfo?.festival}"),
          Text("${_clickInfo?.lunarFestival}"),
        ],
      ),
    );
  }

  Widget _builderItem(CalendarInfo info, Widget child, int month) {
    if (null != _clickInfo && 0 == CalendarUtils.compareDate(_clickInfo!.solarDate, info.solarDate)) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: child,
      );
    }

    return InkWell(
      child: child,
      onTap: () {
        setState(() {
          _clickInfo = info;
        });
      },
    );
  }
}

class SelelctDatePage extends StatefulWidget {
  @override
  _SelelctDatePageState createState() => _SelelctDatePageState();
}

class _SelelctDatePageState extends State<SelelctDatePage> {
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: CalendarSelect(
              initDateTime: DateTime.now(),
              showOtherDay: true,
              showLunary: false,
              onSelect: (start, end) {
                setState(() {
                  _start = start;
                  _end = end;
                });
              },
            ),
          ),
          Text(""),
          Text("开始 ${_start?.toString()?.substring(0, 10)}"),
          Text("结束 ${_end?.toString()?.substring(0, 10)}"),
        ],
      ),
    );
  }
}
