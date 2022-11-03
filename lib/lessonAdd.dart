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

//TextEditingController nameController = TextEditingController();
//TextEditingController apratusNameController = TextEditingController();
//TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController(text: now);
//TextEditingController gradeController = TextEditingController(text: "50");
TextEditingController todayNoteController = TextEditingController();

// 가변적으로 TextFields
List<TextEditingController> totalNoteControllers = [];

// 가변적으로 TextFields DocId 집합 (전체삭제시 필요)
List<String> totalNoteTextFieldDocId = new List.empty(growable: true);
List<TmpLessonInfo> tmpLessonInfoList = new List.empty(growable: true);

//List<String> totalNotes = new List.empty(growable: true);

GlobalFunction globalFunction = GlobalFunction();

//예외처리 : 동작이 없을 경우 저장을 막는 용도로 사용
bool actionSelectMode = false;

//초기상태
bool initState = true;

//날짜 변경할 경우 데이터 다시 불러오기에 활용.
bool DateChangeMode = false;

//totalNoteControllers,totalNoteTextFieldDocId index 에러 방지
bool flagIndexErr = true;

String lessonDate = now;
int additionalActionlength = 0;

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

bool keyboardOpenBefore = false;
String todayNotedocId = "";
String todayNoteView = "";

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  // @override
  // void initState() {
  //   //처음에만 날짜 받아옴.

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lessonDateController.clear();
    todayNoteController.clear();
    clearTotalNoteControllers();
    totalNoteTextFieldDocId.clear();
    tmpLessonInfoList.clear();
    todayNotedocId = "";
    todayNoteView = "";

    //deleteControllers();
    initState = true;
    DateChangeMode = false;
    print("[LA] Dispose : initState ${initState} ");
    super.dispose();
  }

  bool actionNullCheck = true;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    final lessonService = context.read<LessonService>();

    // 이전 화면에서 보낸 변수 받기
    final argsList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    CustomUserInfo.UserInfo customUserInfo = argsList[0];
    List<DateTime> eventList = argsList[2];
    String lessonNoteId = argsList[3];
    String lessonAddMode = argsList[4];
    tmpLessonInfoList = argsList[5];

    print(
        '[LA] 시작 initState - ${initState} / DateChange - ${DateChangeMode} / actionNullCheck - ${actionNullCheck}');
    print(
        "[LA] 노트 관련 ${lessonDate} / ${lessonAddMode} / tmpLessonInfoList ${tmpLessonInfoList.length}");

    if (initState) {
      print("INIT!!! : ${initState}, DateChange:${DateChangeMode}");
      //now = DateFormat("yyyy-MM-dd").format(DateTime.now());

      if (!DateChangeMode) {
        lessonDate = argsList[1];
        lessonDateController.text = lessonDate;
      } else {
        lessonDate = lessonDateController.text;
        DateChangeMode = false;
      }
      print("Date : ${lessonDate}");

      Future<int> lenssonData = lessonService.countPos(
        user.uid,
        customUserInfo.docId,
        lessonDateController.text,
      );

      lenssonData.then((val) {
        // int가 나오면 해당 값을 출력
        print('val: $val');
        //Textfield 생성
        createControllers(val);
        //노트 삭제를 위한 변수 초기화
        //totalNoteTextFieldDocId = List<String>.filled(val, "", growable: true);

        //노트 삭제를 위한 변수 초기화
        //totalNotes = List<String>.filled(val, "", growable: true);
      }).catchError((error) {
        // error가 해당 에러를 출력
        print('error: $error');
      });

      print("초기화시컨트롤러:${totalNoteControllers}");
      print("초기화시노트아이디:${totalNoteTextFieldDocId}");

      initState = !initState;
      actionSelectMode = false;
      print("INIT!!!변경 : ${initState}");
    }
    print("재빌드시 init상태 : ${initState}");
    // if (MediaQuery.of(context).viewInsets.bottom == 0) {
    //   if (keyboardOpenBefore) {
    //     FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
    //     keyboardOpenBefore = false;
    //   }
    // } else {
    //   keyboardOpenBefore = true;
    // }
    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, lessonAddMode, () {
            // 뒤로가기 선택시 MemberInfo로 이동
            Navigator.pop(context);
          }),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    /// 입력창
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      // padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0,
                      //     MediaQuery.of(context).viewInsets.bottom + 14),
                      child: Column(
                        children: [
                          // Text(
                          //     "변경 : ${MediaQuery.of(context).viewInsets.bottom.toString()}"),
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
                            customFunction: () async {
                              await globalFunction.getDateFromCalendar(
                                  context,
                                  lessonDateController,
                                  "수업일",
                                  lessonDateController.text);

                              todayNoteController.text = "";

                              //lessonDate = lessonDateController.text;
                              DateChangeMode = true;
                              initState = true;
                              print(
                                  "[LA] 수업일변경 : lessonDateController ${lessonDateController.text} / todayNoteController ${todayNoteController.text} / DateChangeMode ${DateChangeMode}");
                              initInpuWidget(
                                  uid: user.uid,
                                  docId: customUserInfo.docId,
                                  lessonService: lessonService);

                              // setState(() {
                              //   print(
                              //       "수업일변경 : ${lessonDateController.text}  - ${todayNoteController.text}");
                              //   todayNoteController.text = "";
                              //   print(
                              //       "텍스트지우기 : ${lessonDateController.text} - ${todayNoteController.text}");
                              //   //lessonDate = lessonDateController.text;
                              //   DateChangeMode = true;

                              //   initInpuWidget();
                              // });
                              // await refreshLessonDate(
                              //     uid: user.uid,
                              //     docId: customUserInfo.docId,
                              //     lessonService: lessonService);
                              //lessonService.notifyListeners();
                              // setState(() {

                              // });
                            },
                          ),
                          SizedBox(height: 14),
                          Row(
                            children: [
                              Text(
                                '수업메모',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.gray00,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 14),

                          /// 일별 메모 입력창
                          FutureBuilder<QuerySnapshot>(
                            future: lessonService.readTodayNoteOflessonDate(
                              user.uid,
                              customUserInfo.docId,
                              lessonDateController.text,
                            ),
                            builder: (context, snapshot) {
                              print("문서가져오기시작 : ${lessonDateController.text}");

                              final docsTodayNote =
                                  snapshot.data?.docs ?? []; // 문서들 가져오기
                              //print("문서가져오기끝");

                              // 기존 저장된 값이 없으면 초기화, 동작선택모드 일경우
                              // if (docsTodayNote.isEmpty) {
                              //   if (ActionSelectMode) {
                              //   } else {
                              //     todayNoteController.text = "";
                              //   }
                              //   todayNotedocId = "";
                              // } else {
                              //   todayNoteController.text =
                              //       docsTodayNote[0].get('todayNote');
                              //   todayNotedocId = docsTodayNote[0].id;
                              // }

                              print(
                                  "[LA] 일별노트 출력 시작 : 유/무 ${docsTodayNote.isEmpty} / todayNotedocId ${todayNotedocId} / todayNoteView ${todayNoteView} / todayNoteController ${todayNoteController}");

                              if (docsTodayNote.isEmpty) {
                                todayNotedocId = "";
                                todayNoteView = "";
                                WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => todayNoteController.clear());
                                //에러 제어하기 위해 추가.https://github.com/flutter/flutter/issues/17647
                                //todayNoteController.text = "";
                                print(
                                    "뿌릴 일별 노트 없음 : ${todayNoteController.text}");
                              } else {
                                todayNoteView =
                                    docsTodayNote[0].get('todayNote');
                                todayNotedocId = docsTodayNote[0].id;
                                todayNoteController.text =
                                    docsTodayNote[0].get('todayNote');
                                print(
                                    "뿌릴 일별 노트 출력 완료 : ${todayNoteController.text} - ${todayNotedocId} ");
                              }
                              print(
                                  "[LA] 일별노트 출력 결과 : todayNotedocId ${todayNotedocId} / todayNoteView ${todayNoteView} / todayNoteController ${todayNoteController}");
                              // if (initStateTextfield) {
                              //   if (docsTodayNote.isEmpty) {
                              //     todayNotedocId = "";
                              //     todayNoteController.text = "";
                              //     print("뿌릴 일별 노트 없음");
                              //   } else {
                              //     todayNoteController.text =
                              //         docsTodayNote[0].get('todayNote');
                              //     todayNotedocId = docsTodayNote[0].id;
                              //     print("뿌릴 일별 노트 출력 완료");
                              //   }
                              //   //initStateTextfield = false;
                              // }

                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text("텍스트필드!!"),
                              // ));
                              // 텍스트 필드 이전
                              // return DynamicSaveTextField(
                              //   customController: todayNoteController,
                              //   hint: "일별 메모",
                              //   showArrow: false,
                              //   customFunction: () {
                              //     FocusScope.of(context).unfocus();
                              //   },
                              // );

                              return InkWell(
                                onTap: () {
                                  // todayNoteController.text =
                                  //     todayNoteView;
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    // ignore: unnecessary_new
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        //title: Text('일별 메모 작성'),
                                        content: Builder(
                                          builder: (context) {
                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                            var height = MediaQuery.of(context)
                                                .size
                                                .height;
                                            var width = MediaQuery.of(context)
                                                .size
                                                .width;

                                            return Container(
                                              //height: 40,
                                              width: width - 100,
                                              child: PopupTextField(
                                                customController:
                                                    todayNoteController,
                                                hint: "일별 메모",
                                                showArrow: false,
                                                customFunction: () async {
                                                  print(
                                                      "[LA] 일별메모 저장 : todayNotedocId ${todayNotedocId} ");
                                                  //일별 노트 저장
                                                  await todayNoteSave(
                                                      lessonService,
                                                      customUserInfo,
                                                      context);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              print(
                                                  "[LA] 일별메모 저장 : todayNotedocId ${todayNotedocId} ");
                                              //일별 노트 저장
                                              await todayNoteSave(lessonService,
                                                  customUserInfo, context);
                                            },
                                            child: Text('저장'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  //   showDialog(
                                  //     context: context,
                                  //     barrierDismissible: true,
                                  //     builder: (BuildContext context) {
                                  //       return AlertDialog(
                                  //         title: Text('일별 메모 작성'),
                                  //         content: DynamicSaveTextField(
                                  //           customController:
                                  //               todayNoteController,
                                  //           hint: "일별 메모",
                                  //           showArrow: false,
                                  //           customFunction: () {
                                  //             FocusScope.of(context)
                                  //                 .unfocus();
                                  //           },
                                  //         ),
                                  //         actions: <Widget>[
                                  //           TextButton(
                                  //             onPressed: () {
                                  //               Navigator.of(context)
                                  //                   .pop();
                                  //             },
                                  //             child: Text('저장'),
                                  //           ),
                                  //           TextButton(
                                  //             onPressed: () {
                                  //               Navigator.of(context)
                                  //                   .pop();
                                  //             },
                                  //             child: Text('취소'),
                                  //           ),
                                  //         ],
                                  //       );
                                  //     },
                                  //  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      //top: 5,
                                      //bottom: 5,
                                      ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight: 50,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Palette.grayFF, width: 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      color: Palette.grayFF,
                                    ),
                                    //height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          (todayNoteView == "")
                                              ? Text("일별 메모를 남겨보세요.",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    //fontWeight:
                                                    //FontWeight.bold,
                                                    color: Palette.gray99,
                                                  ))
                                              : Expanded(
                                                  child: Text(
                                                    todayNoteView,
                                                    // overflow:
                                                    //     TextOverflow
                                                    //         .fade,
                                                    maxLines: 10,
                                                    softWrap: true,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                          fontSize: 14.0,
                                                        ),
                                                  ),
                                                ),
                                          // Text(
                                          //   todayNoteView,
                                          //   style: TextStyle(
                                          //     fontSize: 14.0,
                                          //     //fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                          SizedBox(width: 20),
                                          Spacer(flex: 1),
                                          Icon(
                                            Icons.mode_edit,
                                            color: Palette.gray66,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // 동작입력 버튼
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Palette.buttonOrange, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Palette.secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  //String currentAppratus =
                                  //    apratusNameController.text;
                                  String currentAppratus = "";

                                  String lessonDate = lessonDateController.text;
                                  String totalNote = "";

                                  //동작선택 모드
                                  //bool initState = true;
                                  actionSelectMode = true;
                                  print(
                                      "[LA] 동작추가시작 tmpLessonInfoList : ${tmpLessonInfoList.length}");
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

                                  additionalActionlength = result.length
                                          .toInt() -
                                      totalNoteTextFieldDocId.length.toInt();

                                  print(
                                      "추가된 동작 개수 : ${additionalActionlength.toString()}");

                                  // 동작추가시에 textcontroller 추가 생성
                                  createControllers(additionalActionlength);

                                  // for (var i = 0;
                                  //     i < additionalActionlength;
                                  //     i++) {
                                  //   totalNoteTextFieldDocId.add("");
                                  //   //totalNotes.add("");
                                  // }
                                  print("동작추가시컨트롤러:${totalNoteControllers}");
                                  print(
                                      "동작추가시노트아이디:${totalNoteTextFieldDocId}");

                                  lessonService.notifyListeners();

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
                                            fontSize: 14,
                                            color: Palette.buttonOrange),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Palette.buttonOrange,
                                        size: 12.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 재정렬 가능한 리스트 시작
                          FutureBuilder<QuerySnapshot>(
                              future: lessonService.readNotesOflessonDate(
                                user.uid,
                                customUserInfo.docId,
                                lessonDateController.text,
                              ),
                              builder: (context, snapshot) {
                                print("재정렬 기능 시작");
                                final docs =
                                    snapshot.data?.docs ?? []; // 문서들 가져오기
                                if (docs.isEmpty) {
                                  actionNullCheck = true;
                                  print(
                                      '문서 비워져 있을경우 ActionNullCheck : ${actionNullCheck}');

                                  // 이전 값들 초기화
                                  //초기화
                                  tmpLessonInfoList.clear();
                                  for (var i = 0;
                                      i < tmpLessonInfoList.length;
                                      ++i) {
                                    print("${tmpLessonInfoList[i].docId}");
                                  }
                                  totalNoteTextFieldDocId.clear();

                                  print("total노트 : ${totalNoteTextFieldDocId}");

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40),
                                    child: Center(child: Text("동작을 추가해 주세요.")),
                                  );
                                } else {
                                  actionNullCheck = false;
                                  print(
                                      '문서가 있는 경우 actionNullCheck : ${actionNullCheck}');

                                  //reorderable 드래그시 그림자/디자인 조정
                                  Widget proxyDecorator(Widget child, int index,
                                      Animation<double> animation) {
                                    return AnimatedBuilder(
                                      animation: animation,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: child,
                                        );
                                      },
                                      child: child,
                                    );
                                  }

                                  //초기화
                                  totalNoteTextFieldDocId = List<String>.filled(
                                      docs.length, "",
                                      growable: true);

                                  TmpLessonInfo tmpLessonInfo = TmpLessonInfo(
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    true,
                                  );

                                  tmpLessonInfoList =
                                      List<TmpLessonInfo>.filled(
                                          docs.length, tmpLessonInfo,
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
                                        canvasColor: Colors
                                            .transparent, //드래그시 투명하게 만들기 적용
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
                                          if (oldIndex < newIndex)
                                            newIndex -= 1;
                                          docs.insert(newIndex,
                                              docs.removeAt(oldIndex));
                                          totalNoteControllers.insert(
                                              newIndex,
                                              totalNoteControllers
                                                  .removeAt(oldIndex));
                                          //재정렬에 따른 컨트롤러, totalNote DocId, tmp 저장
                                          // totalNoteTextFieldDocId.insert(
                                          //     newIndex,
                                          //     totalNoteTextFieldDocId
                                          //         .removeAt(oldIndex));
                                          //재정렬에 따른 컨트롤러, totalNote DocId, tmp 저장
                                          // tmpLessonInfoList.insert(
                                          //     newIndex,
                                          //     tmpLessonInfoList
                                          //         .removeAt(oldIndex));

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
                                          print('에러포인트시작 : ${index}');

                                          totalNoteTextFieldDocId[index] =
                                              doc.id;

                                          print(
                                              "total노트 : ${totalNoteTextFieldDocId}");

                                          //일괄 textfeild 저장하기 위해 docID저장
                                          //예외처리 ::
                                          // if ((totalNoteTextFieldDocId.length -
                                          //         1) >=
                                          //     index) {
                                          //   totalNoteTextFieldDocId[index] =
                                          //       doc.id;
                                          //   flagIndexErr = true;
                                          // } else {
                                          //   flagIndexErr = false;
                                          // }
                                          // print(
                                          //     '에러방지실행 : ${flagIndexErr},${totalNoteTextFieldDocId.length},${index}');

                                          // print('에러포인트끝 : ${index}');

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

                                          tmpLessonInfo = TmpLessonInfo(
                                            apratusName,
                                            actionName,
                                            name,
                                            lessonDate,
                                            grade,
                                            totalNote,
                                            doc.id,
                                            uid,
                                            true,
                                          );

                                          tmpLessonInfoList[index] =
                                              tmpLessonInfo;

                                          // if (tmpLessonInfoList.isEmpty) {
                                          //   tmpLessonInfoList
                                          //       .add(tmpLessonInfo);
                                          // } else {
                                          //   addTmpInfoList(tmpLessonInfoList,
                                          //       tmpLessonInfo);
                                          // }
                                          for (var i = 0;
                                              i < tmpLessonInfoList.length;
                                              ++i) {
                                            print(
                                                "${tmpLessonInfoList[i].docId}");
                                          }
                                          print(
                                              "InfoList에 내용 추가 : 길이${tmpLessonInfoList.length.toString()}");
                                          //tmpLessonInfoList.add(tmpLessonInfo);

                                          //print(
                                          //    "tmpLessonInfoList:${tmpLessonInfoList[index]}");
                                          //totalNotes[index] =
                                          //    doc.get('totalNote'); //수업총메모
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

                                          // 첫 화면에서

                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text(
                                          //       "텍스트필드!!${initStateTextfield}"),
                                          // ));
                                          // print(
                                          //     '텍스트필드채움 : ActionSelectMode-${ActionSelectMode}');

                                          // totalNoteControllers[index].text =
                                          //     totalNote;

                                          // if (initStateTextfield) {
                                          //   //예외처리 ::
                                          //   if (totalNoteTextFieldDocId.length >
                                          //       index) {
                                          //     totalNoteControllers[index].text =
                                          //         totalNote;
                                          //   }

                                          //   if (index == (docs.length - 1)) {
                                          //     if (initStateTextfieldCnt > 2) {
                                          //       initStateTextfield = false;
                                          //       initStateTextfieldCnt = 0;
                                          //     } else {
                                          //       initStateTextfieldCnt++;
                                          //     }
                                          //     print(
                                          //         '이제안바꿔 : ${initStateTextfield}');
                                          //   }
                                          // }

                                          return Column(
                                            key: ValueKey(doc),
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    //color: Colors.red.withOpacity(0),
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 10,
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
                                                        color: Palette
                                                            .backgroundOrange
                                                        //color: Colors.red.withOpacity(0),
                                                        ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        //top: 5,
                                                        //bottom: 5,
                                                        left: 10.0,
                                                        right: 10.0,
                                                      ),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .drag_handle_outlined,
                                                              color: Palette
                                                                  .gray33,
                                                              size: 20.0,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              apratusNameTrim,
                                                              style: TextStyle(
                                                                fontSize: 14.0,
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
                                                              style: TextStyle(
                                                                fontSize: 14.0,
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
                                                                              () async {
                                                                            await lessonService.deleteSinglelesson(
                                                                                docId: doc.id,
                                                                                onSuccess: () {
                                                                                  totalNoteControllers.removeAt(index);
                                                                                  //totalNoteTextFieldDocId.removeAt(index);
                                                                                  //tmpLessonInfoList.removeAt(index);

                                                                                  //print("삭제시시컨트롤러:${totalNoteControllers}");
                                                                                  //print("삭제시노트아이디:${totalNoteTextFieldDocId}");
                                                                                },
                                                                                onError: () {});
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('삭제'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('취소'),
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
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        // ignore: unnecessary_new
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0))),
                                                            //title: Text('일별 메모 작성'),
                                                            content: Builder(
                                                              builder:
                                                                  (context) {
                                                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                                var height =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height;
                                                                var width =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width;
                                                                totalNoteControllers[
                                                                            index]
                                                                        .text =
                                                                    totalNote;

                                                                return Container(
                                                                  //height:
                                                                  //    40,
                                                                  width: width -
                                                                      100,
                                                                  child:
                                                                      PopupTextField(
                                                                    customController:
                                                                        totalNoteControllers[
                                                                            index],
                                                                    hint:
                                                                        "동작별 메모",
                                                                    showArrow:
                                                                        false,
                                                                    customFunction:
                                                                        () async {
                                                                      //일별 노트 저장
                                                                      await totalNoteSingleSave(
                                                                          lessonService,
                                                                          totalNoteTextFieldDocId[
                                                                              index],
                                                                          totalNoteControllers[index]
                                                                              .text,
                                                                          context,
                                                                          index);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Text('취소'),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  print(
                                                                      "[LA] 동작별메모 저장 : totalNoteTextFieldDocId[index] / totalNoteControllers[index].text");
                                                                  //동작별 노트 저장
                                                                  await totalNoteSingleSave(
                                                                      lessonService,
                                                                      totalNoteTextFieldDocId[
                                                                          index],
                                                                      totalNoteControllers[
                                                                              index]
                                                                          .text,
                                                                      context,
                                                                      index);
                                                                },
                                                                child:
                                                                    Text('저장'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      //height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10.0),
                                                          ),
                                                          color: Palette.grayFA
                                                          //color: Colors.red.withOpacity(0),
                                                          ),
                                                      //color: Palette.grayEE,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                25, 0, 10, 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            totalNote.isEmpty
                                                                ? Text(
                                                                    "동작별 메모를 남겨보세요.",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      //fontWeight:
                                                                      //FontWeight.bold,
                                                                      color: Palette
                                                                          .gray99,
                                                                    ))
                                                                : Text(""),
                                                            //SizedBox(width: 20),
                                                            Expanded(
                                                              child: Text(
                                                                totalNote,
                                                                // overflow:
                                                                //     TextOverflow
                                                                //         .fade,
                                                                maxLines: 10,
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                              ),
                                                            ),
                                                            //Spacer(flex: 1),
                                                            Icon(
                                                              Icons.mode_edit,
                                                              color: Palette
                                                                  .gray66,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // 이전 텍스트 필드
                                                  // Container(
                                                  //   //color: Colors.red.withOpacity(0),
                                                  //   margin:
                                                  //       const EdgeInsets.only(
                                                  //     bottom: 5,
                                                  //   ),
                                                  //   decoration: BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.all(
                                                  //       Radius.circular(10.0),
                                                  //     ),
                                                  //     color: Colors.transparent,
                                                  //     //color: Colors.red.withOpacity(0),
                                                  //   ),
                                                  //   child: Padding(
                                                  //     padding: EdgeInsets.zero,
                                                  //     child: SizedBox(
                                                  //       height: 60,
                                                  //       child: Row(
                                                  //         mainAxisAlignment:
                                                  //             MainAxisAlignment
                                                  //                 .start,
                                                  //         children: [
                                                  //           // Expanded(
                                                  //           //   child: TextField(
                                                  //           //     controller:
                                                  //           //         totalNoteControllers[
                                                  //           //             index],
                                                  //           //   ),
                                                  //           // ),

                                                  //           /// 메모 입력창
                                                  //           flagIndexErr
                                                  //               ? Expanded(
                                                  //                   child:
                                                  //                       DynamicSaveTextField(
                                                  //                     customController:
                                                  //                         totalNoteControllers[
                                                  //                             index],
                                                  //                     hint:
                                                  //                         "동작별 메모를 남겨보세요.",
                                                  //                     showArrow:
                                                  //                         false,
                                                  //                     customFunction:
                                                  //                         () {
                                                  //                       FocusScope.of(context)
                                                  //                           .unfocus();
                                                  //                     },
                                                  //                   ),
                                                  //                 )
                                                  //               : Text("")
                                                  //           //Spacer(flex: 1),
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                                ;
                              }),

                          const SizedBox(height: 15),

                          /// 추가버튼 UI 수정
                          ///
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                elevation: 0,
                                backgroundColor: Palette.buttonOrange,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 90),
                                child: Text("저장하기",
                                    style: TextStyle(fontSize: 16)),
                              ),
                              onPressed: () async {
                                print(
                                    "[LA] 저장버튼실행 actionNullCheck : ${actionNullCheck}/todayNoteView : ${todayNoteView}");

                                // 수업일, 동작선택, 필수 입력
                                if ((todayNoteView == "") &&
                                    actionNullCheck == true) {
                                  //오늘의 노트가 없는 경우, 노트 생성 및 동작 노트들 저장
                                  //await todayNoteSave(
                                  //    lessonService, customUserInfo, context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("일별노트 또는 동작선택중 하나는 필수입력해주세요."),
                                  ));
                                } else {
                                  print(
                                      "[LA] 노트저장 DateChangeMode : ${DateChangeMode}/todayNoteView : ${todayNoteView} / initState : ${initState}");
                                  DateChangeMode = false;
                                  lessonService.notifyListeners();
                                  Navigator.pop(context);
                                }
                              }),

                          /// UI 수정 전
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     elevation: 0,
                          //     backgroundColor: Palette.buttonOrange,
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(16.0),
                          //     child:
                          //         Text("저장하기", style: TextStyle(fontSize: 18)),
                          //   ),
                          //   onPressed: () async {
                          //     print("저장하기 버튼");
                          //     print(
                          //         "저장직전 actionNullCheck : ${actionNullCheck}");
                          //     // 수업일, 동작선택, 필수 입력
                          //     if ((todayNoteView == "") &&
                          //         actionNullCheck == true) {
                          //       //오늘의 노트가 없는 경우, 노트 생성 및 동작 노트들 저장
                          //       //await todayNoteSave(
                          //       //    lessonService, customUserInfo, context);

                          //       ScaffoldMessenger.of(context)
                          //           .showSnackBar(SnackBar(
                          //         content: Text("일별노트 또는 동작선택중 하나는 필수입력해주세요."),
                          //       ));
                          //     } else {
                          //       lessonService.notifyListeners();
                          //       Navigator.pop(context);
                          //     }
                          //   },
                          // ),
                          const SizedBox(height: 15),
                          lessonAddMode == "노트보기"
                              ? DeleteButton(
                                  actionNullCheck: actionNullCheck,
                                  todayNotedocId: todayNotedocId,
                                  lessonService: lessonService,
                                  totalNoteTextFieldDocId:
                                      totalNoteTextFieldDocId,
                                )
                              : const SizedBox(height: 15),
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

  Future<void> totalNoteSave(LessonService lessonService,
      CustomUserInfo.UserInfo customUserInfo, BuildContext context) async {
    if (todayNotedocId == "") {
      // 동작별 노트 업데이트
      for (int idx = 0; idx < totalNoteTextFieldDocId.length; idx++) {
        await lessonService.updateTotalNote(
          totalNoteTextFieldDocId[idx],
          totalNoteControllers[idx].text,
        );
      }
      // for (int idx = 0;
      await lessonService.createTodaynote(
          docId: customUserInfo.docId,
          uid: customUserInfo.uid,
          name: customUserInfo.name,
          lessonDate: lessonDateController.text,
          todayNote: todayNoteController.text,
          onSuccess: () {
            // 저장하기 성공
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("새로운 노트 작성"),
            ));
            lessonService.notifyListeners();

            // 저장하기 성공시 MemberInfo로 이동, 뒤로가기
            Navigator.pop(context);
          },
          onError: () {
            print("저장하기 ERROR");
          });
    } else {
      print("문서가 있는 경우.. 노트 저장");

      // 동작별 노트 업데이트
      for (int idx = 0; idx < totalNoteTextFieldDocId.length; idx++) {
        await lessonService.updateTotalNote(
          totalNoteTextFieldDocId[idx],
          totalNoteControllers[idx].text,
        );
      }

      await lessonService.updateTodayNote(
          docId: todayNotedocId,
          todayNote: todayNoteController.text,
          onSuccess: () {
            // 저장하기 성공
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("노트수정 완료"),
            ));
            // 저장하기 성공시 MemberInfo로 이동, 뒤로가기
            Navigator.pop(context);
          },
          onError: () {
            print("저장하기 ERROR");
          });
    }
  }
}

Future<void> totalNoteSingleSave(
  LessonService lessonService,
  String totalNoteTextFieldDocId,
  String totalNote,
  BuildContext context,
  int index,
) async {
  await lessonService.updateTotalNote(
    totalNoteTextFieldDocId,
    totalNote,
  );
  totalNoteControllers[index].clear();
  Navigator.pop(context);
  lessonService.notifyListeners();
}

Future<void> todayNoteSave(LessonService lessonService,
    CustomUserInfo.UserInfo customUserInfo, BuildContext context) async {
  if (todayNotedocId == "") {
    print(
        "[LA] todayNoteSave 새노트생성 ${lessonDateController.text} / ${todayNoteController.text}");
    // for (int idx = 0;
    await lessonService.createTodaynote(
        docId: customUserInfo.docId,
        uid: customUserInfo.uid,
        name: customUserInfo.name,
        lessonDate: lessonDateController.text,
        todayNote: todayNoteController.text,
        onSuccess: () {
          // 저장하기 성공
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("일별노트 저장"),
          ));
          //todayNoteController.clear();
          Navigator.pop(context);
          //lessonService.notifyListeners();
        },
        onError: () {
          print("저장하기 ERROR");
        });
  } else {
    print(
        "[LA] todayNoteSave 노트수정 ${todayNotedocId} / ${lessonDateController.text} / ${todayNoteController.text}");

    await lessonService.updateTodayNote(
        docId: todayNotedocId,
        todayNote: todayNoteController.text,
        onSuccess: () {
          // 저장하기 성공
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("일별노트 수정"),
          ));

          // 저장하기 성공시 MemberInfo로 이동, 뒤로가기
          Navigator.pop(context);
        },
        onError: () {
          print("저장하기 ERROR");
        });
  }
}

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

