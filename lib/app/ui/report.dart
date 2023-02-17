import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/color.dart';
import 'package:web_project/memberList_admin.dart';

// BBZKGmz56W-GOXCUlzkRuupvFLEOZcvJpt3NCmst0ZibT8SFS-5Q4X3jxUEac3D726CV_i4mW6kCE0ldyBUykHM

var fcmToken = null;

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                print('back');
                // 로그인 페이지로 이동
                Navigator.pop(context);
              },
              color: Palette.gray33,
              // icon: Icon(Icons.account_circle),
              icon: Icon(Icons.logout),
            ),
            elevation: 0,
            backgroundColor: Palette.mainBackground,
            title: Text(
              "리포트",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                  ),
            ),
            centerTitle: true,
          ),
      body: Container(
        color: Palette.mainBackground,
        child: Center(child: Text("리포트 페이지")),
      ),
    );
  }
}