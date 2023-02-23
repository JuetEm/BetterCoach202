import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberTicketService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> memberTicketCollection =
      FirebaseFirestore.instance.collection('memberTicket');

  
}