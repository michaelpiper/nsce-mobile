import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/timehelper.dart';
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
  DateTime _date;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  TransactionPage({this.trnId}){
    _transaction = storage.getItem(STORAGE_TRANSACTION_KEY);
    _date = DateTime.parse(_transaction['createdAt']);
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
                  final String style = '''
      <style>
      
:root {
  --primary-color: white; 
  --primary-btn-color: orange;  
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Roboto', sans-serif;
  letter-spacing: 0.5px;
}

body {
  background-color: var(--primary-color);
}

.invoice-card {
  display: flex;
  flex-direction: column;
  position: absolute;
  padding: 10px 2em;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  min-height: 25em;
  width: 22em;
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0px 10px 30px 5px rgba(0, 0, 0, 0.15);
}

.invoice-card > div {
  margin: 5px 0;
}

.invoice-title {
  flex: 3;
}

.invoice-title #date {
  display: block;
  margin: 8px 0;
  font-size: 12px;
}

.invoice-title #main-title {
  display: flex;
  justify-content: space-between;
  margin-top: 2em;
}

.invoice-title #main-title h4 {
  letter-spacing: 2.5px;
}

.invoice-title span {
  color: rgba(0, 0, 0, 0.4);
}

.invoice-details {
  flex: 1;
  border-top: 0.5px dashed grey;
  border-bottom: 0.5px dashed grey;
  display: flex;
  align-items: center;
}

.invoice-table {
  width: 100%;
  border-collapse: collapse;
}

.invoice-table thead tr td {
  font-size: 12px;
  letter-spacing: 1px;
  color: grey;
  padding: 8px 0;
}

.invoice-table thead tr td:nth-last-child(1),
.row-data td:nth-last-child(1),
.calc-row td:nth-last-child(1)
{
  text-align: right;
}

.invoice-table tbody tr td {
    padding: 8px 0;
    letter-spacing: 0;
}

.invoice-table .row-data #unit {
  text-align: center;
}

.invoice-table .row-data span {
  font-size: 13px;
  color: rgba(0, 0, 0, 0.6);
}

.invoice-footer {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.invoice-footer #later {
  margin-right: 5px;
}

.btn {
  border: none;
  padding: 5px 0px;
  background: none;
  cursor: pointer;
  letter-spacing: 1px;
  outline: none;
}

.btn.btn-secondary {
  color: rgba(0, 0, 0, 0.3);
}

.btn.btn-primary {
  color: var(--primary-btn-color);
}

.btn#later {
  margin-right: 2em;
}

</style>
''';
                  final String html = """ 
                            $style
                            <h1>Transaction #${_transaction['trnRef']}</h1>
                            <div class="invoice-card">
                                 <div class="invoice-title">
                                      <div id="main-title">
                                        <h4>TRANSACTION</h4>
                                        <span>${_transaction['id']}</span>
                                      </div>
                                
                                      <span id="date">${Bart.myDate(_date)}</span>
                                       <h6>Tran Ref #${_transaction['trnRef']}</h6>
                                       <div class="invoice-details">
                                          <table class="invoice-table">
                                            <tbody>
                                                <tr>
                                                  <th>
                                                    Amount
                                                  </th>
                                                  <th>
                                                    ${CURRENCY['sign']} ${oCcy.format(_transaction['amount'])}
                                                  </th>
                                                </tr>
                                                <tr>
                                                  <th>
                                                  Type
                                                  </th>
                                                  <th>
                                                  ${_transaction['TransactionType']['name']}
                                                  </th>
                                                </tr>
                                                <tr>
                                                  <th>
                                                  Status
                                                  </th>
                                                  <th>
                                                  ${_transaction['TransactionStatus']['name']}
                                                  </th>
                                                </tr>
                                            </tbody>
                                          </table>
                                        </div>
                                    </div>
                                  </div>
                        """;
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