import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';

class AllIncome extends StatefulWidget {
  const AllIncome({super.key});

  @override
  State<AllIncome> createState() => _AllIncomeState();
}

class _AllIncomeState extends State<AllIncome> {
  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 1));
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

  final CollectionReference tnx =
      FirebaseFirestore.instance.collection("All Transactions");

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Income"),
      ),
      body: SafeArea(
        child: LiquidPullToRefresh(
          child: FutureBuilder(
              future: tnx.doc(uid).collection('User Transactions').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No data"),
                    );
                  } else {
                    final data = snapshot.data!.docs;

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final txn = data[index];

                        //log(totalBalance);
                        return InkWell(
                            onLongPress: () async {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text("Are you sure?"),
                                        content:
                                            Text("This record will be deleted"),
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
                                : Container());
                      },
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          onRefresh: _handleRefresh,
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
              if (category == "Clothing")
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
