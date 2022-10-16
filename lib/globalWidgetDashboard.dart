import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'globalWidget.dart';

class GlobalWidgetDashboard extends StatefulWidget {
  const GlobalWidgetDashboard({super.key});

  @override
  State<GlobalWidgetDashboard> createState() => _GlobalWidgetDashboardState();
}

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();

class _GlobalWidgetDashboardState extends State<GlobalWidgetDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, "글로벌 위젯 대쉬보드"),
      body: Column(
        children: [
          BaseContainer(
            name: "홍길동",
            registerDate: "20200202",
            goal: "체형관리",
            info: "인포입니다",
            note: "노트입니다",
            isActive: true,
            phoneNumber: "010-0000-1111",
          ),
          BaseTextField(
            customController: controller1,
            hint: "힌트 입력",
            showArrow: true, // 화살표 보여주기
            customFunction: () {
              // 원하는 기능 구현
            },
          ),

          /// 기구 입력창
          BasePopupMenuButton(
            customController: controller2,
            hint: "기구",
            showButton: true,
            dropdownList: ['옵션1', '옵션2', '옵션3'],
            customFunction: () {},
          ),
        ],
      ),
      bottomNavigationBar: BaseBottomAppBar(),
    );
  }
}
