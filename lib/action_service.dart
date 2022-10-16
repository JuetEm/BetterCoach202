import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActionService extends ChangeNotifier {
  final actionCollection = FirebaseFirestore.instance.collection('action');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return actionCollection.where('uid', isEqualTo: uid).get();
  }

  void create(
    String apparatus,
    String position,
    String name,
    String upperCaseName,
    String lowerCaseName,
  ) async {
    // bucket 만들기
    await actionCollection.add({
      'apparatus': apparatus, // 유저 식별자
      'position': position, // 하고싶은 일
      'name': name, // 완료 여부
      'upperCaseName': upperCaseName, // 완료 여부
      'lowerCaseName': lowerCaseName, // 완료 여부
    }).then((value) {
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
    await actionCollection.doc(docId).update({'isDone': isDone});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // bucket 삭제
    await actionCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}
