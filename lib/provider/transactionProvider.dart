import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TransactionProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addTnxDb(
      {required String? amt,
      required String? note,
      required String? date,
      required String? type}) async {
    CollectionReference _tnx = _firestore.collection("All Transactions");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      Map<String, dynamic> data = <String, dynamic>{
        "uid": uid,
        "amount": amt,
        "note": note,
        "date": date,
        "type": type,
      };
      await _tnx.doc(uid).collection("User Transactions").add(data);
    } catch (e) {
      print(e);
    }
  }
}
