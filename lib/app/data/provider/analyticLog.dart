

import '../../../main.dart';

class AnalyticLog {

  sendAnalyticsEvent(String screenName, String name, String strArg, String testParam) {
    // GA 로그 설정
    // 화면 이름
    MyApp.analytics.setCurrentScreen(screenName: screenName);
    // 이벤트 이름
    MyApp.analytics.logEvent(
        name: name,
        parameters: <String, dynamic>{'stirng': strArg,'testParam':testParam});
  }
}
