import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_project/app/data/model/color.dart';

class FaqExpansionTile extends StatelessWidget {
  const FaqExpansionTile({
    Key? key,
    required this.title,
    required this.childText,
    this.isButtonDisabled = true,
    this.customFunctionOnPressed,
  }) : super(key: key);
  final String title;
  final String childText;
  final bool isButtonDisabled;
  final Function? customFunctionOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ExpansionTile(
        textColor: Palette.textOrange,
        iconColor: Palette.buttonOrange,
        collapsedBackgroundColor: Palette.mainBackground,
        backgroundColor: Palette.mainBackground,
        title: Text('$title'),
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('$childText'),
          ),
          Offstage(
            offstage: isButtonDisabled,
            child: Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextButton(
                    child: Text(
                      '탈퇴',
                      style: TextStyle(color: Palette.textRed),
                    ),
                    onPressed: () {
                      customFunctionOnPressed!();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}




// showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('정말로 계정을 탈퇴하시겠습니끼?'),
//                             content: Text('탈퇴된 계정은 데이터가 삭제되고 복구가 불가능합니다.'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   print('완전탈퇴 is Clicked');
//                                 },
//                                 child: Text(
//                                   '탈퇴',
//                                   style: TextStyle(color: Palette.textRed),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   print('탈퇴취소 is Clicked');
//                                 },
//                                 child: Text(
//                                   '취소',
//                                   style: TextStyle(color: Palette.gray00),
//                                 ),
//                               )
//                             ],
//                           );
//                         },
//                       );

//                       print('탈퇴버튼 is clicked.');