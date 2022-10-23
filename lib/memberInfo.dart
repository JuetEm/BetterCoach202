import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/globalWidgetDashboard.dart';

import 'auth_service.dart';
import 'color.dart';
import 'lessonAdd.dart';
import 'lessonDetail.dart';
import 'lesson_service.dart';
import 'memberAdd.dart';
import 'memberList.dart';
import 'memberUpdate.dart';
import 'member_service.dart';
import 'userInfo.dart';
import 'lessonInfo.dart';

Map<DateTime, dynamic> eventSource = {};
List<DateTime> eventList = [];

String lessonNoteId = "";

int indexCheck = 0;

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;
    // 이름 첫글자 자르기
    String nameFirst = ' ';
    if (userInfo.name.length > 0) {
      nameFirst = userInfo.name.substring(0, 1);
    }

    return Consumer<LessonService>(builder: (context, lessonService, child) {
      // lessonService
      // ignore: dead_code
      return Scaffold(
        backgroundColor: Palette.secondaryBackground,
        appBar: BaseAppBarMethod(context, "회원 관리", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberList(),
              // setting에서 arguments로 다음 화면에 회원 정보 넘기기
              settings: RouteSettings(
                arguments: userInfo,
              ),
            ),
          );
        }),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 11),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 33,
                                      backgroundColor: Palette.grayEE,
                                      child: Text(
                                        nameFirst,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.gray33),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userInfo.name}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      '등록일 : ${userInfo.registerDate}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          //fontWeight: FontWeight.bold,
                                          color: Palette.gray99),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      '${userInfo.phoneNumber}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          //fontWeight: FontWeight.bold,
                                          color: Palette.gray99),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      '등록횟수 : ${userInfo.registerType}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          //fontWeight: FontWeight.bold,
                                          color: Palette.gray99),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: Palette.mainBackground,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Text(
                                            '회원정보',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Palette.gray33,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '운동목표',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Palette.gray66,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              userInfo.goal,
                                              style: TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.bold,
                                                color: Palette.gray99,
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              '통증/상해/병력',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.gray66),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              userInfo.info,
                                              style: TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.bold,
                                                color: Palette.gray99,
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              '체형분석',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Palette.gray66,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              userInfo.note,
                                              style: TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.bold,
                                                color: Palette.gray99,
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              '특이사항',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Palette.gray66,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              userInfo.comment,
                                              style: TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.bold,
                                                color: Palette.gray99,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              elevation: 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: Palette.grayEE,
                                            ),
                                            height: 40,
                                            width: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "수정하기",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Palette.gray66),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            // 회원 운동 카드 선택시 MemberInfo로 이동
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MemberUpdate(),
                                                // GlobalWidgetDashboard(), //
                                                // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                                settings: RouteSettings(
                                                    arguments: userInfo),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(22.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: Palette.mainBackground,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          '레슨노트',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.gray33,
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        FutureBuilder<QuerySnapshot>(
                                          future: lessonService.read(
                                            user.uid,
                                            userInfo.docId,
                                          ),
                                          builder: (context, snapshot) {
                                            final docs = snapshot.data?.docs ??
                                                []; // 문서들 가져오기
                                            if (docs.isEmpty) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                        "동작추가 버튼을 눌러 동작을 추가할 수 있습니다"),
                                                  ),
                                                ],
                                              );
                                            }
                                            return GroupedListView(
                                              shrinkWrap: true,
                                              elements: docs,
                                              groupBy: (element) =>
                                                  element['actionName'],
                                              groupSeparatorBuilder:
                                                  (String value) => InkWell(
                                                onTap: () {
                                                  indexCheck = 0;

                                                  // 회원 운동 카드 선택시 MemberInfo로 이동
                                                  eventList = [];
                                                  List<dynamic> args = [
                                                    userInfo,
                                                    value,
                                                    eventList,
                                                    lessonNoteId,
                                                  ];

                                                  print(
                                                      "args.length : ${args.length}");
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LessonDetail(),
                                                      // GlobalWidgetDashboard(), //
                                                      // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                                      settings: RouteSettings(
                                                          arguments: args),
                                                    ),
                                                  );
                                                },
                                                child: GroupActionContainer(
                                                    actionName: value),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      dynamic ddocs) {
                                                // 달력기능 개발 중
                                                // DateTime eventDate = DateTime.parse(
                                                //     docs['lessonDate'].toString());
                                                // eventList.add(eventDate);

                                                print(
                                                    "indexCheck : ${indexCheck}");

                                                print(
                                                    "docID : ??? , apratusName : ${ddocs['apratusName']}, actionName :${ddocs['actionName']}, lessonDate : ${ddocs['lessonDate']}, grade: ${ddocs['grade']}, totalNote : ${ddocs['totalNote']}");
                                                indexCheck++;

                                                return ActionContainer(
                                                    apratusName:
                                                        ddocs['apratusName'],
                                                    actionName:
                                                        ddocs['actionName'],
                                                    lessonDate:
                                                        ddocs['lessonDate'],
                                                    grade: ddocs['grade'],
                                                    totalNote:
                                                        ddocs['totalNote']);
                                              },
                                              itemComparator: (item1, item2) =>
                                                  item1['lessonDate'].compareTo(
                                                      item2[
                                                          'lessonDate']), // optional
                                              order: GroupedListOrder.DESC,
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 14,
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 14,
                            // ),

                            // /// 추가 버튼
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.transparent,
                            //     shadowColor: Colors.transparent,
                            //   ),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(10.0),
                            //       ),
                            //       color: Palette.buttonOrange,
                            //     ),
                            //     height: 60,
                            //     width: double.infinity,
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           "동작추가",
                            //           style: TextStyle(fontSize: 18),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     print("동작추가");
                            //     // LessonAdd로 이동
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => LessonAdd(),
                            //         // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                            //         settings: RouteSettings(
                            //           arguments: userInfo,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 14,
                        // ),

                        // /// 추가 버튼
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.transparent,
                        //     shadowColor: Colors.transparent,
                        //   ),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(10.0),
                        //       ),
                        //       color: Palette.buttonOrange,
                        //     ),
                        //     height: 60,
                        //     width: double.infinity,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           "동작추가",
                        //           style: TextStyle(fontSize: 18),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     print("동작추가");
                        //     // LessonAdd로 이동
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => LessonAdd(),
                        //         // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        //         settings: RouteSettings(
                        //           arguments: userInfo,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 14,
              // ),

              /// 추가 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 11, 22, 22),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Palette.buttonOrange,
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "노트추가",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    print("노트추가");
                    // LessonAdd로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonAdd(),
                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        settings: RouteSettings(
                          arguments: userInfo,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Figma 확인 해보면 '회원정보' 탭에는 BottomAppBar 없는데, '동작' 탬에는 있음
        // 같은 화면인데 '회원정보' 탭에는 누락 된 듯하여 추가 BottomAppBar 함
        //bottomNavigationBar: BaseBottomAppBar(),
      );
    });
  }
}
