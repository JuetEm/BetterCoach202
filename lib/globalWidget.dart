import 'package:flutter/material.dart';
import 'home.dart';
import 'memberList.dart';

import 'search.dart';

AppBar BaseAppBarMethod(BuildContext context, String pageName) {
  return AppBar(
    title: Text(pageName),
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black,
      icon: Icon(Icons.arrow_back_ios),
    ),
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
    return Expanded(
      child: Container(
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
      ),
    );
  }
}

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    Key? key,
    required this.name,
    required this.goal,
    required this.info,
    required this.note,
    required this.isActive,
  }) : super(key: key);

  final String name;
  final String goal;
  final String info;
  final String note;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8.0),
      height: 50,
      // color: Colors.amber[colorCodes[index]],
      child: Center(
        child: Text(
          'name : ${name}, goal : ${goal}, info : ${info}, note : ${note}, isActive : ${isActive}',
        ),
      ),
    );
  }
}
