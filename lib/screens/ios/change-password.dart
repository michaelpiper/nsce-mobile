import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:flutter/rendering.dart';
class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key,this.title:"Change Password"}) : super(key: key);
  final String title;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePasswordPage>  {
  Map<String,String> _form={};
  final _formKey = GlobalKey<FormState>();
  bool obscureEye1=true;
  bool obscureEye2=true;
  bool obscureEye3=true;
  bool loading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void _loading(bool state){
    setState(() {
      loading=state;
    });
  }
  passwordToggle(int idx){
    switch(idx){
      case 1:
        setState(() {
          obscureEye1 = !obscureEye1;
        });
        break;
      case 2:
        setState(() {
          obscureEye2 = !obscureEye2;
        });
        break;
      case 3:
        setState(() {
          obscureEye3 = !obscureEye3;
        });
        break;
    }
  }
  formContent(BuildContext context) {
    return  Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("Current password", style: TextStyle(fontSize: 14),),
          SizedBox(height: 3,),
          TextFormField(
            expands: false,
            autocorrect: true,
            validator: (e){
              if(e.isEmpty){
                return "Currrent password is required";
              }
              return null;
            },
            obscureText: obscureEye1,
            onSaved:(e){
              setState(() => _form['password'] = e);
            },
            decoration: InputDecoration(
                hintText: "password",
                suffixIcon: IconButton(
                  onPressed: ()=>passwordToggle(1),
                  icon: Icon(Icons.visibility),
                )
            ),
          ),
          SizedBox(height: 10,),
          Text("New password", style: TextStyle(fontSize: 14),),
          SizedBox(height: 3,),
          TextFormField(
            expands: false,
            autocorrect: true,
            decoration: InputDecoration(
                hintText: "password",
                suffixIcon: IconButton(
                  onPressed: ()=>passwordToggle(2),
                  icon: Icon(Icons.visibility),
                )
            ),
            obscureText: obscureEye2,
            validator: (e){
              if(e.isEmpty || e.length<=2){
                return "New password can't be empty";
              }
              return null;
            },
            onSaved: (e){
              setState(() =>_form['newPassword'] = e);
            },
          ),
          SizedBox(height: 10,),
          Text("Confirm new password", style: TextStyle(fontSize: 14),),
          SizedBox(height: 3,),
          TextFormField(
            expands: false,
            autocorrect: true,
            decoration: InputDecoration(
                hintText: "password",
                suffixIcon: IconButton(
                  onPressed: ()=>passwordToggle(3),
                  icon: Icon(Icons.visibility),
                )
            ),
            obscureText: obscureEye3,
            validator: (e){
              if(e.isEmpty || e.length<=2){
                return "Confirm new password can't be empty";
              }else if(e != _form['newPassword']){
                return "New password not the same ";
              }
              return null;
            },
            onSaved: (e){
              setState(() =>_form['confirmNewPassword'] = e);
            },
          ),
          SizedBox(height: 30,),
          MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(30.0,30.0),
                      bottom: Radius.elliptical(30.0,30.0)
                  ),
                  side: BorderSide(color: primarySwatch)
              ),
              child: Text(loading?"Loading...":"Save",style:TextStyle(color: primaryTextColor)),
              onPressed: () {
                final form = _formKey.currentState;
                form.save();
                if (!loading && _formKey.currentState.validate()) {
                  _loading(true);
                  f(e){
                    if (e['message']!=null){
                      showDialog(context: context,child: SmartAlert(title:"Alert",description: e['message'],));
                    }
                    _loading(false);
                  }
                  onError(e){
                    print(e);
                    showDialog(context: context,child: SmartAlert(title:"Alert",description: "password couldn't be change",));
                    _loading(false);
                  }
                  changePassword(_form).then(f).catchError(onError);
                }
              }
          ),
        ],
      ),
    );
  }
  buildBody(BuildContext context){
    return ListView(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child:Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))
                ),
                child:ListTile(
                  title: formContent(context),
                )
            )
        )
      ],
    );
  }
  appBar(BuildContext context){
    return AppBar(
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(25.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child:Row(
              children: <Widget>[
                IconButton(icon:Icon(Icons.arrow_back_ios),onPressed: (){
                  Navigator.of(context).pop(true);
                },),
                Text(widget.title,style: TextStyle(color: liteTextColor,fontSize: 20,fontWeight: FontWeight.w600),)
              ],
            ),
          )
      ),
      leading: Container(),
      elevation: 0,
      backgroundColor: liteColor,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: liteTextColor),
    );
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),// here the desired height
            child: appBar(context)
        ),
        body: buildBody(context) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
