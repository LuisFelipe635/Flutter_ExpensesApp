import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'NOVA TRANSAÇÃO',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome:',
                  ),
                  controller: _title,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Valor gasto:',
                  ),
                  controller: _amount,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Data: '
                            : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                          helpText: 'SELECIONAR DATA',
                        ).then((date) {
                          if (date == null) {
                            return;
                          }
                          setState(() {
                            _selectedDate = date;
                          });
                        });
                      },
                      child: Text(
                        'Selecionar data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  onPressed: () {
                    var temp = _amount.text.split(",");
                    String valueSt;
                    if (temp.length == 2) {
                      valueSt = temp[0] + '.' + temp[1];
                    } else {
                      valueSt = temp[0];
                    }
                    if (_title.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Transação sem nome',
                        toastLength: Toast.LENGTH_LONG,
                      );
                    } else if (_amount.text.isEmpty ||
                        valueSt[0].startsWith('-')) {
                      Fluttertoast.showToast(
                        msg: 'Valor vazio ou negativo',
                        toastLength: Toast.LENGTH_LONG,
                      );
                    } else if (_selectedDate == null) {
                      Fluttertoast.showToast(
                        msg: 'Transação sem data',
                        toastLength: Toast.LENGTH_LONG,
                      );
                    } else {
                      double value = double.parse(valueSt);
                      widget.addTransaction(
                        _title.text,
                        value,
                        _selectedDate,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('CONFIRMAR'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
