import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../../utils/colors.dart';
// third screen
class SearchPage extends StatelessWidget {
  var _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
//        leading:SizedBox(width: 0.0,),
        centerTitle: false,
        automaticallyImplyLeading: false,
        title:
                TextField(
                  controller: _controller,
                  onChanged: (e){

                  },
                  onSubmitted: (e){
                    print(e);
                  },
                  cursorColor: secondaryColor,
                  style: TextStyle(
                      color: primaryTextColor
                  ),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Your search end here...',
                    hintStyle: TextStyle(
                        color:  primaryTextColor,
                        decoration: TextDecoration.none
                    ),

//                    focusedBorder: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(30.01)),
//                      borderSide: BorderSide(color: Colors.white54, width: 5.0),
//                    ),
//                    enabledBorder: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(0.01)),
//                      borderSide: BorderSide(color: Colors.white30, width: 5.0),
//                    ),
                  ),
                  textInputAction: TextInputAction.search,
                ),

        iconTheme: IconThemeData(color: primaryTextColor),

      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {

            if(Navigator.canPop(context))
              Navigator.pop(context);
          },
          child: Text('Logout!'),
        ),
      ),
    );
  }
}