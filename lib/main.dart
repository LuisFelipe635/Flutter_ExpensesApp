import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      title: 'Gerenciador de Despesas',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  int _idCounter = 0;
  bool _showChart = false;

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String name, double value, DateTime selectedDate) {
    _idCounter++;
    final transaction = new Transaction(
      id: _idCounter,
      title: name,
      amount: value,
      date: selectedDate,
    );

    setState(() {
      _userTransactions.add(transaction);
    });
  }

  void _removeTransaction(int id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Minhas Despesas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 35,
                  ),
                  onPressed: () => _startNewTransaction(context),
                ),
              ),
            ],
            title: Text(
              'Minhas Despesas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _removeTransaction),
    );

    final pageBody = Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Chart(_recentTransactions),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'LISTA DE DESPESAS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () => _startNewTransaction(context)),
          );
  }
}
