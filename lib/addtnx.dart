import 'dart:math';

import 'package:expensefirebase/homepage.dart';
import 'package:expensefirebase/utils/routers.dart';
import 'package:flutter/material.dart';
import './provider/transactionProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AddTnx extends StatefulWidget {
  const AddTnx({super.key});

  @override
  State<AddTnx> createState() => _AddTnxState();
}

class _AddTnxState extends State<AddTnx> {
  DateTime selectedDate = DateTime.now();
  String type = "Expense";
  TextEditingController amtController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String category = "Misc";
//fefef
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transactions")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromARGB(255, 137, 137, 137),
                          blurRadius: 20.0,
                          offset: Offset(6, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.currency_rupee_outlined,
                      color: Colors.green, //change icon color here
                    )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextField(
                    controller: amtController,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey,
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromARGB(255, 137, 137, 137),
                          blurRadius: 20.0,
                          offset: Offset(6, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.description,
                      color: Colors.amber, //change icon color here
                    )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "Note",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                    //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //keyboardType: TextInputType.number,
                    //maxLength: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromARGB(255, 137, 137, 137),
                          blurRadius: 20.0,
                          offset: Offset(6, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.moving_sharp,
                      color: Colors.deepPurple, //change icon color here
                    )),
                SizedBox(
                  width: 12,
                ),
                ChoiceChip(
                  selectedColor: Colors.deepPurple,
                  label: Text(
                    "Income",
                    style: TextStyle(
                        color: type == "Income" ? Colors.white : Colors.black),
                  ),
                  selected: type == "Income" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                ChoiceChip(
                  selectedColor: Colors.deepPurple,
                  label: Text(
                    "Expense",
                    style: TextStyle(
                        color: type == "Expense" ? Colors.white : Colors.black),
                  ),
                  selected: type == "Expense" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Expense";
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromARGB(255, 137, 137, 137),
                          blurRadius: 20.0,
                          offset: Offset(6, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.date_range_outlined,
                      color: Colors.blueAccent, //change icon color here
                    )),
                TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      "${selectedDate.day} / ${selectedDate.month}",
                      style: TextStyle(color: Colors.blueAccent),
                    )),
              ],
            ),
            (type == "Income")
                ? Container()
                : DropdownButton(
                    hint: Text(
                      category,
                      style: TextStyle(color: Colors.blue),
                    ),
                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.blue),
                    items: ['Food', 'Travel', 'Shopping', 'Rent', 'Misc'].map(
                      (val) {
                        print(val);
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(
                        () {
                          if (type == "Income") {
                            category = "Income";
                          } else {
                            category = val!;
                          }
                        },
                      );
                    },
                  ),
            ElevatedButton(
                onPressed: () {
                  TransactionProvider().addTnxDb(
                      amt: amtController.text,
                      note: noteController.text,
                      date: selectedDate
                          .toString() /*DateFormat.yMMMd().format(selectedDate),*/,
                      type: type,
                      category: category);
                  nextPageOnly(context: context, page: HomePage());
                  setState(() {});
                },
                child: Text("Add"))
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 12),
        lastDate: DateTime(2100, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
