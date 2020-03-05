import 'package:NSCE/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import 'transactions.dart';
// Notification screen
class WalletScreen extends StatelessWidget {
  Function reload;
  Map<String, dynamic> userDetails={'balance':0};
  Map<String, dynamic> currentUser={'phone':''};
  WalletScreen({this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.reload});

  Widget _buildHead(context){

    return Container(
      color: Colors.white,
      child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.vertical(
                      top:    Radius.circular(10.0),
                      bottom: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                        image: ExactAssetImage('images/wallet_card.png'),
                        fit: BoxFit.cover
                    )
                ),
                height: 130,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('NGN '+userDetails['balance'].toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                    Text('Balance',style: TextStyle(color: Colors.white,fontSize: 16),)
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    color: primaryColor,
                    onPressed: (){
                      Navigator.pushNamed(context, '/addfunds');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(10.0,10.0),
                            bottom: Radius.elliptical(10.0,10.0)
                        ),
                        side: BorderSide(color: primarySwatch,)
                    ),
                    padding: EdgeInsets.symmetric(vertical:15.0,horizontal: 45.0),
                    child: Text('Fund Wallet',style: TextStyle(color: primaryTextColor),),
                  ),
                  SizedBox(
                    width: 110,
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(' '),
                  Text("Transaction History"),
                  InkWell(

                    onTap: (){
                      Navigator.of(context).popAndPushNamed('/home/2');
                    },
                    child: Text("View all",
                      style: TextStyle(
                        color:  primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHead(context),
          SizedBox(
            height: 10.0,
          ),
          Expanded(child:TransactionsScreen(length:3)),
        ]
      )
    );
  }
}