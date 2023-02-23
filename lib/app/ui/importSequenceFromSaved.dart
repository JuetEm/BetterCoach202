import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';

class ImportSequenceFromSaved extends StatefulWidget {
  const ImportSequenceFromSaved({super.key});

  @override
  State<ImportSequenceFromSaved> createState() =>
      _ImportSequenceFromSavedState();
}

class _ImportSequenceFromSavedState extends State<ImportSequenceFromSaved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, "시퀀스 불러오기", null, null, null),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          /// 헤더
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(children: [
              Text(
                '시퀀스 제목',
                style: TextStyle(
                    fontSize: 20,
                    color: Palette.gray00,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text('편집',
                  style: TextStyle(
                      fontSize: 20,
                      color: Palette.textBlue,
                      fontWeight: FontWeight.bold))
            ]),
          ),

          /// 리스트들이 뿌려지는 영역
          Expanded(
              child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Text('리스트 $index');
            },
          ))
        ]),
      ),
    );
  }
}
