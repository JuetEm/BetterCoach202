//머지 테스트

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/ui/page/actionSelector.dart';
import 'package:web_project/app/data/provider/lesson_service.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/data/model/userInfo.dart'
    as CustomUserInfo; // 다른 페키지와 클래스 명이 겹치는 경우 alias 선언해서 사용

import '../../data/model/actionInfo.dart';
import '../../data/provider/auth_service.dart';
import '../widget/baseTableCalendar.dart';
import '../../data/model/color.dart';
import '../../../globalFunction.dart';
import '../../../globalWidget.dart';
import '../../data/model/lessonInfo.dart';
import 'memberInfo.dart';

// 2022 10 19 수요일 14시 36분 정규호 푸시 보이는지 테스트 입니다! 이 주석이 보이시나요?

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

TextEditingController nameController = TextEditingController();
TextEditingController apratusNameController = TextEditingController();
TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController(text: now);
TextEditingController gradeController = TextEditingController(text: "50");
TextEditingController totalNoteController = TextEditingController();

FocusNode actionNameFocusNode = FocusNode();
FocusNode gradeFocusNode = FocusNode();
FocusNode totalNoteFocusNode = FocusNode();

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

Color moreButtonColor = Palette.gray99;

String buttonString = "저장하기";

String editDocId = "";
String editApparatusName = "";
String editLessonDate = "";
String editGrade = "";
String editTotalNote = "";
int lessonListIndex = 0;

class LessonDetailDate extends StatefulWidget {
  const LessonDetailDate({super.key});

  @override
  State<LessonDetailDate> createState() => _LessonDetailDateState();
}

class _LessonDetailDateState extends State<LessonDetailDate> {
  // set double(double value) => setState(() => sliderValue = value);

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final argsList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    CustomUserInfo.UserInfo customUserInfo = argsList[0];
    String lessonDate = argsList[1];
    List<DateTime> eventList = argsList[2];
    String lessonNoteId = argsList[3];

