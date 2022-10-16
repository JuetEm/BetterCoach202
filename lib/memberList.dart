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

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Palette.secondaryBackground,
            key: _scaffoldKey,
            appBar: MainAppBarMethod(context, "회원리스트"),
            endDrawer: Container(
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
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FutureBuilder<QuerySnapshot>(
                        future: memberService.read(user.uid, 'name'),
                        builder: (context, snapshot) {
                          final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                          if (docs.isEmpty) {
                            return Center(child: Text("회원 목록을 준비 중입니다."));
                          }
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final doc = docs[index];
                              String name = doc.get('name');
                              String registerDate = doc.get('registerDate');
                              String phoneNumber = doc.get('phoneNumber');
                              String registerType = doc.get('registerType');
                              String goal = doc.get('goal');
                              String info = doc.get('info');
                              String note = doc.get('note');
                              bool isActive = doc.get('isActive');
                              final UserInfo userInfo = UserInfo(
                                user.uid,
                                name,
                                registerDate,
                                phoneNumber,
                                registerType,
                                goal,
                                info,
                                note,
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
                                    name: name,
                                    registerDate: registerDate,
                                    goal: goal,
                                    info: info,
                                    note: note,
                                    phoneNumber: phoneNumber,
                                    isActive: isActive),
                              );
                            },
                            separatorBuilder: ((context, index) => Divider()),
                          );
                        },
                      ),
                    ),

                    /// 추가 버튼
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Palette.buttonOrange,
                        ),
                        height: 60,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "회원추가",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        print("회원추가");
                        // 저장하기 성공시 Home로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MemberAdd()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BaseBottomAppBar(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     print('floating button');
            //   },
            //   backgroundColor: Colors.blue,
            //   child: const Icon(Icons.add),
            // ),
          ),
        );
      },
    );
  }
}
