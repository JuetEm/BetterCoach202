import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'actionSelector.dart';
import 'auth_service.dart';
import 'color.dart';
import 'lessonAdd.dart';

import 'lessonUpdate.dart';
import 'lesson_service.dart';
import 'memberList.dart';
import 'memberUpdate.dart';
import 'userInfo.dart';

Map<DateTime, dynamic> eventSource = {};
List<DateTime> eventList = [];
String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
String lessonDate = "";

String lessonNoteId = "";
String lessonAddMode = "";

int indexCheck = 0;
String listMode = "날짜별";
String viewMode = "기본정보";
String lessonDateTrim = "";
String apratusNameTrim = "";
int dayNotelessonCnt = 0;

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

    final lessonService = context.read<LessonService>();

    Future<int> daylessonCnt = lessonService.countTodaynote(
      user.uid,
      userInfo.docId,
    );

    daylessonCnt.then((val) {
      // int가 나오면 해당 값을 출력
      print('[MI] 오늘 노트 개수 출력 : $val');
      dayNotelessonCnt = val;
      //Textfield 생성
    }).catchError((error) {
      // error가 해당 에러를 출력
      print('error: $error');
    });

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 11),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                Spacer(),
                                Column(
                                  children: [
                                    // Text(
                                    //   '남은횟수 : ${userInfo.registerType}',
                                    //   style: TextStyle(
                                    //       fontSize: 14.0,
                                    //       //fontWeight: FontWeight.bold,
                                    //       color: Palette.gray99),
                                    // ),
                                    Text(
                                      '등록횟수 : ${userInfo.registerType}',
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

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Palette.grayFF,
                                //color: Colors.red.withOpacity(0),
                              ),
                              //padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () {
                                        if (viewMode == "레슨노트") {
                                          setState(() {
                                            viewMode = "기본정보";
                                          });
                                        }
                                        ;
                                      },
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: viewMode == "기본정보"
                                                  ? Palette.gray66
                                                  : Palette.grayEE,
                                              width: 2,
                                            ),
                                          ),
                                        ),

                                        //color: Colors.red.withOpacity(0),

                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            "기본정보",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: viewMode == "기본정보"
                                                  ? Palette.gray33
                                                  : Palette.gray66,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () {
                                        if (viewMode == "기본정보") {
                                          setState(() {
                                            viewMode = "레슨노트";
                                          });
                                        }
                                        ;
                                      },
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: viewMode == "레슨노트"
                                                  ? Palette.gray66
                                                  : Palette.grayEE,
                                              width: 2,
                                            ),
                                          ),
                                        ),

                                        //color: Colors.red.withOpacity(0),

                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            "레슨노트",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: viewMode == "레슨노트"
                                                  ? Palette.gray33
                                                  : Palette.gray66,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ), //   Spacer(),
                                  //   InkWell(
                                  //     onTap: () {
                                  //       if (viewMode == "기본정보") {
                                  //         setState(() {
                                  //           viewMode = "레슨노트";
                                  //         });
                                  //       }
                                  //       ;
                                  //     },
                                  //     child: SizedBox(
                                  //       child: Row(
                                  //         children: [
                                  //           Icon(
                                  //             Icons.sync,
                                  //             color: Palette.gray99,
                                  //             size: 15.0,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 5,
                                  //           ),
                                  //           Text(
                                  //             "레슨노트",
                                  //             style: TextStyle(
                                  //               fontSize: 22,
                                  //               color: Palette.gray66,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),

                            viewMode == "기본정보"
                                ? MemberInfoView(userInfo: userInfo)
                                : LessonNoteView(
                                    userInfo: userInfo,
                                    lessonService: lessonService,
                                  ),

                            //SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 14,
              // ),

              /// 추가 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 11, 5, 24),
                child: ElevatedButton(
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
                          "노트 추가",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    print("노트 추가");

                    lessonDate =
                        DateFormat("yyyy-MM-dd").format(DateTime.now());

                    List<TmpLessonInfo> tmpLessonInfoList = [];
                    eventList = [];
                    lessonAddMode = "노트 추가";
                    List<dynamic> args = [
                      userInfo,
                      lessonDate,
                      eventList,
                      lessonNoteId,
                      lessonAddMode,
                      tmpLessonInfoList,
                    ];

                    // LessonAdd로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonAdd(),
                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        settings: RouteSettings(arguments: args),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Figma 확인 해보면 '기본정보' 탭에는 BottomAppBar 없는데, '동작' 탬에는 있음
        // 같은 화면인데 '기본정보' 탭에는 누락 된 듯하여 추가 BottomAppBar 함
        //bottomNavigationBar: BaseBottomAppBar(),
      );
    });
  }
}

class LessonNoteView extends StatefulWidget {
  const LessonNoteView({
    Key? key,
    required this.userInfo,
    required this.lessonService,
  }) : super(key: key);

