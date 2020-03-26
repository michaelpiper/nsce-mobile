import 'package:NSCE/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

// third screen
class TransactionPage extends StatelessWidget {
  final int trnId;
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map _transaction;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  TransactionPage({this.trnId}){
    _transaction = storage.getItem(STORAGE_TRANSACTION_KEY);
    // print(_transaction);
  }

  Widget _build(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(10.0,10.0),
                bottom: Radius.elliptical(10.0,10.0)
            ),
          ),
          child: ListTile(
            title: Text('Transaction Status'),
            subtitle: Text(_transaction['TransactionStatus']['name']),
            trailing: Text('${CURRENCY['sign']} ${oCcy.format(_transaction['amount'])}'),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(10.0,10.0),
                bottom: Radius.elliptical(10.0,10.0)
            ),
          ),
          child: ListTile(title: Text('Transaction Type'),
            subtitle: Text(_transaction['TransactionType']['name']),),
        ),
        SizedBox(
          height: 10,
        ),

        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(10.0,10.0),
                  bottom: Radius.elliptical(10.0,10.0)
              ),
            ),
            child:ListTile(
              subtitle: Text(_transaction['TransactionStatus']['name']),
              title: Text('trn #'+_transaction['trnRef']),
            )
        ),
        SizedBox(
          height: 10,
        ),
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(10.0,10.0),
                  bottom: Radius.elliptical(10.0,10.0)
              ),
            ),
            child:ListTile(
              subtitle: Text(DateTime.parse(_transaction['createdAt']).toLocal().toString()),
              title: Text('Created On'),
            )
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction "+trnId.toString(), style:TextStyle(color:Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _build(),
          Center(
            child:  MaterialButton(
              color: primaryColor,
              shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(10.0,10.0),
                      bottom: Radius.elliptical(10.0,10.0)
                  ),
                  side: BorderSide(color: primarySwatch)
              ),
              onPressed: () async {

                final bool result =
                await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
                  final String html = "<h1>Transaction</h1>"
                                      "<h1>Tran Ref #${_transaction['trnRef']}</h1>"
                                      "<table>"
                                        "<tbody>"
                                            "<tr>"
                                              "<th>"
                                                'Amount'
                                              "</th>"
                                              "<th>"
                                                '${CURRENCY['sign']} ${oCcy.format(_transaction['amount'])}'
                                              "</th>"
                                            "</tr>"
                                            "<tr>"
                                              "<th>"
                                              'Type'
                                              "</th>"
                                              "<th>"
                                              '${_transaction['TransactionType']['name']}'
                                              "</th>"
                                            "</tr>"
                                            "<tr>"
                                              "<th>"
                                              'Status'
                                              "</th>"
                                              "<th>"
                                              '${_transaction['TransactionStatus']['name']}'
                                              "</th>"
                                            "</tr>"
                                        "</tbody>"
                                      "</table>";
                  return await Printing.convertHtml(format: format, html: html);
                });
              },
              child: Text('Print Transaction',style: TextStyle(color: primaryTextColor),),
            ),
          ),
        ],
      )
    );
  }
}