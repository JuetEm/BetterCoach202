import 'package:flutter/material.dart';
import 'package:web_project/color.dart';
import 'home.dart';
import 'main.dart';
import 'memberList.dart';

import 'search.dart';
import 'color.dart';

AppBar BaseAppBarMethod(BuildContext context, String pageName) {
  return AppBar(
    elevation: 1,
    backgroundColor: Palette.mainBackground,
    title: Text(
      pageName,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Palette.gray33,
          ),
    ),
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Palette.gray33,
      icon: Icon(Icons.arrow_back_ios),
    ),
  );
}

AppBar MainAppBarMethod(BuildContext context, String pageName) {
  return AppBar(
    elevation: 1,
    backgroundColor: Palette.mainBackground,
    title: Text(
      pageName,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Palette.gray33,
          ),
    ),
    centerTitle: true,
    // leading: IconButton(
    //   onPressed: () {},
    //   icon: Icon(Icons.calendar_month),
    // ),
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
        color: Palette.gray33,
        icon: Icon(Icons.account_circle),
      ),
      // IconButton(
      //   onPressed: () {
      //     _openEndDrawer();
      //   },
      //   icon: Icon(Icons.menu),
      // ),
    ],
  );
}

class BaseBottomAppBar extends StatefulWidget {
  const BaseBottomAppBar({super.key});

  @override
  State<BaseBottomAppBar> createState() => _BaseBottomAppBarState();
}

class _BaseBottomAppBarState extends State<BaseBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: IconTheme(
        data: IconThemeData(color: Palette.gray66),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  print('MEMBERS');
                  // 회원목록 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberList()),
                  );
                },
                icon: Icon(Icons.contacts_outlined),
                tooltip: 'MEMBERS',
              ),
              //Spacer(),
              IconButton(
                onPressed: () {
                  print('note_add');
                  // 홈 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                icon: Icon(Icons.home_outlined),
                tooltip: 'Add Class',
              ),
              //Spacer(),
              IconButton(
                onPressed: () {
                  print('search');
                  // 서치 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search()),
                  );
                },
                icon: Icon(Icons.search),
                tooltip: 'Search',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseTextField extends StatefulWidget {
  const BaseTextField({
    Key? key,
    required this.customController,
    required this.hint,
    required this.showArrow,
    required this.customFunction,
  }) : super(key: key);

  final TextEditingController customController;
  final String hint;
  final showArrow;
  final Function customFunction;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: TextField(
        readOnly: widget.showArrow,
        controller: widget.customController,
        decoration: InputDecoration(
            suffixIcon: widget.showArrow
                ? IconButton(
                    onPressed: () {
                      widget.customFunction();
                    },
                    icon: Icon(Icons.navigate_next),
                  )
                : null,
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white),
      ),
    );
  }
}

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.customController,
    required this.hint,
    required this.width,
    required this.height,
    required this.customFunction,
    required this.isSecure,
  }) : super(key: key);

  final TextEditingController customController;
  final String hint;
  final double width;
  final double height;
  final bool isSecure;
  final Function customFunction;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = new FocusNode();
    Color focusColor = Palette.buttonOrange;
    Color normalColor = Palette.gray66;

    return TextField(
      controller: widget.customController,
      obscureText: widget.isSecure, // 비밀번호여부
      style: TextStyle(color: normalColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: Palette.grayFA,
        border: OutlineInputBorder(),
        labelText: widget.hint,
        labelStyle:
            TextStyle(color: myFocusNode.hasFocus ? focusColor : normalColor),
        focusColor: focusColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusColor, width: 2.0),
        ),
      ),
    );
  }
}

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    Key? key,
    required this.name,
    required this.registerDate,
    required this.goal,
    required this.info,
    required this.note,
    required this.isActive,
    required this.phoneNumber,
  }) : super(key: key);

  final String name;
  final String registerDate;
  final String goal;
  final String info;
  final String note;
  final String phoneNumber;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    String nameFirst = ' ';
    if (name.length > 0) {
      nameFirst = name.substring(0, 1);
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Palette.grayEE,
                  // backgroundImage: NetworkImage(
                  //     'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80'),
                  child: Text(
                    nameFirst,
                    //name == null ? "N" : name.substring(0, 1),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.gray33),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원이름 : ${name}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '등록 : ${registerDate}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionContainer extends StatelessWidget {
  const ActionContainer({
    Key? key,
    required this.apratusName,
    required this.actionName,
    required this.lessonDate,
    required this.grade,
    required this.totalNote,
  }) : super(key: key);

  final String apratusName;
  final String actionName;
  final String lessonDate;
  final String grade;
  final String totalNote;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              apratusName,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 15.0),
            Text(
              actionName,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
