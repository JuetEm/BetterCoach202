import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'member_service.dart';

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemberService>(builder: (context, memberService, child) {
      // memberService
      return Scaffold(
        appBar: BaseAppBarMethod(context, "회원 관리"),
        body: SafeArea(
          child: Column(
            children: [
              // BaseContainer(
              //     name: name,
              //     registerDate: registerDate,
              //     goal: goal,
              //     info: info,
              //     note: note,
              //     phone
              //     isActive: isActive,
              //     phoneNumber: phoneNumber)
            ],
          ),
        ),
      );
    });
  }
}
