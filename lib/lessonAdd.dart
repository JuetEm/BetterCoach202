import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/actionSelector.dart';
import 'package:web_project/userInfo.dart'
    as CustomUserInfo; // 다른 페키지와 클래스 명이 겹치는 경우 alias 선언해서 사용

import 'actionInfo.dart';
import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberInfo.dart';
import 'lessonInfo.dart';
import 'lesson_service.dart';

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

TextEditingController nameController = TextEditingController();
TextEditingController apratusNameController = TextEditingController();
TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController(text: now);
TextEditingController gradeController = TextEditingController(text: "50");
TextEditingController todayNoteController = TextEditingController();
TextEditingController totalNoteController = TextEditingController();

// 가변적으로 만들어지는 TextFields
List<TextEditingController> totalNoteControllers = [];

// 가변적으로 만들어지는 TextFields DocId 집합
List<String> updateTextFieldDocId = new List.empty(growable: true);

final lessonInfos = [];

// 노트삭제를 위한 변수 선언
List<String> deleteDocId = new List.empty(growable: true);

GlobalFunction globalFunction = GlobalFunction();

//예외처리 : 동작선택으로 넘어갈 경우 일별노트 Null값 처리하지 않음.
bool ActionSelectMode = false;

String selectedDropdown = '기구';
List<String> dropdownList = [
  'REFORMER',
  'CADILLAC',
  'CHAIR',
  'LADDER BARREL',
  'SPRING BOARD',
  'SPINE CORRECTOR',
  'MAT',
  'OTHERS',
];

double sliderValue = 50;

String editDocId = "";
String editApparatusName = "";
String editLessonDate = "";
String editGrade = "";
String editTotalNote = "";

bool initState = true;
bool initStateTextfield = true;

