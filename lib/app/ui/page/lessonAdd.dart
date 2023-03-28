import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/model/globalVariables.dart';
import 'package:web_project/app/data/provider/daylesson_service.dart';
import 'package:web_project/app/data/provider/memberTicket_service.dart';
import 'package:web_project/app/data/provider/sequenceCustom_service.dart';
import 'package:web_project/app/data/provider/sequenceRecent_service.dart';
import 'package:web_project/app/ui/widget/actionListTileWidget.dart';
import 'package:web_project/app/ui/page/actionSelector.dart';
import 'package:web_project/app/data/provider/lesson_service.dart';
import 'package:web_project/app/ui/page/sequenceLibrary.dart';
import 'package:web_project/app/ui/widget/buttonWidget.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/ui/widget/lessonActionListTileWidget.dart';
import 'package:web_project/main.dart';
import 'package:web_project/app/data/model/userInfo.dart'
    as CustomUserInfo; // 다른 페키지와 클래스 명이 겹치는 경우 alias 선언해서 사용

import '../../data/provider/auth_service.dart';
import '../../data/model/color.dart';
import '../../function/globalFunction.dart';
import '../widget/globalWidget.dart';
import 'memberInfo.dart';

String screenName = "노트추가";

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

TextEditingController lessonDateController = TextEditingController();
TextEditingController todayNoteController = TextEditingController();

/// 시퀀스 이름 컨트롤러
TextEditingController sequenceNameController = TextEditingController();

/// 시퀀스 hint 이름 디폴트
int customSequenceNumber = 1;
String customSequenceName = '커스텀 시퀀스 ${customSequenceNumber}';

/// 시퀀스 이름 포커스 노드
FocusNode sequenceNameFocusNode = FocusNode();

FocusNode lessonDateFocusNode = FocusNode();

// 가변적으로 TextFields
List<TextEditingController> totalNoteControllers = [];

// 가변적으로 TextFields DocId 집합 (전체삭제시 필요)
List<String> totalNoteTextFieldDocId = new List.empty(growable: true);
List<TmpLessonInfo> tmpLessonInfoList = new List.empty(growable: true);

GlobalFunction globalFunction = GlobalFunction();

//예외처리 : 동작이 없을 경우 저장을 막는 용도로 사용
bool actionSelectMode = false;

//초기상태
bool checkInitState = true;

//날짜 변경할 경우 데이터 다시 불러오기에 활용.
bool DateChangeMode = true;

//totalNoteControllers,totalNoteTextFieldDocId index 에러 방지
bool flagIndexErr = true;

String lessonDate = "";
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

// List resultActionList = [];

bool isSequenceSaveChecked = false;
bool isTicketCountChecked = true;

bool isFirst = true;

List lessonActionList = [];
List dayLessonList = [];

List notedActionWidget = [];
List<String> notedActionsList = [];
List deleteTargetDocIdLiet = [];

/// 텍스트 에딧 컨트롤러 동적 생성 관리
List<TextEditingController> txtEdtCtrlrList = [];

int growthInth = 0;

bool isReturnIsNotEmpty = true;

class LessonAdd extends StatefulWidget {
  LessonAdd(this.customFunction, {super.key});
  LessonAdd.getCustomFunction(this.customFunction, {super.key});
  Function customFunction;
  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    String event = "PAGE";
    String value = "노트추가";
    analyticLog.sendAnalyticsEvent(screenName, "${event} : ${value}",
        "${value} : ${userInfo!.name}", "${value} : 프로퍼티 인자2");

    lessonActionList = [];
    txtEdtCtrlrList = [];
    dayLessonList = [];
    deleteTargetDocIdLiet = [];

    initStateCheck = true;
    growthInth = 0;

    isReturnIsNotEmpty = true;

    lessonDate = "";
    DateChangeMode = true;
    checkInitState = true;

    print(
        "globalVariables.memberTicketList.where((element) => element['isSelected'] == true && element['memberId'] == userInfo.docId) : ${globalVariables.memberTicketList.where((element) => element['isSelected'] == true && element['memberId'] == userInfo.docId)}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isFirst = true;
    lessonDateController.clear();
    todayNoteController.clear();
    clearTotalNoteControllers();
    totalNoteTextFieldDocId.clear();
    tmpLessonInfoList.clear();
    todayNotedocId = "";
    todayNoteView = "";

    //deleteControllers();
    checkInitState = true;
    DateChangeMode = true;
    print("[LA] Dispose : checkInitState ${checkInitState} ");
    super.dispose();

    lessonActionList = [];
    txtEdtCtrlrList = [];
    dayLessonList = [];
    deleteTargetDocIdLiet = [];

    lessonAddMode = "";

    initStateCheck = true;
    growthInth = 0;

    lessonDate = "";
    DateChangeMode = true;
  }

