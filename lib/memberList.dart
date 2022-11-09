import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'color.dart';
import 'globalWidget.dart';
import 'main.dart';
import 'memberAdd.dart';
import 'memberInfo.dart';
import 'member_service.dart';
import 'userInfo.dart';

String conutMemberList = "";

String memberAddMode = "추가";

class MemberList extends StatefulWidget {
  const MemberList({super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  void _refreshMemberCount(value) {
    setState(() {
      conutMemberList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    //user.uid = '11';

    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Palette.secondaryBackground,
            key: _scaffoldKey,
            appBar: MainAppBarMethod(context, "회원목록"),
            /* endDrawer: Container(
              child: Drawer(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('This is the Drawer'),
                      ElevatedButton(
                        onPressed: () {
                          _closeEndDrawer();
                        },
                        child: const Text('Close Drawer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 로그아웃
                          context.read<AuthService>().signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: const Text('Log Out'),
                      )
                    ],
                  ),
                ),
              ),
            ), */
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '총 ${conutMemberList} 명',
                          style: TextStyle(color: Palette.gray7B),
                        ),
                        Spacer(),
                        // Text(
                        //   '최근 수업순',
                        //   style: TextStyle(color: Palette.gray7B),
                        // ),
                        // Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<QuerySnapshot>(
                        //future: memberService.read(
                        //    'w5ahp6WhpQdLgqNhA6B8afrWWeA3', 'name'),
                        future: memberService.read(user.uid, 'name'),
                        builder: (context, snapshot) {
                          final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                          if (docs.isEmpty) {
                            return Center(child: Text("회원 목록을 준비 중입니다."));
                          }

                          //해당 함수는 빌드가 끝난 다음 수행 된다.
                          //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            if (conutMemberList != docs.length.toString()) {
                              _refreshMemberCount(docs.length.toString());
                            }
                          });

                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final doc = docs[index];
                              String docId = doc.id;
                              String name = doc.get('name');
                              String registerDate = doc.get('registerDate');
                              String phoneNumber = doc.get('phoneNumber');
                              String registerType = doc.get('registerType');
                              String goal = doc.get('goal');
                              List<String> selectedGoals =
                                  List<String>.from(doc.get('selectedGoals'));
                              print(
                                  "[ML] ListView 회원정보 가져오기 selectedGoals : ${selectedGoals}");
                              String bodyAnalyzed = doc.get('bodyanalyzed');
                              print(
                                  "[ML] ListView 회원정보 가져오기 bodyAnalyzed : ${bodyAnalyzed}");
                              List<String> selectedBodyAnalyzed =
                                  List<String>.from(
                                      doc.get('selectedBodyAnalyzed'));
                              ;
                              String medicalHistories =
                                  doc.get('medicalHistories');
                              List<String> selectedMedicalHistories =
                                  List<String>.from(
                                      doc.get('selectedMedicalHistories'));
                              ;
                              String info = doc.get('info');
                              String note = doc.get('note');
                              String comment = doc.get('comment');
                              bool isActive = doc.get('isActive');

                              final UserInfo userInfo = UserInfo(
                                doc.id,
                                user.uid,
                                name,
                                registerDate,
                                phoneNumber,
                                registerType,
                                goal,
                                selectedGoals,
                                bodyAnalyzed,
                                selectedBodyAnalyzed,
                                medicalHistories,
                                selectedMedicalHistories,
                                info,
                                note,
                                comment,
                                isActive,
                              );

                              return InkWell(
                                onTap: () {
                                  // 회원 카드 선택시 MemberInfo로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MemberInfo(),
                                      // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                      settings: RouteSettings(
                                        arguments: userInfo,
                                      ),
                                    ),
                                  );
                                },
                                child: BaseContainer(
                                  docId: docId,
                                  name: name,
                                  registerDate: registerDate,
                                  goal: goal,
                                  info: info,
                                  note: note,
                                  phoneNumber: phoneNumber,
                                  isActive: isActive,
                                  memberService: memberService,
                                ),
                              );
                            },
                            separatorBuilder: ((context, index) => Divider(
                                  height: 0,
                                )),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),

                    // //추가버튼 FloatingActionbutton으로 변경
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     FloatingActionButton(
                    //       onPressed: () {
                    //         print("회원추가");
                    //         // 저장하기 성공시 Home로 이동
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (_) => MemberAdd()),
                    //         );
                    //       },
                    //       child: Icon(Icons.person_add),
                    //       backgroundColor: Palette.buttonOrange,
                    //     ),
                    //   ],
                    // ),

                    /// 추가 버튼
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     padding: EdgeInsets.all(0),
                    //     elevation: 0,
                    //     backgroundColor: Colors.transparent,
                    //     shadowColor: Colors.transparent,
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(10.0),
                    //       ),
                    //       color: Palette.buttonOrange,
                    //     ),
                    //     height: 60,
                    //     width: double.infinity,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "회원추가",
                    //           style: TextStyle(fontSize: 18),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     print("회원추가");
                    //     // 저장하기 성공시 Home로 이동
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (_) => MemberAdd()),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            //bottomNavigationBar: BaseBottomAppBar(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     print('floating button');
            //   },
            //   backgroundColor: Colors.blue,
            //   child: const Icon(Icons.add),
            // ),

            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("회원추가");
                  memberAddMode = "추가";

                  List<dynamic> args = [
                    memberAddMode,
                  ];

                  // 저장하기 성공시 Home로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberAdd(),
                      // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                      settings: RouteSettings(
                        arguments: args,
                      ),
                    ),
                  );
                },
                label: Text(
                  '회원 추가',
                  style: TextStyle(fontSize: 16, letterSpacing: -0.2),
                ),
                icon: Icon(Icons.person_add),
                backgroundColor: Palette.buttonOrange,
              ),
            ),
          ),
        );
      },
    );
  }
}
