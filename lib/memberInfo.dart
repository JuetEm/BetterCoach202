import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'memberAdd.dart';
import 'memberList.dart';
import 'memberUpdate.dart';
import 'member_service.dart';
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
bool favoriteMember = true;

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  @override
  void initState() {
    //처음에만 날짜 받아옴.

    super.initState();
  }

  Future<bool> _readfavoriteMember(String uid, String docId) async {
    bool result = false;
    final memberService = context.read<MemberService>();
    await memberService
        .readisActive(
      uid,
      docId,
    )
        .then((val) {
      result = val;
      print('[MI]회원정보 화면 _readfavoriteMember : 즐겨찾기 ${val}');
    });
    return result;
  }

  void _updatefavoriteMember() {
    setState(() {});
  }
  //setState(() {});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    final memberService = context.read<MemberService>();

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

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        print("[MI] 빌드시작  : favoriteMember- ${favoriteMember}");
        // lessonService
        // ignore: dead_code
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "회원관리", () {
            Navigator.pop(context);
          }),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 22, 22, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // FutureBuilder 예시 코드
                                  FutureBuilder(
                                      future: _readfavoriteMember(
                                          user.uid, userInfo.docId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                                        if (snapshot.hasData == false) {
                                          return IconButton(
                                              icon: SvgPicture.asset(
                                                "favorite_unselected.svg",
                                              ),
                                              iconSize: 40,
                                              onPressed: () {});
                                        }

                                        //error가 발생하게 될 경우 반환하게 되는 부분
                                        else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                        }

                                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                                        else {
                                          print(
                                              "[MI] 즐겨찾기 로딩후 : ${snapshot.data} / ${userInfo.docId}");
                                          favoriteMember = snapshot.data;
                                          return IconButton(
                                              icon: SvgPicture.asset(
                                                favoriteMember
                                                    ? "favorite_selected.svg"
                                                    : "favorite_unselected.svg",
                                              ),
                                              iconSize: 40,
                                              onPressed: () async {
                                                favoriteMember =
                                                    !favoriteMember;

                                                await memberService
                                                    .updateisActive(
                                                        userInfo.docId,
                                                        favoriteMember);
                                                print(
                                                    "[MI] 즐겨찾기 변경 클릭 : 변경후 - ${favoriteMember} / ${userInfo.docId}");

                                                _updatefavoriteMember();
                                                //lessonService.notifyListeners();

                                                //setState(() {});
                                                // setState(() {
                                                //   userInfo.isActive
                                                //       ? favoriteMember = false
                                                //       : favoriteMember = true;
                                                // }
                                                //);
                                              });
                                        }
                                      }),

                                  Container(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userInfo.name}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '${userInfo.phoneNumber}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              //fontWeight: FontWeight.bold,
                                              color: Palette.gray66),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '등록일',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            //fontWeight: FontWeight.bold,
                                            color: Palette.gray99),
                                        textAlign: TextAlign.right,
                                      ),
                                      Text(
                                        '${userInfo.registerDate}',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            //fontWeight: FontWeight.bold,
                                            color: Palette.gray99),
                                        textAlign: TextAlign.right,
                                      ),
                                      // Text(
                                      //   '남은횟수 : ${userInfo.registerType}',
                                      //   style: TextStyle(
                                      //       fontSize: 14.0,
                                      //       //fontWeight: FontWeight.bold,
                                      //       color: Palette.gray99),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
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
                                        height: 54,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: viewMode == "기본정보"
                                                  ? Palette.buttonOrange
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
                                                  ? Palette.buttonOrange
                                                  : Palette.gray99,
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
                                        height: 54,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: viewMode == "레슨노트"
                                                  ? Palette.buttonOrange
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
                                                  ? Palette.buttonOrange
                                                  : Palette.gray99,
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
//https://kibua20.tistory.com/232
                            viewMode == "기본정보"
                                ? MemberInfoView(userInfo: userInfo)
                                : LessonNoteView(
                                    userInfo: userInfo,
                                    lessonService: lessonService,
                                    //notifyParent: _refreshNoteCount,
                                  ),

                            //SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 14,
                // ),

                /// 추가버튼_이전
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //       ),
                //       elevation: 0,
                //       backgroundColor: Palette.buttonOrange,
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 14, horizontal: 90),
                //       child: Text("노트추가", style: TextStyle(fontSize: 16)),
                //     ),
                //     onPressed: () {
                //       lessonDate =
                //           DateFormat("yyyy-MM-dd").format(DateTime.now());

                //       List<TmpLessonInfo> tmpLessonInfoList = [];
                //       eventList = [];
                //       lessonAddMode = "노트 추가";
                //       List<dynamic> args = [
                //         userInfo,
                //         lessonDate,
                //         eventList,
                //         lessonNoteId,
                //         lessonAddMode,
                //         tmpLessonInfoList,
                //       ];
                //       print(
                //           "[MI] 노트추가 클릭  ${lessonDate} / ${lessonAddMode} / tmpLessonInfoList ${tmpLessonInfoList.length}");
                //       // LessonAdd로 이동
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => LessonAdd(),
                //           // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                //           settings: RouteSettings(arguments: args),
                //         ),
                //       );
                //     }),

                /// 추가 버튼
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(5, 11, 5, 24),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //       ),
                //       backgroundColor: Colors.transparent,
                //       shadowColor: Colors.transparent,
                //     ),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Palette.buttonOrange,
                //       ),
                //       height: 60,
                //       width: double.infinity,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             "노트 추가",
                //             style: TextStyle(fontSize: 18),
                //           ),
                //         ],
                //       ),
                //     ),
                //     onPressed: () {
                //       print("노트 추가");

                //       lessonDate =
                //           DateFormat("yyyy-MM-dd").format(DateTime.now());

                //       List<TmpLessonInfo> tmpLessonInfoList = [];
                //       eventList = [];
                //       lessonAddMode = "노트 추가";
                //       List<dynamic> args = [
                //         userInfo,
                //         lessonDate,
                //         eventList,
                //         lessonNoteId,
                //         lessonAddMode,
                //         tmpLessonInfoList,
                //       ];

                //       // LessonAdd로 이동
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => LessonAdd(),
                //           // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                //           settings: RouteSettings(arguments: args),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),

          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: FloatingActionButton.extended(
              onPressed: () {
                // if (viewMode == "레슨노트") {
                lessonDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
                print(
                    "[MI] 노트추가 클릭  ${lessonDate} / ${lessonAddMode} / tmpLessonInfoList ${tmpLessonInfoList.length}");
                // LessonAdd로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonAdd(),
                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                    settings: RouteSettings(arguments: args),
                  ),
                );
                // } else {
                //   //회원정보 보기에서 동작이 달라짐.
                //   // 회원 운동 카드 선택시 MemberInfo로 이동
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => MemberUpdate(),
                //       // GlobalWidgetDashboard(), //
                //       // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                //       settings: RouteSettings(arguments: userInfo),
                //     ),
                //   );
                //}
              },
              label: Text(
                '노트 작성',
                style: TextStyle(fontSize: 16, letterSpacing: -0.2),
              ),
              icon: Icon(Icons.edit),
              backgroundColor: Palette.buttonOrange,
            ),
          ),
          // Figma 확인 해보면 '기본정보' 탭에는 BottomAppBar 없는데, '동작' 탬에는 있음
          // 같은 화면인데 '기본정보' 탭에는 누락 된 듯하여 추가 BottomAppBar 함
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }
}

