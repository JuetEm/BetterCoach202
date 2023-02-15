import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DaylessonService extends ChangeNotifier {

  final daylessonCollection = FirebaseFirestore.instance.collection('daylesson');

  Future<List> readDaylessonListAtFirstTime(String uid) async {
    var result = await daylessonCollection.where('uid', isEqualTo: uid).orderBy('name', descending: false)
        .get();
    
    
    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
        for(int i=0; i<result.docs.length; i++){
          print("result.docs[i].data() : ${result.docs[i].data()}");
          /* rstObj = result.docs[i].data();
          rstObj['id'] = result.docs[i].id;
          resultList.add(rstObj); */
        }
        return resultList;
  }
}