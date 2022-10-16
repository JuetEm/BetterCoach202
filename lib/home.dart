import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'globalWidget.dart';
import 'main.dart';
import 'member_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100
  ];

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("투데이"),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.calendar_month),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    print('profile');
                    // 로그인 페이지로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: Icon(Icons.account_circle),
                ),
                IconButton(
                  onPressed: () {
                    _openEndDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
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
                child: FutureBuilder<QuerySnapshot>(
                    future: memberService.read(user.uid,'name'),
                    builder: (context, snapshot) {
                      final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                      if (docs.isEmpty) {
                        return Center(child: Text("수업을 준비 중입니다."));
                      }
                      return ListView.separated(
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
                          return InkWell(
                            onTap: () {
                              memberService.update(doc.id, !isActive);
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
                    }),
              ),
            ),
            bottomNavigationBar: BaseBottomAppBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('floating button');
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
