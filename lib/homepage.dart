import 'dart:math';
import 'package:expensefirebase/allexpense.dart';
import 'package:expensefirebase/allincomepage.dart';
import 'package:expensefirebase/authscreen.dart';
import 'package:expensefirebase/categorydisplay.dart';
import 'package:expensefirebase/constants/projectColors.dart';
import 'package:expensefirebase/customPie.dart';
import 'package:expensefirebase/provider/authProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensefirebase/addtnx.dart';
import 'package:expensefirebase/utils/routers.dart';
import 'package:expensefirebase/utils/showalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pie_chart/pie_chart.dart';
import 'card.dart';
import 'constants/projectColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  final CollectionReference tnx =
      FirebaseFirestore.instance.collection("All Transactions");
  Future<void> _handleRefresh() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 1));
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arise"),
        actions: [
          IconButton(
              onPressed: () {
                nextPage(page: MyCard(), context: context);
              },
              icon: Icon(Icons.credit_card_outlined)),
          IconButton(
              onPressed: () {
                nextPage(page: CategoryDisplay(), context: context);
              },
              icon: Icon(Icons.category_outlined)),
          IconButton(
              onPressed: () {
                AuthenticationProvider().signOut().then((value) {
                  nextPageOnly(page: AuthScreen(), context: context);
                });
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: SafeArea(
          child: LiquidPullToRefresh(
              height: 200,
              animSpeedFactor: 2,
              onRefresh: _handleRefresh,
              child: FutureBuilder(
                future: tnx
                    .doc(uid)
                    .collection('User Transactions')
                    .orderBy("date", descending: true)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("No data"),
                      );
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 156, 250, 255),
                                    Color.fromARGB(255, 218, 166, 255),
                                  ],
                                ),
                                color: Color.fromARGB(255, 255, 255, 255),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Color.fromARGB(255, 137, 137, 137),
                                    blurRadius: 20.0,
                                    offset: Offset(6, 6),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Balance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Rs. $totalBalance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          cardIncome(totalIncome.toString()),
                                          cardExpense(totalExpense.toString()),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200.0,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            margin: EdgeInsets.all(
                              12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              boxShadow: [
                                new BoxShadow(
                                  color: Color.fromARGB(255, 137, 137, 137),
                                  blurRadius: 20.0,
                                  offset: Offset(6, 6),
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: LineChart(
                              LineChartData(
                                //maxX: 30,
                                //minX: 1,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    // spots: getPlotPoints(snapshot.data!),
                                    spots: dataSet,
                                    isCurved: false,
                                    barWidth: 3,
                                    color: Colors.deepPurple,
                                    showingIndicators: [200, 200, 90, 10],
                                    dotData: FlDotData(
                                      show: true,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color.fromARGB(255, 201, 182, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                            child: CustomPie(
                              perFood: perFood,
                              perMisc: perMisc,
                              perRent: perRent,
                              perShopping: perShopping,
                              perTravel: perTravel,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Recent",
                              style: GoogleFonts.lato(
                                  fontSize: 32,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final txn = data[index];
                              totalBalance = 0;
                              totalIncome = 0;
                              totalExpense = 0;
                              dataSet.clear();
                              for (int i = 0; i < data.length; i++) {
                                if (data[i].get("type") == "Income") {
                                  totalBalance +=
                                      int.parse(data[i].get("amount"));
                                  totalIncome +=
                                      int.parse(data[i].get("amount"));
                                } else if (data[i].get("type") == "Expense") {
                                  totalBalance -=
                                      int.parse(data[i].get("amount"));
                                  totalExpense +=
                                      int.parse(data[i].get("amount"));
                                }

                                if (data[i].get("type") == "Expense" &&
                                    (DateTime.parse(data[i].get("date")))
                                            .month ==
                                        today.month) {
                                  dataSet.add(FlSpot(
                                      (DateTime.parse(data[i].get("date")))
                                          .day
                                          .toDouble(),
                                      (int.parse(data[i].get("amount")))
                                          .toDouble()));
                                }
                              }
                              //log(totalBalance);
                              return InkWell(
                                  onLongPress: () async {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text("Are you sure?"),
                                              content: Text(
                                                  "This record will be deleted"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel")),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteTnx(
                                                      id: snapshot
                                                          .data!.docs[index].id,
                                                      uid: uid,
                                                    );
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text("ok"),
                                                )
                                              ],
                                            ));
                                  },
                                  child: (txn.get("type") == "Income")
                                      ? incomeTile(
                                          txn.get("amount"),
                                          txn.get("note"),
                                          DateTime.parse(txn.get("date")),
                                          txn.get("type"),
                                          "Food")
                                      : expenseTile(
                                          txn.get("amount"),
                                          txn.get("note"),
                                          DateTime.parse(txn.get("date")),
                                          txn.get("type"),
                                          txn.get("category")));
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "A r i s e",
                              style: GoogleFonts.lato(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 225, 225, 225)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextPage(context: context, page: AddTnx());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void deleteTnx({@required String? id, @required String? uid}) async {
    print(uid);
    print(id);

    try {
      await FirebaseFirestore.instance
          .collection("All Transactions")
          .doc(uid)
          .collection("User Transactions")
          .doc(id)
          .delete();
      print("delete");
    } catch (e) {
      print(e);
    }
  }

  Widget cardIncome(String value) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 162, 249, 165),
          borderRadius: BorderRadius.circular(10)),
      //color: Colors.green,
      child: InkWell(
        onTap: (() {
          nextPage(page: AllIncome(), context: context);
        }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_downward,
                size: 28,
                color: Colors.green,
              ),
              margin: EdgeInsets.only(right: 8),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Income",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget cardExpense(String value) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 150, 142),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: (() {
          nextPage(page: AllExpense(), context: context);
        }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Expense",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_upward,
                size: 28,
                color: Colors.red,
              ),
              margin: EdgeInsets.only(left: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget expenseTile(
      String value, String note, DateTime date, String type, String category) {
    String formattedDate = DateFormat.yMMMd().format(date);
    return Container(
      margin: EdgeInsets.fromLTRB(8, 12, 8, 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(255, 137, 137, 137),
            blurRadius: 20.0,
            offset: Offset(6, 6),
          ),
        ],
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              if (category == "Food")
                Icon(
                  Icons.fastfood_outlined,
                  size: 28,
                  color: Colors.red,
                ),
              if (category == "Travel")
                Icon(
                  Icons.train_outlined,
                  size: 28,
                  color: Colors.red,
                ),
              if (category == "Shopping")
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 28,
                  color: Colors.red,
                ),
              if (category == "Rent")
                Icon(
                  Icons.house_outlined,
                  size: 28,
                  color: Colors.red,
                ),
              if (category == "Misc")
                Icon(
                  Icons.miscellaneous_services_outlined,
                  size: 28,
                  color: Colors.red,
                ),
              /*
              Icon(
                Icons.arrow_circle_up_rounded,
                size: 28,
                color: Colors.red,
              ),
              */
              SizedBox(
                width: 4.0,
              ),
              Text(
                "$note",
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$formattedDate",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Text(
            "-$value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget incomeTile(
      String value, String note, DateTime date, String type, String category) {
    //container
    String formattedDate = DateFormat.yMMMd().format(date);
    return Container(
      margin: EdgeInsets.fromLTRB(8, 12, 8, 12),
      padding: EdgeInsets.all(15),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_circle_down_rounded,
                size: 28,
                color: Colors.green,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "$note",
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$formattedDate",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Text(
            "+$value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
