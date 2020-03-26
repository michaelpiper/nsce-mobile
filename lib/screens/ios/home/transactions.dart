import 'package:flutter/material.dart';
import '../../../services/request.dart';
import 'package:intl/intl.dart';
import '../../../utils/timehelper.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';
// third screen
class TransactionsScreen extends StatefulWidget {
  final int length;
  TransactionsScreen({Key key,this.length}) : super(key: key);
  @override
  _TransactionsScreen createState() => new _TransactionsScreen();
}
class _TransactionsScreen extends State<TransactionsScreen> {
  List transList;
  bool _loadingIndicator;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  _TransactionsScreen(){

    fetchTrn().then((tran){
      if(tran!=false && tran['error']==false){
        List data = tran['data'];
        List<Widget> listToPush = [];
        data.forEach((list){
             String type;
             String subtile;
             Color color;
             if(list['typeId']==1){
               type="Funding wallet";
               subtile=" ";
               color = Colors.black45;
             }else{
               type="Payment for";
               subtile='#'+list['trnRef'];
               color = Colors.orangeAccent;
             }
             var now =  DateTime.parse(list['createdAt']);
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
                       storage.setItem(STORAGE_TRANSACTION_KEY,list).then((v){
                         Navigator.of(context).pushNamed('/transaction/'+list['id'].toString());
                       });
                     },
                     title:Row(children: <Widget>[Text(type),SizedBox(width: 10,),Text(subtile,style: TextStyle(color: color),)],),
                     subtitle: Text(formatted),
                     trailing: Text(CURRENCY['sign']+' '+ oCcy.format(list['amount']),style: TextStyle(color: color)),
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
      return Center(child: CircularProgressIndicator(),);
    }
    return transList.length==0?Center(child: Text('No transaction')):Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: transList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return transList[index];
        },
      ),
    );
  }
}