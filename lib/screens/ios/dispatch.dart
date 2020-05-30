import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// Notification screen
class DispatchPage extends StatefulWidget {
  final int index;
  DispatchPage({this.index});

  @override
  _DispatchPageState createState()=>_DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage>{
  int currentStep;
  Map<String,dynamic> e = {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample2.png','createdAt':'2012 12:00pm','shippingMethod':'Pick up at Yard'};
  _DispatchPageState();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  String _rating;
  String _comment;
  Map<String ,dynamic> dispatch;
  Map<String ,dynamic> _schedule;
  Map<String ,dynamic> _order;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dispatch = Map.from(storage.getItem(STORAGE_DISPATCH_KEY));
    _schedule = storage.getItem(STORAGE_SCHEDULE_LIST_KEY);
    _order = storage.getItem(STORAGE_ORDER_KEY);
    f(){
      if(dispatch['status']=="Completed"){
        sendFeedback();
      }
    }
    Future.delayed(Duration(seconds: 1),f);
  }
  void sendFeedback(){
    showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
      f()async {
        await likeOrders('${_order['id']}',
            {'rating': _rating.toString(),'dispatchId':'${dispatch['id']}', 'comment': _comment.toString()})
            .then((res) {
          String message=res['message']!=null?res['message']:'Raview submited';
          showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
            completed(){
              if(Navigator.of(context).canPop())Navigator.of(context).pop();
            }
            return SmartAlert(title:"Alert",description:message,onOk: completed,);
          }
          );
        });
      }
      return Material(
        child: AlertDialog(
          title: Text('Rate this Driver'),
          elevation: 1,
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[
                  RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating=rating.toString();
                      });
                    },
                  ),
                  TextField(
                      decoration: InputDecoration(
                        labelText:'Feedbacks',
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      ),
                      minLines: 6,
                      maxLines: 6,
                      onChanged: (e){
                        setState(() {
                          _comment=e;
                        });
                      }
                  )
              ]
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL',style: TextStyle(color: Colors.red),),
              onPressed: () {
                if(Navigator.of(context).canPop())Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                f();
              },
            )
          ],
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {

    Widget description(){
      return  Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal:5.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("orderID: "+widget.index.toString(),style:TextStyle(color:primaryTextColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Item',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic)),
                      Text('Quantity',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Text(e['name'],style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),

                      Text(e['quantity']+' '+e['measurement'],style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700))
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Shipping method',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic)),
                  Text(e['shippingMethod'],style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total ....',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                  Expanded(child: Text(CURRENCY['sign']+''+e['amount'].toString(),style:TextStyle(color:primaryTextColor,fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),)
                ],
              ),
            ],
          ),
      );
    }
    Widget head(){
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          title: Text('Order # ${_schedule['orderId']}  '),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Dispatch # ${dispatch['id']}'),
              SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('item',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                      Text('Quantity',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:Text('${isNull(_schedule['Product']['name'],replace: '')}',overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),),
                      Text('${dispatch['quantity']} ${isNull(_schedule['Product']['unit'],replace: 'unit')}'.toString()+' ',style:TextStyle(color:noteColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700))
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text('Delivery date',style:TextStyle(color: textColor,fontSize: 16.0)),
              Text(("${dispatch['dateScheduled']} ( ${dispatch['timeScheduled']} )"),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color: textColor,fontSize: 15.0),textAlign: TextAlign.left,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container(),),
                  Icon(Icons.check_circle,size: 19,color: primaryColor),
                  Text(isNull( dispatch['status'],replace: 'Status'),style:TextStyle(color:primaryColor,fontSize: 19,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }
    Widget status(){
      switch(dispatch['status']){
        case 'Completed':
          return Center(
            child: MaterialButton(
              color: primaryColor,
              onPressed: sendFeedback,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: primarySwatch,)
              ),
              padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 45.0),
              child: Text('Rate Driver',style: TextStyle(color: primaryTextColor),),
            ),
          );
            
        default:
          return Container();
      }

    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Dispatch # ${dispatch['id']}",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: ListView(
          children: [
            head(),
            Driver(dispatch['driverId'],dispatch:dispatch),
            SizedBox(height: 20,),
            status()
          ]
        )
    );
  }
}





class Driver extends StatefulWidget{
  final int driverId;
  final Map dispatch;
  Driver(this.driverId,{this.dispatch});
  @override
  _Driver createState() => _Driver();
}
class _Driver extends State<Driver>{
  bool loading;
  Map<String, dynamic> _driver;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    _loadDriver();
  }
  void _loadDriver(){
    void f(res){
      print(res);
      _loading(false);
      if(res is Map && res['data'] is Map){
        setState(() {
          _driver = Map<String, dynamic>.from(res['data']);
        });
      }
    }
    _loading(true);
    fetchDispatchDriver('${widget.driverId}').then(f);
  }
  void _loading(bool state){
    setState(() {
      loading=state;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(loading){
      return Center(child: CircularProgressIndicator(),);
    }
    f(Map driver){
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          title: Text('Delivery Details'),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Driver\'s name',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                Text('${isNull(driver['firstName'],replace: '')} ${isNull(driver['lastName'],replace: '')}',style:TextStyle(color:textColor,fontSize: 15,fontWeight: FontWeight.w600,textBaseline: TextBaseline.alphabetic)),
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Vehicle Id',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                        Text('Phone number',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child:Text(widget.dispatch['Vehicle']==null?'Not Assigned':isNull(widget.dispatch['Vehicle']['uniqueIdentifier'],replace: 'Not available'),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),),
                        Text('${isNull(driver['phone'],replace: 'Not available')}',style:TextStyle(color:noteColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700))
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Text('Expected Arrival time',style:TextStyle(color: textColor,fontSize: 16.0)),
                Text(isNull(widget.dispatch['expectedArrival'],replace: 'Not available'),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color: textColor,fontSize: 15.0),textAlign: TextAlign.left,),

              ],
            ),
          ),
        ),
      );
    }
    return _driver==null?Center(child: Text('Dispatch not assigned to driver'),):
    f(_driver);
  }
}