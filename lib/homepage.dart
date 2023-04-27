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
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference tnx =
      FirebaseFirestore.instance.collection("All Transactions");
  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 1));
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();

  List<FlSpot> getPlotPoints(entireData) {
    dataSet = [];
    entireData.forEach((key, value) {
      if (value['type'] == "Expense" &&
          (value['date'] as DateTime).month == today.month) {
        dataSet.add(FlSpot((value['date'] as DateTime).day.toDouble(),
            (value['amount'] as int).toDouble()));
      }
    });
    return dataSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Arise")),
      body: SafeArea(
          child: LiquidPullToRefresh(
              height: 200,
              animSpeedFactor: 2,
              onRefresh: _handleRefresh,
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
                      return ListView(
                        children: [
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
                                    spots: getPlotPoints(snapshot.data!),
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
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final txn = data[index];
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
                                                  deleteWallpaper(
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
                                child: Container(
                                  height: 100,
                                  color: Colors.red,
                                  child: Column(
                                    children: [Text(txn.get("amount"))],
                                  ),
                                ),
                              );
                            },
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

  void deleteWallpaper({@required String? id, @required String? uid}) async {
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
}
