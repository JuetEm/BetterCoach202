import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'member_service.dart';
import 'userInfo.dart';

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;
    return Consumer<MemberService>(builder: (context, memberService, child) {
      // memberService
      return Scaffold(
        appBar: BaseAppBarMethod(context, "회원 관리"),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseContainer(
                name: userInfo.name,
                registerDate: userInfo.registerDate,
                goal: userInfo.goal,
                info: userInfo.info,
                note: userInfo.note,
                phoneNumber: userInfo.phoneNumber,
                isActive: userInfo.isActive,
              ),
            ],
          ),
        ),
      );
    });
  }
}
