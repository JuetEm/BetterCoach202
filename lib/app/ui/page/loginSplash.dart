import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/ui/lang/uiTextKor.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/main.dart';

String screenName = "로그인 스플래쉬 스크린";

class LoginSplash extends StatefulWidget {
  const LoginSplash({super.key});

  @override
  State<LoginSplash> createState() => _LoginSplashState();
}

class _LoginSplashState extends State<LoginSplash> {
  @override
  void initState() {
    super.initState();
    analyticLog.sendAnalyticsEvent(screenName, "로그인_스플레쉬_INIT_체험하기",
        "로그인 스플래쉬 INIT 테스트 스트링", "로그인 스플래쉬 INIT 테스트 파라미터");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    analyticLog.sendAnalyticsEvent(screenName, "로그인_스플레쉬_DISPOSE_체험하기",
        "로그인 스플래쉬 DISPOSE 테스트 스트링", "로그인 스플래쉬 DISPOSE 테스트 파라미터");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayFF,
      // 디자인적 요소 더하기 위해 appBar 제거
      // appBar: BaseAppBarMethod(context, "로그인", null),
      body: CenterConstrainedBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 현재 유저 로그인 상태
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120),
                    SizedBox(
                      height: 100,
                      child: Image.asset("assets/images/logo.png", width: 230),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      child: Column(
                        children: [
                          Text(
                            // "필라테스 강사를 위한 레슨 기록 솔루션"
                            UiTextKor.loginSplash_appInfo,
                            style: TextStyle(
                                fontSize: 16,
                                color: Palette.textOrange,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            // "로그인 중입니다."
                            UiTextKor.loginSplash_logInInfo,
                            style: TextStyle(
                                fontSize: 16,
                                color: Palette.textOrange,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              CircularProgressIndicator(
                color: Palette.buttonOrange,
              ),

              SizedBox(height: 100),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

showLoginSplash(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginSplash(),
    ),
  );
}
