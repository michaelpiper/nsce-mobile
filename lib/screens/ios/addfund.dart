import 'package:NSCE/services/dialog.dictionary.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import '../../services/request.dart';
import '../../services/auth.dart';
import 'package:NSCE/utils/constants.dart';
// third screen

class AddFundsPage extends StatefulWidget {
  final num amount;
  final Function onDone;
  AddFundsPage({Key key,this.amount,this.onDone}) : super(key: key);
  @override
  _AddFundsPage createState() => new _AddFundsPage();
}
class _AddFundsPage extends State<AddFundsPage> {
  final _formKey = GlobalKey<FormState>();
  String transaction = 'No transaction Yet';
  String _cardNumber = "4084084084084081";
  String _cvv="408";
  int _expiryYear=20;
  int _expiryMonth=12;
  num _amount= 500;
  bool _loading=false;
  String _expiryDate="12/20";
  connectPaystack() {
    final form = _formKey.currentState;
    form.save();

    if (_formKey.currentState.validate()) {
      // print('Paystack connected');
      if(_loading) {
        return;
      }
      setState(() {
        _loading=true;
      });
      var act = AuthService.getUserDetails();
      act.then ((value) async {
        if(value is bool  || value==null || value.isEmpty){
          _returnError();
          setState(() {
            _loading=false;
          });
          return;
        }
        Map<dynamic, dynamic> userDetails = value;
        var user = await (new AuthService()).getUser();
        // print(userDetails);
        // print(user);
        PaymentCard card = PaymentCard(number: _cardNumber,
            cvc: _cvv,
            expiryYear: _expiryYear,
            expiryMonth: _expiryMonth);
        Charge charge = Charge()
          ..amount = convertToPayStackInt(_amount)
          ..putCustomField('full name', userDetails['firstName']+' '+userDetails['lastName'])
          ..putCustomField('phone number', user['phone'])
          ..email = user['email']
          ..card = card;
        PaystackPlugin.chargeCard(context,
            charge: charge,
            beforeValidate: (transaction) {
              // print(transaction.reference);
            },
            onError: (err, transaction) {
              // print(err);
              _returnError();
              setState(() {
                _loading=false;
              });
            },
            onSuccess: (transaction) {
//            // print(transaction.reference);
              // print(_amount);
              _returnState(dialogDictionary.paymentReceived);
              setState(() {
                _loading=false;
              });
              createTrn({'trnRef':transaction.reference,'amount':_amount.toString()});
            }
        );

      });
    }
  }
  void _returnState(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg??'Your payment was succesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if(widget.onDone is Function)return widget.onDone();
                if(Navigator.of(context).canPop())Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _returnError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your payment was not succesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void initState(){
    PaystackPlugin.initialize(publicKey: PAYSTACK_PUBLIC_KEY );
    super.initState();
    _amount=widget.amount==null?500:widget.amount;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
//        textTheme: TextTheme(display1:),
        title: Text("", style:TextStyle(color:Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: Card(
            elevation: 8.0,
            margin: EdgeInsets.only(top:10.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ListView(
              shrinkWrap: false,
              children: <Widget>[
                TextFormField(

                  initialValue: _cardNumber,
                  onChanged: (v) => _cardNumber = v,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.credit_card),
                    labelText: "Card Number",
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),

                TextFormField(

                  initialValue: _expiryDate,
                  maxLength: 5,
                  onChanged: (v) {
                    _expiryDate=v;
                    List a = v.split('/');
                    _expiryMonth = int.parse(a[0]);
                    _expiryYear = int.parse(a[1]);
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.timer),
                    labelText: "Expiry Date",
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length<5) {
                      return 'Please enter a valid format mm/yy';
                    }
                    return null;
                  }
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(

                  initialValue: _cvv,
                  maxLength: 3,

                  onChanged: (v) => _cvv =v,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "cvv",
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length<3) {
                      return 'Please enter a valid cvv';
                    }
                    return null;
                  }
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _amount.toString(),
                  onChanged: (v) => _amount = num.parse(v),
                  readOnly: widget.amount==null?false:true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.present_to_all),
                    labelText: "Amount",
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length<2) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  }
                ),

                SizedBox(
                  height: 15.0,
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  //elevation: 5.0,
                  child: MaterialButton(
                    onPressed: connectPaystack,
                    minWidth: 150.0,
                    height: 50.0,
                    color: primaryColor,
                    child: Row(
                      crossAxisAlignment:CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       Icon(Icons.lock,color: Colors.white,),
                        Text(
                          (_loading?'loading...':"Continue Payment"),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,

                        ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int convertToPayStackInt(num number){
  if(number.toString().contains('.')){
    return int.tryParse(number.toStringAsFixed(2).replaceAll('.', ''));
  }else{
    return number*100;
  }
}