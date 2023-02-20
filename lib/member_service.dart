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
        .orderBy('name', descending: false)
        .get();
  }

  Future<List> readMemberListAtFirstTime(String uid) async {
    var result = await memberCollection
        .where('uid', isEqualTo: uid)
        .orderBy('name', descending: false)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < result.docs.length; i++) {
      // print("result.docs[i].data() : ${result.docs[i].data()}");
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;
      resultList.add(rstObj);
    }
    return resultList;
  }

  Future<bool> readisActive(String uid, String docId) async {
    bool result = false;

    await memberCollection.doc(docId).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('[MS] readisActive 실행 - readisActive : ${data['isActive']}');
      result = data['isActive'];
    });

    return result;
  }

  Future<bool> readIsFavorite(String uid, String docId) async {
    bool result = false;

    await memberCollection.doc(docId).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('[MS] readisActive 실행 - readisActive : ${data['isFavorite']}');
      result = data['isFavorite'];
    });

    return result;
  }

  Future<String> create({
    required String uid,
    required String name,
    required String registerDate,
    required String phoneNumber,
    required String? registerType,
    required String? goal,
    required List<String>? selectedGoals,
    required String? bodyAnalyzed,
    required List<String>? selectedBodyAnalyzed,
    required String? medicalHistories,
    required List<String>? selectedMedicalHistories,
    required String? info,
    required String? note,
    required String? comment,
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
    var result = await memberCollection.add({
      'uid': uid, // 유저(강사) 식별자
      'name': name, // 회원 이름
      'registerDate': registerDate, // 회원 등록일
      'phoneNumber': phoneNumber, // 회원 전화번호
      'registerType': registerType, // 수강권 종류
      'goal': goal, // 운동 목표
      'selectedGoals': selectedGoals,
      'bodyanalyzed': bodyAnalyzed, // 체형 분석
      'selectedBodyAnalyzed': selectedBodyAnalyzed,
      'medicalHistories': medicalHistories, // 운동 목표
      'selectedMedicalHistories': selectedMedicalHistories,
      'info': info, // 신체 특이사항/체형분석
      'note': note, // 메모
      'comment': comment,
      'isActive': true, // 회원권 활성화 여부
    });
    print("result.id : ${result.id}");
    notifyListeners(); // 화면 갱신
    onSuccess();

    return result.id;
  }

  void update({
    required String docId,
    required String name,
    required String registerDate,
    required String phoneNumber,
    required String registerType,
    required String goal,
    required List<String>? selectedGoals,
    required String? bodyAnalyzed,
    required List<String>? selectedBodyAnalyzed,
    required String? medicalHistories,
    required List<String>? selectedMedicalHistories,
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
      'selectedGoals': selectedGoals,
      'bodyanalyzed': bodyAnalyzed, // 체형 분석
      'selectedBodyAnalyzed': selectedBodyAnalyzed,
      'medicalHistories': medicalHistories, // 운동 목표
      'selectedMedicalHistories': selectedMedicalHistories,
      'info': info, // 신체 특이사항/체형분석
      'note': note, // 메모
      'comment': comment,
      'isActive': true, // 회원권 활성화 여부
    });

    notifyListeners();
    onSuccess(); // 화면 갱신
  }

  //이건 쓰지마세요.(DB수정시 사용)
  void updateforBetaTest({
    required String docId,
  }) async {
    // 업데이트
    await memberCollection.doc(docId).update({
      'medicalHistories': "",
      'selectedBodyAnalyzed': [],
      'selectedGoals': [],
      'selectedMedicalHistories': [],
      'bodyanalyzed': "",
    });
// 화면 갱신
  }

  Future<void> updateisActive(
    String docId,
    bool isActive,
  ) async {
    // 업데이트
    await memberCollection.doc(docId).update({
      'isActive': isActive, // 회원권 활성화 여부
    });

    notifyListeners();
  }

  Future<void> updateIsFavorite(
    String docId,
    bool isFavorite,
  ) async {
    // 업데이트
    await memberCollection.doc(docId).update({
      'isFavorite': isFavorite, // 회원권 활성화 여부
    });

    notifyListeners();
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
