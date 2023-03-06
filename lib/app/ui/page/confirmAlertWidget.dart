import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_project/app/data/model/color.dart';

class ConfirmAlertWidget extends StatelessWidget {
  const ConfirmAlertWidget({
    Key? key,
    required this.titleText,
    required this.contentText,
    required this.confirmButtonText,
    this.cancelButtonText = '취소',
    this.confirmButtonColor = Palette.textBlue,
    this.cancelButtonColor = Palette.textRed,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  /// 타이틀, 내용
  final String titleText;
  final String contentText;

  /// 버튼 이름
  final String confirmButtonText;
  final String cancelButtonText;

  /// 텍스트 버튼 컬러
  final Color confirmButtonColor;
  final Color cancelButtonColor;
  final Function onConfirm;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm();
            print('$confirmButtonText is Clicked');
          },
          child: Text(
            confirmButtonText,
            style: TextStyle(color: confirmButtonColor),
          ),
        ),
        TextButton(
          onPressed: () {
            onCancel();
            print('$cancelButtonText is Clicked');
          },
          child: Text(
            cancelButtonText,
            style: TextStyle(color: cancelButtonColor),
          ),
        )
      ],
    );
  }
}
