import 'package:flutter/material.dart';

import 'globalWidget.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

TextEditingController membershipController = TextEditingController();

FocusNode memberShipFocusNode = FocusNode();

class _MembershipState extends State<Membership> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child:

            /// 횟수입력
            BaseTextField(
          customController: membershipController,
          customFocusNode: memberShipFocusNode,
          hint: "횟수입력",
          showArrow: false,
          customFunction: () {},
        ),
      ),
    );
  }
}
