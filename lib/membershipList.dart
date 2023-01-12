import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'color.dart';
import 'globalWidget.dart';

class MembershipList extends StatefulWidget {
  const MembershipList({super.key, required String lessonCount});

  @override
  State<MembershipList> createState() => _MembershipListState();
}

TextEditingController membershipController = TextEditingController();

FocusNode memberShipFocusNode = FocusNode();

class _MembershipListState extends State<MembershipList> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Scaffold(
        appBar: BaseAppBarMethod(context, "수강횟수", null),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BaseTextField(
                customController: membershipController,
                customFocusNode: memberShipFocusNode,
                hint: "횟수입력",
                showArrow: false,
                customFunction: () {},
              ),

              SizedBox(height: 10),

              /// 수강권 선택 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 0,
                  backgroundColor: Palette.buttonOrange,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
                  child: Text("확인", style: TextStyle(fontSize: 16)),
                ),
                onPressed: () {
                  print("확인 버튼");
                  // create bucket
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("횟수 입력 성공"),
                  ));
                  // 저장하기 성공시 Home로 이동
                  Navigator.pop(context, membershipController.text);
                  membershipController.text = "";
                },
              )
            ],
          ),
        ));
  }
}
