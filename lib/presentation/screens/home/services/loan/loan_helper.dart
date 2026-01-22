import 'package:esae_monie/models/loan_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> buildLoanSections(List<LoanModel> loans) {
  return loans.map((loan) {
    Color color;
    if (loan.title == 'Paid') {
      color = Colors.green;
    } else if (loan.title == 'Due') {
      color = Colors.red;
    } else {
      color = Colors.orange;
    }

    return PieChartSectionData(
      value: loan.amount,
      title: loan.title,
      color: color,
      radius: 45,
      titleStyle: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }).toList();
}