//Textfield 생성
clearTotalNoteControllers() {
  //print('before:${totalNoteControllers}');
  for (var i = 0; i < totalNoteControllers.length; ++i) {
    totalNoteControllers[i].clear();
  }
  totalNoteControllers.clear();
  //totalNoteControllers = [];
  //print('after:${totalNoteControllers}');
}

//Textfield 생성
deleteControllers() {
  //print('before:${totalNoteControllers}');
  // for (var i = 0; i < totalNoteControllers.length; ++i) {
  //   totalNoteControllers[i].dispose();
  // }
  totalNoteControllers = [];
  //print('after:${totalNoteControllers}');
}

class DynamicController {
  DynamicController(this.dynamicClassName);
  TextEditingController dynamicController = TextEditingController();
  String dynamicClassName = "";
}

// 삭제버튼
class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key? key,
    required this.actionNullCheck,
    required this.todayNotedocId,
    required this.lessonService,
    required this.totalNoteTextFieldDocId,
  }) : super(key: key);

  final bool actionNullCheck;
  final String todayNotedocId;
  final LessonService lessonService;
  final List<String> totalNoteTextFieldDocId;

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
        final retvaldelte = await showAlertDialog(
            context, '정말로 삭제하시겠습니까?', '레슨노트 전체내용을 삭제합니다.');
        if (retvaldelte == "OK") {
          if (widget.actionNullCheck) {
            print(
                "전체삭제 - 오늘노트삭제 : actionNullCheck - ${widget.actionNullCheck} / ${todayNotedocId}");
            await widget.lessonService.deleteTodayNote(
              docId: todayNotedocId,
              onSuccess: () {},
              onError: () {},
            );
          } else {
            print("전체삭제 - 오늘노트클리어 : ${todayNotedocId} ");
            await widget.lessonService.clearTodayNote(
              docId: todayNotedocId,
              onSuccess: () {},
              onError: () {},
            );
          }
          for (int idx = 0; idx < totalNoteTextFieldDocId.length; idx++) {
            print("전체삭제 - 동작별 노트삭제 : ${totalNoteTextFieldDocId[idx]} ");
            await widget.lessonService.deleteMultilesson(
              docId: totalNoteTextFieldDocId[idx],
              onSuccess: () {},
              onError: () {},
            );
          }
          // 삭제하기 성공시 MemberList로 이동
          widget.lessonService.notifyListeners(); // 화면 갱신
          Navigator.pop(context);
        }

        //if (showAlertDialog(context) == "OK"){
        //
      },
    );
  }
}

