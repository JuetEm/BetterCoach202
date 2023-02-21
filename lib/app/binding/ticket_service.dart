import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> ticketCollection =
      FirebaseFirestore.instance.collection('ticket');

  Future<List> read(String uid) async {
    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    var result = await ticketCollection
        .where('uid', isEqualTo: uid)
        .orderBy('name', descending: false)
        .get();

        List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
        for(int i=0; i<result.docs.length; i++){
          // print("result.docs[i].data() : ${result.docs[i].data()}");
          rstObj = result.docs[i].data();
          rstObj['id'] = result.docs[i].id;
          resultList.add(rstObj);
        }
        return resultList;
  }

  Future<String> create(
    final String uid,
    final int ticketCountLeft,
    final int ticketCountAll,
    final String ticketTitle,
    final String ticketDescription,
    final DateTime ticketStartDate,
    final DateTime ticketEndDate,
    final int ticketDateLeft,
    final DateTime createDate,
  ) async {
    // report 만들기
    String id = "";
    await ticketCollection.add({
      'uid': uid, // 작성자 uid
      'ticketCountLeft': ticketCountLeft, // 작성자 displayName
      'ticketCountAll': ticketCountAll, // 전화번호
      'ticketTitle': ticketTitle, // 이메일
      'ticketDescription': ticketDescription, // 페이지 명
      'ticketStartDate': ticketStartDate, // 오류/개선 보고 내용
      'ticketEndDate': ticketEndDate, // 등록 일시
      'ticketDateLeft': ticketDateLeft, // 해결 상태
      'createDate': createDate, // 해결 일시
    }).then((value) {
      id = value.id;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }

  void delete({
    String? docId,
    Function? onSuccess,
    Function? onError,
  }) async {
    // bucket 삭제
    await ticketCollection.doc(docId).delete();
    notifyListeners();
    // 화면 갱신
    onSuccess!(); // 성공시

    onError!(); // 에러시
  }
}
