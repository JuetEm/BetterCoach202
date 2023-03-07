import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/controller/sequence_controller.dart';
import 'package:web_project/app/data/provider/auth_service.dart';
import 'package:web_project/app/data/provider/sequenceCustom_service.dart';
import 'package:web_project/app/data/provider/sequenceRecent_service.dart';
import 'package:web_project/app/data/repository/sequence_repository.dart';
import 'package:web_project/app/ui/page/importSequenceFromRecent.dart';
import 'package:web_project/app/ui/page/importSequenceFromSaved.dart';
import 'package:web_project/app/ui/page/memberInfo.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/ui/widget/globalWidget.dart';

bool isPopUpValSelected = false;

SequenceController sequenceController = SequenceController();

// 최근 시퀀스 리스트
List recentSequenceList = [];
List rctSqcList = [];

// 저장된 시퀀스 리스트
List customSequenceList = [];
List ctmSqcList = [];

///
bool isMemberSequence = false;

class SequenceLibrary extends StatefulWidget {
  const SequenceLibrary({super.key});

  @override
  State<SequenceLibrary> createState() => _SequenceLibraryState();
}

class _SequenceLibraryState extends State<SequenceLibrary> {
  @override
  void initState() {
    super.initState();
    recentSequenceList = [];
  }

  @override
  void dispose() {
    recentSequenceList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BaseAppBarMethod(context, "시퀀스 보관함", () {
          Navigator.pop(context);
        },
            [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (val) {
                  print("print it damn it!!");
                  isPopUpValSelected = !isPopUpValSelected;
                  recentSequenceList = [];
                  customSequenceList = [];
                  if (this.mounted) {
                    setState(() {});
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  CheckedPopupMenuItem<String>(
                    value: "이 회뭔만 보기 발류",
                    checked: isPopUpValSelected,
                    child: Text("이 회원만 보기",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
              SizedBox(width: 10),
            ],

            /// 탭바
            TabBar(
                indicatorColor: Palette.buttonOrange,
                unselectedLabelColor: Palette.gray66,
                labelColor: Palette.textOrange,
                tabs: [
                  /// 저장된 시퀀스 탭
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '저장된 시퀀스',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  /// 최근 시퀀스 탭
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '최근 시퀀스',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ])),

        /// 바디 시작
        body: CenterConstrainedBody(
          child: TabBarView(
            children: [
              /// 저장된 시퀀스 탭 내용
              Consumer<SequenceCustomService>(
                builder: (context, sequenceCustomService, child) {
                  customSequenceList.isEmpty
                      ? (isPopUpValSelected
                          ? sequenceController
                              .getCustomSequenceWithMemberIdFromRepository(
                                  AuthService().currentUser()!.uid,
                                  userInfo.docId)
                              .then((value) {
                              customSequenceList.addAll(value);
                              print(
                                  "fdsafewgvearfdad - customSequenceList : ${customSequenceList}");
                              if (this.mounted) {
                                setState(() {});
                              }
                            })
                          : sequenceController
                              .getCustomSequenceFromRepository(
                                  AuthService().currentUser()!.uid,
                                  userInfo.docId)
                              .then((value) {
                              customSequenceList.addAll(value);
                              print(
                                  "fdsafewgvearfdad - customSequenceList : ${customSequenceList}");
                              if (this.mounted) {
                                setState(() {});
                              }
                            }))
                      : null;
                  return Container(
                    width: double.infinity,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: customSequenceList.length,
                      itemBuilder: (context, index) {
                        List actionList =
                            customSequenceList[index]['actionList'];
                        int actionListlength = actionList.length;
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImportSequenceFromSaved(
                                      actionList: customSequenceList[index]
                                          ['actionList'])),
                            ).then((value) {});
                          },
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                          tileColor: Palette.mainBackground,
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Palette.gray99, width: 1)),
                                child: Text(
                                  '${actionListlength}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 320),
                                  width:
                                      MediaQuery.of(context).size.width - 112,
                                  child: Text(customSequenceList[index]
                                      ['sequenceTitle'])),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              /// 최근 시퀀스 탭 내용
              Consumer<SequenceRecentService>(
                  builder: (context, sequenceRecentService, child) {
                recentSequenceList.isEmpty
                    ? (isPopUpValSelected
                        ? sequenceController
                            .getRecentSequenceWithMemberIdFromRepository(
                                AuthService().currentUser()!.uid,
                                userInfo.docId)
                            .then((value) {
                            print("value : ${value.length}");
                            recentSequenceList.addAll(value);
                            if (this.mounted) {
                              setState(() {});
                            }
                          })
                        : sequenceController
                            .getRecentSequenceFromRepository(
                                AuthService().currentUser()!.uid,
                                userInfo.docId)
                            .then((value) {
                            print("value : ${value.length}");
                            recentSequenceList.addAll(value);
                            if (this.mounted) {
                              setState(() {});
                            }
                          }))
                    : null;
                return Container(
                  width: double.infinity,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: recentSequenceList.length,
                    itemBuilder: (context, index) {
                      List actionList = recentSequenceList[index]['actionList'];
                      int actionListLength = actionList.length;
                      print(
                          "hfduosanoirwnvioenroiger - ${recentSequenceList[index]}");
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImportSequenceFromRecent(
                                      actionList: recentSequenceList[index]
                                          ['actionList'],
                                    )),
                          ).then((value) {});
                        },
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                        tileColor: Palette.mainBackground,
                        title: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Palette.gray99, width: 1)),
                              child: Text(
                                '${actionListLength}',
                                style: TextStyle(fontSize: 12),
                                maxLines: null,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                                constraints: BoxConstraints(maxHeight: 320),
                                width: MediaQuery.of(context).size.width - 112,
                                child: Text(recentSequenceList[index]
                                    ['sequenceTitle'])),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      );
                    },
                  ),
                ); /*  */
              })
            ],
          ),
        ),
      ),
    );
  }
}
