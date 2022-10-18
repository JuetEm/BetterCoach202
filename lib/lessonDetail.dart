import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/actionSelector.dart';
import 'package:web_project/userInfo.dart';

import 'actionInfo.dart';
import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberInfo.dart';
import 'lesson_service.dart';

TextEditingController nameController = TextEditingController();
TextEditingController apratusNameController = TextEditingController();
TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController();
TextEditingController gradeController = TextEditingController();
TextEditingController totalNoteController = TextEditingController();

GlobalFunction globalFunction = GlobalFunction();

String selectedDropdown = '기구';
List<String> dropdownList = [
  'REFORMER',
  'CADILLAC',
  'CHAIR',
  'LADDER BARREL',
  'SPRING BOARD',
  'SPINE CORRECTOR',
  'MAT'
];

double sliderValue = 50;

class LessonDetail extends StatefulWidget {
  const LessonDetail({super.key});

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final argsList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    UserInfo userInfo = argsList[0];
    String actionName = argsList[1];
    List<DateTime> eventList = argsList[2];

    nameController = TextEditingController(text: userInfo.name);

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "수업 보기", () {
            // 뒤로가기 선택시 MemberInfo로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberInfo(),
                // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                settings: RouteSettings(
                  arguments: userInfo,
                ),
              ),
            );
            globalFunction.clearTextEditController([
              nameController,
              apratusNameController,
              actionNameController,
              lessonDateController,
              gradeController,
              totalNoteController
            ]);
          }),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// 입력창
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// 수업일 입력창
                        SizedBox(
                            height: 420,
                            child: BaseTableCalendar(
                              pageName: "수업 보기",
                              eventList: eventList,
                            )),
                        Divider(height: 10),

                        /// 동작 노트
                        FutureBuilder<QuerySnapshot>(
                          future: lessonService.readNotesOfAction(
                            user.uid,
                            userInfo.phoneNumber,
                            actionName,
                          ),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                            if (docs.isEmpty) {
                              return Center(child: Text("회원 목록을 준비 중입니다."));
                            }
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Palette.mainBackground,
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final doc = docs[index];

                                  String uid = doc.get('uid'); // 강사 고유번호
                                  String name = doc.get('name'); //회원이름
                                  String phoneNumber = doc.get(
                                      'phoneNumber'); // 회원 고유번호 (전화번호로 회원 식별)
                                  String apratusName =
                                      doc.get('apratusName'); //기구이름
                                  String actionName =
                                      doc.get('actionName'); //동작이름
                                  String lessonDate =
                                      doc.get('lessonDate'); //수업날짜
                                  String grade = doc.get('grade'); //수행도
                                  String totalNote =
                                      doc.get('totalNote'); //수업총메모

                                  return InkWell(
                                    onTap: () {
                                      // 회원 카드 선택시 MemberInfo로 이동
                                      totalNoteController.text = totalNote;

                                      lessonService.readEventData(user.uid,
                                          userInfo.phoneNumber, actionName);
                                    },
                                    child: Text(
                                      "${apratusName}, ${lessonDate}, ${totalNote}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  );
                                },
                                separatorBuilder: ((context, index) => Divider(
                                      height: 0,
                                    )),
                              ),
                            );
                          },
                        ),
                        Divider(height: 10),

                        /// 동작 노트
                        BaseTextField(
                          customController: totalNoteController,
                          hint: "노트 입력",
                          showArrow: false,
                          customFunction: () {},
                        ),
                        Divider(height: 1),

                        /// 추가 버튼
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Palette.buttonOrange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("저장하기", style: TextStyle(fontSize: 18)),
                          ),
                          onPressed: () {
                            print("저장하기 버튼");
                            // create bucket
                            if (globalFunction
                                    .textNullCheck(context, apratusNameController,
                                        "기구") &&
                                globalFunction.textNullCheck(
                                    context, lessonDateController, "수업일") &&
                                globalFunction.textNullCheck(
                                    context, actionNameController, "동작이름") &&
                                globalFunction.textNullCheck(
                                    context, gradeController, "수행도") &&
                                globalFunction.textNullCheck(
                                    context, totalNoteController, "메모")) {
                              String now = DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()); // 오늘 날짜 가져오기
                              lessonService.create(
                                  uid: user.uid,
                                  name: nameController.text,
                                  phoneNumber: userInfo
                                      .phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별
                                  apratusName:
                                      apratusNameController.text, //기구이름
                                  actionName: actionNameController.text, //동작이름
                                  lessonDate: lessonDateController.text, //수업날짜
                                  grade: gradeController.text, //수행도
                                  totalNote: totalNoteController.text, //수업총메모
                                  onSuccess: () {
                                    // 저장하기 성공
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("저장하기 성공"),
                                    ));
                                    // 저장하기 성공시 MemberInfo로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberInfo(),
                                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                        settings: RouteSettings(
                                          arguments: userInfo,
                                        ),
                                      ),
                                    );

                                    globalFunction.clearTextEditController([
                                      nameController,
                                      apratusNameController,
                                      actionNameController,
                                      lessonDateController,
                                      gradeController,
                                      totalNoteController
                                    ]);
                                  },
                                  onError: () {
                                    print("저장하기 ERROR");
                                  });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("항목을 모두 입력해주세요."),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }
}
