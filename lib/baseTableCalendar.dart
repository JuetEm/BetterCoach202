import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_service.dart';
import 'color.dart';
import 'globalWidget.dart';
import 'memberAdd.dart';

class BaseTableCalendar extends StatefulWidget {
  const BaseTableCalendar(
      {super.key, required this.pageName, required this.eventList});

  final String pageName;
  final List<dynamic> eventList;

  @override
  State<BaseTableCalendar> createState() => _BaseTableCalendarState();
}

class _BaseTableCalendarState extends State<BaseTableCalendar> {
  // 달력 보여주는 형식
  CalendarFormat calendarFormat = CalendarFormat.month;

  // 선택된 날짜
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarService>(
      builder: (context, calendarService, child) {
        return Scaffold(
          appBar: widget.pageName == "수업 보기"
              ? null
              : BaseAppBarMethod(context, "${widget.pageName} 선택", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MemberAdd()),
                  );
                }),
          body: widget.pageName == "수업 보기"
              ? Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      tableCalendarMethod(widget.eventList),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      tableCalendarMethod(widget.eventList),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                              "등록일 : ${focusedDate.year}-${focusedDate.month}-${focusedDate.day}"),
                        ),
                      ),

                      /// 추가 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Palette.buttonOrange,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("${widget.pageName} 선택",
                              style: TextStyle(fontSize: 18)),
                        ),
                        onPressed: () {
                          calendarService.setDate(
                            DateTime(
                              focusedDate.year,
                              focusedDate.month,
                              focusedDate.day,
                            ),
                          );
                          // 저장하기 성공시 MemberAdd로 이동
                          Navigator.pop(
                              context, calendarService.currentSelectedDate());
                        },
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }

  TableCalendar<dynamic> tableCalendarMethod(List<dynamic> eventList) {
    return TableCalendar(
      focusedDay: focusedDate,
      firstDay: DateTime.now().subtract(Duration(days: 365 * 10 + 2)),
      lastDay: DateTime.now().add(Duration(days: 365 * 10 + 2)),
      calendarFormat: calendarFormat,
      onFormatChanged: ((format) {
        setState(() {
          calendarFormat = format;
        });
      }),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
          focusedDate = focusedDay;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDate, day);
      },
      eventLoader: (day) {
        return eventList;
      },
    );
  }
}
