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
TextEditingController todayNoteController = TextEditingController();

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

bool initState = true;

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  @override
  Widget build(BuildContext context) {
    if (initState) {
      print("INIT!!! : ${initState}");
      now = DateFormat("yyyy-MM-dd").format(DateTime.now());
      lessonDateController = TextEditingController(text: now);
      gradeController = TextEditingController(text: "50");
      initState = !initState;
    }

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
          appBar: BaseAppBarMethod(context, "노트추가", () {
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
            initState = !initState;
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
                        // // 기구 입력창
                        // BaseModalBottomSheetButton(
                        //   bottomModalController: apratusNameController,
                        //   hint: "기구",
                        //   showButton: true,
                        //   optionList: dropdownList,
                        //   customFunction: () {},
                        // ),

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

                        /// 메모 입력창
                        BaseTextField(
                          customController: todayNoteController,
                          hint: "일별 메모",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        // 동작입력 버튼
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Palette.buttonOrange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 16.0,
                            ),
                            child: InkWell(
                              onTap: () async {
                                String currentAppratus =
                                    apratusNameController.text;
                                bool initState = true;

                                final ActionInfo? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActionSelector(),
                                    fullscreenDialog: true,
                                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                    settings: RouteSettings(arguments: [
                                      userInfo,
                                      currentAppratus,
                                      initState
                                    ]),
                                  ),
                                );

                                if (!(result == null)) {
                                  print(
                                      "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                                  setState(() {
                                    actionNameController.text =
                                        result.actionName;
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
                                        apratusNameController.text =
                                            "SPRING BOARD";
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
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '동작선택',
                                      style: TextStyle(
                                          fontSize: 16, color: Palette.grayFA),
                                    ),
                                    Spacer(flex: 1),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Palette.grayFA,
                                      size: 12.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        FutureBuilder<QuerySnapshot>(
                          future: lessonService.readNotesOflessonDate(
                            user.uid,
                            userInfo.docId,
                            lessonDateController.text,
                          ),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                            if (docs.isEmpty) {
                              return Center(child: Text("노트를 추가해 주세요."));
                            }

                            return Container(
                              //height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              //padding: const EdgeInsets.all(20.0),
                              child: ReorderableListView.builder(
                                itemCount: docs.length,
                                //buildDefaultDragHandles: false,
                                onReorder: ((oldIndex, newIndex) =>
                                    setState(() {
                                      print(
                                          'docs0 : ${docs[0].get('actionName')}');
                                      print(
                                          'docs1 : ${docs[1].get('actionName')}');
                                      print(
                                          'docs2 : ${docs[2].get('actionName')}');

                                      if (oldIndex < newIndex) newIndex -= 1;

                                      print('newIndex : ${newIndex}');
                                      print('oldIndex : ${oldIndex}');

                                      docs.insert(
                                          newIndex, docs.removeAt(oldIndex));

                                      print(
                                          'docs0 : ${docs[0].get('actionName')}');
                                      print(
                                          'docs1 : ${docs[1].get('actionName')}');
                                      print(
                                          'docs2 : ${docs[2].get('actionName')}');

                                      final futures = <Future>[];

                                      for (int pos = 0;
                                          pos < docs.length;
                                          pos++) {
                                        futures.add(lessonService.updatePos(
                                            docs[pos].id, pos));
                                        print(docs[pos].id);
                                      }
                                    })),
                                shrinkWrap: true,
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
                                  String lessonDateTrim = " ";
                                  String apratusNameTrim = " ";
                                  int pos = doc.get('pos'); //순서
                                  // 날짜 글자 자르기
                                  if (lessonDate.length > 0) {
                                    lessonDateTrim =
                                        lessonDate.substring(2, 10);
                                  }
                                  // 기구 첫두글자 자르기
                                  if (apratusName.length > 0) {
                                    apratusNameTrim =
                                        apratusName.substring(0, 2);
                                  }
                                  return Column(
                                    key: ValueKey(doc),

                                    children: [
                                      Container(
                                        //color: Colors.red.withOpacity(0),
                                        margin: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          color: Palette.gray99,
                                          //color: Colors.red.withOpacity(0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            //top: 5,
                                            //bottom: 5,
                                            left: 5.0,
                                            right: 16.0,
                                          ),
                                          child: SizedBox(
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.drag_indicator,
                                                  color: Palette.gray33,
                                                  size: 20.0,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  actionName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Spacer(flex: 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],

                                    // return ListTile(
                                    //   key: ValueKey(doc),
                                    //   title: Text(actionName),
                                    // leading: Icon(
                                    //   Icons.arrow_forward_ios,
                                    //   color: Palette.gray99,
                                    //   size: 12.0,
                                    // ),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        // /// 동작이름 입력창
                        // BaseTextField(
                        //   customController: actionNameController,
                        //   hint: "동작선택",
                        //   showArrow: true,
                        //   customFunction: () async {
                        //     String currentAppratus = apratusNameController.text;
                        //     bool initState = true;

                        //     final ActionInfo? result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ActionSelector(),
                        //         fullscreenDialog: true,
                        //         // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        //         settings: RouteSettings(arguments: [
                        //           userInfo,
                        //           currentAppratus,
                        //           initState
                        //         ]),
                        //       ),
                        //     );

                        //     if (!(result == null)) {
                        //       print(
                        //           "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                        //       setState(() {
                        //         actionNameController.text = result.actionName;
                        //         switch (result.apparatus) {
                        //           case "RE":
                        //             apratusNameController.text = "REFORMER";
                        //             break;
                        //           case "CA":
                        //             apratusNameController.text = "CADILLAC";
                        //             break;
                        //           case "CH":
                        //             apratusNameController.text = "CHAIR";
                        //             break;
                        //           case "LA":
                        //             apratusNameController.text =
                        //                 "LADDER BARREL";
                        //             break;
                        //           case "SB":
                        //             apratusNameController.text = "SPRING BOARD";
                        //             break;
                        //           case "SC":
                        //             apratusNameController.text =
                        //                 "SPINE CORRECTOR";
                        //             break;
                        //           case "MAT":
                        //             apratusNameController.text = "MAT";
                        //             break;
                        //         }
                        //       });
                        //     }
                        //   },
                        // ),

                        // /// 수행도 입력창
                        // BaseTextField(
                        //   customController: gradeController,
                        //   hint: "수행도",
                        //   showArrow: true,
                        //   customFunction: () {},
                        // ),

                        // Container(
                        //   // color: Colors.red,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Slider(
                        //           value: sliderValue,
                        //           min: 0,
                        //           max: 100,
                        //           divisions: 10,
                        //           onChanged: (value) {
                        //             setState(() {
                        //               sliderValue = value;
                        //               gradeController.text =
                        //                   sliderValue.clamp(0, 100).toString();
                        //               print(sliderValue.toString());
                        //             });
                        //           }),
                        //     ],
                        //   ),
                        // ),

                        // /// 메모 입력창
                        // BaseTextField(
                        //   customController: totalNoteController,
                        //   hint: "메모",
                        //   showArrow: false,
                        //   customFunction: () {},
                        // ),

                        const SizedBox(height: 15),

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
                                context, lessonDateController, "수업일")) {
                              print("userInfo.docId : ${userInfo.docId}");

                              lessonService.createTodaynote(
                                  docId: userInfo.docId,
                                  uid: user.uid,
                                  name: nameController.text,
                                  lessonDate: lessonDateController.text,
                                  todayNote: todayNoteController.text,
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
                                    initState = !initState;
                                  },
                                  onError: () {
                                    print("저장하기 ERROR");
                                  });

                              // // 오늘 날짜 가져오기
                              // lessonService.create(
                              //     docId: userInfo
                              //         .docId, // 회권 고유번호 => 회원번호(문서고유번호)로 회원 식별
                              //     uid: user.uid,
                              //     name: nameController.text,
                              //     phoneNumber: userInfo
                              //         .phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별 방식 제거
                              //     apratusName:
                              //         apratusNameController.text, //기구이름
                              //     actionName: actionNameController.text, //동작이름
                              //     lessonDate: lessonDateController.text, //수업날짜
                              //     grade: gradeController.text, //수행도
                              //     totalNote: totalNoteController.text, //수업총메모
                              //     onSuccess: () {
                              //       // 저장하기 성공
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(SnackBar(
                              //         content: Text("저장하기 성공"),
                              //       ));
                              //       // 저장하기 성공시 MemberInfo로 이동
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => MemberInfo(),
                              //           // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                              //           settings: RouteSettings(
                              //             arguments: userInfo,
                              //           ),
                              //         ),
                              //       );

                              //       // 화면 초기화
                              //       initInpuWidget();
                              //       initState = !initState;
                              //     },
                              //     onError: () {
                              //       print("저장하기 ERROR");
                              //     });
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
