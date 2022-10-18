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
              apratusNameController,
              lessonDateController,
              gradeController,
              totalNoteController,
            ]);
          }),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// 입력창
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 8,
                        ),

                        /// Action 제목
                        Text(
                          actionName,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.gray33,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        /// 동작 노트
                        Container(
                          padding: const EdgeInsets.all(21.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Palette.mainBackground,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 9,
                              ),
                              Text("동작노트",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.gray66,
                                  )),
                              SizedBox(
                                height: 19,
                              ),
                              FutureBuilder<QuerySnapshot>(
                                future: lessonService.readNotesOfAction(
                                  user.uid,
                                  userInfo.phoneNumber,
                                  actionName,
                                ),
                                builder: (context, snapshot) {
                                  final docs =
                                      snapshot.data?.docs ?? []; // 문서들 가져오기
                                  if (docs.isEmpty) {
                                    return Center(child: Text("노트를 추가해 주세요."));
                                  }
                                  return Container(
                                    //height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      color: Palette.mainBackground,
                                    ),
                                    //padding: const EdgeInsets.all(20.0),
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
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

                                        // return InkWell(
                                        //   onTap: () {
                                        //     // 회원 카드 선택시 MemberInfo로 이동
                                        //     totalNoteController.text = totalNote;

                                        //     lessonService.readEventData(user.uid,
                                        //         userInfo.phoneNumber, actionName);
                                        //   },
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${lessonDate}   ${apratusName}  ${grade}  ${totalNote}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontSize: 12.0,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                          ],
                                        );
                                      },
                                      separatorBuilder: ((context, index) =>
                                          Divider(
                                            height: 0,
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        /// 기구 입력창
                        BasePopupMenuButton(
                          customController: apratusNameController,
                          hint: "기구",
                          showButton: true,
                          dropdownList: dropdownList,
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

                        /// 수행도 입력창
                        BaseTextField(
                          customController: gradeController,
                          hint: "수행도",
                          showArrow: true,
                          customFunction: () {},
                        ),

                        Container(
                          //color: Colors.red,
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
                            // if (globalFunction.textNullCheck(
                            //         context, lessonDateController, "수업일") &&
                            //     globalFunction.textNullCheck(
                            //         context, actionNameController, "동작이름") &&
                            //     globalFunction.textNullCheck(
                            //         context, gradeController, "수행도") &&
                            //     globalFunction.textNullCheck(
                            //         context, totalNoteController, "메모"))

                            if (globalFunction.textNullCheck(
                                    context, lessonDateController, "수업일") &&
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
                                  actionName: actionName, //동작이름
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
                                      apratusNameController,
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
