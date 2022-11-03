import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'actionSelector.dart';
import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'membershipList.dart';

final goalList = [
  "바디프로필",
  "다이어트",
  "유연성 향상",
  "자세개선",
  "운동능력 향상",
  "통증개선",
  "건강증진",
  "바디라인 개선",
  "기타",
];
List<String> selectedGoals = [];
List<Color> goalTileColorList = [];
List<Color> goalTextColorList = [];

final bodyAnalyzedList = [
  "거북목",
  "일자목",
  "라운드 숄더",
  "어깨 불균형",
  "플랫백",
  "흉추측만",
  "요추측만",
  "스웨이백",
  "척추전만",
  "척추후만",
  "골반틀어짐",
  "O 다리",
  "X 다리",
  "요족",
  "평발",
];
List<String> selelctedAnalyzedList = [];
List<Color> bodyTileColorList = [];
List<Color> bodyTextColorList = [];

final medicalHistoryList = [
  "목",
  "어깨",
  "골반",
  "팔꿈치",
  "손목",
  "허리",
  "고관절",
  "무릎",
  "발목",
  "기타"
];
List<String> selectedHistoryList = [];
List<Color> historyTileColorList = [];
List<Color> historyTextColorList = [];

GlobalFunction globalFunction = GlobalFunction();

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
TextEditingController nameController = TextEditingController();
TextEditingController registerDateController = TextEditingController(text: now);
TextEditingController phoneNumberController = TextEditingController();
TextEditingController registerTypeController = TextEditingController();
TextEditingController goalController = TextEditingController();
TextEditingController bodyAnalyzeController = TextEditingController();
TextEditingController medicalHistoryController = TextEditingController();
TextEditingController infoController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController commentController = TextEditingController();

bool keyboardOpenBefore = false;

class MemberAdd extends StatefulWidget {
  const MemberAdd({super.key});

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    // selectedGoals 값 반영하여 FilterChips 동적 생성
    var goalChips = [];
    goalChips = makeChips(goalChips, selectedGoals);

    // selelctedAnalyzedList 값 반영하여 FilterChips 동적 생성
    var bodyAnalyzedChips = [];
    bodyAnalyzedChips = makeChips(bodyAnalyzedChips, selelctedAnalyzedList);

    // medicalHistoryList 값 반영하여 FilterChips 동적 생성
    var medicalHistoriesChips = [];
    medicalHistoriesChips = makeChips(medicalHistoriesChips, selectedHistoryList);


