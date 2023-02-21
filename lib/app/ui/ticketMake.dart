import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/userInfo.dart';

class TicketMake extends StatefulWidget {
  UserInfo? userInfo;
  TicketMake({super.key});
  TicketMake.getUserInfo(this.userInfo, {super.key});

  @override
  State<TicketMake> createState() => _TicketMakeState();
}

class _TicketMakeState extends State<TicketMake> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, "수강권 관리", () {
        Navigator.pop(context, widget.userInfo);
      },),
      body: Center(child: Container(child: Text("티켓 생성"),),),
    );
  }
}