import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensefirebase/addCard.dart';
import 'package:expensefirebase/utils/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _cardCol =
      FirebaseFirestore.instance.collection("All Cards");

  Future<void> _handleRefresh() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cards")),
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          child: FutureBuilder(
              future: _cardCol.doc(uid).collection("User Cards").get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No data"),
                    );
                  } else {
                    final data = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final _card = data[index];
                        return CreditCardWidget(
                          cardNumber: _card.get("cardNo"),
                          expiryDate: _card.get("exp"),
                          cardHolderName: _card.get("name"),
                          cvvCode: "000",
                          showBackView: false,
                          obscureCardCvv: false,
                          onCreditCardWidgetChange: (CreditCardBrand c) {},
                        );
                      },
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextPage(page: AddCard(), context: context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