    nameController = TextEditingController(text: customUserInfo.name);

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
                  arguments: customUserInfo,
                ),
              ),
            );
            globalFunction.clearTextEditController([
              apratusNameController,
              lessonDateController,
              gradeController,
              totalNoteController,
            ]);
          }, null, null),

          body: CenterConstrainedBody(
            child: SafeArea(
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
                            lessonDate,
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
                            padding: const EdgeInsets.fromLTRB(21, 21, 2, 21),
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
                                  future: lessonService.readNotesOflessonDate(
                                    user.uid,
                                    customUserInfo.docId,
                                    lessonDate,
                                  ),
                                  builder: (context, snapshot) {
                                    final docs =
                                        snapshot.data?.docs ?? []; // 문서들 가져오기
                                    if (docs.isEmpty) {
                                      return Center(
                                          child: Text("노트를 추가해 주세요."));
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

                                              if (oldIndex < newIndex)
                                                newIndex -= 1;

                                              print('newIndex : ${newIndex}');
                                              print('oldIndex : ${oldIndex}');

                                              docs.insert(newIndex,
                                                  docs.removeAt(oldIndex));

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
                                                futures.add(
                                                    lessonService.updatePos(
                                                        docs[pos].id, pos));
                                                print(docs[pos].id);
                                              }
                                            })),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final doc = docs[index];

                                          String uid =
                                              doc.get('uid'); // 강사 고유번호
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

                                          return ListTile(
                                            key: ValueKey(doc),
                                            title: Text(actionName),
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
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          /// 동작 노트

                          // Container(
                          //   padding: const EdgeInsets.fromLTRB(21, 21, 2, 21),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10.0),
                          //     ),
                          //     color: Palette.mainBackground,
                          //   ),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SizedBox(
                          //         height: 9,
                          //       ),
                          //       Text("동작노트",
                          //           style: TextStyle(
                          //             fontSize: 18.0,
                          //             fontWeight: FontWeight.bold,
                          //             color: Palette.gray66,
                          //           )),
                          //       SizedBox(
                          //         height: 19,
                          //       ),
                          //       FutureBuilder<QuerySnapshot>(
                          //         future: lessonService.readNotesOflessonDate(
                          //           user.uid,
                          //           customUserInfo.docId,
                          //           lessonDate,
                          //         ),
                          //         builder: (context, snapshot) {
                          //           final docs =
                          //               snapshot.data?.docs ?? []; // 문서들 가져오기
                          //           if (docs.isEmpty) {
                          //             return Center(child: Text("노트를 추가해 주세요."));
                          //           }

                          //           return Container(
                          //             //height: 200,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.all(
                          //                 Radius.circular(10.0),
                          //               ),
                          //               color: Palette.mainBackground,
                          //             ),
                          //             //padding: const EdgeInsets.all(20.0),
                          //             child: ReorderableListView.builder(
                          //               itemCount: docs.length,
                          //               onReorder: ((oldIndex, newIndex) =>
                          //                   setState(() {
                          //                     //final index = newIndex;
                          //                     // final index = newIndex > oldIndex
                          //                     //     ? newIndex - 1
                          //                     //     : newIndex;

                          //                     print(
                          //                         'docs0 : ${docs[0].get('actionName')}');
                          //                     print(
                          //                         'docs1 : ${docs[1].get('actionName')}');
                          //                     print(
                          //                         'docs2 : ${docs[2].get('actionName')}');

                          //                     if (oldIndex < newIndex)
                          //                       newIndex -= 1;

                          //                     print('newIndex : ${newIndex}');
                          //                     print('oldIndex : ${oldIndex}');

                          //                     docs.insert(newIndex,
                          //                         docs.removeAt(oldIndex));

                          //                     print(
                          //                         'docs0 : ${docs[0].get('actionName')}');
                          //                     print(
                          //                         'docs1 : ${docs[1].get('actionName')}');
                          //                     print(
                          //                         'docs2 : ${docs[2].get('actionName')}');

                          //                     //print('docs : ${docs.pos}');
                          //                     final futures = <Future>[];
                          //                     //print(docs.length);
                          //                     for (int pos = 0;
                          //                         pos < docs.length;
                          //                         pos++) {
                          //                       futures.add(
                          //                           lessonService.updatePos(
                          //                               docs[pos].id, pos));
                          //                       print(docs[pos].id);
                          //                     }
                          //                   })),
                          //               scrollDirection: Axis.vertical,
                          //               shrinkWrap: true,
                          //               itemBuilder:
                          //                   (BuildContext context, int index) {
                          //                 final doc = docs[index];

                          //                 String uid = doc.get('uid'); // 강사 고유번호
                          //                 String name = doc.get('name'); //회원이름
                          //                 String phoneNumber = doc.get(
                          //                     'phoneNumber'); // 회원 고유번호 (전화번호로 회원 식별)
                          //                 String apratusName =
                          //                     doc.get('apratusName'); //기구이름
                          //                 String actionName =
                          //                     doc.get('actionName'); //동작이름
                          //                 String lessonDate =
                          //                     doc.get('lessonDate'); //수업날짜
                          //                 String grade = doc.get('grade'); //수행도
                          //                 String totalNote =
                          //                     doc.get('totalNote'); //수업총메모
                          //                 String lessonDateTrim = " ";
                          //                 String apratusNameTrim = " ";
                          //                 int pos = doc.get('pos'); //순서
                          //                 // 날짜 글자 자르기
                          //                 if (lessonDate.length > 0) {
                          //                   lessonDateTrim =
                          //                       lessonDate.substring(2, 10);
                          //                 }
                          //                 // 기구 첫두글자 자르기
                          //                 if (apratusName.length > 0) {
                          //                   apratusNameTrim =
                          //                       apratusName.substring(0, 2);
                          //                 }

                          //                 return Container(
                          //                   key: ValueKey(doc),
                          //                   child: Padding(
                          //                     padding: const EdgeInsets.only(
                          //                       left: 10.0,
                          //                       right: 10.0,
                          //                       top: 5.0,
                          //                     ),
                          //                     child: SizedBox(
                          //                       //height: 20,
                          //                       child: Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.start,
                          //                         children: [
                          //                           Text(
                          //                             pos.toString(),
                          //                             style: Theme.of(context)
                          //                                 .textTheme
                          //                                 .bodyText1!
                          //                                 .copyWith(
                          //                                   fontSize: 12.0,
                          //                                 ),
                          //                           ),
                          //                           const SizedBox(width: 5.0),
                          //                           Text(
                          //                             apratusNameTrim,
                          //                             style: Theme.of(context)
                          //                                 .textTheme
                          //                                 .bodyText1!
                          //                                 .copyWith(
                          //                                   fontSize: 12.0,
                          //                                 ),
                          //                           ),
                          //                           const SizedBox(width: 15.0),
                          //                           Text(
                          //                             actionName,
                          //                             style: Theme.of(context)
                          //                                 .textTheme
                          //                                 .bodyText1!
                          //                                 .copyWith(
                          //                                   fontSize: 12.0,
                          //                                 ),
                          //                           ),
                          //                           const SizedBox(width: 15.0),
                          //                           Text(
                          //                             grade,
                          //                             style: Theme.of(context)
                          //                                 .textTheme
                          //                                 .bodyText1!
                          //                                 .copyWith(
                          //                                   fontSize: 12.0,
                          //                                 ),
                          //                           ),
                          //                           const SizedBox(width: 15.0),
                          //                           Expanded(
                          //                             child: Text(
                          //                               totalNote,
                          //                               //overflow: TextOverflow.fade,
                          //                               //maxLines: 2,
                          //                               softWrap: true,
                          //                               style: Theme.of(context)
                          //                                   .textTheme
                          //                                   .bodyText1!
                          //                                   .copyWith(
                          //                                     fontSize: 12.0,
                          //                                   ),
                          //                             ),
                          //                           ),
                          //                           IconButton(
                          //                             onPressed: () {
                          //                               print("More");
                          //                               globalFunction
                          //                                   .showBottomSheetContent(
                          //                                 context,
                          //                                 customEditFunction: () {
                          //                                   setState(() {
                          //                                     editDocId = doc.id;
                          //                                     buttonString =
                          //                                         "수정하기";
                          //                                     if (grade
                          //                                         .isNotEmpty) {
                          //                                       sliderValue =
                          //                                           double.parse(
                          //                                               grade);
                          //                                     }
                          //                                     print(
                          //                                         "Edit Function");
                          //                                     apratusNameController
                          //                                             .text =
                          //                                         apratusName;
                          //                                     lessonDateController
                          //                                             .text =
                          //                                         lessonDate;
                          //                                     gradeController
                          //                                         .text = grade;
                          //                                     totalNoteController
                          //                                             .text =
                          //                                         totalNote;
                          //                                   });
                          //                                   Navigator.pop(
                          //                                       context);
                          //                                 },
                          //                                 customDeleteFunction:
                          //                                     () {
                          //                                   print(
                          //                                       "Delete Function");

                          //                                   Navigator.of(context)
                          //                                       .pop();
                          //                                   showDialog(
                          //                                       context: context,
                          //                                       barrierDismissible:
                          //                                           true,
                          //                                       builder:
                          //                                           (BuildContext
                          //                                               context) {
                          //                                         return AlertDialog(
                          //                                           title: Text(
                          //                                               '삭제'),
                          //                                           content: Text(
                          //                                               '동작노트를 삭제하시겠습니까?'),
                          //                                           actions: <
                          //                                               Widget>[
                          //                                             TextButton(
                          //                                               onPressed:
                          //                                                   () {
                          //                                                 lessonService
                          //                                                     .delete(doc.id);
                          //                                                 Navigator.of(context)
                          //                                                     .pop();
                          //                                               },
                          //                                               child: Text(
                          //                                                   '삭제'),
                          //                                             ),
                          //                                             TextButton(
                          //                                               onPressed:
                          //                                                   () {
                          //                                                 Navigator.of(context)
                          //                                                     .pop();
                          //                                               },
                          //                                               child: Text(
                          //                                                   '취소'),
                          //                                             ),
                          //                                           ],
                          //                                         );
                          //                                       });
                          //                                 },
                          //                               );
                          //                             },
                          //                             icon: Icon(
                          //                               Icons.more_horiz_sharp,
                          //                               color: moreButtonColor,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //               },
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // 기구 입력창
                          BaseModalBottomSheetButton(
                            bottomModalController: apratusNameController,
                            hint: "기구",
                            showButton: true,
                            optionList: dropdownList,
                            customFunction: () {},
                          ),

                          /// 동작이름 입력창
                          BaseTextField(
                            customController: actionNameController,
                            customFocusNode: actionNameFocusNode,
                            hint: "동작이름",
                            showArrow: true,
                            customFunction: () async {
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
                                    customUserInfo,
                                    currentAppratus,
                                    initState
                                  ]),
                                ),
                              );

                              if (!(result == null)) {
                                //print(
                                //    "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

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
                          ),

                          /// 수업일 입력창
                          // BaseTextField(
                          //   customController: lessonDateController,
                          //   hint: "수업일",
                          //   showArrow: true,
                          //   customFunction: () {
                          //     globalFunction.getDateFromCalendar(
                          //         context, lessonDateController, "수업일 선택");
                          //   },
                          // ),

                          /// 수행도 입력창
                          BaseTextField(
                            customController: gradeController,
                            customFocusNode: gradeFocusNode,
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
                                        gradeController.text = sliderValue
                                            .clamp(0, 100)
                                            .toString();
                                        //print(sliderValue.toString());
                                      });
                                    }),
                              ],
                            ),
                          ),

                          /// 동작 노트
                          BaseTextField(
                            customController: totalNoteController,
                            customFocusNode: totalNoteFocusNode,
                            hint: "노트 입력",
                            showArrow: false,
                            customFunction: () {},
                          ),

                          SizedBox(height: 10),

                          /// 추가/수정 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Palette.buttonOrange,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(buttonString,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              print("${buttonString} 버튼");

                              if (buttonString == "저장하기") {
                                saveButtonMethodDate(context, lessonService,
                                    user, customUserInfo, lessonDate);
                              } else if (buttonString == "수정하기") {
                                editButtonMethodDate(context, lessonService,
                                    customUserInfo, lessonDate);
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
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void editButtonMethodDate(BuildContext context, LessonService lessonService,
      CustomUserInfo.UserInfo userInfo, String lessonDate) {
    if (globalFunction.textNullCheck(context, actionNameController, "동작이름")) {
      setState(() {
        lessonService.update(
            editDocId,
            apratusNameController.text,
            actionNameController.text,
            lessonDate,
            gradeController.text,
            totalNoteController.text);

        apratusNameController.text = "";
        lessonDateController.text = "";
        actionNameController.text = "";
        gradeController.text = "";
        totalNoteController.text = "";
        sliderValue = 50;
        buttonString = "저장하기";
      });

      // 저장하기 성공시 MemberInfo로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MemberInfo(),
          // setting에서 arguments로 다음 화면에 회원 정보 넘기기
          settings: RouteSettings(
            arguments: userInfo,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("항목을 모두 입력해주세요."),
      ));
    }
  }

  void saveButtonMethodDate(BuildContext context, LessonService lessonService,
      User user, CustomUserInfo.UserInfo userInfo, String lessonDate) {
    if (globalFunction.textNullCheck(context, actionNameController, "동작이름")) {
      String now =
          DateFormat("yyyy-MM-dd").format(DateTime.now()); // 오늘 날짜 가져오기
      lessonService.create(
          docId: userInfo.docId, // 회권 고유번호 => 회원번호(문서고유번호)로 회원 식별
          uid: user.uid,
          name: nameController.text,
          phoneNumber: userInfo.phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별 => 제거
          apratusName: apratusNameController.text, //기구이름
          actionName: actionNameController.text, //동작이름
          lessonDate: lessonDate, //수업날짜
          grade: gradeController.text, //수행도
          totalNote: totalNoteController.text, //수업총메모
          onSuccess: () {
            // 저장하기 성공
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${buttonString} 성공"),
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

            sliderValue = 50;
            globalFunction.clearTextEditController([
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("항목을 모두 입력해주세요."),
      ));
    }
  }
}
