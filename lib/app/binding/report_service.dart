import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> reportCollection =
      FirebaseFirestore.instance.collection('report');

  Future<String> create(
    String uid,
    String name,
    String phoneNumber,
    String email,
    String pageName,
    String content,
    String dateTime,
    String reportStatus,
    String solvedDatetime,
  ) async {
    // report 만들기
    String id = "";
    await reportCollection.add({
      'uid': uid, // 작성자 uid
      'name': name, // 기구명 전체
      'phoneNumber': phoneNumber, // 자세 구분자
      'email': email,
      'pageName': name, // 동작 이름
      'content': content, // 동작 등록인 구분자
      'dateTime': dateTime, // 대분자 동작 이름
      'reportStatus': reportStatus, // 소문자 동작 이름
      'solvedDatetime' : solvedDatetime,
    }).then((value) {
      id = value.id;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }
}
