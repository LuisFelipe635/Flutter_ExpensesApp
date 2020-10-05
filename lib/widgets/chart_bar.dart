import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double percentage;

  ChartBar({
    this.label,
    this.spendingAmount,
    this.percentage,
  });

  String get translateLabel {
    if (label == 'Mon') {
      return 'Seg';
    } else if (label == 'Tue') {
      return 'Ter';
    } else if (label == 'Wed') {
      return 'Qua';
    } else if (label == 'Thu') {
      return 'Qui';
    } else if (label == 'Fri') {
      return 'Sex';
    } else if (label == 'Sat') {
      return 'Sab';
    } else {
      return 'Dom';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 20,
          child: FittedBox(
            child: Text(
              NumberFormat.currency(
                locale: 'pt_BR',
                name: 'R\$',
                decimalDigits: 0,
              ).format(spendingAmount),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 25,
          height: 60,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(translateLabel),
      ],
    );
  }
}