void initInpuWidget({
  required String uid,
  required String docId,
  required LessonService lessonService,
}) async {
  todayNoteController.text = "";
  clearTotalNoteControllers();
  totalNoteTextFieldDocId.clear();
  tmpLessonInfoList.clear();
  todayNotedocId = "";
  todayNoteView = "";
  DateChangeMode = false;

  print(
      "[LA] 수업일변경 - initInpuWidget/초기화 : ${todayNoteController} / ${totalNoteTextFieldDocId} / ${tmpLessonInfoList}");

  lessonDate = lessonDateController.text;

  int lenssonData = await lessonService.countPos(
    uid,
    docId,
    lessonDateController.text,
  );

  //Textfield 생성
  createControllers(lenssonData);

  print(
      "[LA] 수업일변경 - initInpuWidget/재생성 totalNoteControllers${totalNoteControllers} / totalNoteTextFieldDocId${totalNoteTextFieldDocId} / tmpLessonInfoList${tmpLessonInfoList})");
  print("[LA] 수업일변경 - notifyListeners / ${initState}");
  lessonService.notifyListeners();
  // 에러 발생해서 정리..
//     The following assertion was thrown while dispatching notifications for TextEditingController:
// setState() or markNeedsBuild() called during build.
  // setState(() {
  //   sliderValue = 50;
  // });
}

// Future<void> refreshLessonDate({
//   required String uid,
//   required String docId,
//   required LessonService lessonService,
// }) async {
//   print("REFRESH!!!");
//   //now = DateFormat("yyyy-MM-dd").format(DateTime.now());
//   lessonDate = lessonDateController.text;
//   print("Date : ${lessonDate}");

//   int lenssonData = await lessonService.countPos(
//     uid,
//     docId,
//     lessonDateController.text,
//   );

//   //Textfield 생성
//   createControllers(lenssonData);
//   //노트 삭제를 위한 변수 초기화

//   print("초기화시컨트롤러:${totalNoteControllers}");
//   print("초기화시노트아이디:${totalNoteTextFieldDocId}");
// }

void addTmpInfoList(
    List<TmpLessonInfo> tmpLessonInfoList, TmpLessonInfo tmpLessonInfo) {
  bool isNew = true;
  for (int i = 0; i < tmpLessonInfoList.length; i++) {
    if (tmpLessonInfoList[i].docId == tmpLessonInfo.docId) {
      isNew = false;
    }
  }
  if (isNew) {
    tmpLessonInfoList.add(tmpLessonInfo);
  }
}
