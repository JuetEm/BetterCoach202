import 'package:flutter/material.dart';
import 'home.dart';
import 'memberList.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    required this.appBar,
    required this.title,
    required this.center,
  }) : super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _BaseAppBarState extends State<BaseAppBar> {
  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: widget.center,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.calendar_month),
      ),
      actions: [
        IconButton(
          onPressed: () {
            print('profile');
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
    );
  }
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
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
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
                icon: Icon(Icons.contacts),
                tooltip: 'MEMBERS',
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  print('note_add');
                  // 홈 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                icon: Icon(Icons.note_add),
                tooltip: 'Add Class',
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  print('search');
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
  }) : super(key: key);

  final TextEditingController customController;
  final String hint;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  Widget build(BuildContext context) {
    return

        /// 이름 입력창
        Expanded(
      child: TextField(
        controller: widget.customController,
        decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white),
      ),
    );
  }
}
