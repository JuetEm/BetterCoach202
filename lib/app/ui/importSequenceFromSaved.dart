import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/actionInfo.dart';

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
      body: Column(
        children: [
          /// 헤더
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    fontSize: 16,
                    color: Palette.textBlue,
                  ))
            ]),
          ),

          /// 리스트들이 뿌려지는 영역
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {});
              },
              physics: BouncingScrollPhysics(),
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  selected: false,
                  onTap: () {
                    setState(() {});
                  },
                  selectedColor: Palette.gray66,
                  selectedTileColor: Palette.secondaryBackground,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Palette.grayEE, width: 1),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  key: ValueKey(index),
                  tileColor: Palette.mainBackground,
                  visualDensity: VisualDensity(vertical: -4),
                  title: Text(
                    'Abs Training $index',
                    style: TextStyle(fontSize: 14, color: Palette.gray00),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'CA',
                        style: TextStyle(fontSize: 12, color: Palette.gray99),
                      ),
                      SizedBox(width: 6),
                      Text('Supine',
                          style: TextStyle(fontSize: 12, color: Palette.gray99))
                    ],
                  ),
                  trailing: Icon(Icons.drag_handle),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
