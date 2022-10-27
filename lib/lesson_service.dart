import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'globalFunction.dart';
import 'lessonDetail.dart';

Timestamp? timestamp = null;

class LessonService extends ChangeNotifier {
  final lessonCollection = FirebaseFirestore.instance.collection('lesson');
  final todaylessonCollection =
      FirebaseFirestore.instance.collection('daylesson');

  GlobalFunction globalFunction = GlobalFunction();

  void create({
    required String
        docId, // 회원 교유번호, firebase에서 생성하는 회원 (문서) 고유번호를 통해 회원 식별, 기존 전화번호르 회원 식별하는 것에서 변경
    required String uid, // 강사 고유번호
    required String name, //회원이름
    required String phoneNumber, // 회원 고유번호 (전화번호로 회원 식별) => 전화번호 식별 방식 폐기
    required String apratusName, //기구이름
    required String actionName, //동작이름
    required String lessonDate, //수업날짜
    required String grade, //수행도
    required String totalNote, //수업총메모
    int? pos,
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

    print("Create Called!!");
    if (pos == null) {
      pos = await countPos(
        uid,
        docId,
        lessonDate,
      );
      print("pos Null change : ${pos}");
    }

    print('pos : ${pos}');

    timestamp = Timestamp.now();

    await lessonCollection.add({
      'docId': docId, // 회원 고유번호, 회원(문서번호)번호로 식별
      'uid': uid, //강사 고유번호
      'name': name, //회원이름
      'phoneNumber': phoneNumber,
      'apratusName': apratusName, //기구이름
      'actionName': actionName, //동작이름
      'lessonDate': lessonDate, //수업날짜
      'grade': grade, //수행도
      'totalNote': totalNote, //수업총메모
      'timestamp': timestamp,
      'pos': pos, // 순서
    }).then((value) {
      print("value : ${value}");
      onSuccess();
    }).onError((error, stackTrace) {
      print("error : ${error}");
      onError();
    });
    notifyListeners(); // 화면 갱신
  }

  void createTodaynote({
    required String
        docId, // 회원 교유번호, firebase에서 생성하는 회원 (문서) 고유번호를 통해 회원 식별, 기존 전화번호르 회원 식별하는 것에서 변경
    required String uid, // 강사 고유번호
    required String name, //회원이름
    required String lessonDate, //수업날짜
    required String todayNote, //수업총메모

    required Function onSuccess,
    required Function onError,
  }) async {
    // 문서 만들기 set 방식 => 문서 아이디 지정 부여
    // await bucketCollection.doc("원하는 ID").set({
    //   'uid': uid, // 유저 식별자
    //   'job': job, // 하고싶은 일
    //   'isDone': false, // 완료 여부
    // });

    timestamp = Timestamp.now();

    await todaylessonCollection.add({
      'docId': docId, // 회원 고유번호, 회원(문서번호)번호로 식별
      'uid': uid, //강사 고유번호
      'name': name, //회원이름
      'lessonDate': lessonDate, //수업날짜
      'timestamp': timestamp,
      'todayNote': todayNote,
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

  Future<QuerySnapshot> readNotesOflessonDate(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return lessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isEqualTo: lessonDate)
        .orderBy("pos", descending: false)
        .get();
  }

  Future<void> updatePos(
    String docId,
    int pos,
  ) async {
    final result = await lessonCollection.doc(docId).update({
      'pos': pos,
    });
    //notifyListeners(); // 화면 갱신
  }

  Future<int> countPos(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    QuerySnapshot docRaw = await lessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isEqualTo: lessonDate)
        .orderBy("pos", descending: false)
        .get();
    List<DocumentSnapshot> docs = docRaw.docs;
    print('pos : ${docs.length}');

    return docs.length;
  }

  Future<void> update(
    String docId,
    String apratusName,
    String actionName,
    String lessonDate,
    String grade,
    String totalNote,
  ) async {
    // bucket isActive 업데이트
    print(
        "update docId : ${docId}, apratusName : ${apratusName}, lessonDate ${lessonDate}, totalNote : ${totalNote}");
    final result = await lessonCollection.doc(docId).update({
      'apratusName': apratusName,
      'actionName': actionName,
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

  void updateposition(String docId, bool isActive) async {
    // bucket isActive 업데이트

    await lessonCollection.doc(docId).update({'isActive': isActive});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // bucket 삭제
    await lessonCollection.doc(docId).delete().then((value) {
      print("delete then");
    }).onError((error, stackTrace) {
      print("delete error : ${error}");
    });
    notifyListeners(); // 화면 갱신
  }

  Future<void> deleteFromActionSelect(String uid, String docId,
      String lessonDate, String apparatusName, String actionName) async {
    QuerySnapshot docRaw = await lessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isEqualTo: lessonDate)
        .where('apratusName', isEqualTo: apparatusName)
        .where('actionName', isEqualTo: actionName)
        .get();

    String noteId = docRaw.docs.first.id;
    print(
        "noteId : ${noteId}, lessonDate : ${lessonDate}, apparatusName : ${apparatusName}, actionName : ${actionName}");
    await lessonCollection.doc(noteId).delete().then((value) {
      print("delete then");
    }).onError((error, stackTrace) {
      print("delete error : ${error}");
    });
  }
}
