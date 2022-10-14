import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'globalWidget.dart';
import 'main.dart';
import 'memberAdd.dart';
import 'member_service.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _searchState();
}

class _searchState extends State<Search> {
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
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("노트보기"),
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
        child: Column(
          children: [
            // 상단 간격
            SizedBox(
              height: 20,
            ),

            /// 가로 회원리스트
            SizedBox(
              height: 100,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      UserProfileImage(
                        imageURL:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                        size: 60.0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이다인",
                        style: TextStyle(
                          fontFamily: 'Pretendard-ExtraBold',
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 세로 카드리스트
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 120.0),
                children: [
                  ...noteList.map((e) => NoteCard(note: e)),
                ],
              ),
            ),
          ],
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


class User {
  final String name;
  final String imageUrl;

  const User({
    required this.name,
    required this.imageUrl,
  });
}

class Note {
  final String date;
  final String action;
  final String note;
  final List<User> trainee;

  const Note({
    required this.date,
    required this.action,
    required this.note,
    required this.trainee,
  });
}

final List<Note> noteList = [
  Note(
    date: '10월 17일(월)',
    action: 'Roll Down',
    note: '근육 힘을 잘 조절하지 못함',
    trainee: (List<User>.from(_allUsers)..shuffle()).getRange(0, 4).toList(),
  ),
  Note(
    date: '10월 17일(월)',
    action: 'Roll Down',
    note: '근육 힘을 잘 조절하지 못함',
    trainee: (List<User>.from(_allUsers)..shuffle()).getRange(0, 4).toList(),
  ),
  Note(
    date: '10월 17일(월)',
    action: 'Roll Down',
    note: '근육 힘을 잘 조절하지 못함',
    trainee: (List<User>.from(_allUsers)..shuffle()).getRange(0, 4).toList(),
  ),
  Note(
    date: '10월 17일(월)',
    action: 'Roll Down',
    note: '근육 힘을 잘 조절하지 못함',
    trainee: (List<User>.from(_allUsers)..shuffle()).getRange(0, 4).toList(),
  ),
  Note(
    date: '10월 17일(월)',
    action: 'Roll Down',
    note: '근육 힘을 잘 조절하지 못함',
    trainee: (List<User>.from(_allUsers)..shuffle()).getRange(0, 4).toList(),
  ),
];

const List<User> _allUsers = [
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1331&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=664&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1519631128182-433895475ffe?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  User(
      name: '손석구',
      imageUrl:
          'https://images.unsplash.com/photo-1515077678510-ce3bdf418862?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjF9&auto=format&fit=crop&w=675&q=80'),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80',
  ),
  User(
    name: '손석구',
    imageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
];

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.date,
                          style: Theme.of(context).textTheme.overline!.copyWith(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '플랜',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '초보동작 익히기',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '주목할 동작',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          note.action,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UserProfileImage(
                          imageURL: note.trainee[1].imageUrl,
                          size: 48,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          note.trainee[1].name,
                          style: Theme.of(context).textTheme.overline!.copyWith(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  '수업 노트',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  note.note,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({Key? key, required this.imageURL, this.size = 48.0})
      : super(key: key);
  final String imageURL;
  final double size;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2 - size / 18),
      child: Image.network(
        imageURL,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
