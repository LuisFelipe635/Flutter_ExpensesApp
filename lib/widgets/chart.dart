import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              width: double.infinity,
              child: Text(
                'DESPESAS DOS ÚLTIMOS 7 DIAS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            recentTransactions.isEmpty
                ? Container(
                    padding: EdgeInsets.only(top: 40, bottom: 15),
                    width: double.infinity,
                    child: Text(
                      'Nenhuma transação recente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: groupedTransactionValues.map((data) {
                        return Flexible(
                          fit: FlexFit.tight,
                          child: ChartBar(
                            label: data['day'],
                            spendingAmount: data['amount'],
                            percentage: totalSpending == 0.0
                                ? 0.0
                                : (data['amount'] as double) / totalSpending,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
