
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/ext/selectionlist.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/search.dart';
import 'package:intl/intl.dart';
class ProductPage extends StatefulWidget {
  final int id;

  ProductPage({this.id});
  @override
  ProductStatePage createState() =>ProductStatePage(id:id);
}

class ProductStatePage extends State<ProductPage> with TickerProviderStateMixin{
  final int id;
  int unit;
  bool _loadingIndicator;
  String selectedMethod='';
  Map<String,dynamic>  _product;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  TextEditingController _txtController = TextEditingController();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  Map post={'productId':'','quantity':'','schedule':'','pickup':'','contactPerson':'','contactPhone':''};
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  ProductStatePage({this.id});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingIndicator=true;
    unit=1;
    _txtController.text=unit.toString();
  }
  void increament(){
    setState(() {
      unit++;
      _txtController.text=unit.toString();
    });
  }
  void decreament(){
    setState(() {
      if(unit>1)unit--;
      else unit=1;
      _txtController.text=unit.toString();
    });
  }

  Future _loadProduct() async {
    fetchProductWithParents(id).then((product){
      if(product==false || product==null){
        return Future.value(false);
      }
      if( product['data'] is Map){
        print(product['data']);
        setState(() {
          _product = product['data'];
          _productLoaded();
        });
        return Future.value(true);
      }else{

      }
      return Future.value(false);
    });
  }
  void _productLoaded(){
    setState(() {
      _loadingIndicator= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_loadingIndicator){
      _loadProduct().then((loaded){
        if(loaded==false && Navigator.of(context).canPop())Navigator.of(context).pop();
      });
      return Loading();
    }
    dialogMan.buildContext(context);
    Widget titleSection = Container(
        padding: EdgeInsets.only(
            top: 0.12,
            right: 0.0,
            left: 0.0),
        child:Card(
      child:  Padding(padding: EdgeInsets.only(right:7.0),child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),
                  ),
                ),
                Text(
                  _product['Category']['Quarry']['address']+' '+_product['Category']['Quarry']['state']+', '+_product['Category']['Quarry']['country'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ],
      ),),
    )
    );

