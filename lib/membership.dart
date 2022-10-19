import 'package:flutter/material.dart';

import 'globalWidget.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

TextEditingController membershipController = TextEditingController();

class _MembershipState extends State<Membership> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child:

            /// 신체 특이사항/체형분석 입력창
            BaseTextField(
          customController: membershipController,
          hint: "횟수입력",
          showArrow: false,
          customFunction: () {},
        ),
      ),
    );
  }
}
