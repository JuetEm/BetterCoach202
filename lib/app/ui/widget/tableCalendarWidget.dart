import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:web_project/app/data/provider/calendar_service.dart';

class TableCalendarWidget extends StatefulWidget {
  TableCalendarWidget({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

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
    return Consumer<CalendarService>(
        builder: (context, calendarService, child) {
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
        // calendarIsOffStaged = true;
      );
    });
  }
}
