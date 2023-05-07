import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pie_chart/pie_chart.dart';

class CategoryDisplay extends StatefulWidget {
  const CategoryDisplay({super.key});

  @override
  State<CategoryDisplay> createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  int totExp = 0;
  int foodAmt = 0;
  int rentAmt = 0;
  int shoppingAmt = 0;
  int travelAmt = 0;
  int miscAmt = 0;
  double perFood = 0;
  double perTravel = 0;
  double perRent = 0;
  double perShopping = 0;
  double perMisc = 0;

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  final CollectionReference tnx =
      FirebaseFirestore.instance.collection("All Transactions");

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _handleRefresh() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tnx.doc(uid).collection('User Transactions').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No Data"));
            } else {
              final data = snapshot.data!.docs;
              int totExp = 0;
              int foodAmt = 0;
              int rentAmt = 0;
              int shoppingAmt = 0;
              int travelAmt = 0;
              int miscAmt = 0;
              double perFood = 0;
              double perTravel = 0;
              double perRent = 0;
              double perShopping = 0;
              double perMisc = 0;
              for (int i = 0; i < data.length; i++) {
                final txn = snapshot.data!.docs[i];
                if (txn.get("category") == "Food" &&
                    txn.get("type") == "Expense") {
                  foodAmt += int.parse(txn.get("amount"));
                  totExp += int.parse(txn.get("amount"));
                } else if (txn.get("category") == "Travel" &&
                    txn.get("type") == "Expense") {
                  travelAmt += int.parse(txn.get("amount"));
                  totExp += int.parse(txn.get("amount"));
                } else if (txn.get("category") == "Shopping" &&
                    txn.get("type") == "Expense") {
                  shoppingAmt += int.parse(txn.get("amount"));
                  totExp += int.parse(txn.get("amount"));
                } else if (txn.get("category") == "Rent" &&
                    txn.get("type") == "Expense") {
                  rentAmt += int.parse(txn.get("amount"));
                  totExp += int.parse(txn.get("amount"));
                } else if (txn.get("category") == "Misc" &&
                    txn.get("type") == "Expense") {
                  miscAmt += int.parse(txn.get("amount"));
                  totExp += int.parse(txn.get("amount"));
                }
              }
              perFood = (foodAmt / totExp) * 100;
              perTravel = (travelAmt / totExp) * 100;
              perShopping = (shoppingAmt / totExp) * 100;
              perRent = (rentAmt / totExp) * 100;
              perMisc = (miscAmt / totExp) * 100;
              print("total $totExp");
              return ListView(
                children: [
                  /*Text(
                      "Expenses in last 30 days",
                      style: GoogleFonts.lato(
                          fontSize: 32,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),*/
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 137, 137, 137),
                          blurRadius: 20.0,
                          offset: Offset(6, 6),
                        ),
                      ],
                    ),
                    child: PieChart(
                      dataMap: {
                        "Food": perFood,
                        "Travel": perTravel,
                        "Shopping": perShopping,
                        "Rent": perRent,
                        "Misc": perMisc
                      },
                    ),
                  ),
                  /*Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.food_bank_outlined,
                            color: Colors.green,
                          ),
                          Text("Food : $foodAmt")
                        ],
                      ),
                    )*/
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
