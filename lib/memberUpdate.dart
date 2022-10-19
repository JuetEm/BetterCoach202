import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberInfo.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'membershipList.dart';
import 'userInfo.dart';

GlobalFunction globalFunction = GlobalFunction();

class MemberUpdate extends StatefulWidget {
  const MemberUpdate({super.key});

  @override
  State<MemberUpdate> createState() => _MemberUpdateState();
}

class _MemberUpdateState extends State<MemberUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController registerDateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController registerTypeController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;
    nameController.text = userInfo.name;
    registerDateController.text = userInfo.registerDate;
    phoneNumberController.text = userInfo.phoneNumber;
    registerTypeController.text = userInfo.registerType;
    goalController.text = userInfo.goal;
    infoController.text = userInfo.info;
    noteController.text = userInfo.note;

    String imgUrl =
        "https://newsimg.hankookilbo.com/cms/articlerelease/2021/01/07/0de90f3e-d3fa-452e-a471-aa0bec4a1252.jpg";
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "회원 추가", () {
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
              noteController
            ]);
          }),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                /// 입력창
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SizedBox(
                        //   height: 200,
                        //   width: 200,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(100),
                        //     child: Image.network(
                        //       imgUrl,
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),

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

                        /// 등록횟수입력창
                        BaseTextField(
                          customController: registerTypeController,
                          hint: "등록횟수입력",
                          showArrow: true,
                          customFunction: () {
                            _getMembership(context);
                          },
                        ),

                        /// 운동목표 입력창
                        BaseTextField(
                          customController: goalController,
                          hint: "운동목표",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 신체 특이사항/체형분석 입력창
                        BaseTextField(
                          customController: infoController,
                          hint: "통증/상해/병력",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 체형분석 입력창
                        BaseTextField(
                          customController: noteController,
                          hint: "체형분석",
                          showArrow: false,
                          customFunction: () {},
                        ),
                        Divider(height: 1),

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
                          onPressed: () {
                            //print("${userInfo.mid}");
                            // create bucket

                            if (globalFunction.textNullCheck(
                                    context, nameController, "이름") &&
                                globalFunction.textNullCheck(
                                    context, registerDateController, "등록일") &&
                                globalFunction.textNullCheck(
                                    context, phoneNumberController, "전화번호") &&
                                globalFunction.textNullCheck(
                                    context, registerTypeController, "등록횟수입력") &&
                                globalFunction.textNullCheck(
                                    context, goalController, "운동목표") &&
                                globalFunction.textNullCheck(
                                    context, infoController, "통증/상해/병력") &&
                                globalFunction.textNullCheck(
                                    context, noteController, "체형분석")) {
                              memberService.update(
                                  docId: userInfo.docId,
                                  name: nameController.text,
                                  registerDate: registerDateController.text,
                                  phoneNumber: phoneNumberController.text,
                                  registerType: registerTypeController.text,
                                  goal: goalController.text,
                                  info: infoController.text,
                                  note: noteController.text,
                                  uid: user.uid,
                                  onSuccess: () {
                                    // 저장하기 성공
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("저장하기 성공"),
                                    ));

                                    //userinfoupdate.mid = nameController.text;

                                    //List<UserInfo> userupdateInfo
                                    UserInfo userInfouUpdate = new UserInfo(
                                        userInfo.docId,
                                        userInfo.uid,
                                        nameController.text,
                                        registerDateController.text,
                                        phoneNumberController.text,
                                        registerTypeController.text,
                                        goalController.text,
                                        infoController.text,
                                        noteController.text,
                                        true);

                                    // 저장하기 성공시 MemberInfo로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberInfo(),
                                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                        settings: RouteSettings(
                                          arguments: userInfouUpdate,
                                        ),
                                      ),
                                    );

                                    globalFunction.clearTextEditController([
                                      nameController,
                                      registerDateController,
                                      phoneNumberController,
                                      registerTypeController,
                                      goalController,
                                      infoController,
                                      noteController
                                    ]);
                                  },
                                  onError: () {
                                    print("저장하기 ERROR");
                                  });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("항목을 모두 입력해주세요."),
                              ));
                            }
                          },
                        ),

                        SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Palette.buttonOrange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("삭제하기", style: TextStyle(fontSize: 18)),
                          ),
                          onPressed: () {
                            print("${userInfo.docId}");
                            // create bucket

                            memberService.delete(
                                docId: userInfo.docId,
                                onSuccess: () {
                                  // 삭제하기 성공
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("저장하기 성공"),
                                  ));

                                  //userinfoupdate.mid = nameController.text;

                                  // 삭제하기 성공시 MemberList로 이동
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
                                    noteController
                                  ]);
                                },
                                onError: () {
                                  print("삭제하기 ERROR");
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void _getMembership(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MembershipList()),
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
