import 'package:flutter/material.dart';
import '../../../services/request.dart';
//import 'package:intl/intl.dart';
import '../../../utils/timehelper.dart';
import 'package:NSCE/utils/constants.dart';
//'₦'
import 'package:NSCE/ext/spinner.dart';
// third screen
import '../../../ext/loading.dart';
//Card(
//elevation: 3.0,
//shape:RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(
//15.0,
//),
//),
//child:  ListTile(
//title:Row(children: <Widget>[Text('Payment for'),Text(' Order # 123',style: TextStyle(color: primaryColor),)],),
//subtitle: Text('3rd Jul, 20 3:00pm'),
//trailing: Text(CURRENCY['sign']+' 180,000'),
//),
//);
class TransactionsScreen extends StatefulWidget {
  int length;
  TransactionsScreen({Key key,this.length}) : super(key: key);
  @override
  _TransactionsScreen createState() => new _TransactionsScreen();
}
class _TransactionsScreen extends State<TransactionsScreen> {
  List transList;
  bool _loadingIndicator;
  _TransactionsScreen(){

    fetchTrn().then((tran){
      if(tran!=false && tran['error']==false){
        List data = tran['data'];
        List<Widget> listToPush = [];
        data.forEach((list){
             String type;
             String subtile;
             Color color;
             String amount=list['amount'].toString()+' NGN';
             if(list['typeId']==1){
               type="Funding wallet";
               subtile=" ";
               color = Colors.black45;
             }else{
               type="Payment for";
               subtile=' transId # '+list['trnRef'];
               color = Colors.orangeAccent;
             }
             var now =  DateTime.parse(list['createdAt']);
//             print((new DateTime.now()).timeZoneName);
             var bart = Bart(now);
             String formatted = bart.diffNow();
             listToPush.add(
                 Card(
                   elevation: 3.0,
                   shape:RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(
                       12.0,
                     ),
                   ),
                   child:  ListTile(
                     onTap: (){
                       Scaffold.of(context).showSnackBar(SnackBar(content:Text("opening transaction")));
                       Navigator.of(context).pushNamed('/transaction/'+list['id'].toString());
                     },
                     title:Row(children: <Widget>[Text(type),SizedBox(width: 10,),Text(subtile,style: TextStyle(color: color),)],),
                     subtitle: Text(formatted),
                     trailing: Text(CURRENCY['sign']+ amount.toString(),style: TextStyle(color: color)),
                   ),
                 )
             );
          }
        );
        setState(() {
          _done();
          if(widget.length!=null){
            int len =widget.length>listToPush.length?listToPush.length:widget.length;
            transList=listToPush.sublist(0,len).toList();
            if(transList.length<=0){
              transList.add(Text('Empty transaction',textAlign: TextAlign.center,));
            }
          }else{
            transList=listToPush.toList();
            if(transList.length<=0){
              transList.add(Text('Empty transaction',textAlign: TextAlign.center,));
            }
          }
        });
      }
    });
  }
  Future _done()async{
    await Future.delayed(new Duration(seconds: 1));
    _dataLoaded();
  }
  void _dataLoaded(){
    setState(() {
      _loadingIndicator = false;
    });
  }
  @override
  initState(){
    super.initState();
    _loadingIndicator=true;
  }

  @override
  Widget build(BuildContext context) {
    if(_loadingIndicator){
      return Center(child: Spinner(icon: Icons.sync,),);
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ListView(
//        shrinkWrap: false,
        children: transList,
      ),
    );
  }
}