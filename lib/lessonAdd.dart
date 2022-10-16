import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/userInfo.dart';

import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'globalWidget.dart';
import 'home.dart';
import 'memberInfo.dart';
import 'memberList.dart';
import 'lesson_service.dart';
import 'membershipList.dart';

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  TextEditingController nameController = TextEditingController();
  TextEditingController apratusNameController = TextEditingController();
  TextEditingController actionNameController = TextEditingController();
  TextEditingController lessonDateController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController totalNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          appBar: BaseAppBarMethod(context, "노트 추가"),
          body: Column(
            children: [
              /// 입력창
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// 이름 입력창
                      BaseTextField(
                        customController: nameController,
                        hint: "이름",
                        showArrow: false,
                        customFunction: () {},
                      ),

                      /// 기구 입력창
                      BaseTextField(
                        customController: apratusNameController,
                        hint: "기구",
                        showArrow: false,
                        customFunction: () {},
                      ),

                      /// 수업일 입력창
                      BaseTextField(
                        customController: lessonDateController,
                        hint: "등록일",
                        showArrow: true,
                        customFunction: () {
                          _getDateFromCalendar(context);
                        },
                      ),

                      /// 전화번호 입력창
                      BaseTextField(
                        customController: actionNameController,
                        hint: "동작이름",
                        showArrow: false,
                        customFunction: () {},
                      ),

                      /// 수행도 입력창
                      BaseTextField(
                        customController: gradeController,
                        hint: "목표",
                        showArrow: false,
                        customFunction: () {},
                      ),

                      /// 메모 입력창
                      BaseTextField(
                        customController: totalNoteController,
                        hint: "메모",
                        showArrow: false,
                        customFunction: () {},
                      ),
                      Divider(height: 1),

                      /// 추가 버튼
                      ElevatedButton(
                        child: Text("저장하기", style: TextStyle(fontSize: 21)),
                        onPressed: () {
                          print("추가 버튼");
                          // create bucket
                          if (textNullCheck(apratusNameController,
                                  "apratusNameController") &&
                              textNullCheck(lessonDateController,
                                  "lessonDateController") &&
                              textNullCheck(actionNameController,
                                  "actionNameController") &&
                              textNullCheck(
                                  gradeController, "gradeController") &&
                              textNullCheck(
                                  totalNoteController, "totalNoteController")) {
                            lessonService.create(
                                uid: user.uid,
                                name: nameController.text,
                                apratusName: apratusNameController.text, //기구이름
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
                                  // 저장하기 성공시 Home로 이동
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
                                },
                                onError: () {
                                  print("저장하기 ERROR");
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("항목을 모두 입력해주세요."),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void _getDateFromCalendar(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BaseTableCalendar()),
    );

    if (!(result == null)) {
      String formatedDate = DateFormat("yyyy-MM-dd")
          .format(DateTime(result.year, result.month, result.day));

      lessonDateController.text = formatedDate;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("등록일 : ${formatedDate}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("등록일을 선택해주세요."),
      ));
    }
  }

  bool textNullCheck(
    TextEditingController checkController,
    String controllerName,
  ) {
    bool notEmpty = true;
    if (!checkController.text.isNotEmpty) {
      print("${controllerName} is Empty");
      notEmpty = !notEmpty;
    }

    return notEmpty;
  }
}
