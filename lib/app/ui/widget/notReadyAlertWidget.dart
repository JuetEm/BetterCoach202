import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_project/app/data/model/color.dart';

class NotReadyAlertWidget extends StatelessWidget {
  const NotReadyAlertWidget({
    Key? key,
    required this.featureName,
  });
  final String featureName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(featureName),
      content: Text('$featureName 기능은 곧 업데이트 예정입니다.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('확인', style: TextStyle(color: Palette.textBlue)),
        )
      ],
    );
  }
}
