import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/ui/page/confirmAlertWidget.dart';
import 'package:web_project/app/ui/widget/FaqExpansionTile.dart';
import 'package:web_project/app/ui/widget/globalWidget.dart';

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
        FaqExpansionTile(
          title: '이거는 어떻게 할까요1?',
          childText: '만족을 드리지 못해 죄송합니다. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요2?',
          childText: '만족을 드리지 못해 죄송합니다. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요3?',
          childText: '만족을 드리지 못해 죄송합니다. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '이거는 어떻게 할까요4?',
          childText: '만족을 드리지 못해 죄송합니다. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
          isButtonDisabled: true,
        ),
        FaqExpansionTile(
          title: '탈퇴는 어떻게 하나요?',
          childText: '만족을 드리지 못해 죄송합니다. 더 나은 서비스를 제공하기위해 최선을 다해 노력하겠습니다.',
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
                    /// 탈퇴버튼 클릭 시 작동할 함수
                  },
                  onCancel: () {
                    /// 취소버튼 클릭 시 작동할 함수
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
