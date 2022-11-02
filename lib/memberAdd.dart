import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'membershipList.dart';

GlobalFunction globalFunction = GlobalFunction();

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
TextEditingController nameController = TextEditingController();
TextEditingController registerDateController = TextEditingController(text: now);
TextEditingController phoneNumberController = TextEditingController();
TextEditingController registerTypeController = TextEditingController();
TextEditingController goalController = TextEditingController();
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
                                context, registerDateController, "등록일");
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

                        Row(
                          children: [
                            Text(
                              '운동목표',
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

                        /// 운동목표 입력창
                        BaseTextField(
                          customController: goalController,
                          hint: "운동목표",
                          showArrow: false,
                          customFunction: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// 입력창_체형분석
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
                              '체형분석',
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

                        /// 체형분석 입력창
                        BaseTextField(
                          customController: noteController,
                          hint: "체형분석",
                          showArrow: false,
                          customFunction: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                ///통증/상해/병력
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
                              '통증/상해/병력',
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

                        /// 통증/상해/병력 입력창
                        BaseTextField(
                          customController: infoController,
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
                          goal: goalController.text,
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
