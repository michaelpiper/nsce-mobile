import 'package:flutter/material.dart';
import '../../../services/request.dart';
//import 'package:intl/intl.dart';
import '../../../utils/timehelper.dart';
//'₦'
//final formatCurrency = new NumberFormat("#,##0.00", "en_US");
// third screen
class TransactionsScreen extends StatefulWidget {
  TransactionsScreen({Key key}) : super(key: key);
  @override
  _TransactionsScreen createState() => new _TransactionsScreen();
}
class _TransactionsScreen extends State<TransactionsScreen> {
  List transList;
  _TransactionsScreen(){
    fetchTrn().then((tran){
      if(tran!=false && tran['error']==false){
        List data = tran['data'];
        List<Widget> listToPush = [];
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
             var now =  DateTime.parse(list['createdAt']);
             print(now.timeZoneName);
             print((new DateTime.now()).timeZoneName);
             var bart = Bart(now);
             String formatted = bart.diffNow();
             listToPush.add(
               Card(
                   elevation: 3.0,

                   shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(
                         15.0,),
                       side: BorderSide(color: Colors.amberAccent)),
                   margin: EdgeInsets.only(top:10.0),
                   child:Padding(
                     padding:EdgeInsets.all(10.0),
                     child:InkWell(
                       onTap: (){
                         Scaffold.of(context).showSnackBar(SnackBar(content:Text("opening transaction")));
                         Navigator.of(context).pushNamed('/transaction/'+list['id'].toString());
                       },
                       child: Column(
                         children:<Widget>[
                         Row(
                           children: <Widget>[
                             Expanded(child: Text('TransId: '+list['trnRef']),),
                             Text(formatted,
                               style: TextStyle(color: Colors.black45),
                             ),
                           ],
                         ),
                         Row (
                           children: <Widget>[
                             Expanded(child:  Text(type),),
                             Text(amount,
                               style: TextStyle(color:color),),
                            ],
                         ),
                       ],
                     ),
                   ),
                 )
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
    transList = <Widget>[];
    var now =  DateTime.now();
    now = now.subtract(Duration(seconds: 200,days: 2));
    var bart = Bart(now);
    String formatted = bart.diffNow();
    for(int i=0;i<5;i++){
      transList.add(
        Card(
            elevation: 3.0,
            margin: EdgeInsets.only(top: 10.0),
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,),
                side: BorderSide(color: Colors.amberAccent)),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child:InkWell(
                onTap: (){
                  Scaffold.of(context).showSnackBar(SnackBar(content:Text("opening transaction")));
                  Navigator.of(context).pushNamed('/transaction/'+i.toString());
                },
                child: Column(
                  children:<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text('TransId: ----------'),),
                        Text(formatted,
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text('__'),),
                        Text('____ NGN',
                          style: TextStyle(color: (i%2==0?Colors.red:Colors.green)),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          )
        )
      );
    }
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