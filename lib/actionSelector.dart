import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/color.dart';

import 'actionInfo.dart';
import 'action_service.dart';
import 'auth_service.dart';
import 'globalWidget.dart';
import 'memberInfo.dart';
import 'userInfo.dart';

bool isReformerSelected = false;
bool isCadillacSelected = false;
bool isChairSelected = false;
bool isLadderBarrelSelected = false;
bool isSpringBoardSelected = false;
bool isSpineCorrectorSelected = false;
bool isMatSelected = false;

bool isSupineSelected = false;
bool isSittingSelected = false;
bool isProneSelected = false;
bool isKneelingSelected = false;
bool isSideLyingSelected = false;
bool isStandingSelected = false;

List positionArray = [];

int positionFilteredSize = 0;

class ActionSelector extends StatefulWidget {
  const ActionSelector({super.key});

  @override
  State<ActionSelector> createState() => _ActionSelectorState();
}

class _ActionSelectorState extends State<ActionSelector> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;
    print("positionFilteredSize : ${positionFilteredSize}");
    positionFilteredSize = 0;

    final apparatusChips = [
      FilterChip(
        labelStyle: TextStyle(
            fontSize: 12,
            color: isCadillacSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("CADILLAC"),
        selected: isCadillacSelected,
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
            color: isReformerSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("REFORMER"),
        selected: isReformerSelected,
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
            color: isChairSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("CHAIR"),
        selected: isChairSelected,
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
            color: isMatSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("MAT"),
        selected: isMatSelected,
        onSelected: (value) {
          setState(
            () {
              isMatSelected = !isMatSelected;
              print("isMatSelected : ${isMatSelected}");
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
            color: isSittingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("SITTING"),
        selected: isSittingSelected,
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
            color: isProneSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("PRONE"),
        selected: isProneSelected,
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
            color: isKneelingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("KNEELING"),
        selected: isKneelingSelected,
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
            color: isStandingSelected ? Palette.grayFF : Palette.gray66),
        selectedColor: Palette.buttonOrange,
        label: Text("STANDING"),
        selected: isStandingSelected,
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
    ];

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Consumer<ActionService>(builder: (context, actionService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "동작선택", null),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // SizedBox(
              //   height: 30,
              //   child: Text(
              //     "기구 필터",
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              Divider(),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final chip in apparatusChips)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: chip,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              // SizedBox(
              //   height: 30,
              //   child: Text(
              //     "자세 필터",
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final chip in positionChips)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: chip,
                        ),
                    ],
                  ),
                ),
              ),
              Divider(),
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
                    isSupineSelected,
                    isSittingSelected,
                    isProneSelected,
                    isKneelingSelected,
                    isSideLyingSelected,
                    isStandingSelected,
                  ),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                    print("docs : ${docs.length}");
                    if (docs.isEmpty) {
                      return Center(child: Text("운동 목록을 준비 중입니다."));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final doc = docs[index];
                          String apparatus = doc.get('apparatus');
                          String position = doc.get('position');
                          String name = doc.get('name');
                          String upperCaseName = doc.get('upperCaseName');
                          String lowerCaseName = doc.get('lowerCaseName');
                          final ActionInfo actionInfo = ActionInfo(
                            name,
                            apparatus,
                            position,
                          );

                          if (positionArray.isEmpty) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Palette.mainBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Palette.grayEE, width: 1),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // 회원 카드 선택시 MemberInfo로 이동
                                      Navigator.pop(context, actionInfo);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              "${apparatus}   ",
                                              style: TextStyle(
                                                  color: Palette.gray99),
                                            ),
                                          ),
                                          // Text("${position}"),
                                          Text(
                                            "${name}",
                                            style: TextStyle(
                                                color: Palette.gray66,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Palette.gray66,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                )
                              ],
                            );
                          } else {
                            if (positionArray.contains(position)) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Palette.mainBackground,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Palette.grayEE, width: 1),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // 회원 카드 선택시 MemberInfo로 이동
                                        Navigator.pop(context, actionInfo);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: Text(
                                                "${apparatus}   ",
                                                style: TextStyle(
                                                    color: Palette.gray99),
                                              ),
                                            ),
                                            // Text("${position}"),
                                            Text(
                                              "${name}",
                                              style: TextStyle(
                                                  color: Palette.gray66,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Palette.gray66,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 10,
                                  )
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          // bottomNavigationBar: BaseBottomAppBar(),
        );
      }),
    );
  }
}
