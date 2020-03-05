import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../ext/loading.dart';
// Notification screen
class ShippingPage extends StatefulWidget {
  final int index;
  ShippingPage({this.index});
  @override
  _ShippingPageState createState() => _ShippingPageState(index:this.index);
}
class _ShippingPageState extends State<ShippingPage> with TickerProviderStateMixin {
  final int index;
  bool _loadingIndicator;
  var _controller;
  _ShippingPageState({this.index});

  @override
  void initState() {
    super.initState();
    _loadingIndicator=true;

  }
  Future _done()async{
    await Future.delayed(new Duration(seconds: 2));
    _dataLoaded();
  }
  void _dataLoaded(){
    setState(() {
      _loadingIndicator = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_loadingIndicator) {
      _done();
      return Loading();
    }
    Widget _headerBuilder(){
      return Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:5.0 ,horizontal: 12.0),
          child: ListTile(
            title: Text('dsddd'),
          ),
        ),
      );
    }
    Widget _formBuilder(){
      return Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                   Navigator.pushNamed(context,'/checkout');
                },
                child: Text('Confirm Order'),
              ),
            ),

          ]
      );
    }
    Widget bodyBuilder(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _headerBuilder(),
            const SizedBox(height: 8.0,),
            Expanded(child:_formBuilder())
          ],
        ),
      );
    }
    Widget saveButton=Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceAround,
        children: <Widget>[
          MaterialButton(
            color: primaryColor,

            onPressed: (){
              Navigator.pushNamed(context, '/checkout');
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(15.0,15.0),
                    bottom: Radius.elliptical(15.0,15.0)
                ),
                side: BorderSide(color: primarySwatch,)
            ),
            padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 45.0),
            child: Text('Save and Continue',style: TextStyle(color: primaryTextColor),),
          )
        ]
      )
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Shipping",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        resizeToAvoidBottomInset:false,
        body:bodyBuilder(),
      bottomNavigationBar:saveButton,
    );
  }

}