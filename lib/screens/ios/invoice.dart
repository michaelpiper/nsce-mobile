import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/timehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogflow/flutter_dialogflow.dart';
import 'package:printing/printing.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pdf/pdf.dart';
// Notification screen
class InvoicesPage extends StatefulWidget {
  static trnType(id){
    switch(id){
      case 1:
        return '';
      default:
        return '';
    }
  }
  static statusType(id){
    switch(id){
      case 0:
        return 'Awaiting Payment';
      case 1:
        return 'Sucessful';
      case 2:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }
  InvoicesPageState createState() =>InvoicesPageState();
}

class InvoicesPageState extends State<InvoicesPage>{
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  bool _loading;
  String _name="All";
  List<Map<String, dynamic>> _invoices = [
  ];
  List<Map<String, dynamic>> _cacheInvoice = [

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading=true;
    _loadInvoice();
  }
  void _loadInvoice(){
    f(res){
      if(res is Map && res['data'] is List){
        // print(res['data']);
        setState(() {
          _cacheInvoice=res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
          _invoices = res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
          _loading=false;
        });
        print(res['data']);
      } else{
        setState((){
          _loading=false;
        });
      }
    }
    fetchTrn(id:'debit').then(f);
  }
  void _sort(n){
    List<Map<String, dynamic>> invoices=[];

    f(order){
      if ( n =="Pending" && order['statusId']==2){
        invoices.add(order);
      }else if (n =="Completed" && order['statusId']==1){
        invoices.add(order);
      }
    }
    if(n=="All"){
      invoices=_cacheInvoice;
    }else{
      _cacheInvoice.forEach(f);
    }
    setState((){
      _name=n;
      _invoices=invoices;
    });
  }
  printme(_transaction)async{
    DateTime _date = DateTime.parse(_transaction['createdAt']);
    final dynamic result = await fetchTrn(id:_transaction['trnRef']+'/order');
    print(result);
    List orderDetails = [];
    if(result is Map &&  result['data'] is Map && result['data']['OrderDetails'] is List){
      orderDetails = result['data']['OrderDetails'];
    }
    String body = "";
    orderDetails.forEach((e){
      body += """
        <tr class="row-data">
        <td>${e['Product']['Category']['name']} <span>(${e['Product']['name']})</span></td>
        <td id="unit">${e['quantity']}</td>
        <td>${e['unitPrice']}</td>
        <td>${e['shippingFee']}</td>
        <td>${e['totalPrice']}</td>
        </tr>
""";

    });
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

      final String html = '''
      $style
      
      <h1>Transaction #${_transaction['trnRef']}</h1>
          <div class="invoice-card">
          <div class="invoice-title">
      <div id="main-title">
      <h4>INVOICE</h4>
      <span>#${_transaction['id']}</span>
      </div>

      <span id="date">${Bart.myDate(_date)}</span>
      </div>

      <div class="invoice-details">
      <table class="invoice-table">
      <thead>
      <tr>
      <td>PRODUCT</td>
      <td>UNIT</td>
      <td>PRICE</td>
      <td>SHIPPING</td>
      <td>TOTAL</td>
      </tr>
      </thead>

      <tbody>
      $body
      </tbody>
      </table>
      </div>

      <div class="invoice-footer">
      <button class="btn btn-secondary" id="later">TOTAL</button>
      <button class="btn btn-primary">${CURRENCY['sign']} ${oCcy.format(_transaction['amount'])}</button>
      </div>
      </div>
      ''';
      return await Printing.convertHtml(format: format, html: html);
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget _builList(){
      Widget f(e){
        DateTime _date = DateTime.parse(e['createdAt']).toLocal();
        return Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child:InkWell(
              onTap: (){
                printme(e);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal:15.0 ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Invoice #"+e['id'].toString(),style:TextStyle(color:noteColor,fontSize: 20,fontWeight: FontWeight.w800,textBaseline: TextBaseline.alphabetic)),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(right:1.0),),
                                      SizedBox(width: 100,child: Text('Billed on: ',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),),
                                      Padding(padding: EdgeInsets.only(right:3.0),),
                                      Expanded(child:Text(Bart.myDate(_date),style:TextStyle(color:noteColor,fontSize: 20,textBaseline: TextBaseline.alphabetic)))
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(right:1.0),),
                                      SizedBox(width: 100,child: Text('Amount',style:TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)),),
                                      Padding(padding: EdgeInsets.only(right:3.0),),
                                      Expanded(child:Text(CURRENCY['sign']+' '+ oCcy.format(e['amount']),style:TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)))
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(child: Container(),),
                                  Icon(Icons.check_circle,size: 19,color: primaryColor),
                                  Text('${InvoicesPage.statusType(e['statusId'])}',style:TextStyle(color:primaryColor,fontSize: 19,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          )
                      ),
                    )
                  ],
                ) ,
              )
          ),
        );
      }
      return _loading?
      Center(child:CircularProgressIndicator()):_invoices.length==0?
      Center(child: Text('Empty list'),):
      ListView.builder(
          itemCount: _invoices.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return f(_invoices[index]);
          }
      );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("My Invoices",style: TextStyle(color: liteTextColor),),
          iconTheme: IconThemeData(color: liteTextColor),
          backgroundColor: liteColor,
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.99),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color:liteColor,
              child: Center(
                  child:
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          _sort("All");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        color: _name=='All'?primaryColor:liteColor,
                        child: Text('All',style: TextStyle(color: _name=='All'?primaryTextColor:liteTextColor),),
                      ),
                      FlatButton(
                        onPressed: (){
                          _sort("Pending");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        color: _name=='Pending'?primaryColor:liteColor,
                        child: Text('Pending',style: TextStyle(color: _name=='Pending'?primaryTextColor:liteTextColor),),
                      ),
//                        FlatButton(
//                          onPressed: (){
//                            _sort("Processing");
//                          },
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(5))
//                          ),
//                          color: _name=='Processing'?primaryColor:liteColor,
//                          child: Text('Processing',style: TextStyle(color: _name=='Processing'?primaryTextColor:liteTextColor),),
//                        ),
                      FlatButton(
                        onPressed: (){
                          _sort("Completed");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        color: _name=='Completed'?primaryColor:liteColor,
                        child: Text('Completed',style: TextStyle(color:_name=='Completed'?primaryTextColor:liteTextColor),),
                      )
                    ],
                  )
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal:10.0 ),
                child:_builList(),
              ),
            )
          ],
        )
    );
  }
}