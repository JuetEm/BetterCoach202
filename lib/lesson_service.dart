import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'globalFunction.dart';
import 'lessonDetail.dart';

Timestamp? timestamp = null;

class LessonService extends ChangeNotifier {
  final lessonCollection = FirebaseFirestore.instance.collection('lesson');

  GlobalFunction globalFunction = GlobalFunction();

  void create({
    required String
        docId, // 회원 교유번호, firebase에서 생성하는 회원 (문서) 고유번호를 통해 회원 식별, 기존 전화번호르 회원 식별하는 것에서 변경
    required String uid, // 강사 고유번호
    required String name, //회원이름
    required String phoneNumber, // 회원 고유번호 (전화번호로 회원 식별)
    required String apratusName, //기구이름
    required String actionName, //동작이름
    required String lessonDate, //수업날짜
    required String grade, //수행도
    required String totalNote, //수업총메모

    required Function onSuccess,
    required Function onError,
  }) async {
    // 문서 만들기 set 방식 => 문서 아이디 지정 부여
    // await bucketCollection.doc("원하는 ID").set({
    //   'uid': uid, // 유저 식별자
    //   'job': job, // 하고싶은 일
    //   'isDone': false, // 완료 여부
    // });

    // 문서 만들기 add 방식 => 문서 ID를 랜덤으로 부여
    // await lessonCollection.add({
    //   'uid': uid, //강사 고유번호
    //   'name': name, //회원이름
    //   'apratusName': apratusName, //기구이름
    //   'actionName': actionName, //동작이름
    //   'lessonDate': lessonDate, //수업날짜
    //   'grade': grade, //수행도
    //   'totalNote': totalNote, //수업총메모
    // });

    timestamp = Timestamp.now();

    await lessonCollection.add({
      'docId': docId, // 회원 고유번호, 회원(문서번호)번호로 식별
      'uid': uid, //강사 고유번호
      'name': name, //회원이름
      'phoneNumber': phoneNumber, // 회원 고유번호 => 전화번호로 회원 식별 방식 제거
      'apratusName': apratusName, //기구이름
      'actionName': actionName, //동작이름
      'lessonDate': lessonDate, //수업날짜
      'grade': grade, //수행도
      'totalNote': totalNote, //수업총메모
      'timestamp': timestamp,
    });
    notifyListeners(); // 화면 갱신
    onSuccess();
  }

  Future<QuerySnapshot> read(
    String uid,
    String docId,
  ) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return lessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .get();
  }

  Future<QuerySnapshot> readNotesOfAction(
    String uid,
    String docId,
    String actionName,
  ) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return lessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('actionName', isEqualTo: actionName)
        .get();
  }

  void update(
    String docId,
    String apratusName,
    String lessonDate,
    String grade,
    String totalNote,
  ) async {
    // bucket isActive 업데이트
    print(
        "update docId : ${docId}, apratusName : ${apratusName}, lessonDate ${lessonDate}, totalNote : ${totalNote}");
    final result = await lessonCollection.doc(docId).update({
      'apratusName': apratusName,
      'lessonDate': lessonDate,
      'grade': grade,
      'totalNote': totalNote,
    });
    notifyListeners(); // 화면 갱신
  }

  void updateLesson(String docId, bool isActive) async {
    // bucket isActive 업데이트

    await lessonCollection.doc(docId).update({'isActive': isActive});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // bucket 삭제
    await lessonCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}
