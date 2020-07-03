import 'package:NSCE/screens/ios/addfund.dart';
import 'package:NSCE/services/request.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:intl/intl.dart';

class SaveAndPay extends StatelessWidget {
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  Map _transaction;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final DialogMan dialogMan = DialogMan(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator())));

  SaveAndPay() {
    _transaction = localStorage.getItem(STORAGE_CART_CHECKOUT_KEY);
  }

  payWithCheque(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onTap: () {
          dialogMan.show();
          f(buyRes) {
            dialogMan.hide();
            if (buyRes is Map && buyRes['error'] == false) {
              // print(buyRes);
              showDialog(
                  context: context,
                  builder: (BuildContext context) => SmartAlert(
                        title: "Alert",
                        description: buyRes['message'],
                        onOk: () {
                          localStorage.deleteItem(STORAGE_CART_CHECKOUT_KEY);
                          Navigator.of(context).popAndPushNamed('/home');
                        },
                      ));
            }
          }

          buyItem({
            'amount': _transaction['totalPrice'].toString(),
            'typeId': '3',
            'trnRef': _transaction['trnRef']
          }).then(f);
        },
        leading: Image.asset('images/cheque.png'),
        title: Text(
          'pay with Cheque',
        ),
      ),
    );
  }

  payWithWallectORCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onTap: () {
          dialogMan.show();
          f(res) {
            dialogMan.hide();
            if (res is Map && res['error'] == false) {
              fn(buyRes) {
                if (buyRes is Map && buyRes['error'] == false) {
                  dialogMan.hide();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => SmartAlert(
                            title: "Alert",
                            description: buyRes['message'],
                            onOk: () {
                              localStorage
                                  .deleteItem(STORAGE_CART_CHECKOUT_KEY);
                              Navigator.of(context).popAndPushNamed('/home');
                            },
                          ));
                }
              }

              onDone() {
                dialogMan.show();
                buyItem({
                  'amount': _transaction['totalPrice'].toString(),
                  'typeId': '2',
                  'trnRef': _transaction['trnRef']
                }).then(fn);
              }

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String des = "";
                    if (res['data'] >= _transaction['totalPrice']) {
                      des = "You will be charged " +
                          _transaction['currency'] +
                          ' ' +
                          oCcy.format(_transaction['totalPrice']) +
                          " from your wallet";
                    } else {
                      des =
                          "You current wallet balance is ${CURRENCY['sign']} " +
                              oCcy.format(res['data']) +
                              "  will be charged ${CURRENCY['sign']} " +
                              oCcy.format(
                                  _transaction['totalPrice'] - res['data']) +
                              " from your card";
                    }
                    return SmartAlert(
                      title: "Confirm Payment",
                      description: des,
                      onOk: () {
                        if (res['data'] >= _transaction['totalPrice']) {
                          onDone();
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddFundsPage(
                                  onDone: onDone,
                                  amount: (_transaction['totalPrice'] -
                                      res['data']))));
                        }
                      },
                      canCancel: true,
                    );
                  },
                  barrierDismissible: false);
            }
          }

          fetchAccount(id: 'balance').then(f);
        },
        leading: Image.asset('images/wallet.png'),
        title: Text(
          'pay with Wallet',
        ),
      ),
    );
  }

  payWithCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onTap: () {
          dialogMan.show();
          f() {
            dialogMan.hide();

            fn(buyRes) {
              if (buyRes is Map && buyRes['error'] == false) {
                dialogMan.hide();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => SmartAlert(
                          title: "Alert",
                          description: buyRes['message'],
                          onOk: () {
                            localStorage.deleteItem(STORAGE_CART_CHECKOUT_KEY);
                            Navigator.of(context).popAndPushNamed('/home');
                          },
                        ));
              }
            }

            onDone() {
              dialogMan.show();
              buyItem({
                'amount': _transaction['totalPrice'].toString(),
                'typeId': '2',
                'trnRef': _transaction['trnRef']
              }).then(fn);
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                String des = "You will be charged ${CURRENCY['sign']} " +
                    oCcy.format(_transaction['totalPrice']) +
                    " from your card";
                return SmartAlert(
                  title: "Confirm Payment",
                  description: des,
                  onOk: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddFundsPage(
                          onDone: onDone,
                          amount: _transaction['totalPrice'],
                        ),
                      ),
                    );
                  },
                  canCancel: true,
                );
              },
              barrierDismissible: false,
            );
          }

          Future.delayed(Duration(seconds: 1), f);
        },
        leading: Image.asset('images/cheque.png'),
        title: Text(
          'pay with Card',
        ),
      ),
    );
  }

  payWithBank(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
          onTap: () {
//            dialogMan.show();
//            f(buyRes){
//              dialogMan.hide();
//              if(buyRes is Map && buyRes['error']==false){
//                // print(buyRes);
//                showDialog(
//                    context: context,
//                    builder: (BuildContext context) =>SmartAlert(
//                      title: "Alert",
//                      description: buyRes['message'],
//                      onOk: (){
//                        localStorage.deleteItem(STORAGE_CART_CHECKOUT_KEY);
//                        Navigator.of(context).popAndPushNamed('/home');
//                      },));
//              }
//            }
//            buyItem({'amount':_transaction['totalPrice'].toString(),'typeId':'4','trnRef':_transaction['trnRef']}).then(f);
          },
          leading: Image.asset('images/bank.png'),
          title: Text(
            'pay with Bank transfer',
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: liteColor,
          title: Text(
            "Payment",
            style: TextStyle(color: liteTextColor),
          ),
          iconTheme: IconThemeData(color: liteTextColor),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
          child: ListView(children: <Widget>[
            SizedBox(
              height: 21.0,
            ),
            Text('Select Payment method'),
            SizedBox(
              height: 21.0,
            ),
            Text("Transaction Ref: " + _transaction['trnRef']),
            Text("Total Amount: " +
                _transaction['currency'] +
                ' ' +
                oCcy.format(_transaction['totalPrice'])),
            SizedBox(
              height: 21.0,
            ),
            payWithWallectORCard(context),
            payWithCard(context),
            payWithBank(context),
          ]),
        ));
  }
}
