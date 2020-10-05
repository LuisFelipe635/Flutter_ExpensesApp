import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function remove;

  TransactionList(this.userTransactions, this.remove);

  void removeConfirmation(BuildContext ctx, int index) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10,),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Tem certeza que deseja excluir esta transação?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              'Atenção: Esta ação não pode ser desfeita!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: Navigator.of(ctx).pop,
                            child: Text('NÃO'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              remove(userTransactions[index].id);
                              Navigator.of(ctx).pop();
                            },
                            color: Theme.of(ctx).primaryColor,
                            child: Text('SIM'),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: userTransactions.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 15),
                  height: 125,
                  child: Icon(Icons.error_outline, size: 125, color: Colors.grey[700],),
                ),
                Text(
                  'Nada para exibir aqui. Crie uma nova transação',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text(
                              NumberFormat.currency(
                                locale: 'pt_BR',
                                name: 'R\$',
                                decimalDigits: 2,
                              ).format(userTransactions[index].amount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        userTransactions[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy')
                            .format(userTransactions[index].date),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Colors.red,
                        onPressed: () => removeConfirmation(context, index),
                      ),
                    ),
                    elevation: 6,
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}

//Código alternativo para ListView.buider():

// Row(
//   children: <Widget>[
//     Container(
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.symmetric(
//         vertical: 10,
//         horizontal: 15,
//       ),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         border: Border.all(
//           color: Theme.of(context).primaryColor,
//           width: 2,
//         ),
//       ),
//       child: Text(
//         NumberFormat.currency(
//           locale: 'pt_BR',
//           name: 'R\$',
//           decimalDigits: 2,
//         ).format(userTransactions[index].amount),
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//           color: Colors.white,
//         ),
//       ),
//     ),
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           userTransactions[index].title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 5),
//           child: Text(
//             DateFormat('dd/MM/yyyy, H:m')
//                 .format(userTransactions[index].date),
//             style: TextStyle(color: Colors.grey[700]),
//           ),
//         ),
//       ],
//     ),
//   ],
// ),
