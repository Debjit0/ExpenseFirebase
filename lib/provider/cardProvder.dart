import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class cardProvider {
  final _firestore = FirebaseFirestore.instance;
  void addCard(
      {@required String? cardNo,
      @required String? name,
      @required String? exp}) async {
    CollectionReference _cardCol = _firestore.collection("All Cards");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    try {
      Map<String, dynamic> data = <String, dynamic>{
        "cardNo": cardNo,
        "exp": exp,
        "name": name,
      };

      await _cardCol.doc(uid).collection("User Cards").add(data);
    } catch (e) {
      print(e);
    }
  }
}
