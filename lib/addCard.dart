import 'package:expensefirebase/card.dart';
import 'package:expensefirebase/provider/cardProvder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNo = "0000000000000000";
  String exp = "00/00";
  String name = "Debjit";
  TextEditingController cardNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController expController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Card"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "card number"),
            controller: cardNoController,
          ),
          TextField(
            decoration: InputDecoration(hintText: "exp (11/23)"),
            controller: expController,
          ),
          TextField(
            decoration: InputDecoration(hintText: "name"),
            controller: nameController,
          ),
          ElevatedButton(
              onPressed: () {
                cardProvider().addCard(
                    cardNo: cardNoController.text,
                    name: nameController.text,
                    exp: expController.text);
              },
              child: Text("Add")),
        ],
      ),
    );
  }
}
