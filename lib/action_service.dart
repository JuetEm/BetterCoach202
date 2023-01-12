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
    bool isOthersApparatusSelected,
    String searchString,
  ) async {
    // 내 bucketList 가져오기
    // throw UnimplementedError(); // return 값 미구현 에러
    // uid가 현재 로그인된 유저의 uid와 일치하는 문서만 가져온다.

    List apparatus = [];
    List searchKeywordArray = [];

    print("Search Called!! : ${searchString}");

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
    if (isOthersApparatusSelected) {
      actionCollection.where('apparatus', isEqualTo: 'OT');
      apparatus.add("OT");
    }
    final result;
    if (searchString.isEmpty) {
      result = await actionCollection
          .where("apparatus",
              whereIn: apparatus.isEmpty
                  ? ["RE", "CA", "CH", "BA", "SB", "SC", "MAT", "OT"]
                  : apparatus)
          .orderBy("nGramizedLowerCaseName", descending: false)
          .get();
    } else {
      if (searchString.trim().contains(" ")) {
        searchKeywordArray = searchString.toLowerCase().split(" ");
      } else {
        searchKeywordArray.add(searchString.toLowerCase());
      }

      print("searchString : ${searchString}");
      print("searchKeyword : ${searchKeywordArray}");
      print("Search String Not Empty 울립니다! START");
      result = await actionCollection
          // .where("apparatus", whereIn: [searchString])
          .where("nGramizedLowerCaseName", arrayContains: searchString)
          .where("apparatus",
              whereIn: apparatus.isEmpty
                  ? ["RE", "CA", "CH", "BA", "SB", "SC", "MAT", "OT"]
                  : apparatus)
          // .orderBy("nGramizedLowerCaseName", descending: false)
          .orderBy("lowerCaseName", descending: false)
          .get();
      print("Search String Not Empty 울립니다! END");
    }

    print("ORDERS?!?!");
    // notifyListeners(); // 화면 갱신

    return result;
  }

  Future<List> readActionListAtFirstTime(String uid) async {
    var result = await actionCollection //.where('uid', isEqualTo: uid)
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
    String apparatus,
    String otherApparatusName,
    String position,
    String otherPositionName,
    String name,
    String author,
    String upperCaseName,
    String lowerCaseName,
  ) async {
    List<String> nGramizedLowerCaseName = [];
    nGramizedLowerCaseName = lowerCaseName.split(" ");
    print("nGramizedLowerCaseName : ${nGramizedLowerCaseName}");
    // bucket 만들기
    String id = "";
    await actionCollection.add({
      'apparatus': apparatus, // 기구 카테고리 구분자
      'otherApparatusName': otherApparatusName, // 기구명 전체
      'position': position, // 자세 구분자
      'otherPositionName': otherPositionName,
      'name': name, // 동작 이름
      'author': author, // 동작 등록인 구분자
      'upperCaseName': upperCaseName, // 대분자 동작 이름
      'lowerCaseName': lowerCaseName, // 소문자 동작 이름
      'nGramizedLowerCaseName': nGramizedLowerCaseName,
    }).then((value) {
      id = value.id;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }

  void createDummy(
    String apparatus,
    String otherApparatusName,
    String position,
    String otherPositionName,
    String name,
    String author,
    String upperCaseName,
    String lowerCaseName,
    List<String> nGramizedLowerCaseName,
  ) async {
    // bucket 만들기
    await actionCollection.add({
      'apparatus': apparatus, // 기구 카테고리 구분자
      'otherApparatusName': otherApparatusName, // 기구명 전체
      'position': position, // 자세 구분자
      'otherPositionName': otherPositionName,
      'name': name, // 동작 이름
      'author': author, // 동작 등록인 구분자
      'upperCaseName': upperCaseName, // 대분자 동작 이름
      'lowerCaseName': lowerCaseName, // 소문자 동작 이름
      'nGramizedLowerCaseName': nGramizedLowerCaseName,
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
