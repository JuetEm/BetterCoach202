import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/color.dart';

import 'actionAdd.dart';
import 'actionInfo.dart';
import 'action_service.dart';
import 'lessonAdd.dart';
import 'lessonInfo.dart';
import 'lesson_service.dart';
import 'auth_service.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'package:web_project/userInfo.dart'
    as CustomUserInfo; // 다른 페키지와 클래스 명이 겹치는 경우 alias 선언해서 사용

bool isReformerSelected = false;
bool isCadillacSelected = false;
bool isChairSelected = false;
bool isLadderBarrelSelected = false;
bool isSpringBoardSelected = false;
bool isSpineCorrectorSelected = false;
bool isMatSelected = false;
bool isOthersApparatusSelected = false;

bool isSupineSelected = false;
bool isSittingSelected = false;
bool isProneSelected = false;
bool isKneelingSelected = false;
bool isSideLyingSelected = false;
bool isStandingSelected = false;
bool isPlankSelected = false;
bool isQuadrupedSelected = false;
bool isOthersPositionSelected = false;

String searchString = "";

List positionArray = [];

int positionFilteredSize = 0;

GlobalFunction globalFunction = GlobalFunction();

bool initStateVar = true;

TextEditingController searchController = TextEditingController();

late bool isFloating;
late int selectedActionCount = -1;

late Color actionTileColor;
late List<LessonInfo> lessonInfoList;
late List<TmpLessonInfo> tmpLessonInfoList;
late List<int> checkedTileList;

class ActionSelector extends StatefulWidget {
  const ActionSelector({super.key});

  @override
  State<ActionSelector> createState() => _ActionSelectorState();
}

