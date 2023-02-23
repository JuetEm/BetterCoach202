import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:web_project/app/ui/ticketLibraryMake.dart';
import 'package:web_project/app/ui/lessonAdd.dart';

import 'calendar_service.dart';
import 'color.dart';
import 'globalWidget.dart';
import 'app/ui/memberAdd.dart';
import 'app/ui/ticketLibraryMake.dart';

TicketLibraryMake ticketMake = TicketLibraryMake((){},null);

class BaseTableCalendar extends StatefulWidget {
  const BaseTableCalendar(
    this.customFunction,
    this.isHideAppbar, {
    super.key,
    required this.selectedDate,
    required this.pageName,
    required this.eventList,
  });

  final customFunction;
  final bool isHideAppbar;
  final String selectedDate;
  final String pageName;
  final List<dynamic> eventList;

  @override
  State<BaseTableCalendar> createState() => _BaseTableCalendarState();
}

class _BaseTableCalendarState extends State<BaseTableCalendar> {
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
        return Scaffold(
          appBar: widget.isHideAppbar
              ? null
              : BaseAppBarMethod(context, "${widget.pageName} 선택", () {
                  Navigator.pop(context);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => MemberAdd()),
                  // );
                }, null, null),
          body: widget.pageName == "노트편집"
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      tableCalendarMethod(widget.eventList),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            "${widget.pageName} : ${focusedDate.year}-${focusedDate.month}-${focusedDate.day}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      /// 추가 버튼
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.all(0),
                            elevation: 0,
                            backgroundColor: Palette.buttonOrange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 100),
                            child: Text("${widget.pageName} 선택",
                                style: TextStyle(fontSize: 16)),
                          ),
                          onPressed: () {
                            if (widget.pageName == "수강 시작일") {
                              print("수강 시작일");
                              ticketStartDate =
                                  "${focusedDate.year}-${focusedDate.month}-${focusedDate.day}";
                              ticketStartDate =
                                  DateFormat("yyyy-MM-dd").format(focusedDate);
                              ticketStartDateController.text = ticketStartDate!;
                              calendarIsOffStaged = true;
                              widget.customFunction();
                            } else if (widget.pageName == "수강 종료일") {
                              print("수강 종료일");
                              ticketEndDate =
                                  "${focusedDate.year}-${focusedDate.month}-${focusedDate.day}";
                              ticketEndDate =
                                  DateFormat("yyyy-MM-dd").format(focusedDate);
                              ticketEndDateController.text = ticketEndDate!;
                              calendarIsOffStaged = true;
                              widget.customFunction();
                            } else {
                              calendarService.setDate(
                                DateTime(
                                  focusedDate.year,
                                  focusedDate.month,
                                  focusedDate.day,
                                ),
                              );
                              // 저장하기 성공시 MemberAdd로 이동
                              Navigator.pop(context,
                                  calendarService.currentSelectedDate());
                            }
                          })
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
          selectedDateIn = selectedDay;
          focusedDate = focusedDay;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDateIn, day);
      },
      eventLoader: (day) {
        return eventList;
      },
    );
  }
}
