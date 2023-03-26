import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/data/provider/auth_service.dart';
import 'package:web_project/app/data/provider/deletedUser_service.dart';
import 'package:web_project/app/ui/page/confirmAlertWidget.dart';
import 'package:web_project/app/ui/widget/FaqExpansionTile.dart';
import 'package:web_project/app/ui/widget/globalWidget.dart';
import 'package:web_project/main.dart';

String screenName = "자주 묻는 질문";

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, '자주 묻는 질문', null, null, null),
      body: ListView(children: [
        /* FaqExpansionTile(
          title: '이거는 어떻게 할까요1?',
          childText: '더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요2?',
          childText: '더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요3?',
          childText: '더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요4?',
          childText: '더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ), */
        FaqExpansionTile(
          title: '탈퇴는 어떻게 하나요?',
          childText: '탈퇴를 원하시면 아래 탈퇴 버튼을 클릭해주세요. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: false,
          customFunctionOnPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ConfirmAlertWidget(
                  titleText: '정말로 계정을 탈퇴하시겠습니끼?',
                  contentText: '탈퇴된 계정은 데이터가 삭제되고 복구가 불가능합니다.',
                  confirmButtonText: '탈퇴',
                  confirmButtonColor: Palette.textRed,
                  cancelButtonColor: Palette.gray00,
                  onConfirm: () {
                    String event = "onConfirm";
                    String value = "회원탈퇴";
                    analyticLog.sendAnalyticsEvent(
                        screenName,
                        "${event} : ${value}",
                        "${value} 프로퍼티 인자1",
                        "${value} 프로퍼티 인자2");

                    /// 탈퇴버튼 클릭 시 작동할 함수
                    final deletedUserCollection =
                        context.read<DeletedUserService>();
                    final dUserDate = {
                      'uid': AuthService().currentUser()!.uid,
                      'displayName': AuthService().currentUser()!.displayName,
                      'email': AuthService().currentUser()!.email,
                      'phoneNumber': AuthService().currentUser()!.phoneNumber,
                      'photoURL': AuthService().currentUser()!.photoURL
                    };

                    deletedUserCollection
                        .logDeletedUserInfo(dUserDate)
                        .then((value) {
                      AuthService().currentUser()!.delete().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      });
                    });
                  },
                  onCancel: () {
                    /// 취소버튼 클릭 시 작동할 함수
                    Navigator.pop(context);
                  },
                );
              },
            );

            print('탈퇴버튼 is clicked.');
          },
        ),
      ]),
    );
  }
}
