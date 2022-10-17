import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActionService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> actionCollection =
      FirebaseFirestore.instance.collection('action');

  Future<QuerySnapshot> read(
    bool isReformerSelected,
    bool isCadillacSelected,
    bool isChairSelected,
    bool isLadderBarrelSelected,
    bool isSpringBoardSelected,
    bool isSpineCorrectorSelected,
    bool isMatSelected,
    bool isSupineSelected,
    bool isSittingSelected,
    bool isProneSelected,
    bool isKneelingSelected,
    bool isSideLyingSelected,
    bool isStandingSelected,
  ) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    List apparatus = [];

    // 기구 필터 쿼리
    if (isReformerSelected) {
      print("actionService isReformerSelected : ${isReformerSelected}");
      actionCollection.where('apparatus', isEqualTo: "RE");
      apparatus.add("RE");
    }
    if (isCadillacSelected) {
      actionCollection.where('apparatus', isEqualTo: 'CA');
      apparatus.add("CA");
    }
    if (isChairSelected) {
      actionCollection.where('apparatus', isEqualTo: 'CH');
      apparatus.add("CH");
    }
    if (isLadderBarrelSelected) {
      actionCollection.where('apparatus', isEqualTo: 'BA');
      apparatus.add("BA");
    }
    if (isSpringBoardSelected) {
      actionCollection.where('apparatus', isEqualTo: 'SB');
      apparatus.add("SB");
    }
    if (isSpineCorrectorSelected) {
      actionCollection.where('apparatus', isEqualTo: 'SC');
      apparatus.add("SC");
    }
    if (isMatSelected) {
      actionCollection.where('apparatus', isEqualTo: 'MAT');
      apparatus.add("MAT");
    }

    if (isSupineSelected) {
      actionCollection.where('position', isEqualTo: 'supine');
    }
    if (isSittingSelected) {
      actionCollection.where('position', isEqualTo: 'sitting');
    }
    if (isProneSelected) {
      actionCollection.where('position', isEqualTo: 'prone');
    }
    if (isKneelingSelected) {
      actionCollection.where('position', isEqualTo: 'kneeling');
    }
    if (isSideLyingSelected) {
      actionCollection.where('position', isEqualTo: 'side lying');
    }
    if (isStandingSelected) {
      actionCollection.where('position', isEqualTo: 'standing');
    }

    return actionCollection
        .where("apparatus",
            whereIn: apparatus.isEmpty
                ? ["RE", "CA", "CH", "BA", "SB", "SC", "MAT"]
                : apparatus)
        .get();
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
