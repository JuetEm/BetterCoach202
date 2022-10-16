import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'baseTableCalendar.dart';

class GlobalFunction {
  GlobalFunction();

  bool textNullCheck(
    BuildContext context,
    TextEditingController checkController,
    String controllerName,
  ) {
    bool notEmpty = true;
    if (!checkController.text.isNotEmpty) {
      print("${controllerName} is Empty");
      notEmpty = !notEmpty;

      // 로그인 성공
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${controllerName} 항목을 입력 해주세요."),
      ));
    }

    return notEmpty;
  }

  void getDateFromCalendar(
      BuildContext context, TextEditingController customController) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BaseTableCalendar()),
    );

    if (!(result == null)) {
      String formatedDate = DateFormat("yyyy-MM-dd")
          .format(DateTime(result.year, result.month, result.day));

      customController.text = formatedDate;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("등록일 : ${formatedDate}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("등록일을 선택해주세요."),
      ));
    }
  }
}
