import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberService extends ChangeNotifier {
  final memberCollection = FirebaseFirestore.instance.collection('member');

  Future<QuerySnapshot> read(String uid, String orderByField) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    return memberCollection
        .where('uid', isEqualTo: uid)
        //.orderBy("name", descending: true)
        .get();
  }

  void create({
    required String name,
    required String registerDate,
    required String phoneNumber,
    required String registerType,
    required String goal,
    required String info,
    required String note,
    required String uid,
    required String comment,
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
    // await memberCollection.add({
    //   'uid': uid, // 유저(강사) 식별자
    //   'name': name, // 회원 이름
    //   'registerDate': registerDate, // 회원 등록일
    //   'phoneNumber': phoneNumber, // 회원 전화번호
    //   'registerType': registerType, // 수강권 종류
    //   'goal': goal, // 운동 목표
    //   'info': info, // 신체 특이사항/체형분석
    //   'note': note, // 메모
    //   'isActive': true, // 회원권 활성화 여부
    // });
    await memberCollection.add({
      'uid': uid, // 유저(강사) 식별자
      'name': name, // 회원 이름
      'registerDate': registerDate, // 회원 등록일
      'phoneNumber': phoneNumber, // 회원 전화번호
      'registerType': registerType, // 수강권 종류
      'goal': goal, // 운동 목표
      'info': info, // 신체 특이사항/체형분석
      'note': note, // 메모
      'comment': comment,
      'isActive': true, // 회원권 활성화 여부
    });
    notifyListeners(); // 화면 갱신
    onSuccess();
  }

  void update({
    required String docId,
    required String name,
    required String registerDate,
    required String phoneNumber,
    required String registerType,
    required String goal,
    required String info,
    required String note,
    required String uid,
    required String comment,
    required Function onSuccess,
    required Function onError,
  }) async {
    // 업데이트
    await memberCollection.doc(docId).update({
      'uid': uid, // 유저(강사) 식별자
      'name': name, // 회원 이름
      'registerDate': registerDate, // 회원 등록일
      'phoneNumber': phoneNumber, // 회원 전화번호
      'registerType': registerType, // 수강권 종류
      'goal': goal, // 운동 목표
      'info': info, // 신체 특이사항/체형분석
      'note': note, // 메모
      'comment': comment,
      'isActive': true, // 회원권 활성화 여부
    });

    notifyListeners();
    onSuccess(); // 화면 갱신
  }

  void delete({
    required String docId,
    required Function onSuccess,
    required Function onError,
  }) async {
    // bucket 삭제
    await memberCollection.doc(docId).delete();
    notifyListeners();
    // 화면 갱신
    onSuccess(); // 화면 갱신
  }
}