  final UserInfo userInfo;
  final LessonService lessonService;

  @override
  State<LessonNoteView> createState() => _LessonNoteViewState();
}

class _LessonNoteViewState extends State<LessonNoteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: Palette.mainBackground,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text(
            //   '레슨노트',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Palette.gray33,
            //   ),
            // ),
            Spacer(
              flex: 1,
            ),
            Container(
              //color: Colors.red,
              child: InkWell(
                onTap: () {
                  if (listMode == "동작별") {
                    setState(() {
                      listMode = "날짜별";
                    });
                  } else {
                    setState(() {
                      listMode = "동작별";
                    });
                  }
                  ;
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.sync,
                        color: Palette.gray99,
                        size: 15.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        listMode == "동작별" ? "날짜별" : "동작별",
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.gray66,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        FutureBuilder<QuerySnapshot>(
          future: widget.lessonService.read(
            widget.userInfo.uid,
            widget.userInfo.docId,
          ),
          builder: (context, snapshot) {
            final doc = snapshot.data?.docs ?? []; // 문서들 가져오기
            print(
                "[MI] 노트 유무 체크 - doc:${doc.length}/${widget.userInfo.uid}/${widget.userInfo.docId}");
            if (doc.isEmpty && dayNotelessonCnt == 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Text("첫번째 노트를 작성해보세요!"),
                  ),
                ],
              );
            } else if (doc.isEmpty && dayNotelessonCnt > 0) {
              print("동작은 없는데, 일별노트는 있는 경우");
              if (listMode == "동작별") {
                return Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text("노트에서 동작을 추가해보세요!"),
                    ),
                  ],
                );
              } else {
                List<TmpLessonInfo> tmpLessonInfoList = [];
                return NoteListDateCategory(
                  docs: doc,
                  userInfo: widget.userInfo,
                  lessonService: widget.lessonService,
                  tmpLessonInfoList: tmpLessonInfoList,
                );
              }
            } else {
              print("왜가리지?");
              if (listMode == "동작별") {
                return NoteListActionCategory(
                    docs: doc, userInfo: widget.userInfo);
              } else {
                List<TmpLessonInfo> tmpLessonInfoList = [];
                return NoteListDateCategory(
                  docs: doc,
                  userInfo: widget.userInfo,
                  lessonService: widget.lessonService,
                  tmpLessonInfoList: tmpLessonInfoList,
                );
              }
            }
            ;
          },
        ),
        SizedBox(
          height: 14,
        ),
      ]),
    );
  }
}

class MemberInfoView extends StatelessWidget {
  const MemberInfoView({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  final UserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: Palette.mainBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          // Row(
          //   children: [
          //     Text(
          //       '회원정보',
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //         color: Palette.gray33,
          //       ),
          //     ),
          //     Spacer(),
          //   ],
          // ),
          //const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '운동목표',
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
                  '통증/상해/병력',
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
                  '체형분석',
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
                const SizedBox(height: 20.0),
                Text(
                  '특이사항',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray66,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  userInfo.comment,
                  style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.bold,
                    color: Palette.gray99,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Palette.grayEE,
                ),
                height: 40,
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "수정하기",
                      style: TextStyle(fontSize: 14, color: Palette.gray66),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                // 회원 운동 카드 선택시 MemberInfo로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberUpdate(),
                    // GlobalWidgetDashboard(), //
                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                    settings: RouteSettings(arguments: userInfo),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class NoteListActionCategory extends StatefulWidget {
  const NoteListActionCategory({
    Key? key,
    required this.docs,
    required this.userInfo,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Object?>> docs;
  final UserInfo userInfo;

  @override
  State<NoteListActionCategory> createState() => _NoteListActionCategoryState();
}

class _NoteListActionCategoryState extends State<NoteListActionCategory> {
  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      elements: widget.docs,
      groupBy: (element) => element['actionName'],
      groupSeparatorBuilder: (String value) =>
          GroupActionContainer(actionName: value),
      itemBuilder: (BuildContext context, dynamic ddocs) {
        // 달력기능 개발 중
        // DateTime eventDate = DateTime.parse(
        //     docs['lessonDate'].toString());
        // eventList.add(eventDate);

        print("indexCheck : ${indexCheck}");

        print(
            "docID : ??? , apratusName : ${ddocs['apratusName']}, actionName :${ddocs['actionName']}, lessonDate : ${ddocs['lessonDate']}, grade: ${ddocs['grade']}, totalNote : ${ddocs['totalNote']}");
        indexCheck++;

        return ActionContainer(
            apratusName: ddocs['apratusName'],
            actionName: ddocs['actionName'],
            lessonDate: ddocs['lessonDate'],
            grade: ddocs['grade'],
            totalNote: ddocs['totalNote']);
      },
      itemComparator: (item1, item2) =>
          item2['lessonDate'].compareTo(item1['lessonDate']), // optional
      order: GroupedListOrder.ASC,
    );
  }
}

class NoteListDateCategory extends StatefulWidget {
  const NoteListDateCategory({
    Key? key,
    required this.docs,
    required this.userInfo,
    required this.lessonService,
    required this.tmpLessonInfoList,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Object?>> docs;
  final UserInfo userInfo;
  final LessonService lessonService;
  final tmpLessonInfoList;

  @override
  State<NoteListDateCategory> createState() => _NoteListDateCategoryState();
}

class _NoteListDateCategoryState extends State<NoteListDateCategory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        FutureBuilder<QuerySnapshot>(
          future: widget.lessonService.readTodaynote(
            widget.userInfo.uid,
            widget.userInfo.docId,
          ),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? []; // 문서들 가져오기

            if (docs.isEmpty) {
              return Center(child: Text(" "));
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                final doc = docs[index];
                String memberId = widget.userInfo.docId;
                String name = doc.get('name');
                String lessonDate = doc.get('lessonDate');
                String todayNote = doc.get('todayNote');

                return LessonCard(
                  userInfo: widget.userInfo,
                  memberId: memberId,
                  lessonDate: lessonDate,
                  todayNote: todayNote,
                  lessonService: widget.lessonService,
                );
              },
              separatorBuilder: ((context, index) => SizedBox(
                    height: 10,
                  )),
            );
          },
        ),
      ],
    );
  }
}