  @override
  void didUpdateWidget(covariant LessonAdd oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("oldWidget : ${oldWidget}");
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
    String lessonDateArg = argsList[1];
    List<DateTime> eventList = argsList[2];
    String lessonNoteId = argsList[3];
    String lessonAddMode = argsList[4];
    tmpLessonInfoList = argsList[5]; // null
    // resultActionList = argsList[6];

    print(
        '[LA] 시작 checkInitState - ${checkInitState} / DateChange - ${DateChangeMode} / actionNullCheck - ${actionNullCheck}');
    print(
        "[LA] 노트 관련 ${lessonDate} / ${lessonAddMode} / tmpLessonInfoList ${tmpLessonInfoList.length}");

    if (checkInitState) {
      print("INIT!!! : ${checkInitState}, DateChange:${DateChangeMode}");

      if (DateChangeMode) {
        print("ㄷㅎㄷㄱㅅㄱㅅ 날짜 초기화는 어디인가요? - 1 lessonDate : ${lessonDate}");
        lessonDate == ""
            ? lessonDate = argsList[1]
            : (lessonDateController.text.isEmpty
                ? lessonDate = argsList[1]
                : lessonDate = lessonDateController.text);
        lessonDateController.text = lessonDate;
        DateChangeMode = false;
      } else {
        print("ㄷㅎㄷㄱㅅㄱㅅ 날짜 초기화는 어디인가요? - 2");
        lessonDate = now; // lessonDateController.text;
        DateChangeMode = false;
      }
      print("Date : ${lessonDate}");

      /* Future<int> lenssonData = lessonService.countPos(
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
      }); */

      print("초기화시컨트롤러:${totalNoteControllers}");
      print("초기화시노트아이디:${totalNoteTextFieldDocId}");

      checkInitState = !checkInitState;
      actionSelectMode = false;
      print("INIT!!!변경 : ${checkInitState}");
    }
    print("재빌드시 init상태 : ${checkInitState}");

    return Consumer5<LessonService, DayLessonService, SequenceRecentService,
        SequenceCustomService, MemberTicketService>(
      builder: (context, lessonService, dayLessonService, sequenceRecentService,
          sequenceCustomService, memberTicketService, child) {
        print(
            "customUserInfo.uid : ${customUserInfo.uid}, customUserInfo.docId :  ${customUserInfo.docId} lessonDateArg : ${lessonDateArg}");
        /* if (!isReturnIsNotEmpty) {
          return Center(
            child: Text("레슨 노트를 추가해 보세요."),
          );
        } */

        if (isReturnIsNotEmpty &&
            lessonActionList.isEmpty &&
            lessonAddMode == "노트편집") {
          lessonService
              .readDateMemberActionNote(
                  customUserInfo.uid,
                  customUserInfo.docId,
                  lessonDate.isEmpty ? lessonDateArg : lessonDate)
              .then((value) {
            print("ppppppppp - value : ${value}");
            value.length == 0
                ? isReturnIsNotEmpty = false
                : isReturnIsNotEmpty = true;
            lessonActionList.addAll(value);
            lessonActionList.isNotEmpty ? growthInth++ : null;
            lessonActionList.forEach((element) =>
                element['totalNote'].isNotEmpty
                    ? element['noteSelected'] = true
                    : element['noteSelected'] = false);

            debugList(lessonActionList, "1");

            // notedActionWidget = makeChips(notedActionWidget, lessonActionList, Palette.backgroundOrange);
            txtEdtCtrlrList = [];
            lessonActionList.forEach((element) {
              txtEdtCtrlrList.add(new TextEditingController());
            });

            // setState(() {}); // 여기서 setState 호출하면 무한 획귀 오려 발생 하기도 함
            // lessonService.notifyListeners();
          });
        }
        print(
            "lessonActionList.where((element) => element['noteSelected'] == true).isNotEmpty; : ${lessonActionList.where((element) => element['noteSelected'] == true).isNotEmpty}");

        if (dayLessonList.isEmpty && lessonAddMode == "노트편집") {
          daylessonService
              .readTodayNoteOflessonDate(
                  customUserInfo.uid, customUserInfo.docId, lessonDateArg)
              .then((value) {
            print("fdsahrebr value : ${value}");

            dayLessonList.add(value);
            print("fdsahrebr dayLessonList : ${dayLessonList}");
            dayLessonList.forEach((element) {
              print("ppppppppp - dayLessonList - element : ${element}");
              todayNoteController.text = element[0]['todayNote'];
            });

            setState(() {});
          });
        }
        print("aaaaaaaaa - lessonActionList.length ${lessonActionList.length}");
        totalNoteTextFieldDocId = [];
        lessonActionList.forEach(
          (element) {
            print("aaaaaaaaa - element['docId'] : ${element['docId']}");
            totalNoteTextFieldDocId.add(element['docId']);
          },
        );

        todayNoteController.selection = TextSelection.fromPosition(
            TextPosition(offset: todayNoteController.text.length));

        return Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, lessonAddMode, () {
            String event = "onPressed";
            String value = "뒤로가기";
            analyticLog.sendAnalyticsEvent(screenName, "${event} : ${value}",
                "${value} : ${userInfo!.name}", "${value} : 프로퍼티 인자2");
            print(
                "[LA] 저장버튼실행 actionNullCheck : ${actionNullCheck}/todayNoteView : ${todayNoteView}");
            lessonDate = "";
            DateChangeMode = true;
            checkInitState = true;
            // 뒤로가기 선택시 MemberInfo로 이동
            Navigator.pop(context);
          }, [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextButton(
                  onPressed: todayNoteController.text == ""
                      ? null
                      : () async {
                          String event = "onPressed";
                          String value = "완료";
                          analyticLog.sendAnalyticsEvent(
                              screenName,
                              "${event} : ${value}",
                              "${value} : ${userInfo!.name}",
                              "${value} : 프로퍼티 인자2");
                          print(
                              "[LA] 저장버튼실행 actionNullCheck : ${actionNullCheck}/todayNoteView : ${todayNoteView}");

                          // 오늘의 레슨 종합 레슨 기록이 비어있고, 개별 기록도 없다면 안내 메세지 보여줌
                          // 뭐 든 하나라도 있다면 저장
                          if ((todayNoteController.text.trim().isEmpty) &&
                              lessonActionList
                                  .where((element) => element['noteSelected'])
                                  .isEmpty) {
                            //오늘의 노트가 없는 경우, 노트 생성 및 동작 노트들 저장
                            //await todayNoteSave(
                            //    lessonService, customUserInfo, context);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("일별노트 또는 동작선택중 하나는 필수입력해주세요."),
                            ));
                          } else {
                            print(
                                "[LA] 노트저장 DateChangeMode : ${DateChangeMode}/todayNoteView : ${todayNoteView} / checkInitState : ${checkInitState}");
                            DateChangeMode = false;

                            print(
                                "[LA] 일별메모 저장 : todayNotedocId ${todayNotedocId} ");

                            //일별 노트 저장
                            /* await todayNoteSave(
                          lessonService, customUserInfo, context); */
                            saveRecentSequence(
                              sequenceRecentService,
                              userInfo.uid,
                              userInfo.docId,
                              todayNoteView,
                              lessonActionList,
                              false,
                              0,
                              Timestamp.now(),
                              userInfo.name,
                            );
                            saveMethod(
                              lessonService,
                              lessonDate.isEmpty ? lessonDateArg : lessonDate,
                              lessonAddMode,
                              customUserInfo,
                              dayLessonService,
                              todayNoteView,
                            );
                            isSequenceSaveChecked
                                ? saveCustomSequnce(
                                    sequenceCustomService,
                                    userInfo.uid,
                                    userInfo.docId,
                                    todayNoteView,
                                    lessonActionList,
                                    false,
                                    0,
                                    Timestamp.now(),
                                    userInfo.name,
                                    sequenceNameController.text,
                                  )
                                : null;

                            // await totalNoteSave(
                            //     lessonService, customUserInfo, context);

                            memberActionNote = [];
                            isReturnIsNotEmpty = true;

                            print("여기가 맞긴 합니까?!");

                            // lessonService.notifyListeners();
                            widget.customFunction();
                            lessonService.nofiFunction();
                            Navigator.pop(context);
                          }
                        },
                  child: Text(
                    '완료',
                    style: TextStyle(
                      color: todayNoteController.text == ""
                          ? Palette.gray99
                          : Palette.textBlue,
                      fontSize: 16,
                    ),
                  )),
            )
          ], null),

          body: CenterConstrainedBody(
            child: Container(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: (MediaQuery.of(context).viewInsets.bottom),
                    ),
                    child: Column(
                      children: [
                        /// 입력창
                        Column(
                          children: [
                            SizedBox(height: 10),

                            /// 이름 및 수강권
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userInfo.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '등록일: ${userInfo.registerDate}',
                                          style: TextStyle(
                                              color: Palette.gray99,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Spacer(),

                                    /// 수강권 관련 컬럼 -> 보류로 인해 임시 비활성화
                                    /* Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              globalVariables.memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId).isNotEmpty
                                                  ? (isTicketCountChecked
                                                      ? Icons.confirmation_num
                                                      : Icons
                                                          .confirmation_num_outlined)
                                                  : Icons
                                                      .confirmation_num_outlined,
                                              color: globalVariables
                                                          .memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId).isNotEmpty
                                                  ? (isTicketCountChecked
                                                      ? Palette.buttonOrange
                                                      : Palette.gray99)
                                                  : Palette.gray99,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              globalVariables.memberTicketList.where((element) =>
                                                          element['isSelected'] == true &&
                                                          element['memberId'] ==
                                                              userInfo.docId).isNotEmpty
                                                  ? (isTicketCountChecked
                                                      ? (globalVariables.memberTicketList
                                                                      .where((element) =>
                                                                          element['isSelected'] == true &&
                                                                          element['memberId'] ==
                                                                              userInfo
                                                                                  .docId)
                                                                      .toList()
                                                                      .first[
                                                                  'ticketCountLeft'] -
                                                              1)
                                                          .toString()
                                                      : (globalVariables
                                                              .memberTicketList
                                                              .where((element) =>
                                                                  element['isSelected'] == true &&
                                                                  element['memberId'] == userInfo.docId)
                                                              .toList()
                                                              .first['ticketCountLeft'])
                                                          .toString())
                                                  : "수강권 없음",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isTicketCountChecked
                                                    ? Palette.gray00
                                                    : Palette.gray99,
                                              ),
                                            ),
                                            Text(
                                              globalVariables.memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId).isNotEmpty
                                                  ? "/"
                                                  : "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isTicketCountChecked
                                                    ? Palette.gray00
                                                    : Palette.gray99,
                                              ),
                                            ),
                                            Text(
                                              globalVariables.memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId).isNotEmpty
                                                  ? ((globalVariables
                                                          .memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId)
                                                          .toList()
                                                          .first['ticketCountAll'])
                                                      .toString())
                                                  : "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isTicketCountChecked
                                                    ? Palette.gray00
                                                    : Palette.gray99,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text("수강권 차감 여부"),
                                            Checkbox(
                                              value: isTicketCountChecked,
                                              onChanged: globalVariables
                                                          .memberTicketList
                                                          .where((element) =>
                                                              element['isSelected'] ==
                                                                  true &&
                                                              element['memberId'] ==
                                                                  userInfo
                                                                      .docId).isNotEmpty
                                                  ? (value) {
                                                      String event =
                                                          "onChanged";
                                                      String value =
                                                          "수강권 차감 여부";
                                                      analyticLog.sendAnalyticsEvent(
                                                          screenName,
                                                          "${event} : ${value}",
                                                          "${value} : ${userInfo!.name}",
                                                          "${value} :  : 프로퍼티 인자2");

                                                      /// 체크 토글
                                                      isTicketCountChecked =
                                                          !isTicketCountChecked;

                                                      /// 화면 재빌드
                                                      setState(() {});
                                                    }
                                                  : null,
                                            )
                                          ],
                                        )
                                      ],
                                    ), */
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            /// 일별 메모 입력 영역
                            Container(
                              color: Palette.mainBackground,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    /// 수업일 입력창
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Palette.gray99,
                                        ),
                                        SizedBox(width: 10),

                                        /// 새로 도전하는 수업일 입력창
                                        Container(
                                          width: 140,
                                          child: Material(
                                            color: Palette.mainBackground,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () async {
                                                print("여기가 맞습니다!");
                                                String event = "onTap";
                                                String value = "수강권 차감 여부";
                                                analyticLog.sendAnalyticsEvent(
                                                    screenName,
                                                    "${event} : ${value}",
                                                    "${value} : ${userInfo!.name}",
                                                    "${value} :  : 프로퍼티 인자2");
                                                await globalFunction
                                                    .getDateFromCalendar(
                                                        context,
                                                        lessonDateController,
                                                        "수업일",
                                                        lessonDateController
                                                            .text)
                                                    .then((value) async {
                                                  print(
                                                      "ewagerefw 여기가 then 입니다!! lessonDateController.text : ${lessonDateController.text}");
                                                  lessonDate =
                                                      lessonDateController.text;
                                                  print(
                                                      "ewagerefw lessonDate : ${lessonDate}");
                                                  await lessonService
                                                      .readDateMemberActionNote(
                                                          customUserInfo.uid,
                                                          customUserInfo.docId,
                                                          lessonDate)
                                                      .then((value) {
                                                    lessonActionList = [];
                                                    lessonActionList
                                                        .addAll(value);
                                                    print(
                                                        "ewagerefw lessonActionList : ${lessonActionList}");
                                                    txtEdtCtrlrList = [];
                                                    lessonActionList
                                                        .forEach((element) {
                                                      txtEdtCtrlrList.add(

                                                          /// 날짜 노트 읽어 올 때 동작 별 메모 남긴 경우 그대로 반영해서 읽어 오도록 처리
                                                          TextEditingController(
                                                              text: element[
                                                                      'totalNote']
                                                                  .toString()));
                                                    });

                                                    print(
                                                        "ewagerefw txtEdtCtrlrList.length : ${txtEdtCtrlrList.length}");
                                                    txtEdtCtrlrList.length > 0
                                                        ? print(
                                                            "ewagerefw txtEdtCtrlrList[0] : ${txtEdtCtrlrList[0]}")
                                                        : null;
                                                  });
                                                  await dayLessonService
                                                      .readCalSelectedDateNote(
                                                          customUserInfo.uid,
                                                          customUserInfo.docId,
                                                          lessonDate)
                                                      .then((value) {
                                                    print(
                                                        "ewagerefw value : ${value}");
                                                    print(
                                                        "ewagerefw value.isEmpty : ${value.isEmpty}");
                                                    value.isEmpty
                                                        ? todayNoteController
                                                            .text = ""
                                                        : todayNoteController
                                                                .text =
                                                            value[0]
                                                                ['todayNote'];
                                                  });
                                                });
                                                setState(() {
                                                  lessonDate =
                                                      lessonDateController.text;
                                                });
                                                DateChangeMode = true;
                                                checkInitState = true;
                                                print(
                                                    "[LA] 수업일변경 : lessonDateController ${lessonDateController.text} / todayNoteController ${todayNoteController.text} / DateChangeMode ${DateChangeMode}");
                                                /* initInpuWidget(
                                                    uid: user.uid,
                                                    docId: customUserInfo.docId,
                                                    lessonService:
                                                        lessonService); */
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.start,
                                                        enabled: false,
                                                        maxLines: null,
                                                        controller:
                                                            lessonDateController,
                                                        focusNode:
                                                            lessonDateFocusNode,
                                                        autofocus: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              '날짜를 선택하세요.',
                                                          hintStyle: TextStyle(
                                                              color: Palette
                                                                  .gray99,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Palette.gray00,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Palette.gray99,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 0),

                                    /// 일별 메모 입력창
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Icon(
                                              Icons.text_snippet_outlined,
                                              color: Palette.gray99,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child:

                                              /// 리턴 시작
                                              // return
                                              Container(
                                            constraints:
                                                BoxConstraints(minHeight: 120),
                                            child: Container(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  // 오늘의 레슨 기록 변화 시 todayNoteController에 넣는다
                                                  todayNoteController.text =
                                                      value;
                                                  todayNoteController
                                                          .selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  todayNoteController
                                                                      .text
                                                                      .length));
                                                  setState(() {});
                                                },
                                                maxLines: null,
                                                controller: todayNoteController,
                                                autofocus: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(20),
                                                  border: InputBorder.none,
                                                  hintText: '오늘의 수업 내용을 기록해보세요',
                                                  hintStyle: TextStyle(
                                                      color: Palette.gray99,
                                                      fontSize: 14),
                                                ),
                                                style: TextStyle(
                                                    color: Palette.gray00,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    /// 동작별 메모 (New)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 0,
                                            ),
                                            Icon(
                                              Icons.accessibility_new_rounded,
                                              color: Palette.gray99,
                                            ),
                                          ],
                                        ),

                                        // 레슨 기록에 동작별 기록이 있으면 칩으로 보여준다.
                                        lessonActionList
                                                .where((element) =>
                                                    element['noteSelected'] ==
                                                    true)
                                                .isNotEmpty // is동작메모하나라도있니? 변수 필요
                                            /// 동작 있을 경우
                                            ? Expanded(
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        lessonActionList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final doc =
                                                          lessonActionList[
                                                              index];

                                                      
                                                      String uid =
                                                          doc['uid']; // 강사 고유번호

                                                      String name =
                                                          doc['name']; //회원이름
                                                      String phoneNumber = doc[
                                                          'phoneNumber']; // 회원 고유번호 ()
                                                      String apratusName = doc[
                                                          'apratusName']; //기구이름
                                                      String actionName = doc[
                                                          'actionName']; //동작이름
                                                      String lessonDate = doc[
                                                          'lessonDate']; //수업날짜
                                                      String grade =
                                                          doc['grade']; //수행도
                                                      String totalNote = doc[
                                                          'totalNote']; //수업총메모
                                                      int pos = doc['pos'] ??
                                                          index; //수업총메모
                                                      bool isSelected =
                                                          doc['noteSelected'];

                                                      String actionNote =
                                                          doc['totalNote'];

                                                      if (initStateCheck) {
                                                        String tmp =
                                                            txtEdtCtrlrList[
                                                                    index]
                                                                .text;
                                                        txtEdtCtrlrList[index]
                                                            .text = actionNote;
                                                        if (lessonActionList
                                                                    .length -
                                                                1 ==
                                                            index) {
                                                          initStateCheck =
                                                              false;
                                                        }
                                                      }
                                                      print(
                                                          "ewagerefw index : ${index}");
                                                      txtEdtCtrlrList != null
                                                          ? txtEdtCtrlrList[index]
                                                                  .selection =
                                                              TextSelection.fromPosition(
                                                                  TextPosition(
                                                                      offset: txtEdtCtrlrList[
                                                                              index]
                                                                          .text
                                                                          .length))
                                                          : null;

                                                      return Offstage(
                                                        offstage: !isSelected,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20),
                                                                child: Chip(
                                                                  backgroundColor: doc[
                                                                          'noteSelected']
                                                                      ? Palette
                                                                          .titleOrange
                                                                      : Palette
                                                                          .grayEE,
                                                                  label: Text(
                                                                      "$actionName"),
                                                                  deleteIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .close_sharp,
                                                                    size: 16,
                                                                  ),
                                                                  onDeleted:
                                                                      () {
                                                                    lessonActionList[
                                                                            index]
                                                                        [
                                                                        'noteSelected'] = !lessonActionList[
                                                                            index]
                                                                        [
                                                                        'noteSelected'];
                                                                    // controller의 텍스트 초기화
                                                                    txtEdtCtrlrList[
                                                                            index]
                                                                        .text = "";
                                                                    String tmp =
                                                                        txtEdtCtrlrList[index]
                                                                            .text;

                                                                    print(
                                                                        "ewagerefw txtEdtCtrlrList[index].text : ${txtEdtCtrlrList[index].text}");

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                )),
                                                            TextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                txtEdtCtrlrList[
                                                                        index]
                                                                    .text = value;
                                                                String tmp =
                                                                    txtEdtCtrlrList[
                                                                            index]
                                                                        .text;
                                                                txtEdtCtrlrList[
                                                                            index]
                                                                        .selection =
                                                                    TextSelection
                                                                        .fromPosition(TextPosition(
                                                                            offset:
                                                                                txtEdtCtrlrList[index].text.length));
                                                              },
                                                              controller:
                                                                  txtEdtCtrlrList[
                                                                      index],
                                                              maxLines: null,
                                                              autofocus: true,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                /* content padding을 20이상 잡아두지 않으면,
                                                              한글 입력 시 텍스트가 위아래로 움직이는 오류 발생 */
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                hintText:
                                                                    '동작 수행 시 특이사항을 남겨보세요.',
                                                                hintStyle: TextStyle(
                                                                    color: Palette
                                                                        .gray99,
                                                                    fontSize:
                                                                        14),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                              style: TextStyle(
                                                                  color: Palette
                                                                      .gray00,
                                                                  fontSize: 14),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )

                                            /// 동작 하나도 없을 경우
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  '아래에서 동작을 선택하여 추가해보세요.',
                                                  style: TextStyle(
                                                      color: Palette.gray99),
                                                ),
                                              )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),

                            /// 시퀀스 영역 시작
                            SizedBox(height: 20),

                            /// 시퀀스의 헤딩 영역
                            Container(
                                padding: EdgeInsets.fromLTRB(9, 0, 20, 0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSequenceSaveChecked,
                                      onChanged: (value) {
                                        /// 체크 토글
                                        isSequenceSaveChecked =
                                            !isSequenceSaveChecked;

                                        /// 체크박스 클릭하면 포커스가 이동하는 함수
                                        if (isSequenceSaveChecked == true) {
                                          sequenceNameFocusNode.requestFocus();
                                        }

                                        /// 화면 재빌드
                                        setState(() {});
                                      },
                                    ),
                                    Text('시퀀스 보관함에 저장',
                                        style:
                                            TextStyle(color: Palette.gray00)),
                                    Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          /// 저장된 시퀀스들이 있는 화면으로 이동하는 함수
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SequenceLibrary()),
                                          ).then((value) {
                                            // lessonActionList = [];
                                            List valList = value;
                                            for (var v in valList) {
                                              lessonActionList.add(v);
                                            }

                                            /* lessonActionList.forEach(
                                                (element) => element[
                                                            'totalNote']
                                                        .isNotEmpty
                                                    ? element['noteSelected'] =
                                                        false // true
                                                    : element['noteSelected'] =
                                                        false); */
                                            lessonActionList.forEach(
                                              (element) {
                                                element['deleteSelected'] =
                                                    false;
                                              },
                                            );
                                            debugList(lessonActionList, "1");

                                            // notedActionWidget = makeChips(notedActionWidget, lessonActionList, Palette.backgroundOrange);
                                            // txtEdtCtrlrList = [];
                                            valList.forEach((element) {
                                              txtEdtCtrlrList.add(
                                                  new TextEditingController());
                                            });
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.folder_outlined,
                                              color: Palette.gray99,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '시퀀스 보관함',
                                              style: TextStyle(
                                                  color: Palette.gray00),
                                            )
                                          ],
                                        ))
                                  ],
                                )),

                            /// 시퀀스 제목 영역
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                focusNode: sequenceNameFocusNode,
                                controller: sequenceNameController,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(

                                    /// customSequenceName:'커스텀 시퀀스 ${customSequenceNumber}'
                                    /// 중복된 값 없도록 만들어주는 숫자 변수: customSequenceNumber
                                    hintText: customSequenceName,
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.gray00),
                                    border: InputBorder.none),
                              ),
                            ),

                            /// 시퀀스 영역 시작
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(children: [
                                // 동작입력 버튼
                                GrayInkwellButton(
                                  label: '동작 추가',
                                  customFunctionOnTap: () async {
                                    String currentAppratus = "";

                                    String lessonDate =
                                        lessonDateController.text;
                                    String totalNote = "";

                                    //동작선택 모드
                                    actionSelectMode = true;
                                    print(
                                        "[LA] 동작추가시작 tmpLessonInfoList : ${tmpLessonInfoList.length}");

                                    globalVariables.actionList
                                        .forEach((element) {
                                      element['actionSelected'] = false;
                                    });

                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActionSelector(),
                                        fullscreenDialog: true,
                                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                        settings: RouteSettings(arguments: [
                                          customUserInfo,
                                          currentAppratus,
                                          lessonDate,
                                          checkInitState,
                                          totalNote,
                                          tmpLessonInfoList,
                                          // resultActionList,
                                        ]),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        print(
                                            "aewregfdsfgdaf - value : ${value}");
                                        value.forEach((element) {
                                          var rElement = {
                                            'actionName': element['name'],
                                            'docId': customUserInfo.docId,
                                            'pos': element[
                                                'pos'], // lessonActionList.length,
                                            'lessonDate': lessonDate.isEmpty
                                                ? lessonDateArg
                                                : lessonDate,
                                            'totalNote': "",
                                            'grade': '50',
                                            'uid': customUserInfo.uid,
                                            'apratusName': element['apparatus'],
                                            'timestamp': null,
                                            'name': customUserInfo.name,
                                            'phoneNumber':
                                                customUserInfo.phoneNumber,
                                            'id': null,
                                            'noteSelected': false,
                                            'position': element['name'],
                                            'deleteSelected': false,
                                          };
                                          print("rElement : ${rElement}");
                                          lessonActionList.add(rElement);
                                          txtEdtCtrlrList
                                              .add(TextEditingController());
                                          txtEdtCtrlrList[txtEdtCtrlrList
                                                          .length -
                                                      1]
                                                  .selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: txtEdtCtrlrList[
                                                              txtEdtCtrlrList
                                                                      .length -
                                                                  1]
                                                          .text
                                                          .length));
                                        });
                                      }

                                      return value;
                                    });

                                    print("동작추가시컨트롤러:${totalNoteControllers}");
                                    print(
                                        "동작추가시노트아이디:${totalNoteTextFieldDocId}");

                                    // lessonService.notifyListeners();
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 20),

                                // 손재형 재정렬 가능한 리스트 시작 => 동작 목록 리스트
                                ReorderableListView.builder(
                                    padding: lessonAddMode == "노트편집"
                                        ? EdgeInsets.only(bottom: 40)
                                        : EdgeInsets.only(bottom: 100),
                                    onReorder: (oldIndex, newIndex) {
                                      // print("fsdadfewgree before - oldIndex : ${oldIndex} <=> newIndex : ${newIndex}");
                                      if (newIndex > oldIndex) {
                                        newIndex -= 1;
                                      }
                                      // print("fsdadfewgree after - oldIndex : ${oldIndex} <=> newIndex : ${newIndex}");

                                      /// 동작 순서 변경 시 처리 하는 로직
                                      /// 제거 하는 oldIndex 리스트 요소를 final로 받고
                                      /// 리스트에 newIndex에 요소를 insert 해준다.
                                      final movedActionList =
                                          lessonActionList.removeAt(oldIndex);
                                      lessonActionList.insert(
                                          newIndex, movedActionList);

                                      /// 위와 동일한 방식 txtEdtCtrlrList에 적용
                                      final movedTextField =
                                          txtEdtCtrlrList.removeAt(oldIndex);
                                      txtEdtCtrlrList.insert(
                                          newIndex, movedTextField);

                                      print(
                                          "qefwdfasfs ============= change =============");
                                      lessonActionList.forEach((element) {
                                        print(
                                            "qefwdfasfs change - element : ${element['actionName']}");
                                      });
                                      txtEdtCtrlrList.forEach((element) {
                                        print(
                                            "qefwdfasfs change - element.text : ${element.text}");
                                      });

                                      lessonActionList.forEach((element) {
                                        // print("fsdadfewgree 0 - element['actionName'] : ${element['actionName']}, element['pos'] : ${element['pos']}, element['id'] : ${element['id']},");
                                      });
                                      int reorderedIndex = 0;
                                      lessonActionList.forEach((element) {
                                        element['pos'] = reorderedIndex;
                                        reorderedIndex++;
                                      });
                                      lessonActionList.forEach((element) {
                                        // print("fsdadfewgree 1 - element['actionName'] : ${element['actionName']}, element['pos'] : ${element['pos']}, element['id'] : ${element['id']},");
                                        if (growthInth > 0) {
                                          lessonService.setLessonActionNote(
                                              element['id'] ??
                                                  customUserInfo.uid +
                                                      "_" +
                                                      customUserInfo.docId +
                                                      "_" +
                                                      (lessonDate.isEmpty
                                                          ? lessonDateArg
                                                          : lessonDate) +
                                                      "_" +
                                                      (Timestamp.now())
                                                          .toString(),
                                              element['uid'],
                                              element['docId'],
                                              element['actionName'],
                                              element['apratusName'],
                                              element['grade'],
                                              element['lessonDate'],
                                              element['name'],
                                              element['phoneNumber'],
                                              element['pos'],
                                              element['totalNote']);
                                        }
                                      });
                                    },
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: lessonActionList.length,
                                    itemBuilder: (context, index) {
                                      lessonActionList.forEach((element) {
                                        // print("fewghrsdrfgdsfg - element : ${element}");
                                      });
                                      Key? valueKey;

                                      lessonActionList[index]['pos'] = index;
                                      valueKey = ValueKey(index);

                                      final doc = lessonActionList[index];
                                      print("동작 목록 리스트 - doc : ${doc}");

                                      String uid = doc['uid']; // 강사 고유번호

                                      String name = doc['name']; //회원이름
                                      String phoneNumber = doc[
                                          'phoneNumber']; // 회원 고유번호 (전화번호로 회원 식별)
                                      String apratusName =
                                          doc['apratusName']; //기구이름
                                      String actionName =
                                          doc['actionName']; //동작이름
                                      String lessonDate =
                                          doc['lessonDate']; //수업날짜
                                      String grade = doc['grade']; //수행도
                                      String totalNote =
                                          doc['totalNote']; //수업총메모
                                      int pos = doc['pos']; //수업총메모
                                      bool isSelected = doc['noteSelected'];

                                      return GestureDetector(
                                        key: valueKey,
                                        onHorizontalDragUpdate: (details) {
                                          int sensitivity = 8;
                                          if (details.delta.dx > sensitivity) {
                                            // right swipe
                                            print(
                                                "GestureDetector right swipe");
                                            lessonActionList[index]
                                                ['deleteSelected'] = true;
                                          } else if (details.delta.dx <
                                              -sensitivity) {
                                            // left swipe
                                            print("GestureDetector left swipe");
                                            lessonActionList[index]
                                                ['deleteSelected'] = false;
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: LessonActionListTile(
                                                  actionName: actionName,
                                                  apparatus: apratusName,
                                                  position: globalFunction
                                                      .getActionPosition(
                                                          apratusName,
                                                          actionName,
                                                          globalVariables
                                                              .actionList),
                                                  name: name,
                                                  phoneNumber: phoneNumber,
                                                  lessonDate: lessonDate,
                                                  grade: grade,
                                                  totalNote: totalNote,
                                                  docId: userInfo.docId,
                                                  memberdocId: userInfo.docId,
                                                  uid: uid,
                                                  pos: pos,
                                                  isSelected: isSelected,
                                                  isSelectable: true,
                                                  isDraggable: true,
                                                  // 커스텀 시퀀스 리스트의 onTap 이벤트를 처리하는 영역
                                                  customFunctionOnTap: () {
                                                    print(
                                                        "qowefiowefioewiofiowe called!!");
                                                    doc['noteSelected'] =
                                                        !doc['noteSelected'];

                                                    !doc['noteSelected']
                                                        ? txtEdtCtrlrList[index]
                                                            .text = totalNote
                                                        : txtEdtCtrlrList[index]
                                                            .text = "";
                                                    /* txtEdtCtrlrList[index]
                                                        .text = totalNote;
                                                    String tmp =
                                                        txtEdtCtrlrList[index]
                                                            .text; */
                                                  }),
                                            ),
                                            Offstage(
                                              offstage: lessonActionList[index]
                                                  ['deleteSelected'],
                                              child: IconButton(
                                                onPressed: () async {
                                                  // 노트편집 화면의 경우 기존 목록에서 동작을 삭제하는 경우 생길 수 있어서, 삭제이벤트 발생시 docId 수집
                                                  getDeleteTargetDocId(index);

                                                  if (growthInth > 0 &&
                                                      lessonActionList[index]
                                                              ['id'] !=
                                                          null) {
                                                    lessonService.delete(
                                                        docId: lessonActionList[
                                                            index]['id'],
                                                        onSuccess: () {},
                                                        onError: () {});
                                                  }
                                                  lessonActionList
                                                      .removeAt(index);
                                                  print(
                                                      "qefwdfasfs ============= delete =============");
                                                  lessonActionList
                                                      .forEach((element) {
                                                    print(
                                                        "qefwdfasfs delete - element : ${element['actionName']}");
                                                  });
                                                  int i = 0;
                                                  lessonActionList
                                                      .forEach((element) {
                                                    element['pos'] = i;
                                                    print(
                                                        "egwqgerv - lessonActionList[i]['actionName'] : ${lessonActionList[i]['actionName']}, lessonActionList[i]['pos'] : ${lessonActionList[i]['pos']}");

                                                    i++;
                                                  });
                                                  if (growthInth > 0) {
                                                    int k = 0;
                                                    lessonActionList
                                                        .forEach((element) {
                                                      lessonService.setLessonActionNote(
                                                          lessonActionList[k]
                                                                  ['id'] ??
                                                              customUserInfo
                                                                      .uid +
                                                                  "_" +
                                                                  customUserInfo
                                                                      .docId +
                                                                  "_" +
                                                                  (lessonDate
                                                                          .isEmpty
                                                                      ? lessonDateArg
                                                                      : lessonDate) +
                                                                  "_" +
                                                                  (DateTime
                                                                          .now())
                                                                      .toString(),
                                                          lessonActionList[k]
                                                              ['uid'],
                                                          lessonActionList[k]
                                                              ['docId'],
                                                          lessonActionList[k]
                                                              ['actionName'],
                                                          lessonActionList[k]
                                                              ['apratusName'],
                                                          lessonActionList[k]
                                                              ['grade'],
                                                          lessonActionList[k]
                                                              ['lessonDate'],
                                                          lessonActionList[k]
                                                              ['name'],
                                                          lessonActionList[k]
                                                              ['phoneNumber'],
                                                          lessonActionList[k]
                                                              ['pos'],
                                                          lessonActionList[k]
                                                              ['totalNote']);
                                                    });
                                                  }
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Palette.statusRed,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ]),
                            ),

                            /// 저장버튼 추가버튼 UI 수정
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(30.0),
                            //     ),
                            //     elevation: 0,
                            //     backgroundColor: Palette.buttonOrange,
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         vertical: 14, horizontal: 90),
                            //     child: Text("저장하기",
                            //         style: TextStyle(fontSize: 16)),
                            //   ),
                            //   onPressed: () async {
                            //     print(
                            //         "[LA] 저장버튼실행 actionNullCheck : ${actionNullCheck}/todayNoteView : ${todayNoteView}");

                            //     // 수업일, 동작선택, 필수 입력
                            //     if ((todayNoteController.text.trim().isEmpty) &&
                            //         lessonActionList
                            //             .where((element) =>
                            //                 element['noteSelected'])
                            //             .isEmpty) {
                            //       //오늘의 노트가 없는 경우, 노트 생성 및 동작 노트들 저장
                            //       ScaffoldMessenger.of(context)
                            //           .showSnackBar(SnackBar(
                            //         content:
                            //             Text("일별노트 또는 동작선택중 하나는 필수입력해주세요."),
                            //       ));
                            //     } else {
                            //       print(
                            //           "[LA] 노트저장 DateChangeMode : ${DateChangeMode}/todayNoteView : ${todayNoteView} / checkInitState : ${checkInitState}");
                            //       DateChangeMode = false;

                            //       print(
                            //           "[LA] 일별메모 저장 : todayNotedocId ${todayNotedocId} ");
                            //       saveRecentSequence(
                            //         sequenceRecentService,
                            //         userInfo.uid,
                            //         userInfo.docId,
                            //         todayNoteView,
                            //         lessonActionList,
                            //         false,
                            //         0,
                            //         Timestamp.now(),
                            //         userInfo.name,
                            //       );
                            //       saveMethod(
                            //         lessonService,
                            //         lessonDateArg,
                            //         lessonAddMode,
                            //         customUserInfo,
                            //         dayLessonService,
                            //         todayNoteView,
                            //       );
                            //       isSequenceSaveChecked
                            //           ? saveCustomSequnce(
                            //               sequenceCustomService,
                            //               userInfo.uid,
                            //               userInfo.docId,
                            //               todayNoteView,
                            //               lessonActionList,
                            //               false,
                            //               0,
                            //               Timestamp.now(),
                            //               userInfo.name,
                            //               sequenceNameController.text,
                            //             )
                            //           : null;

                            //       lessonService.notifyListeners();
                            //       Navigator.pop(context);
                            //     }
                            //   },
                            // ),

                            lessonAddMode == "노트편집"
                                ? DeleteButton(
                                    actionNullCheck: actionNullCheck,
                                    todayNotedocId: todayNotedocId,
                                    lessonService: lessonService,
                                    dayLessonService: dayLessonService,
                                    totalNoteTextFieldDocId:
                                        totalNoteTextFieldDocId,
                                  )
                                : const SizedBox(height: 15),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void getDeleteTargetDocId(int index) {
    print(
        "getDeleteTargetDocId - index : ${index}, lessonActionList[index]['docId'] : ${lessonActionList[index]['docId']}, lessonActionList[index]['id'] : ${lessonActionList[index]['id']}");
    deleteTargetDocIdLiet.add(lessonActionList[index]['id']);
  }

  void saveRecentSequence(
    SequenceRecentService sequenceRecentService,
    String uid,
    String memberId,
    String todayNote,
    List actionList, // List -> Json
    bool isfavorite, // 즐겨찾는 시퀀스 (추후 추가 가능성)
    int like, // 좋아요 수 (추후 추가 가능성)
    Timestamp timeStamp, // 꺼내 쓸 때 변환해서 씀
    String username,
  ) {
    var now = DateTime.now();
    String sequenceTitle =
        username + "님 " + DateFormat("yyyy-MM-dd HH:MM").format(now);
    sequenceRecentService.create(uid, memberId, todayNote, actionList,
        isfavorite, like, timeStamp, sequenceTitle);
  }

  void saveCustomSequnce(
    SequenceCustomService sequenceCustomService,
    String uid,
    String memberId,
    String todayNote,
    List actionList, // List -> Json
    bool isfavorite, // 즐겨찾는 시퀀스 (추후 추가 가능성)
    int like, // 좋아요 수 (추후 추가 가능성)
    Timestamp timeStamp, // 꺼내 쓸 때 변환해서 씀
    String username,
    String sequenceTitle,
  ) {
    // 타임 스탬프 생성 난수로 임시명 생성 대체, 원래 전략으로 복귀 해야 함
    var unixTimestamp = DateTime.now().microsecondsSinceEpoch;
    // print("unixTimestamp : ${unixTimestamp}");

    sequenceTitle.isEmpty
        ? sequenceTitle = "커스텀 시퀀스 ${unixTimestamp}"
        : sequenceTitle = sequenceTitle;
    sequenceCustomService.create(uid, memberId, unixTimestamp, todayNote,
        actionList, isfavorite, like, timeStamp, sequenceTitle);
  }

  int i = 0;
  Future<void> saveMethod(
    LessonService lessonService,
    String lessonDateTmp,
    String lessonAddMode,
    CustomUserInfo.UserInfo customUserInfo,
    DayLessonService dayLessonService,
    // MemberTicketService memberTicketService,
    String todayNote,
    // String selectedTicketId,
    // bool isTicketCountChecked,
  ) async {
    print("asdfsdfsfsgfdg - saveMethod CALLED!! => ${i}");
    lessonActionList.forEach((element) {
      print("asdfsdfsfsgfdg -${element['actionName']} : ${element['pos']}");
    });

    print(userInfo.uid +
        "_" +
        userInfo.docId +
        "_" +
        lessonDateTmp +
        ", " +
        ", " +
        userInfo.uid +
        ", " +
        userInfo.docId +
        ", " +
        lessonDateTmp +
        ", " +
        userInfo.uid +
        ", " +
        userInfo.name +
        ", " +
        todayNote);
    await dayLessonService.setLessonTodayNote(
      userInfo.uid + "_" + userInfo.docId + "_" + lessonDateTmp,
      userInfo.uid,
      userInfo.docId,
      lessonDateTmp,
      userInfo.name,
      todayNoteController.text,
      // selectedTicketId,
      // isTicketCountChecked
    );

    /* int result = 0;
    lessonService
        .countRecord(userInfo.uid, userInfo.docId, lessonDate)
        .then((value) {
      result = value;
    }); */
    if (growthInth > 0) {
      lessonActionList.forEach((element) {
        print("fdasewvref 0 element : ${element}");
        element['id'] != null
            ? lessonService.delete(
                docId: element['id'], onSuccess: () {}, onError: () {})
            : null;
        print("fdasewvref 1 element : ${element}");
      });
    }

    // int teclIndex = 0;
    String recordId = "";
    
    lessonActionList.forEach((element) async {
      var rnd = Random().nextInt(45)+1;
      recordId = customUserInfo.uid +
          "_" +
          customUserInfo.docId +
          "_" +
          lessonDateTmp +
          "_" +
          (DateTime.now().millisecondsSinceEpoch).toString()+(DateTime.now().microsecondsSinceEpoch).toString()+(rnd).toString();
          
      print("asdfsdfsfsgfdg gks qjs qhqtlek. : " +
          "recordId : " +
          recordId +
          ", customUserInfo.uid : " +
          customUserInfo.uid +
          ", customUserInfo.docId, : " +
          customUserInfo.docId +
          ", element['actionName'] : " +
          element['actionName'] +
          ", element['apratusName'] : " +
          element['apratusName'] +
          ", element['grade'] : " +
          element['grade'] +
          ", lessonDateArg : " +
          lessonDateTmp +
          ", element['name'] : " +
          element['name'] +
          ", element['phoneNumber'] : " +
          element['phoneNumber'] +
          ", element['pos'] : " +
          element['pos'].toString() +
          ", txtEdtCtrlrList[$element['pos']].text.trim() : " +
          txtEdtCtrlrList[element['pos']].text.trim());
      await lessonService.setLessonActionNote(
        recordId,
        customUserInfo.uid,
        customUserInfo.docId,
        element['actionName'],
        element['apratusName'],
        element['grade'],
        lessonDateTmp,
        element['name'],
        element['phoneNumber'],
        element['pos'],
        txtEdtCtrlrList[element['pos']].text.trim(),
      );
      // teclIndex ++;
      recordId = "";
      // .dart 파일이 시작 종료 될 때만 0으로 초기화, 계속 1씩 늘어나기만 하는 정수
      growthInth++;
    });
    // teclIndex = 0;

    /*  for (int i = 0; i < lessonActionList.length; i++) {
      print("asdfsdfsfsgfdg gks qjs qhqtlek. : " +
          customUserInfo.uid +
          "_" +
          customUserInfo.docId +
          "_" +
          lessonDateArg +
          "_" +
          DateTime.now().toString() +
          "' " +
          customUserInfo.uid +
          "' " +
          customUserInfo.docId +
          "' " +
          lessonActionList[i]['actionName'] +
          "' " +
          lessonActionList[i]['apratusName'] +
          "' " +
          lessonActionList[i]['grade'] +
          "' " +
          lessonDateArg +
          "' " +
          lessonActionList[i]['name'] +
          "' " +
          lessonActionList[i]['phoneNumber'] +
          "' " +
          lessonActionList[i]['pos'].toString() +
          "' " +
          txtEdtCtrlrList[i].text.trim());
      await lessonService.setLessonActionNote(
        customUserInfo.uid +
            "_" +
            customUserInfo.docId +
            "_" +
            lessonDateArg +
            "_" +
            (DateTime.now()).toString(),
        customUserInfo.uid,
        customUserInfo.docId,
        lessonActionList[i]['actionName'],
        lessonActionList[i]['apratusName'],
        lessonActionList[i]['grade'],
        lessonDateArg,
        lessonActionList[i]['name'],
        lessonActionList[i]['phoneNumber'],
        lessonActionList[i]['pos'],
        txtEdtCtrlrList[i].text.trim(),
      );

      // .dart 파일이 시작 종료 될 때만 0으로 초기화, 계속 1씩 늘어나기만 하는 정수
      growthInth++;
    } */

    lessonActionList = [];
    // lessonService.notifyListeners();
    /* String ticketId = globalVariables.memberTicketList
            .where((element) => element['isSelect'] == true && element['memberId'] == userInfo.docId).toList().first['id'];

    ticketId.isNotEmpty
        ? memberTicketService.
        : null; */
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
          isRefresh: true,
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
        isRefresh: true,
        onSuccess: () {
          // 저장하기 성공
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("일별노트 저장"),
          ));
          //todayNoteController.clear();
          // Navigator.pop(context);
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
          // Navigator.pop(context);
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
  for (var i = 0; i < txtEdtCtrlrList.length; ++i) {
    txtEdtCtrlrList[i].clear();
  }
  txtEdtCtrlrList.clear();
}

//Textfield 생성
deleteControllers() {
  totalNoteControllers = [];
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
    required this.dayLessonService,
    required this.totalNoteTextFieldDocId,
  }) : super(key: key);

  final bool actionNullCheck;
  final String todayNotedocId;
  final LessonService lessonService;
  final DayLessonService dayLessonService;
  final List<String> totalNoteTextFieldDocId;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Palette.backgroundPink),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 50,
          child: Text("노트 삭제하기",
              style: TextStyle(fontSize: 14, color: Palette.textRed))),
      onPressed: () async {
        // create bucket
        final retvaldelte = await showAlertDialog(context, '정말로 삭제하시겠습니까?',
            '해당 노트의 전체 내용이 삭제됩니다. 삭제된 내용은 이후 복구가 불가능합니다.');
        if (retvaldelte == "OK") {
          int recordLength = 0;

          for (int i = 0; i < lessonActionList.length; i++) {
            widget.lessonService.delete(
                docId: lessonActionList[i]['id'],
                onSuccess: () {},
                onError: () {});
          }

          widget.dayLessonService.delete(
              docId: AuthService().currentUser()!.uid.toString() +
                  "_" +
                  userInfo.docId.toString() +
                  "_" +
                  lessonDate.toString(),
              onSuccess: () {},
              onError: () {});

          memberActionNote = [];
          eventSource = {};

          setState(() {});

          // 삭제하기 성공시 MemberList로 이동
          widget.lessonService.notifyListeners(); // 화면 갱신
          Navigator.pop(context);
        }
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
  print("[LA] 수업일변경 - notifyListeners / ${checkInitState}");
  // lessonService.notifyListeners();
}

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

debugList(List list, String mark) {
  list.forEach((element) {
    print("${mark} - element : ${element}");
  });
}
