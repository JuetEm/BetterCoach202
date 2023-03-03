import 'package:flutter/foundation.dart';
import 'package:web_project/app/data/provider/sequenceCustom_service.dart';
import 'package:web_project/app/data/provider/sequenceRecent_service.dart';

class SequenceRepository{
  SequenceRepository();

SequenceRecentService sequenceRecentService = SequenceRecentService();
SequenceCustomService sequenceCustomService = SequenceCustomService();

  Future<List> getRecentSequenceFromService(String uid, String memberId) async{
    List resultLit = [];
    await sequenceRecentService.read(uid, memberId).then((value){
      resultLit.addAll(value);
    });

    return resultLit;
  }

  Future<List> getCustomSequenceFromService(String uid, String memberId) async {
    List resultList = [];
    await sequenceCustomService.read(uid, memberId).then((value){
      resultList.addAll(value);
    });

    return resultList;
  }
}