    String imgUrl =
        "https://newsimg.hankookilbo.com/cms/articlerelease/2021/01/07/0de90f3e-d3fa-452e-a471-aa0bec4a1252.jpg";
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        // if (MediaQuery.of(context).viewInsets.bottom == 0) {
        //   if (keyboardOpenBefore) {
        //     FocusScopeNode currentFocus = FocusScope.of(context);
        //     if (!currentFocus.hasPrimaryFocus) {
        //       currentFocus.unfocus();
        //     } // 키보드 닫기 이벤트
        //     keyboardOpenBefore = false;
        //   }
        // } else {
        //   keyboardOpenBefore = true;
        // }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "회원등록", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberList(),
              ),
            );

            globalFunction.clearTextEditController([
              nameController,
              registerDateController,
              phoneNumberController,
              registerTypeController,
              goalController,
              bodyAnalyzeController,
              medicalHistoryController,
              infoController,
              noteController,
              commentController,
            ]);
            registerDateController.text = now;
          }),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                /// 압력기본정보
                Container(
                  color: Palette.mainBackground,
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '기본정보',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Palette.gray00,
                              ),
                            ),
                            Text('*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.buttonOrange,
                                ))
                          ],
                        ),

                        /// 이름 입력창
                        BaseTextField(
                          customController: nameController,
                          hint: "이름",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 등록일 입력창
                        BaseTextField(
                          customController: registerDateController,
                          hint: "등록일",
                          showArrow: true,
                          customFunction: () {
                            globalFunction.getDateFromCalendar(
                                context,
                                registerDateController,
                                "등록일",
                                registerDateController.text);
                          },
                        ),

                        /// 전화번호 입력창
                        BaseTextField(
                          customController: phoneNumberController,
                          hint: "전화번호",
                          showArrow: false,
                          customFunction: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// 입력창_수강정보
                Container(
                  color: Palette.mainBackground,
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Title

                        Row(
                          children: [
                            Text(
                              '수강정보',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Palette.gray00,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '추가',
                              style: TextStyle(
                                fontSize: 14,
                                color: Palette.gray00,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),

                        /// 등록횟수입력창
                        BaseTextField(
                          customController: registerTypeController,
                          hint: "등록횟수입력",
                          showArrow: true,
                          customFunction: () {
                            String lessonCount = registerTypeController.text;
                            _getMembership(context, lessonCount);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// 입력창_운동목표
                Container(
                  color: Palette.mainBackground,
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Title
                        /// 운동 목표
                        customGoalGridView(
                            context,
                            goalController,
                            "운동목표",
                            "목표를 선택해주세요.",
                            goalList,
                            selectedGoals,
                            goalTileColorList,
                            goalTextColorList),

                        Offstage(
                          offstage: selectedGoals.isEmpty,
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final chip in goalChips)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4.0, 0, 4, 0),
                                        child: chip,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// 운동목표 입력창
                        BaseTextField(
                          customController: goalController,
                          hint: "운동목표",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 체형분석
                        customBodyGridView(
                          context,
                          bodyAnalyzeController,
                          "체형분석",
                          "체형 특이사항을 선택해주세요.",
                          bodyAnalyzedList,
                          selelctedAnalyzedList,
                          bodyTileColorList,
                          bodyTextColorList,
                        ),

                        Offstage(
                          offstage: selelctedAnalyzedList.isEmpty,
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final chip in bodyAnalyzedChips)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4.0, 0, 4, 0),
                                        child: chip,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// 체형분석 입력창
                        BaseTextField(
                          customController: bodyAnalyzeController,
                          hint: "체형분석",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 통증/상해/병력
                        customMedicalHistoryGridView(
                            context,
                            medicalHistoryController,
                            "통증/상해",
                            "통증/상해 부위를 선택해주세요.",
                            medicalHistoryList,
                            selectedHistoryList,
                            historyTileColorList,
                            historyTextColorList),

                            Offstage(
                          offstage: selectedHistoryList.isEmpty,
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final chip in medicalHistoriesChips)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4.0, 0, 4, 0),
                                        child: chip,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// 통증/상해/병력 입력창
                        BaseTextField(
                          customController: medicalHistoryController,
                          hint: "통증/상해/병력",
                          showArrow: false,
                          customFunction: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// 입력창_특이사항
                Container(
                  color: Palette.mainBackground,
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Title

                        Row(
                          children: [
                            Text(
                              '특이사항',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Palette.gray00,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  // Bottom Sheet 함수 작성
                                },
                                icon: Icon(
                                  Icons.expand_more_outlined,
                                  color: Palette.gray66,
                                )),
                          ],
                        ),

                        /// 특이사항 입력창
                        BaseTextField(
                          customController: commentController,
                          hint: "특이사항",
                          showArrow: false,
                          customFunction: () {},
                        ),
                        Divider(height: 1),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                /// 추가 버튼
                SizedBox(height: 40),
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
                    child: Text("저장하기", style: TextStyle(fontSize: 16)),
                  ),
                  onPressed: () {
                    print("추가 버튼");
                    // create bucket
                    if (globalFunction.textNullCheck(
                        context, nameController, "이름")) {
                      // globalFunction.textNullCheck(
                      //     context, registerDateController, "등록일") &&
                      // globalFunction.textNullCheck(
                      //     context, phoneNumberController, "전화번호") &&
                      // globalFunction.textNullCheck(
                      //     context, registerTypeController, "등록횟수입력") &&
                      // globalFunction.textNullCheck(
                      //     context, goalController, "운동목표") &&
                      // globalFunction.textNullCheck(
                      //     context, infoController, "통증/상해/병력") &&
                      // globalFunction.textNullCheck(
                      //     context, noteController, "체형분석")) {
                      memberService.create(
                          name: nameController.text,
                          registerDate: registerDateController.text,
                          phoneNumber: phoneNumberController.text,
                          registerType: registerTypeController.text,
                          goal: selectedGoals.toString() +"\r\n"+ goalController.text,
                          bodyAnalyzed: selelctedAnalyzedList.toString() +"\r\n"+  bodyAnalyzeController.text,
                          medicalHistories: selectedHistoryList.toString() +"\r\n"+  medicalHistoryController.text,
                          info: infoController.text,
                          note: noteController.text,
                          comment: commentController.text,
                          uid: user.uid,
                          onSuccess: () {
                            // 저장하기 성공
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("저장하기 성공"),
                            ));
                            // 저장하기 성공시 Home로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MemberList()),
                            );

                            globalFunction.clearTextEditController([
                              nameController,
                              registerDateController,
                              phoneNumberController,
                              registerTypeController,
                              goalController,
                              bodyAnalyzeController,
                              medicalHistoryController,
                              infoController,
                              noteController,
                              commentController,
                            ]);
                            registerDateController.text = now;
                          },
                          onError: () {
                            print("저장하기 ERROR");
                          });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("항목을 모두 입력해주세요."),
                      ));
                    }
                  },
                ),

                /// 취소버튼
                SizedBox(height: 6),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        foregroundColor: Palette.gray00,
                        textStyle: TextStyle(fontWeight: FontWeight.normal)),
                    onPressed: () {
                      /// Pop 함수 입력
                    },
                    child: Text(
                      '취소하고 나가기',
                      selectionColor: Palette.gray00,
                    )),
                SizedBox(
                  height: 36,
                )
              ],
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  List<dynamic> makeChips(List<dynamic> resultChips, List<String> targetList) {
    if (targetList.isNotEmpty) {
      resultChips = targetList
          .map((e) => FilterChip(
                label: Row(
                  children: [
                    Text(e),
                    Icon(
                      Icons.close_outlined,
                      size: 14,
                      color: targetList.contains(e)
                          ? Palette.grayFF
                          : Palette.gray99,
                    )
                  ],
                ),
                onSelected: ((value) {
                  setState(() {
                    targetList.remove(e);
                  });
                  print("value : ${value}");
                }),
                selected: targetList.contains(e),
                labelStyle: TextStyle(
                    fontSize: 12,
                    color: targetList.contains(e)
                        ? Palette.grayFF
                        : Palette.gray99),
                selectedColor: Palette.buttonOrange,
                backgroundColor: Colors.transparent,
                showCheckmark: false,
                side: targetList.contains(e)
                    ? BorderSide.none
                    : BorderSide(color: Palette.grayB4),
              ))
          .toList();
    }
    return resultChips;
  }

  Row customGoalGridView(
      BuildContext context,
      TextEditingController customController,
      String bigTitle,
      String bottomSheetTitle,
      List<String> objectList,
      List<String> resultObjectList,
      List<Color> customTileColorList,
      List<Color> customTextColorList) {
    return Row(
      children: [
        Text(
          bigTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Palette.gray00,
          ),
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              // Bottom Sheet 함수 작성
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Palette.secondaryBackground,
                  context: context,
                  builder: ((context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter stateSetter) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        bottomSheetTitle,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Palette.gray66,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(
                                          "resultObjectList : ${resultObjectList}");
                                      // String goalsSum = "";
                                      // for (int i = 0;
                                      //     i < resultObjectList.length;
                                      //     i++) {
                                      //   if (i == resultObjectList.length - 1) {
                                      //     goalsSum += resultObjectList[i];
                                      //   } else {
                                      //     goalsSum +=
                                      //         resultObjectList[i] + ", ";
                                      //   }
                                      // }
                                      // customController.text = goalsSum;
                                      customTileColorList.clear();
                                      customTextColorList.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      '완료',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Palette.textBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: objectList.length,
                                itemBuilder: ((context, index) {
                                  var value = objectList[index];
                                  // stateSetter((() {
                                  //   setState(() {
                                      if (resultObjectList.contains(value)) {
                                        customTileColorList.add(Palette.buttonOrange);
                                        customTextColorList.add(Palette.grayFF);
                                        // print("언제 울리니? 1 ");
                                      } else {
                                        customTileColorList.add(Palette.grayEE);
                                        customTextColorList.add(Palette.gray00);
                                        // print("언제 울리니? 2 ");
                                      }
                                  //   });
                                  // }));

                                  // return Text(widget.optionList[index]);
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: InkWell(
                                        onTap: () {
                                          stateSetter(
                                            () {
                                              setState(() {
                                                if (resultObjectList
                                                    .contains(value)) {
                                                  customTileColorList[index] =
                                                      Palette.grayEE;
                                                  customTextColorList[index] =
                                                      Palette.gray00;
                                                  resultObjectList
                                                      .remove(value);
                                                } else {
                                                  customTileColorList[index] =
                                                      Palette.buttonOrange;
                                                  customTextColorList[index] =
                                                      Palette.grayFF;
                                                  resultObjectList.add(value);
                                                }
                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color:
                                                    customTileColorList[index]),
                                            child: Center(
                                                child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: customTextColorList[
                                                      index]),
                                            ))),
                                      ));
                                }),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 1,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  }));
            },
            icon: Icon(
              Icons.expand_more_outlined,
              color: Palette.gray66,
            )),
      ],
    );
  }

  Row customBodyGridView(
      BuildContext context,
      TextEditingController customController,
      String bigTitle,
      String bottomSheetTitle,
      List<String> objectList,
      List<String> resultObjectList,
      List<Color> customTileColorList,
      List<Color> customTextColorList) {
    return Row(
      children: [
        Text(
          bigTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Palette.gray00,
          ),
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              // Bottom Sheet 함수 작성
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Palette.secondaryBackground,
                  context: context,
                  builder: ((context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter stateSetter) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        bottomSheetTitle,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Palette.gray66,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(
                                          "resultObjectList : ${resultObjectList}");
                                      // String goalsSum = "";
                                      // for (int i = 0;
                                      //     i < resultObjectList.length;
                                      //     i++) {
                                      //   if (i == resultObjectList.length - 1) {
                                      //     goalsSum += resultObjectList[i];
                                      //   } else {
                                      //     goalsSum +=
                                      //         resultObjectList[i] + ", ";
                                      //   }
                                      // }
                                      // customController.text = goalsSum;
                                      customTileColorList.clear();
                                      customTextColorList.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      '완료',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Palette.textBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: objectList.length,
                                itemBuilder: ((context, index) {
                                  var value = objectList[index];
                                  if (resultObjectList.contains(value)) {
                                        customTileColorList.add(Palette.buttonOrange);
                                        customTextColorList.add(Palette.grayFF);
                                        // print("언제 울리니? 1 ");
                                      } else {
                                        customTileColorList.add(Palette.grayEE);
                                        customTextColorList.add(Palette.gray00);
                                        // print("언제 울리니? 2 ");
                                      }
                                  // return Text(widget.optionList[index]);
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: InkWell(
                                        onTap: () {
                                          stateSetter(
                                            () {
                                              setState(() {
                                                if (resultObjectList
                                                    .contains(value)) {
                                                  customTileColorList[index] =
                                                      Palette.grayEE;
                                                  customTextColorList[index] =
                                                      Palette.gray00;
                                                  resultObjectList
                                                      .remove(value);
                                                } else {
                                                  customTileColorList[index] =
                                                      Palette.buttonOrange;
                                                  customTextColorList[index] =
                                                      Palette.grayFF;
                                                  resultObjectList.add(value);
                                                }
                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color:
                                                    customTileColorList[index]),
                                            child: Center(
                                                child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: customTextColorList[
                                                      index]),
                                            ))),
                                      ));
                                }),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 1,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  }));
            },
            icon: Icon(
              Icons.expand_more_outlined,
              color: Palette.gray66,
            )),
      ],
    );
  }

  Row customMedicalHistoryGridView(
      BuildContext context,
      TextEditingController customController,
      String bigTitle,
      String bottomSheetTitle,
      List<String> objectList,
      List<String> resultObjectList,
      List<Color> customTileColorList,
      List<Color> customTextColorList) {
    return Row(
      children: [
        Text(
          bigTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Palette.gray00,
          ),
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              // Bottom Sheet 함수 작성
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Palette.secondaryBackground,
                  context: context,
                  builder: ((context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter stateSetter) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        bottomSheetTitle,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Palette.gray66,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(
                                          "resultObjectList : ${resultObjectList}");
                                      // String goalsSum = "";
                                      // for (int i = 0;
                                      //     i < resultObjectList.length;
                                      //     i++) {
                                      //   if (i == resultObjectList.length - 1) {
                                      //     goalsSum += resultObjectList[i];
                                      //   } else {
                                      //     goalsSum +=
                                      //         resultObjectList[i] + ", ";
                                      //   }
                                      // }
                                      // customController.text = goalsSum;
                                      customTileColorList.clear();
                                      customTextColorList.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      '완료',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Palette.textBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: objectList.length,
                                itemBuilder: ((context, index) {
                                  var value = objectList[index];
                                  if (resultObjectList.contains(value)) {
                                        customTileColorList.add(Palette.buttonOrange);
                                        customTextColorList.add(Palette.grayFF);
                                        // print("언제 울리니? 1 ");
                                      } else {
                                        customTileColorList.add(Palette.grayEE);
                                        customTextColorList.add(Palette.gray00);
                                        // print("언제 울리니? 2 ");
                                      }
                                  // return Text(widget.optionList[index]);
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: InkWell(
                                        onTap: () {
                                          stateSetter(
                                            () {
                                              setState(() {
                                                if (resultObjectList
                                                    .contains(value)) {
                                                  customTileColorList[index] =
                                                      Palette.grayEE;
                                                  customTextColorList[index] =
                                                      Palette.gray00;
                                                  resultObjectList
                                                      .remove(value);
                                                } else {
                                                  customTileColorList[index] =
                                                      Palette.buttonOrange;
                                                  customTextColorList[index] =
                                                      Palette.grayFF;
                                                  resultObjectList.add(value);
                                                }
                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color:
                                                    customTileColorList[index]),
                                            child: Center(
                                                child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: customTextColorList[
                                                      index]),
                                            ))),
                                      ));
                                }),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 1,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  }));
            },
            icon: Icon(
              Icons.expand_more_outlined,
              color: Palette.gray66,
            )),
      ],
    );
  }

  void _getMembership(BuildContext context, String lessonCount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MembershipList(
                lessonCount: lessonCount,
              )),
    );

    if (!(result == null)) {
      registerTypeController.text = result;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("선택 된 수강권 : ${result}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("수강권을 선택해주세요."),
      ));
    }
  }
}
