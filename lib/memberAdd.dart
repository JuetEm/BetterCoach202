import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'globalWidget.dart';
import 'home.dart';
import 'memberList.dart';
import 'member_service.dart';

class MemberAdd extends StatefulWidget {
  const MemberAdd({super.key});

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
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
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("회원추가"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Column(
            children: [
              /// 입력창
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// 이름 입력창
                      BaseTextField(
                        customController: nameController,
                        hint: "이름",
                      ),

                      /// 등록일 입력창
                      BaseTextField(
                        customController: registerDateController,
                        hint: "등록일",
                      ),

                      /// 전화번호 입력창
                      BaseTextField(
                        customController: phoneNumberController,
                        hint: "전화번호",
                      ),

                      /// 수강권 선택 입력창
                      BaseTextField(
                        customController: registerTypeController,
                        hint: "수강권 선택",
                      ),

                      /// 목표 입력창
                      BaseTextField(
                        customController: goalController,
                        hint: "목표",
                      ),

                      /// 신체 특이사항/체형분석 입력창
                      BaseTextField(
                        customController: infoController,
                        hint: "신체 특이사항 / 체형분석",
                      ),

                      /// 메모 입력창
                      BaseTextField(
                        customController: noteController,
                        hint: "메모",
                      ),
                      Divider(height: 1),

                      /// 추가 버튼
                      ElevatedButton(
                        child: Text("저장하기", style: TextStyle(fontSize: 21)),
                        onPressed: () {
                          print("추가 버튼");
                          // create bucket
                          if (textNullCheck(nameController, "nameController") &&
                              textNullCheck(registerDateController,
                                  "registerDateController") &&
                              textNullCheck(phoneNumberController,
                                  "phoneNumberController") &&
                              textNullCheck(registerTypeController,
                                  "registerTypeController") &&
                              textNullCheck(goalController, "goalController") &&
                              textNullCheck(infoController, "infoController") &&
                              textNullCheck(noteController, "noteController")) {
                            memberService.create(
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
                                  // 저장하기 성공시 Home로 이동
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MemberList()),
                                  );
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  bool textNullCheck(
    TextEditingController checkController,
    String controllerName,
  ) {
    bool notEmpty = true;
    if (!checkController.text.isNotEmpty) {
      print("${controllerName} is Empty");
      notEmpty = !notEmpty;
    }

    return notEmpty;
  }
}
