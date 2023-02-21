import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/ui/memberList.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalFunction.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/main.dart';
import 'package:web_project/app/binding/member_service.dart';
import 'package:web_project/userInfo.dart';

GlobalFunction globalFunction = GlobalFunction();

late UserInfo? userInfo;

bool favoriteMember = true;

class TicketManage extends StatefulWidget {
  UserInfo? userInfo;
  TicketManage({super.key});
  TicketManage.getUserInfo(this.userInfo, {super.key});

  @override
  State<TicketManage> createState() => _TicketManageState();
}

class _TicketManageState extends State<TicketManage> {
  @override
  Widget build(BuildContext context) {
    userInfo = widget.userInfo;
    return Scaffold(
      backgroundColor: Palette.secondaryBackground,
      appBar: BaseAppBarMethod(context, "수강권 관리", () {
        Navigator.pop(context, userInfo);
      }),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 22, 22, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: globalFunction.readfavoriteMember(
                              userInfo!.uid, userInfo!.docId),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                            if (snapshot.hasData == false) {
                              return IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/favoriteUnselected.svg",
                                  ),
                                  iconSize: 40,
                                  onPressed: () {});
                            }

                            //error가 발생하게 될 경우 반환하게 되는 부분
                            else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }

                            // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                            else {
                              print(
                                  "[TM] 즐겨찾기 로딩후 : ${snapshot.data} / ${userInfo!.docId}");
                              favoriteMember = snapshot.data;
                              return IconButton(
                                  icon: SvgPicture.asset(
                                    favoriteMember
                                        ? "assets/icons/favoriteSelected.svg"
                                        : "assets/icons/favoriteUnselected.svg",
                                  ),
                                  iconSize: 40,
                                  onPressed: () async {
                                    favoriteMember = !favoriteMember;

                                              await memberService
                                                  .updateIsFavorite(
                                                      userInfo!.docId,
                                                      favoriteMember);
                                              int rstLnth = globalVariables
                                                  .resultList.length;
                                              for (int i = 0;
                                                  i < rstLnth;
                                                  i++) {
                                                if (userInfo!.docId ==
                                                    globalVariables
                                                        .resultList[i]['id']) {
                                                  print(
                                                      "memberInfo - widget.resultMemberList[${i}]['id'] : ${globalVariables.resultList[i]['id']}");
                                                  if(globalVariables.resultList[i]
                                                          ['isFavorite'] == null){
                                                            globalVariables.resultList[i]
                                                          ['isFavorite'] = true;
                                                  }else{
                                                    globalVariables.resultList[i]
                                                          ['isFavorite'] =
                                                      !globalVariables
                                                              .resultList[i]
                                                          ['isFavorite'];
                                                  }
                                                  
                                                  
                                                  break;
                                                }
                                              }

                                              print(
                                                  "[TM] 즐겨찾기 변경 클릭 : 변경후 - ${favoriteMember} / ${userInfo!.docId}");
                                                  setState(() {
                                                    print("ticketManage setState called!");
                                                  });
                                  });
                            }
                          }),
                      Container(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userInfo!.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${userInfo!.phoneNumber}',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  //fontWeight: FontWeight.bold,
                                  color: Palette.gray66),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '등록일',
                            style: TextStyle(
                                fontSize: 14.0,
                                //fontWeight: FontWeight.bold,
                                color: Palette.gray99),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            '${userInfo!.registerDate}',
                            style: TextStyle(
                                fontSize: 14.0,
                                //fontWeight: FontWeight.bold,
                                color: Palette.gray99),
                            textAlign: TextAlign.right,
                          ),
                          // Text(
                          //   '남은횟수 : ${userInfo.registerType}',
                          //   style: TextStyle(
                          //       fontSize: 14.0,
                          //       //fontWeight: FontWeight.bold,
                          //       color: Palette.gray99),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
