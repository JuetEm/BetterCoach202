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
import 'memberList.dart';
import 'member_service.dart';
import 'userInfo.dart';
import 'lessonInfo.dart';

Map<DateTime, dynamic> eventSource = {};
List<DateTime> eventList = [];

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              Text(
                                '회원정보',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.gray33,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '목표',
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
                                      '신체특이사항/체형분석',
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
                                      '메모',
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
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 20),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '동작',
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
                                  userInfo.phoneNumber,
                                ),
                                builder: (context, snapshot) {
                                  final docs =
                                      snapshot.data?.docs ?? []; // 문서들 가져오기
                                  if (docs.isEmpty) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Center(
                                          child: Text(
                                              "노트추가 버튼을 눌러 동작을 추가할 수 있습니다"),
                                        ),
                                      ],
                                    );
                                  }
                                  return GroupedListView(
                                    shrinkWrap: true,
                                    elements: docs,
                                    groupBy: (element) => element['actionName'],
                                    groupSeparatorBuilder: (String value) =>
                                        InkWell(
                                      onTap: () {
                                        // 회원 운동 카드 선택시 MemberInfo로 이동
                                        eventList = [];
                                        List<dynamic> args = [
                                          userInfo,
                                          value,
                                          eventList
                                        ];

                                        print("args.length : ${args.length}");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LessonDetail(),
                                            // GlobalWidgetDashboard(), //
                                            // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                            settings:
                                                RouteSettings(arguments: args),
                                          ),
                                        );
                                      },
                                      child: GroupActionContainer(
                                          actionName: value),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, dynamic docs) {
                                      DateTime eventDate = DateTime.parse(
                                          docs['lessonDate'].toString());
                                      eventList.add(eventDate);
                                      return ActionContainer(
                                          apratusName: docs['apratusName'],
                                          actionName: docs['actionName'],
                                          lessonDate: docs['lessonDate'],
                                          grade: docs['grade'],
                                          totalNote: docs['totalNote']);
                                    },
                                    itemComparator: (item1, item2) =>
                                        item1['lessonDate'].compareTo(
                                            item2['lessonDate']), // optional
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
                  SizedBox(
                    height: 14,
                  ),

                  /// 추가 버튼
                  ElevatedButton(
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
                ],
              ),
            ),
          ),
        ),
        // Figma 확인 해보면 '회원정보' 탭에는 BottomAppBar 없는데, '동작' 탬에는 있음
        // 같은 화면인데 '회원정보' 탭에는 누락 된 듯하여 추가 BottomAppBar 함
        //bottomNavigationBar: BaseBottomAppBar(),
      );
    });
  }
}