class _ActionSelectorState extends State<ActionSelector> {
  @override
  void initState() {
    isFloating = false;
    selectedActionCount = 0;
    actionTileColor = Palette.grayEE;
    lessonInfoList = [];
    tmpLessonInfoList = [];
    checkedTileList = [];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 화면 나갈때  chip 변수 초기화
    isReformerSelected = false;
    isCadillacSelected = false;
    isChairSelected = false;
    isLadderBarrelSelected = false;
    isSpringBoardSelected = false;
    isSpineCorrectorSelected = false;
    isMatSelected = false;
    isOthersApparatusSelected = false;

    isSupineSelected = false;
    isSittingSelected = false;
    isProneSelected = false;
    isKneelingSelected = false;
    isSideLyingSelected = false;
    isStandingSelected = false;
    isPlankSelected = false;
    isQuadrupedSelected = false;
    isOthersPositionSelected = false;

    positionArray = [];
    initStateVar = !initStateVar;

    searchString = "";

    isFloating = false;
    selectedActionCount = 0;
    actionTileColor = Palette.grayEE;
    lessonInfoList = [];
    tmpLessonInfoList = [];
    checkedTileList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    //레슨서비스 활용
    final lessonService = context.read<LessonService>();

    // 이전 화면에서 보낸 변수 받기
    final List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final CustomUserInfo.UserInfo customUserInfo = args[0];
    final String currentApparatus = args[1];
    final String lessonDate = args[2];

    // initState = args[3];
    final String totalNote = args[4];
    tmpLessonInfoList = args[5];

    if (initStateVar) {
      switch (currentApparatus) {
        case "REFORMER":
          isReformerSelected = true;
          initStateVar = !initStateVar;
          break;
        case "CADILLAC":
          isCadillacSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "CHAIR":
          isChairSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "LADDER BARREL":
          isLadderBarrelSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "SPRING BOARD":
          isSpringBoardSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "SPINE CORRECTOR":
          isSpineCorrectorSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "MAT":
          isMatSelected = true;
          initStateVar = !initStateVar;
          ;
          break;
        case "OTHERS":
          isOthersApparatusSelected = true;
          initStateVar = !initStateVar;
          break;
      }
    }

    print("positionFilteredSize : ${positionFilteredSize}");
    positionFilteredSize = 0;

    final apparatusChips = [
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isMatSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("MAT"),
        selected: isMatSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isMatSelected = !isMatSelected;
              print("isMatSelected : ${isMatSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isReformerSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("REFORMER"),
        selected: isReformerSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isReformerSelected = !isReformerSelected;
              print("isReformerSelected : ${isReformerSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isCadillacSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("CADILLAC"),
        selected: isCadillacSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isCadillacSelected = !isCadillacSelected;
              print(
                  "isSupineisCadillacSelectedSelected : ${isCadillacSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isChairSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("CHAIR"),
        selected: isChairSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isChairSelected = !isChairSelected;
              print("isChairSelected : ${isChairSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isLadderBarrelSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("LADDER BARREL"),
        selected: isLadderBarrelSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isLadderBarrelSelected = !isLadderBarrelSelected;
              print("isLadderBarrelSelected : ${isLadderBarrelSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isSpringBoardSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SPRING BOARD"),
        selected: isSpringBoardSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isSpringBoardSelected = !isSpringBoardSelected;
              print("isSpringBoardSelected : ${isSpringBoardSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isSpineCorrectorSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SPINE CORRECTOR"),
        selected: isSpineCorrectorSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isSpineCorrectorSelected = !isSpineCorrectorSelected;
              print("isSpineCorrectorSelected : ${isSpineCorrectorSelected}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isOthersApparatusSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("OTHERS"),
        selected: isOthersApparatusSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isOthersApparatusSelected = !isOthersApparatusSelected;
              print(
                  "isOthersApparatusSelectedSelected : ${isOthersApparatusSelected}");
            },
          );
        },
      ),
    ];

    final positionChips = [
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isSupineSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SUPINE"),
        selected: isSupineSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isSupineSelected = !isSupineSelected;
              if (isSupineSelected) {
                positionArray.add("supine");
              } else {
                positionArray.remove("supine");
              }
              print("isSupineSelected : ${isSupineSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isProneSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("PRONE"),
        selected: isProneSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isProneSelected = !isProneSelected;
              if (isProneSelected) {
                positionArray.add("prone");
              } else {
                positionArray.remove("prone");
              }
              print("isProneSelected : ${isProneSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isSittingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SITTING"),
        selected: isSittingSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isSittingSelected = !isSittingSelected;
              if (isSittingSelected) {
                positionArray.add("sitting");
              } else {
                positionArray.remove("sitting");
              }
              print("isSittingSelected : ${isSittingSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isStandingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("STANDING"),
        selected: isStandingSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isStandingSelected = !isStandingSelected;
              if (isStandingSelected) {
                positionArray.add("standing");
              } else {
                positionArray.remove("standing");
              }
              print("isStandingSelected : ${isStandingSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isKneelingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("KNEELING"),
        selected: isKneelingSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isKneelingSelected = !isKneelingSelected;
              if (isKneelingSelected) {
                positionArray.add("kneeling");
              } else {
                positionArray.remove("kneeling");
              }
              print("isKneelingSelected : ${isKneelingSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isSideLyingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SIDE LYING"),
        selected: isSideLyingSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isSideLyingSelected = !isSideLyingSelected;
              if (isSideLyingSelected) {
                positionArray.add("side lying");
              } else {
                positionArray.remove("side lying");
              }
              print("isSideLyingSelected : ${isSideLyingSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isQuadrupedSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("QUADRUPED"),
        selected: isQuadrupedSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isQuadrupedSelected = !isQuadrupedSelected;
              if (isQuadrupedSelected) {
                positionArray.add("quadruped");
              } else {
                positionArray.remove("quadruped");
              }
              print("isStandingSelected : ${isPlankSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isPlankSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("PLANK"),
        selected: isPlankSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isPlankSelected = !isPlankSelected;
              if (isPlankSelected) {
                positionArray.add("plank");
              } else {
                positionArray.remove("plank");
              }
              print("isStandingSelected : ${isPlankSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isOthersPositionSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("OTHERS"),
        selected: isOthersPositionSelected,
        showCheckmark: false,
        onSelected: (value) {
          setState(
            () {
              isOthersPositionSelected = !isOthersPositionSelected;
              if (isOthersPositionSelected) {
                positionArray.add("others");
              } else {
                positionArray.remove("others");
              }
              print("isOthersPositionSelected : ${isOthersPositionSelected}");
              print("positionArray : ${positionArray}");
            },
          );
        },
      ),
    ];

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Consumer<ActionService>(builder: (context, actionService, child) {
        if (tmpLessonInfoList.isNotEmpty) {
          selectedActionCount = tmpLessonInfoList.length;
          print(
              "selectedActionCount : ${selectedActionCount}, tmpLessonInfoList.length : ${tmpLessonInfoList.length}");
        }
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "동작선택", () {
            // 화면 나갈때  chip 변수 초기화
            isReformerSelected = false;
            isCadillacSelected = false;
            isChairSelected = false;
            isLadderBarrelSelected = false;
            isSpringBoardSelected = false;
            isSpineCorrectorSelected = false;
            isMatSelected = false;
            isOthersApparatusSelected = false;

            isSupineSelected = false;
            isSittingSelected = false;
            isProneSelected = false;
            isKneelingSelected = false;
            isSideLyingSelected = false;
            isStandingSelected = false;
            isPlankSelected = false;
            isQuadrupedSelected = false;
            isOthersPositionSelected = false;

            initStateVar = !initStateVar;
            positionArray = [];

            searchString = "";
            Navigator.pop(context);
          }),
          floatingActionButton: tmpLessonInfoList.isEmpty
              ? null
              : FloatingActionButton.extended(
                  isExtended: isFloating,
                  onPressed: () {
                    print(
                        "Floating Button onPressed Clicked! +${selectedActionCount}");
                  },
                  label: Text("+${selectedActionCount}"),
                ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SizedBox(height: 10),
                BaseSearchTextField(
                  customController: searchController,
                  hint: "동작을 검색하세요.",
                  showArrow: true,
                  customFunction: () {
                    setState(() {
                      searchString = searchController.text;
                    });
                  },
                ),
                // SizedBox(height: 10),
                // SizedBox(
                //   height: 30,
                //   width: double.infinity,
                //   child: Text(
                //     "기구별",
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),

                SizedBox(
                  height: 40,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final chip in apparatusChips)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                              child: chip,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 5),
                // SizedBox(
                //   height: 30,
                //   width: double.infinity,
                //   child: Text(
                //     "자세별",
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final chip in positionChips)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                              child: chip,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                // SizedBox(
                //   height: 50,
                //   child: Padding(
                //     padding: const EdgeInsets.all(14.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Text(
                //           "APPARATUS",
                //           style: TextStyle(
                //             fontSize: 14,
                //           ),
                //         ),
                //         Spacer(),
                //         Text(
                //           "POSITION",
                //           style: TextStyle(
                //             fontSize: 14,
                //           ),
                //         ),
                //         Spacer(),
                //         Text(
                //           "NAME",
                //           style: TextStyle(
                //             fontSize: 14,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                /// 신규동작추가 버튼
                SizedBox(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Palette.buttonOrange,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                        ),
                        height: 60,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "신규동작추가",
                              style: TextStyle(
                                fontSize: 18,
                                color: Palette.buttonOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        print("신규 동작 추가");
                        // LessonAdd로 이동
                        final result = await showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              return ActionAdd();
                            },
                          ),
                        );
                        setState(() {
                          searchController.text = result;
                          searchString = result;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "동작을 선택하세요",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: actionService.read(
                      isReformerSelected,
                      isCadillacSelected,
                      isChairSelected,
                      isLadderBarrelSelected,
                      isSpringBoardSelected,
                      isSpineCorrectorSelected,
                      isMatSelected,
                      isOthersApparatusSelected,
                      searchString,
                    ),
                    builder: (context, snapshot) {
                      final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                      print("docs : ${docs.length}");
                      if (docs.isEmpty) {
                        return Center(child: Text("운동 목록을 준비 중입니다."));
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: Palette.mainBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final doc = docs[index];
                            String noteId = doc.id;
                            String apparatus = doc.get('apparatus');
                            String position = doc.get('position');
                            String name = doc.get('name');
                            String lowerCaseName = doc.get('lowerCaseName');
                            List<dynamic> nGramizedLowerCaseName =
                                doc.get('nGramizedLowerCaseName');
                            ;
                            final ActionInfo actionInfo = ActionInfo(
                              name,
                              apparatus,
                              position,
                            );

                            print(
                                "noteId : ${noteId}, apparatus : ${apparatus}, actionName : ${name}, nGramizedLowerCaseName : ${nGramizedLowerCaseName}");
                            if (searchString.isEmpty) {
                              if (positionArray.isEmpty) {
                                return ActionTile(
                                    noteId: noteId,
                                    apparatus: apparatus,
                                    actionName: name,
                                    name: customUserInfo.name,
                                    phoneNumber: "temp",
                                    lessonDate: lessonDate,
                                    grade: "50",
                                    totalNote: totalNote,
                                    docId: customUserInfo.docId,
                                    uid: user.uid,
                                    pos: index);
                              } else {
                                if (positionArray.contains(position)) {
                                  positionFilteredSize++;
                                  return ActionTile(
                                      noteId: noteId,
                                      apparatus: apparatus,
                                      actionName: name,
                                      name: customUserInfo.name,
                                      phoneNumber: "temp",
                                      lessonDate: lessonDate,
                                      grade: "50",
                                      totalNote: totalNote,
                                      docId: customUserInfo.docId,
                                      uid: user.uid,
                                      pos: index);
                                } else {
                                  return SizedBox.shrink();
                                }
                              }
                            } else {
                              if (lowerCaseName
                                  .startsWith(searchString.toLowerCase())) {
                                if (positionArray.isEmpty) {
                                  return ActionTile(
                                      noteId: noteId,
                                      apparatus: apparatus,
                                      actionName: name,
                                      name: customUserInfo.name,
                                      phoneNumber: "temp",
                                      lessonDate: lessonDate,
                                      grade: "50",
                                      totalNote: totalNote,
                                      docId: customUserInfo.docId,
                                      uid: user.uid,
                                      pos: index);
                                } else {
                                  if (positionArray.contains(position)) {
                                    positionFilteredSize++;
                                    return ActionTile(
                                        noteId: noteId,
                                        apparatus: apparatus,
                                        actionName: name,
                                        name: customUserInfo.name,
                                        phoneNumber: "temp",
                                        lessonDate: lessonDate,
                                        grade: "50",
                                        totalNote: totalNote,
                                        docId: customUserInfo.docId,
                                        uid: user.uid,
                                        pos: index);
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                /// 추가 버튼
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 22),
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
                            "동작추가",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      print("동작추가");
                      // LessonAdd로 이동
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ActionAdd(),
                      //     // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                      //     settings: RouteSettings(
                      //       arguments: customUserInfo,
                      //     ),
                      //   ),
                      // );

                      // lessonAdd
                      if (tmpLessonInfoList.isNotEmpty) {
                        print("userInfo.docId : ${customUserInfo.docId}");

                        // for (int i = 0; i < tmpLessonInfoList.length; i++) {
                        //   lessonService.create(
                        //     docId: customUserInfo.docId,
                        //     uid: user.uid,
                        //     name: customUserInfo.name,
                        //     phoneNumber: customUserInfo.phoneNumber,
                        //     apratusName: tmpLessonInfoList[i].apparatusName,
                        //     actionName: tmpLessonInfoList[i].actionName,
                        //     lessonDate: lessonDate,
                        //     grade: "50",
                        //     totalNote: totalNote,
                        //     pos: i,
                        //     onSuccess: () {
                        //       print(
                        //           "동작추가 성공 : tmpLessonInfoList[${i}].apparatusName : ${tmpLessonInfoList[i].apparatusName}, tmpLessonInfoList[${i}].actionName : ${tmpLessonInfoList[i].actionName}");
                        //     },
                        //     onError: () {
                        //       print(
                        //           "동작추가 에러 : tmpLessonInfoList[${i}].apparatusName : ${tmpLessonInfoList[i].apparatusName}, tmpLessonInfoList[${i}].actionName : ${tmpLessonInfoList[i].actionName}");
                        //     },
                        //   );
                        // }

                        List<DateTime> tmpEventList = [];
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("동작추가 성공"),
                        ));
                        // 저장하기 성공시 MemberInfo로 이동
                        Navigator.pop(context, tmpLessonInfoList);
                        //initStateVar = !initStateVar;
                        //Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LessonAdd(),
                        //     // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        //     settings: RouteSettings(
                        //       arguments: [
                        //         customUserInfo,
                        //         lessonDate,
                        //         tmpEventList,
                        //         "",
                        //         "",
                        //         tmpLessonInfoList
                        //       ],
                        //     ),
                        //   ),
                        // );
                        initStateVar = !initStateVar;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("동작을 선택해주세요."),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: BaseBottomAppBar(),
        );
      }),
    );
  }
}

class ActionTile extends StatefulWidget {
  ActionTile({
    Key? key,
    required this.noteId,
    required this.apparatus,
    required this.actionName,
    required this.name,
    required this.phoneNumber,
    required this.lessonDate,
    required this.grade,
    required this.totalNote,
    required this.docId,
    required this.uid,
    required this.pos,
  }) : super(key: key);

  final String noteId;
  final String apparatus;
  final String actionName;
  final String name;
  final String phoneNumber;
  final String lessonDate;
  final String grade;
  final String totalNote;
  final String docId;
  final String uid;
  int pos;

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  @override
  Widget build(BuildContext context) {
    TmpLessonInfo tmpLessonInfo = TmpLessonInfo(
        widget.apparatus,
        widget.actionName,
        widget.name,
        widget.lessonDate,
        widget.grade,
        widget.totalNote,
        widget.docId,
        widget.uid);
    //레슨서비스 활용
    final lessonService = context.read<LessonService>();
    // onTap 방식과는 다르게 동작해야 함

    // setState(() {
    if (manageListContaining(tmpLessonInfoList, tmpLessonInfo, false)) {
      actionTileColor = Palette.buttonOrange;
      print(
          "YES contain!! => widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
    } else {
      actionTileColor = Palette.grayEE;
      print(
          "NOT contain!! => widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
    }
    // });
    return Column(
      children: [
        InkWell(
          onTap: () {
            print(
                "apparatus : ${widget.apparatus}, actionName : ${widget.actionName}");
            // 회원 카드 선택시 MemberInfo로 이동
            // Navigator.pop(context, actionInfo);
            setState(() {
              if (manageListContaining(
                  tmpLessonInfoList, tmpLessonInfo, true)) {
                actionTileColor = Palette.grayEE;
                print(
                    "YES contain!! remove item => widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
                // checkedTileList.remove(widget.pos);

                lessonService.deleteFromActionSelect(widget.uid, widget.docId,
                    widget.lessonDate, widget.apparatus, widget.actionName);
              } else {
                actionTileColor = Palette.buttonOrange;
                print(
                    "NOT contain!! add item => widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
                // checkedTileList.add(widget.pos);

                lessonService.create(
                  docId: widget.docId,
                  uid: widget.uid,
                  name: widget.name,
                  phoneNumber: widget.phoneNumber,
                  apratusName: widget.apparatus,
                  actionName: widget.actionName,
                  lessonDate: widget.lessonDate,
                  grade: "50",
                  totalNote: "",
                  pos: null,
                  onSuccess: () {
                    print(
                        "동작추가 성공 : widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
                  },
                  onError: () {
                    print(
                        "동작추가 에러 : widget.apparatus : ${widget.apparatus}, widget.actionName : ${widget.actionName}");
                  },
                );
              }

              if (tmpLessonInfoList.isNotEmpty) {
                isFloating = true;
                selectedActionCount = tmpLessonInfoList.length;
                print(
                    "isFloating isNotEmpty : tmpLessonInfoList.length : ${tmpLessonInfoList.length}");
              } else {
                isFloating = false;
                print(
                    "isFloating isEmpty : tmpLessonInfoList.length : ${tmpLessonInfoList.length}");
              }
            });
            for (int i = 0; i < tmpLessonInfoList.length; i++) {
              print(
                  "tmpLessonInfoList - apratusName : ${tmpLessonInfoList[i].apparatusName}, actionName : ${tmpLessonInfoList[i].actionName}");
            }
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Palette.grayEE, width: 1),
                ),
                color: actionTileColor),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.apparatus}   ",
                    style: TextStyle(color: Palette.gray99),
                  ),
                ),
                Text(
                  "${widget.actionName}",
                  style: TextStyle(
                      color: Palette.gray66, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

bool manageListContaining(List<TmpLessonInfo> tmpLessonInfoList,
    TmpLessonInfo tmpLessonInfo, bool isEditable) {
  bool isConatained = false;
  for (int i = 0; i < tmpLessonInfoList.length; i++) {
    if (tmpLessonInfoList[i].apparatusName == tmpLessonInfo.apparatusName) {
      if (tmpLessonInfoList[i].actionName == tmpLessonInfo.actionName) {
        isConatained = true;
        if (isEditable) {
          tmpLessonInfoList.removeAt(i);
        }
      }
    }
  }
  if (isEditable) {
    if (!isConatained) {
      tmpLessonInfoList.add(tmpLessonInfo);
    }
  }
  return isConatained;
}

class TmpLessonInfo {
  TmpLessonInfo(
    this.apparatusName,
    this.actionName,
    this.name,
    this.lessonDate,
    this.grade,
    this.totalNote,
    this.docId,
    this.uid,
  );

  String apparatusName;
  String actionName;
  String name;
  String lessonDate;
  String grade;
  String totalNote;
  String docId;
  String uid;
}
