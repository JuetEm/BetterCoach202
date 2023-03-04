import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:web_project/main.dart';

class AnalyticLog {
  AnalyticLog();

  // GA analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // Amplitude analytics
  static Amplitude amplitude = Amplitude.getInstance();

  static Identify identify = Identify();

  Map<String, dynamic> analyticConfig(String uid) {
    amplitude.init("210de2d03268aacc063d1bda33b8275a");
    amplitude.setUserId(uid);

    Map<String, dynamic> logInstances = {};

    logInstances['firebaseAnalytics'] = analytics;

    logInstances['amplitudeAnalytics'] = amplitude;

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

    identify.set('sign_up_date', '2015-08-24');

    Amplitude.getInstance().identify(identify!);

    amplitude.trackingSessionEvents(true);

    amplitude.logEvent(EventName, eventProperties: {
      'screenName': screenName,
      'stirng': strArg,
      'testParam': testParam,
    });

    return mapInstance;
  }
}
