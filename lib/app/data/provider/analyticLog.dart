import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:web_project/main.dart';

class AnalyticLog {
  AnalyticLog();

  // GA analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // Amplitude analytics
  late Amplitude amplitude;

  static Identify identify = Identify();

  Future<Map<String, dynamic>> analyticConfig(String? uid) async {
    Map<String, dynamic> logInstances = {};

    logInstances['firebaseAnalytics'] = analytics;
    if (kIsWeb) {
      /// 웹 앱으로 빌드하는 경우 Amplitude 인스턴스 생성하지 않는다.
      /// Amplitude 관련 에러인 듯,
      /// 웹의 경우 Amplitude가 어떻게 관리하는지 확인 필요함
    } else {
      amplitude = Amplitude.getInstance(instanceName: "BetterCoach");
      amplitude.init("210de2d03268aacc063d1bda33b8275a");
      uid != null ? amplitude.setUserId(uid) : null;

      logInstances['amplitudeAnalytics'] = amplitude;
    }
    return logInstances;
  }

  sendAnalyticsEvent(String screenName, String EventName, String strArg,
      String testParam) async {
    Map<String, dynamic> mapInstance = {};

    // 화면 이름
    analytics.setCurrentScreen(screenName: screenName);
    // 이벤트 이름
    analytics.logEvent(name: EventName, parameters: <String, dynamic>{
      'stirng': strArg,
      'testParam': testParam
    });

    if (kIsWeb) {
      /// 웹 앱으로 빌드하는 경우 Amplitude 인스턴스 생성하지 않는다.
      /// Amplitude 관련 에러인 듯,
      /// 웹의 경우 Amplitude가 어떻게 관리하는지 확인 필요함
    } else {
      identify.set('sign_up_date', '2015-08-24');

      Amplitude.getInstance().identify(identify!);

      amplitude.trackingSessionEvents(true);

      amplitude.logEvent(EventName, eventProperties: {
        'screenName': screenName,
        'stirng': strArg,
        'testParam': testParam,
      });
    }

    return mapInstance;
  }
}
