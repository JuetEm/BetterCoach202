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

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

TextEditingController nameController = TextEditingController();
TextEditingController apratusNameController = TextEditingController();
TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController(text: now);
TextEditingController gradeController = TextEditingController(text: "50");
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

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;

    nameController = TextEditingController(text: userInfo.name);
    //lessonDateController = TextEditingController(text: now);
    //gradeController = TextEditingController(text: "50");

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "노트 추가", () {
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
            // 페이지 초기화
            initInpuWidget();
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
                        // 기구 입력창
                        BaseModalBottomSheetButton(
                          bottomModalController: apratusNameController,
                          hint: "기구",
                          showButton: true,
                          optionList: dropdownList,
                          customFunction: () {},
                        ),

                        /// 수업일 입력창
                        BaseTextField(
                          customController: lessonDateController,
                          hint: "수업일",
                          showArrow: true,
                          customFunction: () {
                            globalFunction.getDateFromCalendar(
                                context, lessonDateController, "수업일");
                          },
                        ),

                        /// 동작이름 입력창
                        BaseTextField(
                          customController: actionNameController,
                          hint: "동작이름",
                          showArrow: true,
                          customFunction: () async {
                            String currentAppratus = apratusNameController.text;

                            final ActionInfo? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActionSelector(),
                                fullscreenDialog: true,
                                // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                settings: RouteSettings(
                                    arguments: [userInfo, currentAppratus]),
                              ),
                            );

                            if (!(result == null)) {
                              print(
                                  "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                              setState(() {
                                actionNameController.text = result.actionName;
                                switch (result.apparatus) {
                                  case "RE":
                                    apratusNameController.text = "REFORMER";
                                    break;
                                  case "CA":
                                    apratusNameController.text = "CADILLAC";
                                    break;
                                  case "CH":
                                    apratusNameController.text = "CHAIR";
                                    break;
                                  case "LA":
                                    apratusNameController.text =
                                        "LADDER BARREL";
                                    break;
                                  case "SB":
                                    apratusNameController.text = "SPRING BOARD";
                                    break;
                                  case "SC":
                                    apratusNameController.text =
                                        "SPINE CORRECTOR";
                                    break;
                                  case "MAT":
                                    apratusNameController.text = "MAT";
                                    break;
                                }
                              });
                            }
                          },
                        ),

                        /// 수행도 입력창
                        BaseTextField(
                          customController: gradeController,
                          hint: "수행도",
                          showArrow: true,
                          customFunction: () {},
                        ),

                        Container(
                          // color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Slider(
                                  value: sliderValue,
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  onChanged: (value) {
                                    setState(() {
                                      sliderValue = value;
                                      gradeController.text =
                                          sliderValue.clamp(0, 100).toString();
                                      print(sliderValue.toString());
                                    });
                                  }),
                            ],
                          ),
                        ),

                        /// 메모 입력창
                        BaseTextField(
                          customController: totalNoteController,
                          hint: "메모",
                          showArrow: false,
                          customFunction: () {},
                        ),

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
                            if (globalFunction.textNullCheck(
                                    context, lessonDateController, "수업일") &&
                                globalFunction.textNullCheck(
                                    context, actionNameController, "동작이름")) {
                              // 오늘 날짜 가져오기
                              lessonService.create(
                                  docId: userInfo
                                      .docId, // 회권 고유번호 => 회원번호(문서고유번호)로 회원 식별
                                  uid: user.uid,
                                  name: nameController.text,
                                  phoneNumber: userInfo
                                      .phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별 방식 제거
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

                                    // 화면 초기화
                                    initInpuWidget();
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

  void initInpuWidget() {
    globalFunction.clearTextEditController([
      nameController,
      apratusNameController,
      actionNameController,
      lessonDateController,
      gradeController,
      totalNoteController
    ]);
    lessonDateController.text = now;
    setState(() {
      sliderValue = 50;
    });
  }
}
