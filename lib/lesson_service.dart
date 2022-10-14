import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberService extends ChangeNotifier {
  final memberCollection = FirebaseFirestore.instance.collection('lessonNote');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.
    return memberCollection.where('uid', isEqualTo: uid).get();
  }

  void create({
    required String uid, //트레이너고유아이디
    required String trainerName, //트레이너이름
    required String traineeName,
    required String tid, //회원 고유식별아이디
    required String lessonDate, //수업날짜
    required String startTime, //수업시작시간
    required String endTime, //수업마감시간
    required String title, //수업제목
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
    await memberCollection.add({
      'uid': uid, //트레이너고유아이디
      'trainerName': trainerName, //트레이너이름
      'traineeName': traineeName, //회원이름
      'tid': tid, //회원고유아이디
      'lessonDate': lessonDate, //수업날짜
      'startTime': startTime, //수업시작시간
      'endTime': endTime, //수업마감시간
      'title': title, //수업이름
      'totalNote': totalNote, //수업총메모
    });
    notifyListeners(); // 화면 갱신
    onSuccess();
  }

  void update(String docId, bool isActive) async {
    // bucket isActive 업데이트

    await memberCollection.doc(docId).update({'isActive': isActive});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // bucket 삭제
    await memberCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}
