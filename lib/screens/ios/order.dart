import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
// Notification screen
class OrderPage extends StatefulWidget {
  final int index;
  OrderPage({this.index});
  @override
  _OrderPageState createState()=>_OrderPageState(index:this.index);
}

class _OrderPageState extends State<OrderPage>{
  final int index;
  int currentStep;
  Map<String,dynamic> e= {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample2.png','createdAt':'2012 12:00pm','shippingMethod':'Pick up at Quarry'};
  _OrderPageState({this.index});
  goTo(step){
    setState(() {
      currentStep=step;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStep=2;
  }
  @override
  Widget build(BuildContext context) {
    List <Step>_steps=[
      Step(
        title: const Text('Shippined'),
        subtitle: const Text('Delivered'),
        state: StepState.complete,
        isActive: true,
        content: Text('hi')
      ),
      Step(
        title: const Text('Orders'),
        state: StepState.indexed,
        isActive: false,
        subtitle: const Text('Delivered'),
        content: Column(
          children: <Widget>[
            ListTile(
              onTap:() {
                Navigator.pushNamed(context,'/order-child/1');
              } ,
              title: Text('Schedule 1022'),
              subtitle: Text('Jun 10 2019 8:19am'),
            ),
            ListTile(
              onTap:() {
                Navigator.pushNamed(context,'/order-child/1');
              } ,
              title: Text('Schedule 1022'),
              subtitle: Text('Jun 11 2019 8:19am'),
            ),
            ListTile(
              onTap:() {
                Navigator.pushNamed(context,'/order-child/1');
              } ,
              title: Text('Schedule 1022'),
              subtitle: Text('Jun 12 2019 8:19am'),
            )
          ],
        ),

      ),
      Step(
        title: const Text('Delivered'),
        state: StepState.indexed,
        isActive: false,
        subtitle: const Text('Delivered'),
        content: Text('hi'),

      )
    ];
    Widget description(){
      return InkWell(
        onTap: (){
          Navigator.pushNamed(context,'/order/'+index.toString());
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal:5.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("orderID: "+index.toString(),style:TextStyle(color:primaryTextColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),
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
                  Text('Total    ....',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                  Expanded(child: Text(CURRENCY['sign']+''+e['amount'].toString(),style:TextStyle(color:primaryTextColor,fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),)
                ],
              ),
            ],
          ),
        ),
      );
    }
    Widget head(){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        color: primaryColor,
        child: Container(
          height: 300.0,
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Created at',style:TextStyle(color: primaryTextColor,fontSize: 20.0),textAlign: TextAlign.left,),
                  Text(e['createdAt'],style:TextStyle(color: primaryTextColor,fontSize: 20.0),textAlign: TextAlign.left,),
                ],
              ),
              Expanded(
                child: description(),
              )
            ],
          ),
        ),
      );
    }
    Widget status(){
      return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Stepper(
          steps: _steps,
          currentStep: currentStep,
          onStepCancel: null,
          onStepContinue: null,
          onStepTapped: (step)=>goTo(step),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Order # "+index.toString(),style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: ListView(
        children:<Widget> [
          head(),
          SizedBox(height: 10,),
          status(),
          SizedBox(height: 20,),
        ]
      )
    );
  }
}