class LessonNoteView extends StatefulWidget {
  const LessonNoteView({
    Key? key,
    required this.userInfo,
    required this.lessonService,
    //required this.notifyParent,
  }) : super(key: key);

  final UserInfo userInfo;
  final LessonService lessonService;
  //final Function() notifyParent;

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '총 ${dayNotelessonCnt}개',
              style: TextStyle(
                fontSize: 14,
                color: Palette.gray66,
              ),
            ),
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

class MemberInfoView extends StatefulWidget {
  const MemberInfoView({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  final UserInfo userInfo;

  @override
  State<MemberInfoView> createState() => _MemberInfoViewState();
}

class _MemberInfoViewState extends State<MemberInfoView> {
  @override
  Widget build(BuildContext context) {
    // selectedGoals 값 반영하여 FilterChips 동적 생성
    var goalChips = [];
    goalChips = makeChips(
        goalChips, widget.userInfo.selectedGoals, Palette.backgroundOrange);
    // selelctedAnalyzedList 값 반영하여 FilterChips 동적 생성
    var bodyAnalyzedChips = [];
    bodyAnalyzedChips = makeChips(bodyAnalyzedChips,
        widget.userInfo.selectedBodyAnalyzed, Palette.grayEE);

    // medicalHistoryList 값 반영하여 FilterChips 동적 생성
    var medicalHistoriesChips = [];
    medicalHistoriesChips = makeChips(medicalHistoriesChips,
        widget.userInfo.selectedMedicalHistories, Palette.backgroundBlue);

    print(
        "[MI] 운동목표 칩셋출력 : selectedGoals비었니.? ${widget.userInfo.selectedGoals.isEmpty}");
    print("[MI] 운동목표 칩셋출력 : goalChips ${goalChips}");

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '수강정보',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray66,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '등록횟수 : ${widget.userInfo.registerType}',
                  style: TextStyle(
                      fontSize: 14.0,
                      //fontWeight: FontWeight.bold,
                      color: Palette.gray99),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 30),
                Text(
                  '운동목표',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray66,
                  ),
                ),
                const SizedBox(height: 10),
                Offstage(
                  offstage: widget.userInfo.selectedGoals.isEmpty,
                  child: Wrap(
                    direction: Axis.horizontal, // 나열 방향
                    alignment: WrapAlignment.start, // 정렬 방식
                    spacing: 5, // 좌우 간격
                    runSpacing: 5,
                    children: [
                      for (final chip in goalChips)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                          child: chip,
                        ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: widget.userInfo.goal.isEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.userInfo.goal,
                        style: TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                          color: Palette.gray99,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  '체형분석',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray66,
                  ),
                ),
                const SizedBox(height: 10),
                Offstage(
                  offstage: widget.userInfo.selectedMedicalHistories.isEmpty,
                  child: Wrap(
                    direction: Axis.horizontal, // 나열 방향
                    alignment: WrapAlignment.start, // 정렬 방식
                    spacing: 5, // 좌우 간격
                    runSpacing: 5,
                    children: [
                      for (final chip in bodyAnalyzedChips)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                          child: chip,
                        ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: widget.userInfo.bodyAnalyzed.isEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.userInfo.bodyAnalyzed,
                        style: TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                          color: Palette.gray99,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  '통증/상해/병력',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Palette.gray66),
                ),
                const SizedBox(height: 10),
                Offstage(
                  offstage: widget.userInfo.selectedMedicalHistories.isEmpty,
                  child: Wrap(
                    direction: Axis.horizontal, // 나열 방향
                    alignment: WrapAlignment.start, // 정렬 방식
                    spacing: 5, // 좌우 간격
                    runSpacing: 5,
                    children: [
                      for (final chip in medicalHistoriesChips)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                          child: chip,
                        ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: widget.userInfo.medicalHistories.isEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.userInfo.medicalHistories,
                        style: TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                          color: Palette.gray99,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  '특이사항',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray66,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.userInfo.comment,
                  style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.bold,
                    color: Palette.gray99,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(36.0),
                  ),
                  color: Palette.grayB4,
                ),
                height: 36,
                width: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "정보 수정",
                      style: TextStyle(fontSize: 14, color: Palette.grayFF),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                print("회원수정");
                String memberAddMode = "수정";

                List<dynamic> args = [
                  memberAddMode,
                  widget.userInfo,
                ];

                // 저장하기 성공시 Home로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberAdd(),
                    // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                    settings: RouteSettings(
                      arguments: args,
                    ),
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

  List<dynamic> makeChips(List<dynamic> resultChips, List<String> targetList,
      Color chipBackgroundColor) {
    resultChips = targetList
        .map((e) => Chip(
            label: Text(e),
            // onSelected: ((value) {
            //   setState(() {
            //     targetList.remove(e);
            //   });
            //   print("value : ${value}");
            // }),
            // selected: targetList.contains(e),
            labelStyle: TextStyle(fontSize: 12, color: Palette.gray00),
            // selectedColor: Palette.buttonOrange,
            backgroundColor: chipBackgroundColor,
            // showCheckmark: false,
            side: BorderSide(color: Palette.grayFF)))
        .toList();
    // .map((e) => Chip(
    //     label: Row(
    //       children: [
    //         Text(e),
    //         Icon(
    //           Icons.close_outlined,
    //           size: 14,
    //           color:
    //               targetList.contains(e) ? Palette.grayFF : Palette.gray99,
    //         )
    //       ],
    //     ),
    //     // onSelected: ((value) {
    //     //   setState(() {
    //     //     targetList.remove(e);
    //     //   });
    //     //   print("value : ${value}");
    //     // }),
    //     // selected: targetList.contains(e),
    //     labelStyle: TextStyle(fontSize: 12, color: Palette.grayFF),
    //     // selectedColor: Palette.buttonOrange,
    //     backgroundColor: Palette.buttonOrange,
    //     // showCheckmark: false,
    //     side: BorderSide(color: Palette.grayB4)))
    // .toList();

    print("[MI] makeChips : ${resultChips}");
    return resultChips;
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
          color: Palette.secondaryBackground,
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
                print("[MI]LessonCard-lessonDate : ${lessonDate}");
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
                decoration: BoxDecoration(
                  //color: Palette.grayEE
                  color: Colors.red.withOpacity(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Palette.gray33,
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
                  //color: Palette.buttonOrange,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Palette.grayEE))
                  //color: Colors.red.withOpacity(0),
                  ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 38,
                  ),
                  width: double.infinity,
                  //height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     todayNote,
                      //     //overflow: TextOverflow.fade,
                      //     maxLines: 3,
                      //     softWrap: true,
                      //     style:
                      //         Theme.of(context).textTheme.bodyText1!.copyWith(
                      //               fontSize: 14.0,
                      //             ),
                      //   ),
                      // ),
                      Text(
                        "${todayNote}",
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14,
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
                            left: 14.0,
                            right: 14.0,
                            top: 5.0,
                          ),
                          child: SizedBox(
                            //height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  apratusNameTrim,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Palette.gray66,
                                  ),
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText1!
                                  //     .copyWith(
                                  //       fontSize: 12.0,
                                  //     ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  actionName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Palette.gray66,
                                  ),
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText1!
                                  //     .copyWith(
                                  //       fontSize: 12.0,
                                  //     ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    totalNote,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
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
              decoration: BoxDecoration(
                border: Border.all(color: Palette.grayFF, width: 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Palette.grayFF,
              ),
              child: const SizedBox(
                width: double.infinity,
                height: 30,
              ),
            )
          ],
        ));
  }
}
