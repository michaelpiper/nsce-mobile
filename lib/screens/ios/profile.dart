import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/search.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/screens/ios/update_profile.dart';

// Notification screen
class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool _loading;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _txtController = TextEditingController();
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final DialogMan dialogMan = DialogMan(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator())));
  Map _userDetails;

  _ProfilePageState();

  int _i;

  @override
  void initState() {
    _userDetails = storage.getItem(STORAGE_USER_DETAILS_KEY) ?? {};
    _userDetails = _userDetails.map((k, v) => MapEntry(k, v.toString()));
    _loading = false;
    _txtController.text = _userDetails['address'];
    _i = 0;
  }

  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    fn(res) {
      _loading = false;
      dialogMan.hide();
      print(res);
      print('i am here');
      if (res is bool || res['error'] == true) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return SmartAlert(title: "Warning", description: "Please retry");
          },
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            var act2 = checkAuth();
            act2.then((value) {
              if (value == false) {
                return;
              }
              if (value.containsKey('error') && value['error']) {
                return;
              }
              if (value.containsKey('data') && value['data'] == null) {
                return;
              }
              storage
                  .setItem(STORAGE_USER_DETAILS_KEY, value['data'])
                  .then<void>((value) {});
            });
            return SmartAlert(title: "Alert", description: "Profile updated");
          },
        );
      }
    }

    Widget _buildForm = Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: _userDetails['firstName'],
                    onSaved: (value) => _userDetails['firstName'] = value,
                    decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.person, color: secondaryTextColor),
                        labelText: 'First name',
                        labelStyle: TextStyle(
                          color: secondaryTextColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide:
                                BorderSide(color: Colors.black12, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2))),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => _userDetails['firstName'] = v,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: _userDetails['lastName'],
                    onSaved: (value) => _userDetails['lastName'] = value,
                    decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.person, color: secondaryTextColor),
                        labelText: 'Last name',
                        labelStyle: TextStyle(
                          color: secondaryTextColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide:
                                BorderSide(color: Colors.black12, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2))),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => _userDetails['lastName'] = v,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      initialValue: _userDetails['phone'],
                      onSaved: (value) => _userDetails['phone'] = value,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          hintText: '9433313465',
                          hintStyle: TextStyle(
                            color: secondaryTextColor,
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2))),
                      onChanged: (v) => _userDetails['phone'] = v,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                initialValue: _userDetails['company'],
                onSaved: (value) => _userDetails['company'] = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: secondaryTextColor),
                    labelText: 'Company name',
                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2))),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (v) => _userDetails['companyname'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                initialValue: _userDetails['country'],
                onSaved: (value) => _userDetails['country'] = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: secondaryTextColor),
                    labelText: 'country',
                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2))),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (v) => _userDetails['country'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _txtController,
                readOnly: true,
                onTap: () {
                  showFancyCustomDialogForAddress(context);
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: secondaryTextColor),
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2))),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                children: <Widget>[
                  Text(''),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          final form = _formKey.currentState;
                          form.save();
                          if (form.validate()) {
                            if (_loading) {
                              return;
                            }
                            setState(() {
                              _loading = true;
                            });
                            if (_loading) {
                              dialogMan.show();
                            }
                            patchAccount(_userDetails).then(fn).catchError((e) {
                              print(e);
                            });
                          } else {
                            // print('am here');
                          }
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(color: primaryColor, fontSize: 16.0),
                          textAlign: TextAlign.right,
                        )),
                  )
                ],
              )
            ],
          ),
        ));
    Widget bodyBuilder() {
      ImageProvider bgIm = (_userDetails.containsKey('image') &&
              _userDetails['image'] != null &&
              _userDetails['image'] != 'null' &&
              _userDetails['image'] != '')
          ? NetworkImage(baseURL('${_userDetails['image']}?$_i'))
          : AssetImage('images/avatar.png');
      return ListView(children: [
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    onOk() async {
                      setState(() {
                        _i += 1;
                      });
                    }

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          imageCache.clear();
                          return UpdateProfile();
                        }).then((success) {
                      if (success == true)
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return SmartAlert(
                              title: "Alert",
                              description: "Profile picture updated",
                              onOk: onOk,
                            );
                          },
                        );
                    });
                  },
                  child: SizedBox(
                    width: 120.0,
                    height: 120.0,
                    child: CircleAvatar(
                        key: UniqueKey(),
                        backgroundImage: bgIm,
                        child: Icon(Icons.camera_alt)),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  (_userDetails['firstName'] == null
                          ? ''
                          : _userDetails['firstName']) +
                      ' ' +
                      (_userDetails['lastName'] == null
                          ? ''
                          : _userDetails['lastName']),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ]),
        ),
        _buildForm
      ]);
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Profile",
            style: TextStyle(color: primaryTextColor),
          ),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: bodyBuilder());
  }

  void showFancyCustomDialogForAddress(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Search(
        onSelect: (value) {
          Navigator.of(context).pop();
          setState(() {
            _userDetails['address'] = value['address'];
            _txtController.text = _userDetails['address'];
          });
        },
        initValue: _userDetails['address'] ?? 'Address',
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => fancyDialog,
        barrierDismissible: false);
  }
}