class LessonCard extends StatelessWidget {
  const LessonCard({
    Key? key,
    required this.userInfo,
    required this.memberId,
    required this.lessonDate,
    required this.todayNote,
    required this.lessonService,
  }) : super(key: key);

  final UserInfo userInfo;
  final String memberId;
  final String lessonDate;
  final String todayNote;
  final LessonService lessonService;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Palette.grayEE, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          //color: Palette.secondaryBackground,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                List<TmpLessonInfo> tmpLessonInfoList = [];
                eventList = [];
                lessonAddMode = "노트보기";
                List<dynamic> args = [
                  userInfo,
                  lessonDate,
                  eventList,
                  lessonNoteId,
                  lessonAddMode,
                  tmpLessonInfoList,
                ];
                print("args.length : ${args.length}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonAdd(),
                    // GlobalWidgetDashboard(), //
                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                    settings: RouteSettings(arguments: args),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(color: Palette.grayEE
                    //color: Colors.red.withOpacity(0),
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    //top: 5,
                    //bottom: 5,
                    left: 30.0,
                    right: 16.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              lessonDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Spacer(flex: 1),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Palette.gray99,
                              size: 12.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Palette.grayFF,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Palette.grayEE))
                  //color: Colors.red.withOpacity(0),
                  ),
              child: Padding(
                padding: const EdgeInsets.only(
                  //top: 5,
                  //bottom: 5,
                  left: 30.0,
                  right: 16.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${todayNote}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Palette.gray66,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Palette.grayFF,
                //color: Colors.red.withOpacity(0),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 10,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: lessonService.readNotesOflessonDate(
                userInfo.uid,
                memberId,
                lessonDate,
              ),
              builder: (context, snapshot) {
                final lessonData = snapshot.data?.docs ?? []; // 문서들 가져오기
                if (lessonData.isEmpty) {
                  return Center(child: Text(""));
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: lessonData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final doc = lessonData[index];
                    int pos = doc.get('pos');
                    String actionName = doc.get('actionName');
                    String apratusName = doc.get('apratusName');
                    String totalNote = doc.get('totalNote');
                    // 날짜 글자 자르기
                    if (lessonDate.length > 0) {
                      lessonDateTrim = lessonDate.substring(2, 10);
                    }
                    // 기구 첫두글자 자르기
                    if (apratusName.length > 0) {
                      apratusNameTrim = apratusName.substring(0, 2);
                    }

                    return Container(
                        decoration: BoxDecoration(
                          color: Palette.grayFF,
                          //color: Colors.red.withOpacity(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                            top: 5.0,
                          ),
                          child: SizedBox(
                            //height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  apratusNameTrim,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 12.0,
                                      ),
                                ),
                                const SizedBox(width: 15.0),
                                Text(
                                  actionName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 12.0,
                                      ),
                                ),
                                const SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    totalNote,
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },

                  //   Text(
                  //       "${pos.toString()}-${actionName}-${aparatusName}-${totalNote}");
                  // },
                  separatorBuilder: ((context, index) => Divider(
                        height: 0,
                      )),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(color: Palette.grayFF
                  //color: Colors.red.withOpacity(0),
                  ),
              child: SizedBox(
                width: double.infinity,
                height: 10,
              ),
            ),
            const SizedBox(height: 10)
          ],
        ));
  }
}