//    Color color = Theme.of(context).primaryColor;

    Widget headerSection= Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(0, 0, 0, 0), primaryColor],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
    child:
      Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .13,
              right: 0.0,
              left: 0.0
            ),
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(20.0,20.0),
                    bottom: Radius.elliptical(12.0,12.0)
                  )
                )
              ),
          ),
          Align(
            alignment: Alignment(0,11),
            child: Container(
              padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 60.01,
              ),
                height: 300.0,
                width:  MediaQuery.of(context).size.width-80,
                child: _product['image']==null?
                Container():
                Image.network(
                  baseURL(_product['image']),
                  alignment: Alignment(0,-11),
                  width: 200,
                  height: 240,
                  fit: BoxFit.fill,
                ),
            ),

          ),
        ],
      )
    );
    Widget aboutSection = Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text(_product['name'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: textColor),),)
                ]
              ),
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} '+percentage(_product['price'],_product['discount']).toString()+'/'+_product['unit'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: textColor),),)
                  ]
              ),
              _product['discount']==0?
              Container() :
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} '+oCcy.format(_product['price']),style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor,decoration: TextDecoration.lineThrough,decorationColor: noteColor),),),
                    Text(_product['discount'].toString()+'% Off',style: TextStyle(color: rejectColor,fontWeight: FontWeight.w600),)
                  ]
              ),
            ]
          )
        )
      )
    );
    Widget shippingSection =  Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
              children: <Widget>[
                Expanded(child: Text('Description',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),InkWell(child: Text('see more',style:TextStyle(color:primaryColor)))
              ]),
              Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right:7.0),),
                  Expanded(child:Text(_product['descripton'].toString()+' from Quarry in\n'+_product['Category']['Quarry']['state']+', '+_product['Category']['Quarry']['country'],style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                ],
              )
            ]
          ),
        ),
      ),
    );
    Widget addtocart = Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(right: 20.0),
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(12.0,12.0),
                            bottom: Radius.elliptical(12.0,12.0)
                        ),
                        side: BorderSide(color: secondaryColor,)
                    ),
                    child:
                    SizedBox(
                      child: Stack(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 20.0),),
                          ButtonBar(
                            buttonPadding: EdgeInsets.only(top:20.0),
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,
                                icon: Icon(Icons.remove),
                                tooltip: 'Decrease volume by 1',
                                onPressed: () {
                                  decreament();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 7),
                                child:  SizedBox(
                                  width: 32,
                                  child: TextField(

                                    controller: _txtController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none
                                    ),
                                    onChanged: (e)=>setState(() {
                                      unit=int.tryParse(e);
                                    }),
                                    onSubmitted: (e)=>setState(() {
                                      unit=int.tryParse(e);
                                    }),
                                    style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,

                                icon: Icon(Icons.add),
                                tooltip: 'Increase volume by 1',
                                onPressed: () {
                                  increament();
                                },
                              ),
                            ],)
                        ],
                      ),

                      width: 130,
                      height: 40,),
                  ),
                  Text('x1 unit',
                    style: TextStyle(color: noteColor),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),

              MaterialButton(
                splashColor: primaryColor,
                color: primaryColor,
                textColor: primaryTextColor,
                hoverColor: primarySwatch,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                ),
                child: Text('Schedule'),
                onPressed: (){
                  showFancyCustomDialog(context);
                },
              )
            ],
          ),
        )
      )
    );
    return Scaffold(
      resizeToAvoidBottomInset : true,
      appBar: AppBar(
        elevation: 0,
        title: Text(_product['name'],style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          headerSection,
          aboutSection,
          titleSection,
          shippingSection,
        ],
      ),
      bottomNavigationBar: addtocart,
    );

  }
  void changeMethod(e){
    setState(() {

      selectedMethod=e;
      if(e=="Site Delivery"){
        showFancyCustomDialogForAddress(context);
      }
    });
  }
  void continueToAdd()async{
    var act = await Provider.of<AuthService>(context).getUser();
    var act2 = checkAuth();
    act2.then((value) {
      print(value['data']);
      if(value is Map &&  value.containsKey('data')){
        Map <String,dynamic> contact = value['data'];
        post['productId']=id.toString();
        post['quantity']=unit.toString();
        post['schedule']='';
        post['pickup']= selectedMethod=="Site Delivery"?'0':'1';
        post['contactPerson']=contact['firstName']+' '+contact['lastName'];
        post['contactPhone']=act['phone'];
        storage.setItem(STORAGE_SCHEDULE_KEY, {'post':post,'product':_product}).then<void>((value){
          dialogMan.hide();
          Navigator.pushNamed(context, '/schedule');
        });
      }

    });

  }
  void showFancyCustomDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: SelectionList(
                  ['Site Delivery','Pick up at Quarry'],
                  onChange: (e)=>changeMethod(e),

                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Choose your Delivery method",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  if(selectedMethod==''){
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return  SmartAlert(title:"Warning",description:"Please select one of the shipping method");
                      },
                    );
                  }else{
                    Navigator.pop(context);
                    dialogMan.show();
                    continueToAdd();
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Confirm Delivery Method",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
  void showFancyCustomDialogForAddress(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Search(
        initValue:post['address'] ==null?'':post['address'] ,
      onSelect: (e){
        post['contactPhone']="";
        post['contactPerson']="";
        post['address'] = e['address'];
        List arrAddress =post['address'].split(',');
        post['country'] = arrAddress[arrAddress.length-1];
        post['state'] = arrAddress[arrAddress.length-2];
        post['geolocation'] = e['geolocation'];
        Navigator.of(context).pop();
      },)
    );

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog, barrierDismissible: false);
  }
}