List<TmpLessonInfo> tmpLessonInfoList = [];

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  @override
  Widget build(BuildContext context) {
    // 이전 화면에서 보낸 변수 받기
    final argsList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    CustomUserInfo.UserInfo customUserInfo = argsList[0];
    String lessonDate = argsList[1];
    List<DateTime> eventList = argsList[2];
    String lessonNoteId = argsList[3];
    String lessonAddMode = argsList[4];
    tmpLessonInfoList = argsList[5];

    if (initState) {
      print("INIT!!! : ${initState}");
      //now = DateFormat("yyyy-MM-dd").format(DateTime.now());
      lessonDateController = TextEditingController(text: lessonDate);
      gradeController = TextEditingController(text: "50");
      initState = !initState;
    }
    // if (initState) {
    //   print("INIT!!! : ${initState}");
    //   now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //   lessonDateController = TextEditingController(text: now);
    //   gradeController = TextEditingController(text: "50");
    //   initState = !initState;
    // }

    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    // // 이전 화면에서 보낸 변수 받기
    // final userInfo =
    //     ModalRoute.of(context)!.settings.arguments as CustomUserInfo.UserInfo;

    // nameController = TextEditingController(text: userInfo.name);
    // //lessonDateController = TextEditingController(text: now);
    // //gradeController = TextEditingController(text: "50");

    String todayNotedocId = "";
    bool ActionNullCheck = true;
    print('화면 리프레시 ActionNullCheck : ${ActionNullCheck}');

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, lessonAddMode, () {
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
                        FutureBuilder<QuerySnapshot>(
                          future: lessonService.readTodayNoteOflessonDate(
                            user.uid,
                            customUserInfo.docId,
                            lessonDateController.text,
                          ),
                          builder: (context, snapshot) {
                            final docsTodayNote =
                                snapshot.data?.docs ?? []; // 문서들 가져오기

                            if (docsTodayNote.isEmpty) {
                              print(
                                  "체크전 ActionSelectMode : ${ActionSelectMode}");
                              if (ActionSelectMode) {
                              } else {
                                todayNoteController.text = "";
                              }
                              todayNotedocId = "";

                              return DynamicSaveTextField(
                                customController: todayNoteController,
                                hint: "일별 메모",
                                showArrow: false,
                                customFunction: () {},
                              );
                            } else {
                              todayNoteController.text =
                                  docsTodayNote[0].get('todayNote');
                              todayNotedocId = docsTodayNote[0].id;
                              return BaseTextField(
                                customController: todayNoteController,
                                hint: "일별 메모",
                                showArrow: false,
                                customFunction: () {},
                              );
                            }
                          },
                        ),

                        // 동작입력 버튼
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Palette.gray99, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Palette.secondaryBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                            ),
                            child: InkWell(
                              onTap: () async {
                                String currentAppratus =
                                    apratusNameController.text;
                                String lessonDate = lessonDateController.text;
                                String totalNote = "";

                                bool initState = true;
                                ActionSelectMode = true;
                                print(
                                    "진입전 ActionSelectMode : ${ActionSelectMode}");

                                final List<TmpLessonInfo> result =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActionSelector(),
                                    fullscreenDialog: true,
                                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                    settings: RouteSettings(arguments: [
                                      customUserInfo,
                                      currentAppratus,
                                      lessonDate,
                                      initState,
                                      totalNote,
                                      tmpLessonInfoList
                                    ]),
                                  ),
                                );

                                tmpLessonInfoList = result;
                                ActionSelectMode = !ActionSelectMode;

                                // if (!(result == null)) {
                                //   print(
                                //       "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                                //   setState(() {
                                //     actionNameController.text =
                                //         result.actionName;
                                //     switch (result.apparatus) {
                                //       case "RE":
                                //         apratusNameController.text = "REFORMER";
                                //         break;
                                //       case "CA":
                                //         apratusNameController.text = "CADILLAC";
                                //         break;
                                //       case "CH":
                                //         apratusNameController.text = "CHAIR";
                                //         break;
                                //       case "LA":
                                //         apratusNameController.text =
                                //             "LADDER BARREL";
                                //         break;
                                //       case "SB":
                                //         apratusNameController.text =
                                //             "SPRING BOARD";
                                //         break;
                                //       case "SC":
                                //         apratusNameController.text =
                                //             "SPINE CORRECTOR";
                                //         break;
                                //       case "MAT":
                                //         apratusNameController.text = "MAT";
                                //         break;
                                //       case "OT":
                                //         apratusNameController.text = "OTHERS";
                                //         break;
                                //     }
                                //   });
                                // }
                              },
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '동작 추가',
                                      style: TextStyle(
                                          fontSize: 16, color: Palette.gray66),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: Palette.gray66,
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
                              customUserInfo.docId,
                              lessonDateController.text,
                            ),
                            builder: (context, snapshot) {
                              final docs =
                                  snapshot.data?.docs ?? []; // 문서들 가져오기
                              if (docs.isEmpty) {
                                ActionNullCheck = true;
                                print(
                                    '문서 비워져 있을경우 ActionNullCheck : ${ActionNullCheck}');
                                return Center(child: Text("동작을 추가해 주세요."));
                              } else {
                                ActionNullCheck = false;
                                print(
                                    '문서가 있는 경우 ActionNullCheck : ${ActionNullCheck}');

                                //Textfield 생성
                                createControllers(docs.length);

                                //reorderable 드래그시 그림자/디자인 조정
                                Widget proxyDecorator(Widget child, int index,
                                    Animation<double> animation) {
                                  return AnimatedBuilder(
                                    animation: animation,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: child,
                                      );
                                    },
                                    child: child,
                                  );
                                }

                                //노트 삭제를 위한 변수 초기화
                                deleteDocId = List<String>.filled(
                                    docs.length, "",
                                    growable: true);

                                //가변적으로 변하는 텍스트 필드 docID초기화
                                updateTextFieldDocId = List<String>.filled(
                                    docs.length, "",
                                    growable: true);

                                return Container(
                                  //height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),

                                  child: Theme(
                                    data: ThemeData(
                                      canvasColor:
                                          Colors.transparent, //드래그시 투명하게 만들기 적용
                                    ),
                                    child: ReorderableListView.builder(
                                      proxyDecorator: proxyDecorator,
                                      itemCount: docs.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      //buildDefaultDragHandles: false,
                                      onReorder: ((oldIndex, newIndex) {
                                        if (newIndex > docs.length)
                                          newIndex = docs.length;
                                        if (oldIndex < newIndex) newIndex -= 1;
                                        docs.insert(
                                            newIndex, docs.removeAt(oldIndex));
                                        for (int pos = 0;
                                            pos < docs.length;
                                            pos++) {
                                          lessonService.updatePos(
                                              docs[pos].id, pos);
                                        }

                                        //setState(() {});
                                      }),

                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final doc = docs[index];

                                        //일괄 textfeild 저장하기 위해 docID저장
                                        updateTextFieldDocId[index] = doc.id;
                                        deleteDocId[index] = doc.id;

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

                                        if (initStateTextfield) {
                                          totalNoteControllers[index].text =
                                              totalNote;
                                          initStateTextfield =
                                              !initStateTextfield; //동작별 노트 가져오기
                                        }

                                        return Column(
                                          key: ValueKey(doc),

                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  //color: Colors.red.withOpacity(0),
                                                  margin: const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                      color: Palette.grayEE
                                                      //color: Colors.red.withOpacity(0),
                                                      ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      //top: 5,
                                                      //bottom: 5,
                                                      left: 5.0,
                                                      right: 16.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 50,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .drag_indicator,
                                                            color:
                                                                Palette.gray33,
                                                            size: 20.0,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            apratusNameTrim,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            actionName,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                          ),
                                                          Spacer(flex: 1),
                                                          IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        '삭제'),
                                                                    content: Text(
                                                                        '동작노트를 삭제하시겠습니까?'),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          lessonService.delete(
                                                                              docId: doc.id,
                                                                              onSuccess: () {},
                                                                              onError: () {});
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            '삭제'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            '취소'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color: Palette
                                                                  .statusRed,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Palette.grayEE,
                                                ),
                                                Container(
                                                  //color: Colors.red.withOpacity(0),
                                                  margin: const EdgeInsets.only(
                                                    bottom: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    color: Colors.transparent,
                                                    //color: Colors.red.withOpacity(0),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.zero,
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Expanded(
                                                          //   child: TextField(
                                                          //     controller:
                                                          //         totalNoteControllers[
                                                          //             index],
                                                          //   ),
                                                          // ),

                                                          /// 메모 입력창
                                                          Expanded(
                                                            child:
                                                                DynamicSaveTextField(
                                                              customController:
                                                                  totalNoteControllers[
                                                                      index],
                                                              hint:
                                                                  "동작별 메모를 남겨보세요.",
                                                              showArrow: false,
                                                              customFunction:
                                                                  () {},
                                                            ),
                                                          ),
                                                          //Spacer(flex: 1),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                  ),
                                );
                              }
                              ;
                            }),

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
                          onPressed: () async {
                            print("저장하기 버튼");
                            print("저장직전 ActionNullCheck : ${ActionNullCheck}");
                            // create bucket
                            if (globalFunction.textNullCheck(
                                    context, lessonDateController, "수업일") &&
                                ActionNullCheck == false) {
                              print("userInfo.docId : ${customUserInfo.docId}");

                              if (todayNotedocId == "") {
                                // for (int idx = 0;
                                //     idx < updateTextFieldDocId.length;
                                //     idx++) {
                                //   await lessonService.updateTotalNote(
                                //     updateTextFieldDocId[idx],
                                //     totalNoteControllers[idx].text,
                                //   );
                                // }
                                lessonService.createTodaynote(
                                    docId: customUserInfo.docId,
                                    uid: user.uid,
                                    name: customUserInfo.name,
                                    lessonDate: lessonDateController.text,
                                    todayNote: todayNoteController.text,
                                    onSuccess: () {
                                      // 저장하기 성공
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("새로운 노트 작성"),
                                      ));
                                      // 저장하기 성공시 MemberInfo로 이동
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

                                      // 화면 초기화
                                      initInpuWidget();
                                      initState = !initState;
                                    },
                                    onError: () {
                                      print("저장하기 ERROR");
                                    });
                              } else {
                                print("문서가 있는 경우.. 노트 저장");

                                for (int idx = 0;
                                    idx < updateTextFieldDocId.length;
                                    idx++) {
                                  await lessonService.updateTotalNote(
                                    updateTextFieldDocId[idx],
                                    totalNoteControllers[idx].text,
                                  );
                                }

                                lessonService.updateTodayNote(
                                    docId: todayNotedocId,
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
                                            arguments: customUserInfo,
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
                              }

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
                        const SizedBox(height: 15),
                        lessonAddMode == "노트보기"
                            ? DeleteButton(
                                customUserInfo: customUserInfo,
                                lessonService: lessonService)
                            : const SizedBox(height: 15),
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

//   void initInpuWidget() {
//     globalFunction.clearTextEditController([
//       nameController,
//       apratusNameController,
//       actionNameController,
//       lessonDateController,
//       todayNoteController,
//       gradeController,
//       totalNoteController
//     ]);
//     lessonDateController.text = now;
//     sliderValue = 50;
//     // 에러 발생해서 정리..
// //     The following assertion was thrown while dispatching notifications for TextEditingController:
// // setState() or markNeedsBuild() called during build.
//     // setState(() {
//     //   sliderValue = 50;
//     // });
//   }

  //Textfield 생성
  void createControllers(length) {
    DynamicController dynamicController;
    TextEditingController tmpTextEditingController;
    for (var i = 0; i < length; i++) {
      dynamicController = DynamicController("dynamicController-${i}");
      tmpTextEditingController = dynamicController.dynamicController;
      totalNoteControllers.add(tmpTextEditingController);
    }
  }
}

