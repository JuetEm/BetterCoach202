import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/memberTicket_service.dart';
import 'package:web_project/app/binding/ticketLibrary_service.dart';
import 'package:web_project/app/ui/memberList.dart';
import 'package:web_project/app/ui/memberTicketMake.dart';
import 'package:web_project/app/ui/ticketLibraryMake.dart';
import 'package:web_project/auth_service.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalFunction.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/main.dart';
import 'package:web_project/app/binding/member_service.dart';
import 'package:web_project/ticketWidget.dart';
import 'package:web_project/userInfo.dart';

int ticketCnt = 0; // 사용가능한 수강권 개수
int expiredTicketCnt = 0; // 만료된 수강권 개수

GlobalFunction globalFunction = GlobalFunction();

late UserInfo? userInfo;

bool favoriteMember = true;

/** 사용가능한 수강권 리스트 열렸는지 */
bool isActiveTicketListOpened = true;

/** 만료된 수강권 리스트 열렸는지 */
bool isExpiredTicketListOpened = true;

class MemberTicketManage extends StatefulWidget {
  UserInfo? userInfo;
  MemberTicketManage({super.key});
  MemberTicketManage.getUserInfo(this.userInfo, {super.key});

  @override
  State<MemberTicketManage> createState() => _MemberTicketManageState();
}

class _MemberTicketManageState extends State<MemberTicketManage> {
  
  @override
  Widget build(BuildContext context) {
    userInfo = widget.userInfo;
    return Consumer<MemberTicketService>(
      builder: (context, memberTicketService, child) {
        
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "수강권 관리", () {
            Navigator.pop(context, userInfo);
          }, null, null),
          body: SafeArea(
            child: Column(
              children: [
                /// 헤더: 회원명/전화번호/등록일
                Container(
                  padding: EdgeInsets.all(15),
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

                                    await memberService.updateIsFavorite(
                                        userInfo!.docId, favoriteMember);
                                    int rstLnth =
                                        globalVariables.resultList.length;
                                    for (int i = 0; i < rstLnth; i++) {
                                      if (userInfo!.docId ==
                                          globalVariables.resultList[i]['id']) {
                                        print(
                                            "memberInfo - widget.resultMemberList[${i}]['id'] : ${globalVariables.resultList[i]['id']}");
                                        if (globalVariables.resultList[i]
                                                ['isFavorite'] ==
                                            null) {
                                          globalVariables.resultList[i]
                                              ['isFavorite'] = true;
                                        } else {
                                          globalVariables.resultList[i]
                                                  ['isFavorite'] =
                                              !globalVariables.resultList[i]
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

                      // 이름, 전화번호
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
                      // 등록일
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
                // 수강권 추가 버튼
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  color: Palette.mainBackground,
                  child: TextButton(
                    onPressed: () async {
                      var result = await // 저장하기 성공시 Home로 이동
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MemberTicketMake.getUserInfo(userInfo)),
                      ).then((value) {
                        print("수강권 추가 result");
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Palette.gray99, width: 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "수강권 추가하기",
                            style:
                                TextStyle(fontSize: 16, color: Palette.gray66),
                          ),
                          Icon(
                            Icons.add_circle_outline,
                            color: Palette.gray66,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 수강권 리스트 영역 시작
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 700),
                      color: Palette.mainBackground,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 사용 가능한 수강권 리스트

                          ////// 타이틀 + Expand 버튼
                          InkWell(
                            onTap: () {
                              /// 리스트 오픈 토글
                              isActiveTicketListOpened =
                                  !isActiveTicketListOpened;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "사용 가능한 수강권(${expiredTicketCnt})",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.gray66,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  isActiveTicketListOpened
                                      ? Icons.expand_more
                                      : Icons.expand_less,
                                )
                              ],
                            ),
                          ),

                          ////// 사용 가능한 수강권 리스트

                          Offstage(
                            offstage: isActiveTicketListOpened,
                            child: Container(
                              height: 100,
                              color: Palette.backgroundBlue,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: globalVariables.memberTicketList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        print("globalVariables.memberTicketList : ${globalVariables.memberTicketList}");
                                        if(globalVariables.memberTicketList[index]['id'] == userInfo!.docId){
                                          return TicketWidget(customFunctionOnTap: (){}, ticketCountLeft: globalVariables.memberTicketList[index]['ticketCountLeft'], ticketCountAll: globalVariables.memberTicketList[index]['ticketCountAll'], ticketTitle: globalVariables.memberTicketList[index]['ticketTitle'], ticketDescription: globalVariables.memberTicketList[index]['ticketDescription'], ticketStartDate: globalVariables.memberTicketList[index]['ticketStartDate'], ticketEndDate: globalVariables.memberTicketList[index]['ticketEndDate'], ticketDateLeft: globalVariables.memberTicketList[index]['ticketDateLeft']);
                                        }else{
                                    return null;

                                        }
                                  }),
                            ),
                          ),

                          /// 만료된 수강권 리스트

                          /// /// 타이틀 + Expand버튼
                          InkWell(
                            onTap: () {
                              /// 리스트 오픈 토글
                              isExpiredTicketListOpened =
                                  !isExpiredTicketListOpened;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "만료된 수강권(${ticketCnt})",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.gray66,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  isExpiredTicketListOpened
                                      ? Icons.expand_more
                                      : Icons.expand_less,
                                )
                              ],
                            ),
                          ),

                          ////// 만료된 수강권 리스트
                          Offstage(
                            offstage: isExpiredTicketListOpened,
                            child: Container(
                                width: double.infinity,
                                height: 100,
                                color: Palette.backgroundBlue,
                                child: Text('만료된 수강권 리스트')),
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
      },
    );
  }
}
