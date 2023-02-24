import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberTicketService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> memberTicketCollection =
      FirebaseFirestore.instance.collection('memberTicket');

  Future<List> read(String uid, String docId) async {
    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    var result = await memberTicketCollection
        .where('uid', isEqualTo: uid)
        .where('docId',isEqualTo: docId)
        .orderBy('ticketTitle', descending: false)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < docsLength; i++) {
      // print("result.docs[i].data() : ${result.docs[i].data()}");
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;
      resultList.add(rstObj);
    }
    return resultList;
  }

  Future<String> create(
    final String uid,
    final String docId,
    final int ticketUsingCount,
    final int ticketCountLeft,
    final int ticketCountAll,
    final String ticketTitle,
    final String ticketDescription,
    final DateTime? ticketStartDate,
    final DateTime? ticketEndDate,
    final int ticketDateLeft,
    final DateTime createDate,
  ) async {
    // report 만들기
    String id = "";
    await memberTicketCollection.add({
      'uid': uid, // 작성자 uid
      'docId': docId, // 회원 docId
      'ticketCountLeft': ticketCountLeft, // 수강권 남은 횟수
      'ticketUsingCount': ticketUsingCount, // 수강권 사용 횟수
      'ticketCountAll': ticketCountAll, // 수강권 총 횟수
      'ticketTitle': ticketTitle, // 수강권 명
      'ticketDescription': ticketDescription, // 수강권 설명
      'ticketStartDate': ticketStartDate, // 수강권 시작일
      'ticketEndDate': ticketEndDate, // 수강권 종료일
      'ticketDateLeft': ticketDateLeft, // 수강권 남은 일 수
      'createDate': createDate, // 수강권 생성일
    }).then((value) {
      id = value.id;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }

  Future<String> update(
    final String uid,
    final String docId,
    final int ticketUsingCount,
    final int ticketCountLeft,
    final int ticketCountAll,
    final String ticketTitle,
    final String ticketDescription,
    final DateTime? ticketStartDate,
    final DateTime? ticketEndDate,
    final int ticketDateLeft,
    final DateTime createDate,
  ) async {
    // report 만들기
    String id = "";
    await memberTicketCollection.doc(docId).update({
      'uid': uid, // 작성자 uid
      'docId': docId,
      'ticketCountLeft': ticketCountLeft,
      'ticketUsingCount': ticketUsingCount, // 작성자 displayName
      'ticketCountAll': ticketCountAll, // 전화번호
      'ticketTitle': ticketTitle, // 이메일
      'ticketDescription': ticketDescription, // 페이지 명
      'ticketStartDate': ticketStartDate, // 오류/개선 보고 내용
      'ticketEndDate': ticketEndDate, // 등록 일시
      'ticketDateLeft': ticketDateLeft, // 해결 상태
      'createDate': createDate, // 해결 일시
    }).then((value) {
      // id = value
      // id = docID;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return docId;
  }
}