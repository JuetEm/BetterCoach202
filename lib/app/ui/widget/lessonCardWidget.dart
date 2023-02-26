import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/data/model/userInfo.dart';

class LessonCardWidget extends StatelessWidget {
  const LessonCardWidget({
    Key? key,
    required this.userInfo,
    required this.memberId,
    required this.lessonDate,
    required this.todayNote,
    required this.lessonActionList,
  }) : super(key: key);

  final UserInfo userInfo;
  final String memberId;
  final String lessonDate;
  final String todayNote;
  final List lessonActionList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.mainBackground,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            /// 수업일 입력창
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Palette.gray99,
                ),
                SizedBox(width: 10),

                /// 새로 도전하는 수업일 입력창
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                    child: Text(
                      '${lessonDate}',
                      style: TextStyle(
                          color: Palette.gray00, fontWeight: FontWeight.bold),
                      /* validator:
                                                                      _model.textControllerValidator.asValidator(context), */
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 0),

            /// 일별 메모 입력창
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Icon(
                    Icons.text_snippet_outlined,
                    color: Palette.gray99,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 86,
                  child: todayNote == ""
                      ? Text(
                          '-',
                          style: TextStyle(color: Palette.gray99, fontSize: 14),
                        )
                      : Text(
                          '$todayNote',
                          style: TextStyle(color: Palette.gray00, fontSize: 14),
                        ),
                ),
              )
            ]),

            const SizedBox(height: 20),

            /// 동작별 메모 (New)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Icon(
                      Icons.accessibility_new_rounded,
                      color: Palette.gray99,
                    ),
                  ],
                ),

                /// 동작별 메모 한 묶음.
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: lessonActionList.length,
                      itemBuilder: (context, index) {
                        Key? valueKey;
                        lessonActionList[index]['pos'] = index;
                        valueKey = ValueKey(lessonActionList[index]['pos']);

                        final doc = lessonActionList[index];

                        print("bbbbbbbb - doc : ${doc}");

                        String uid = doc['uid']; // 강사 고유번호

                        String name = doc['name']; //회원이름
                        String phoneNumber =
                            doc['phoneNumber']; // 회원 고유번호 (전화번호로 회원 식별)
                        String apratusName = doc['apratusName']; //기구이름
                        String actionName = doc['actionName']; //동작이름
                        String lessonDate = doc['lessonDate']; //수업날짜
                        String grade = doc['grade']; //수행도
                        String totalNote = doc['totalNote']; //수업총메모
                        int pos = doc['pos']; //수업총메모
                        bool isSelected = doc['selected'];

                        return Offstage(
                          key: valueKey,
                          offstage: !isSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Chip(
                                    label: Text("$actionName"),
                                    deleteIcon: Icon(
                                      Icons.close_sharp,
                                      size: 16,
                                    ),
                                    onDeleted: () {},
                                  )),
                              Text(
                                totalNote,
                                style: TextStyle(
                                    color: Palette.gray00, fontSize: 14),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
