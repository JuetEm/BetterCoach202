import 'package:flutter/material.dart';

class CalendarService extends ChangeNotifier {
  DateTime? selectedDate = null;

  DateTime? currentSelectedDate() {
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
  }

  setDate(DateTime date) {
    selectedDate = date;
    notifyListeners(); // 상태 변경 알림
  }

  DateTime? getDate() {
    return selectedDate;
  }
}