// 삭제버튼
class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key? key,
    required this.customUserInfo,
    required this.lessonService,
  }) : super(key: key);

  final CustomUserInfo.UserInfo customUserInfo;
  final LessonService lessonService;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Palette.mainBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("삭제하기",
            style: TextStyle(fontSize: 18, color: Palette.textRed)),
      ),
      onPressed: () async {
        // create bucket
        final retvaldelte =
            await showAlertDialog(context, '정말로 삭제하시겠습니까?', '레슨노트를 삭제합니다.');
        if (retvaldelte == "OK") {
          widget.lessonService.deleteTodayNote(
            docId: widget.customUserInfo.docId,
            onSuccess: () {},
            onError: () {},
          );
          for (int idx = 0; idx < deleteDocId.length; idx++) {
            //print(deleteDocId[idx]);
            widget.lessonService.delete(
              docId: deleteDocId[idx],
              onSuccess: () {},
              onError: () {},
            );
          }

          // 삭제하기 성공시 MemberList로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberInfo(),
              // setting에서 arguments로 다음 화면에 회원 정보 넘기기
              settings: RouteSettings(
                arguments: widget.customUserInfo,
              ),
            ),
          );

          // 페이지 초기화
          initInpuWidget();
          initState = !initState;
        }

        //if (showAlertDialog(context) == "OK"){
        //
      },
    );
  }
}

class DynamicController {
  DynamicController(this.dynamicClassName);
  TextEditingController dynamicController = TextEditingController();
  String dynamicClassName = "";
}

void initInpuWidget() {
  globalFunction.clearTextEditController([
    nameController,
    apratusNameController,
    actionNameController,
    lessonDateController,
    todayNoteController,
    gradeController,
    totalNoteController
  ]);
  lessonDateController.text = now;
  sliderValue = 50;
  initStateTextfield = !initStateTextfield;
  // 에러 발생해서 정리..
//     The following assertion was thrown while dispatching notifications for TextEditingController:
// setState() or markNeedsBuild() called during build.
  // setState(() {
  //   sliderValue = 50;
  // });
}
