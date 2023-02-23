import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberTicketService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> memberTicketCollection =
      FirebaseFirestore.instance.collection('memberTicket');

  Future<List> read(String uid, String docId) async {
    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    var result = await memberTicketCollection
        .where('uid', isEqualTo: uid)
        .where('docId',isEqualTo: docId)
        .orderBy('ticketTitle', descending: false)
        .get();

    List resultList = [];
    var docsLength = result.docs.length;
    var rstObj = {};
    for (int i = 0; i < docsLength; i++) {
      // print("result.docs[i].data() : ${result.docs[i].data()}");
      rstObj = result.docs[i].data();
      rstObj['id'] = result.docs[i].id;
      resultList.add(rstObj);
    }
    return resultList;
  }
}