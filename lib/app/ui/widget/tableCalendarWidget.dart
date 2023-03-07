import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/data/model/event.dart';
import 'package:web_project/app/data/provider/calendar_service.dart';
import 'package:web_project/app/data/provider/daylesson_service.dart';
import 'package:web_project/app/ui/page/memberInfo.dart';

List docForCal = [];

class TableCalendarWidget extends StatefulWidget {
  TableCalendarWidget({
    Key? key,
    required this.selectedDate,
    required this.eventSource,
  }) : super(key: key);

  final Map<DateTime, dynamic> eventSource;
  final String selectedDate;
  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  // 달력 보여주는 형식
  CalendarFormat calendarFormat = CalendarFormat.month;
  // 선택된 날짜
  DateTime selectedDateIn = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDate = DateTime.now();

  @override
  void initState() {
    if (widget.selectedDate == "") {
      selectedDateIn = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
    } else {
      // DateTime selectedDateIn;
      selectedDateIn = new DateFormat('yyyy-MM-dd').parse(widget.selectedDate);
    }

    print(
        "[GF] getDateFromCalendar - selectedDateIn 선택날짜 / ${selectedDateIn.toString()}");
    focusedDate = selectedDateIn;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarService, DayLessonService>(
        builder: (context, calendarService, dayLessonService, child) {
      widget.eventSource.isEmpty
          ? dayLessonService
              .readTodayNoteForCal(userInfo.uid, userInfo.docId)
              .then((value) {
              // 잡았다 요놈!!
              docForCal = [];
              docForCal.addAll(value);
              docForCal.forEach((element) {
                // print("kliohuikutydfklgjhjyhrts - 0 - element['name'] : ${element['name']}, element['lessonDate'] : ${element['lessonDate']}");
                var dt = DateTime.parse(element['lessonDate']);
                widget.eventSource[DateTime(dt.year, dt.month, dt.day)] = [
                  Event(element['name'], element['lessonDate'])
                ];
                dayLessonService.notifyListeners();
                // print("kliohuikutydfklgjhjyhrts - 0 - dt : ${dt}, eventSource : ${eventSource}");
              });
            })
          : null;
      return TableCalendar(
        focusedDay: focusedDate,
        firstDay: DateTime.now().subtract(Duration(days: 365 * 10 + 2)),
        lastDay: DateTime.now().add(Duration(days: 365 * 10 + 2)),
        calendarFormat: calendarFormat,
        calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Palette.titleOrange,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Palette.buttonOrange,
              shape: BoxShape.circle,
            ),
            markerSize: 10.0,
            markerDecoration: BoxDecoration(
              color: Palette.buttonOrange,
              shape: BoxShape.circle,
            )),
        onFormatChanged: ((format) {
          setState(() {
            calendarFormat = format;
          });
        }),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDateIn = selectedDay;
            focusedDate = focusedDay;
          });
          calendarService.setDate(
            DateTime(
              focusedDate.year,
              focusedDate.month,
              focusedDate.day,
            ),
          );
          // 저장하기 성공시 MemberAdd로 이동
          //  calendarService.currentSelectedDate());
        },
        selectedDayPredicate: (day) {
          return isSameDay(selectedDateIn, day);
        },
        eventLoader: (day) {
          return getEventFroDay(
              day,
              widget
                  .eventSource); // [{DateTime.now() : Event("고두심", DateTime.now().toString())}];//
        },
        // calendarIsOffStaged = true;
      );
    });
  }
}

List<Event> getEventFroDay(DateTime day, Map<DateTime, dynamic> events) {
  // print("kliohuikutydfklgjhjyhrts - 1 - events[${DateTime(day.year, day.month, day.day)}] : ${events[DateTime(day.year, day.month, day.day)]} , events : ${events}");
  return events[DateTime(day.year, day.month, day.day)] ?? [];
}
