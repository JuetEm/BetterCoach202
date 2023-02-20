import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> reportCollection =
      FirebaseFirestore.instance.collection('report');

  Future<String> create(
    String uid,
    String? name,
    String? phoneNumber,
    String? email,
    String? pageName,
    String? content,
    DateTime? dateTime,
    String? solvingStatus,
    DateTime? solvedDatetime,
  ) async {
    // report 만들기
    String id = "";
    await reportCollection.add({
      'uid': uid, // 작성자 uid
      'name': name, // 작성자 displayName
      'phoneNumber': phoneNumber, // 전화번호
      'email': email, // 이메일
      'pageName': pageName, // 페이지 명
      'content': content, // 오류/개선 보고 내용
      'dateTime': dateTime, // 등록 일시
      'solvingStatus': solvingStatus, // 해결 상태
      'solvedDatetime' : solvedDatetime, // 해결 일시
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
