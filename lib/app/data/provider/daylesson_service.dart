import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_project/app/data/model/globalVariables.dart';
import 'package:web_project/app/function/globalFunction.dart';

class DayLessonService extends ChangeNotifier {
  final daylessonCollection =
      FirebaseFirestore.instance.collection('daylesson');

      GlobalFunction globalFunction = GlobalFunction();
      GlobalVariables globalVariables = GlobalVariables();

  Future<QuerySnapshot> readTodaynote(
    String uid,
    String docId,
  ) async {
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .orderBy("lessonDate", descending: true)
        .orderBy("timestamp", descending: false)
        .get();
  }

  Future<QuerySnapshot> readCalSelectedNote(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    print("eawgraetgtrgdf - readCalSelectedNote - uid : ${uid}, docId : ${docId}, lessonDate : ${lessonDate}");
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isLessThanOrEqualTo: lessonDate)
        .orderBy("lessonDate", descending: true)
        .orderBy("timestamp", descending: false)
        .get();
  }

  Future<QuerySnapshot> readNotesAtFirstTime(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    print("eawgraetgtrgdf - readCalSelectedNote - uid : ${uid}, docId : ${docId}, lessonDate : ${lessonDate}");
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        // .where('lessonDate', isLessThanOrEqualTo: lessonDate)
        .orderBy("lessonDate", descending: true)
        .orderBy("timestamp", descending: false)
        .get();
  }

  Future<List> readCalSelectedDateNote(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    print("ewagerefw - readCalSelectedNote - uid : ${uid}, docId : ${docId}, lessonDate : ${lessonDate}");
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    List resultList = [];
    var dayLessonResult;

    dayLessonResult = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isEqualTo: lessonDate)
        .orderBy("timestamp", descending: false)
        .get();

        var docsALength = dayLessonResult.docs.length;
    var rstAObj = {};
    for (int i = 0; i < docsALength; i++) {
      // print( "readDateMemberComplexNote - lessonActionResult.docs[i].data() : ${lessonActionResult.docs[i].data()}");
      rstAObj = dayLessonResult.docs[i].data();
      rstAObj['id'] = dayLessonResult.docs[i].id;
      rstAObj['docId'] = dayLessonResult.docs[i]['docId'];
      rstAObj['id'] = dayLessonResult.docs[i]['id'] ?? null;
      rstAObj['lessonDate'] = dayLessonResult.docs[i]['lessonDate'];
      rstAObj['name'] = dayLessonResult.docs[i]['name'];
      rstAObj['todayNote'] = dayLessonResult.docs[i]['todayNote'];
      rstAObj['uid'] = dayLessonResult.docs[i]['uid'];
      resultList.add(rstAObj);
    }

    return resultList;
  }

  Future<List> readTodayNoteForCal(
    String uid,
    String docId,
  ) async {
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    final result = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .orderBy("lessonDate", descending: true)
        .orderBy("timestamp", descending: false)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < result.docs.length; i++) {
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;

      resultList.add(rstObj);
    }
    // 레슨 노트 consumer3 이하 무한 재빌드 문제 발생시키는 nofityListeners(); 주석 처리
    // notifyListeners();
    return resultList;
  }

  Future<List> readLessonDayNote(
    String uid,
    String memberId,
  ) async {
    final result;
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    result = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where(
          'docId',
          isEqualTo: memberId,
        )
        .orderBy('lessonDate', descending: true)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < result.docs.length; i++) {
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;

      // if (rstObj)
      resultList.add(rstObj);
      // print("[daylesson]result.docs[i].data() : ${result.docs[i].data()}");
      /* rstObj = result.docs[i].data();
          rstObj['id'] = result.docs[i].id;
          resultList.add(rstObj); */
    }
    print('[daylesson]resultList:$resultList');

    notifyListeners();

    return resultList;
  }

  Future<QuerySnapshot<Object?>>? readLessonDayNoteForFutureBuilder(
    String uid,
    String memberId,
  ) async {
    final result;
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    result = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where(
          'docId',
          isEqualTo: memberId,
        )
        .orderBy('lessonDate', descending: true)
        .get();

    notifyListeners();

    return result;
  }

  Future<List> readTodayNoteOflessonDate(
    String uid,
    String docId,
    String lessonDate,
  ) async {
    print("fdsahrebr uid : ${uid}, docId : ${docId}, lessonDate : ${lessonDate}");
    final result;
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    result = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .where('lessonDate', isEqualTo: lessonDate)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < result.docs.length; i++) {
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;

      // if (rstObj)
      resultList.add(rstObj);
      print("[daylesson]result.docs[i].data() : ${result.docs[i].data()}");
      /* rstObj = result.docs[i].data();
          rstObj['id'] = result.docs[i].id;
          resultList.add(rstObj); */
    }
    print('[daylesson]resultList:$resultList');

    notifyListeners();

    return resultList;
  }

  Future<List> readDaylessonListAtFirstTime(String uid) async {
    var result = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .orderBy('docId', descending: false)
        .orderBy('name', descending: false)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < result.docs.length; i++) {
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;

      // if (rstObj)
      resultList.add(rstObj);
      print("[daylesson]result.docs[i].data() : ${result.docs[i].data()}");
      /* rstObj = result.docs[i].data();
          rstObj['id'] = result.docs[i].id;
          resultList.add(rstObj); */
    }
    print('[daylesson]resultList:$resultList');

    notifyListeners();
    return resultList;
  }

  updateDayNote(
    String id,
    String docId,
    String lessonDate,
    String name,
    // Timestamp,
    String todayNote,
    String uid,
  ) async {
    await daylessonCollection.doc(id).update({
      'docId': docId,
      'lessonDate': lessonDate,
      'name': name,
      'timestamp': DateTime.now(),
      'todayNote': todayNote,
      'uid': uid,
    });

    notifyListeners();
  }

  creatDayNote(
    String docId,
    String lessonDate,
    String name,
    // Timestamp,
    String todayNote,
    String uid,
  ) async {
    await daylessonCollection.add({
      'docId': docId,
      'lessonDate': lessonDate,
      'name': name,
      'timestamp': DateTime.now(),
      'todayNote': todayNote,
      'uid': uid,
    });

    notifyListeners();
  }

  setLessonTodayNote(
    String id,
    String uid,
    String memberId,
    String lessonDate,
    String name,
    // Timestamp timestamp,
    String todayNote,
    // String ticketId,
    // bool isTicketUsed,
  ) {
    // Update one field, creating the document if it does not already exist.
    /* final data = {"capital": true};

    db.collection("cities").doc("BJ").set(data, SetOptions(merge: true)); */
    Map<String, dynamic> data = {
      'id': id,
      'uid': uid,
      'docId': memberId,
      'lessonDate': lessonDate,
      'name': name,
      'timestamp': DateTime.now(),
      'todayNote': todayNote,
      // 'ticketId': ticketId,
      // 'isTicketUsed': isTicketUsed,
    };
    daylessonCollection.doc(id).set(data, SetOptions(merge: true));
  }

  updateTicketUsedById(
    String id,
    bool ticketUsed,
    String usedTicketId,
  ) async {
    await daylessonCollection.doc(id).update({
      'ticketUsed': ticketUsed,
      'usedTicketId': usedTicketId,
    });

    notifyListeners();
  }

  Future<int> countTodaynote(
    String uid,
    String docId,
  ) async {
    QuerySnapshot docRaw = await daylessonCollection
        .where('uid', isEqualTo: uid)
        .where('docId', isEqualTo: docId)
        .get();
    List<DocumentSnapshot> docs = docRaw.docs;
    print('pos : ${docs.length}');
    print("uid : ${uid}");

    return docs.length;
  }

  void delete({
    required String docId,
    required Function onSuccess,
    required Function onError,
  }) async {
    // bucket 삭제
    await daylessonCollection.doc(docId).delete();
    notifyListeners();
    // 화면 갱신
    onSuccess(); // 화면 갱신
  }
}
