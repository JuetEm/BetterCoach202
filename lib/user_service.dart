import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> actionCollection =
      FirebaseFirestore.instance.collection('user');

  void create(
    String email,
    String phonenumber,
    String gender,
    String birthdate,
    String career,
  ) async {
    // bucket 만들기
    await actionCollection.add({
      'email': email, // 강사 이메일
      'phonenumber': phonenumber, // 기구명 전체
      'gender': gender, // 자세 구분자
      'birthdate': birthdate,
      'career': career, // 동작 이름
    }).then((value) {
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신
  }
}
