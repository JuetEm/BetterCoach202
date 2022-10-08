import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

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
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Better Coach"),
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
      endDrawer: SafeArea(
        child: Container(
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        },
        separatorBuilder: ((context, index) => Divider()),
      ),
      bottomNavigationBar: BottomAppBar(
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
                    print('contacts');
                  },
                  icon: Icon(Icons.contacts),
                  tooltip: 'Client List',
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    print('note_add');
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('floating button');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
