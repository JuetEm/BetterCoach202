import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeletedUserService extends ChangeNotifier {
  final deletedUserCollection =
      FirebaseFirestore.instance.collection('deletedUser');

      Future<void> logDeletedUserInfo(Map<String, dynamic> dUserInfo) async {
        await deletedUserCollection.doc(dUserInfo['uid']).set(dUserInfo);
      }
}