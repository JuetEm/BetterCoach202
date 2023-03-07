import 'package:flutter/material.dart';
import 'package:web_project/app/data/provider/sequenceCustom_service.dart';
import 'package:web_project/app/data/repository/sequence_repository.dart';

class SequenceController {
  SequenceController();

  SequenceRepository sequenceRepository = SequenceRepository();

  
  Future<List> getRecentSequenceFromRepository(String uid, String memberId) async {
    List resultList = [];
    await sequenceRepository.getRecentSequenceFromService(uid, memberId).then((value){
      resultList.addAll(value);
    });

    return resultList;
  }

  Future<List> getRecentSequenceWithMemberIdFromRepository(String uid, String memberId) async {
    List resultList = [];
    await sequenceRepository.getRecentSequenceWithMemberIdFromService(uid, memberId).then((value){
      resultList.addAll(value);
    });

    return resultList;
  }

  Future<List> getCustomSequenceFromRepository(String uid, String memberId) async {
    List resultList = [];
    await sequenceRepository.getCustomSequenceFromService(uid, memberId).then((value){
      resultList.addAll(value);
    });

    return resultList;
  }

  Future<List> getCustomSequenceWithMemberIdFromRepository(String uid, String memberId) async {
    List resultList = [];
    await sequenceRepository.getCustomSequenceWithMemberIdFromService(uid, memberId).then((value){
      resultList.addAll(value);
    });

    return resultList;
  }
}