import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/color.dart';
import 'package:web_project/memberList_admin.dart';

// BBZKGmz56W-GOXCUlzkRuupvFLEOZcvJpt3NCmst0ZibT8SFS-5Q4X3jxUEac3D726CV_i4mW6kCE0ldyBUykHM

var fcmToken = null;

TextEditingController pageName = TextEditingController();
TextEditingController errorContents = TextEditingController();

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
        child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Palette.grayFF),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('오류 및 개선요청', style: TextStyle(fontSize: 16)),
                  Container(
                    width: double.infinity,
                    height: 10,
                    
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Text('문제 페이지',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Palette.gray00, fontSize: 14)),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text("dropdown"),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Text('오류 및 개선요청 내용',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Palette.gray00, fontSize: 14)),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: TextFormField(
                      controller: errorContents,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: '오류가 발생한 내용 혹은 개선이 필요한 부분을 알려주세요.',
                        hintStyle: TextStyle(color: Palette.gray99),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: TextStyle(color: Palette.gray00),
                      /* validator:
                          _model.textControllerValidator.asValidator(context), */
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: AlignmentDirectional(0, -0.05),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){}, child: Text("취소")),
                        TextButton(onPressed: (){}, child: Text("제출"))
                      ],
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