import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:web_project/member_service.dart';

import 'action_service.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';

GlobalFunction globalfunction = GlobalFunction();

class GlobalWidgetDashboard extends StatefulWidget {
  const GlobalWidgetDashboard({super.key});

  @override
  State<GlobalWidgetDashboard> createState() => _GlobalWidgetDashboardState();
}

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();
TextEditingController controller3 = TextEditingController();

FocusNode focusNode = FocusNode();

class _GlobalWidgetDashboardState extends State<GlobalWidgetDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActionService>(builder: (context, actionService, child) {
      return Scaffold(
        appBar: BaseAppBarMethod(context, "글로벌 위젯 대쉬보드", null),
        body: Column(
          children: [
            ElevatedButton(
              child: Text("DB 밀어 넣기"),
              onPressed: () async {
                // final memberService = context.read<MemberService>();
                // memberService.updateforBetaTest(docId: "0ASCDgW2VHo6ZbHQ1EWf");
                // memberService.updateforBetaTest(docId: "0u6y16vHcJ3wUEuzjV1y");
                // memberService.updateforBetaTest(docId: "2uuRVnyTqVRD1PUcZvDC");
                // memberService.updateforBetaTest(docId: "6NSTY2521sJ7Xw5V9c9R");
                // memberService.updateforBetaTest(docId: "7jqyuW7biL3CZm7vEMGC");
                // memberService.updateforBetaTest(docId: "EUFPPF7ve112Q7KRqXbh");
                // memberService.updateforBetaTest(docId: "F8ihwRErwL4H5iSGE40I");
                // memberService.updateforBetaTest(docId: "FgyjMKkVnDeJ805yxKmC");
                // memberService.updateforBetaTest(docId: "Hq7boIwfUSGTkrOOT9UZ");
                // memberService.updateforBetaTest(docId: "L23VyRg9hRqVLJTjhvZh");
                // memberService.updateforBetaTest(docId: "TdNrZUA0qrrup5cZNETn");
                // memberService.updateforBetaTest(docId: "V891QPzu3TIlzxw07LfD");
                // memberService.updateforBetaTest(docId: "fD2HfGQZo7rkzGVcOO2k");
                // memberService.updateforBetaTest(docId: "ghHbe7iH6mNtpDe2kzW5");
                // memberService.updateforBetaTest(docId: "lJRyF5IFpEi9t5p11fDp");
                // memberService.updateforBetaTest(docId: "mcZzmSNCHJc8jSBSKoRW");
                // memberService.updateforBetaTest(docId: "tFVp9KlGOHR9kS0TNInJ");
                // memberService.updateforBetaTest(docId: "up84PFQN1aHha89cfDWO");
              },
            ),
            // BaseContainer(
            //   docId : "///",
            //   name: "홍길동",
            //   registerDate: "20200202",
            //   goal: "체형관리",
            //   info: "인포입니다",
            //   note: "노트입니다",
            //   isActive: true,
            //   phoneNumber: "010-0000-1111",
            //   memberService : memberService,
            // ),
            BaseTextField(
              customController: controller1,
              customFocusNode: focusNode,
              hint: "힌트 입력",
              showArrow: true, // 화살표 보여주기
              customFunction: () {
                // 동작 DB 밀어넣기
                globalfunction.createDummy(actionService);
                Timestamp timestamp = Timestamp.now();

                print(
                    "timestamp : ${timestamp}, in one line : ${timestamp.seconds}${timestamp.nanoseconds}");
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

            /// 기구 입력창2
            BaseModalBottomSheetButton(
              bottomModalController: controller3,
              hint: "기구2",
              showButton: true,
              optionList: [
                'REFORMER',
                'CADILLAC',
                'CHAIR',
                'LADDER BARREL',
                'SPRING BOARD',
                'SPINE CORRECTOR',
                'MAT'
              ],
              customFunction: () {},
            ),
          ],
        ),
        bottomNavigationBar: BaseBottomAppBar(),
      );
    });
  }
}
