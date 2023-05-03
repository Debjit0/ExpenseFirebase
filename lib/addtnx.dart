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

//fefef
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transactions")),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Enter Amount"),
            controller: amtController,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter Note"),
            controller: noteController,
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
          TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(
                "${selectedDate.day} / ${selectedDate.month}",
                style: TextStyle(color: Colors.blueAccent),
              )),
          ElevatedButton(
              onPressed: () {
                TransactionProvider().addTnxDb(
                    amt: amtController.text,
                    note: noteController.text,
                    date: selectedDate
                        .toString() /*DateFormat.yMMMd().format(selectedDate),*/,
                    type: type);
                nextPageOnly(context: context, page: HomePage());
                setState(() {});
              },
              child: Text("Add"))
        ],
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
