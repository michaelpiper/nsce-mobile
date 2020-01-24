import 'package:flutter/material.dart';
import '../../../services/request.dart';
import 'package:intl/intl.dart';
//'₦'
//final formatCurrency = new NumberFormat("#,##0.00", "en_US");
// third screen
class TransactionPage extends StatefulWidget {
  TransactionPage({Key key}) : super(key: key);
  @override
  _TransactionPage createState() => new _TransactionPage();
}
class _TransactionPage extends State<TransactionPage> {
  List transList;
  _TransactionPage(){
    fetchTrn().then((tran){
      if(tran['error']==false){
        List data = tran['data'];
        List<Widget> listToPush=[];
        data.forEach((list){
             print(list['trnRef']);
             String type;
             MaterialColor color;
             String amount=list['amount'].toString()+' NGN';
             if(list['typeId']==1){
               type="Credit";
               color = Colors.green;
             }else{
               type="Debit";
               color = Colors.red;
             }
             listToPush.add(
               Card(
                 elevation: 3.0,
                 margin: EdgeInsets.only(top:10.0),
                   child:Padding( padding:EdgeInsets.all(10.0),child:
                   Row (
                     children: <Widget>[
                       Expanded(child:  Text(type),),
                       Text(amount,
                         style: TextStyle(color:color),
                       ),
                     ],
                   ),
                 ),
               )
            );
          }
        );
        setState(() {
          transList=listToPush.toList();
        });
      }

    });
  }
  @override
  initState(){
    super.initState();
    transList = <Widget>[
      Card(
        elevation: 3.0,
        margin: EdgeInsets.only(top: 10.0),
        child: Padding(padding: EdgeInsets.all(10.0), child:
        Row(
          children: <Widget>[
            Expanded(child: Text('__'),),
            Text('____ NGN',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        ),
      ),
      Card(
        elevation: 3.0,
        margin: EdgeInsets.only(top: 10.0),
        child: Padding(padding: EdgeInsets.all(10.0), child:
        Row(
          children: <Widget>[
            Expanded(child: Text('__'),),
            Text('____ NGN',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
        ),
      ),
      Card(
        elevation: 3.0,
        margin: EdgeInsets.only(top: 10.0),
        child: Padding(padding: EdgeInsets.all(10.0), child:
        Row(
          children: <Widget>[
            Expanded(child: Text('__'),),
            Text('____ NGN',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        ),
      ), Card(
        elevation: 3.0,
        margin: EdgeInsets.only(top: 10.0),
        child: Padding(padding: EdgeInsets.all(10.0), child:
        Row(
          children: <Widget>[
            Expanded(child: Text('__'),),
            Text('____ NGN',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        shrinkWrap: false,
        children: transList,
      ),
    );
  }
}