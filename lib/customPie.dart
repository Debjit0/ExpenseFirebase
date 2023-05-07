import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';

class CustomPie extends StatelessWidget {
  CustomPie({
    this.perFood,
    this.perMisc,
    this.perRent,
    this.perShopping,
    this.perTravel,
  });
  final perFood;
  final perTravel;
  final perRent;
  final perShopping;
  final perMisc;

  @override
  Widget build(BuildContext context) {
    return PieChart(dataMap: {
      "Food": perFood,
      "Travel": perTravel,
      "Shopping": perShopping,
      "Rent": perRent,
      "Misc": perMisc
    });
  }
}
