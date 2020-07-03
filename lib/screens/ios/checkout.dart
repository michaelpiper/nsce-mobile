import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/utils/country.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../ext/smartalert.dart';
import '../../ext/dialogman.dart';
import 'package:NSCE/ext/search.dart';
import 'package:NSCE/utils/constants.dart';

// Notification screen
class CheckoutPage extends StatefulWidget {
  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  String warning;
  bool _loading;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _txtController = TextEditingController();
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final DialogMan dialogMan = DialogMan(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator())));
  Map<String, String> _billingData;
  Map<String, String> _customer;
  List _cart;
  String _type;

  DropdownMenuItem f(e) {
    return DropdownMenuItem(
      child: Text(
        e['name'],
        style: TextStyle(color: textColor),
      ),
      value: e['name'],
    );
  }

  List<DropdownMenuItem> _countryList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = false;
    _countryList = simpleCountryCode.map(f).toList();
    _cart = storage.getItem(STORAGE_CART_KEY);
    _type = _cart[0]['type'];
  }

  _loadCustomer() async {
    var act = checkAuth();
    act.then((res) {
      if (res is Map && res.containsKey('data')) {
        _billingData = {};
        _customer = {};
        setState(() {
          res['data'].forEach((k, v) {
            _billingData[k] = v.toString();
            _customer[k] = v.toString();
          });
          _txtController.text = _billingData['address'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_billingData == null) {
      _billingData = {};
      _loadCustomer();
      return Loading();
    }
    dialogMan.buildContext(context);
    Widget _checkout = Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: () {
                  if (warning != '' && warning != null) {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return SmartAlert(
                            title: "Warning", description: warning);
                      },
                    );
                  }
                  if (_billingData['phone'] == null ||
                      _billingData['country'] == null ||
                      _billingData['address'] == null) {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return SmartAlert(
                            title: "Alert",
                            description:
                                "Phone, country and address can't be empty");
                      },
                    );
                  }
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
                        .then<void>((value) {
                      Navigator.popAndPushNamed(context, '/confirm_order');
                    });
                  });
                  return null;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0, 15.0),
                        bottom: Radius.elliptical(15.0, 15.0)),
                    side: BorderSide(
                      color: primarySwatch,
                    )),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 45.0),
                child: Text(
                  'Continue',
                  style: TextStyle(color: primaryTextColor),
                ),
              )
            ]));
    Widget _buildForm = Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: _billingData['firstName'],
                    onSaved: (value) => _billingData['firstName'] = value,
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
                    onChanged: (v) => _billingData['firstName'] = v,
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
                    initialValue: _billingData['lastName'],
                    onSaved: (value) => _billingData['lastName'] = value,
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
                    onChanged: (v) => _billingData['lastName'] = v,
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
                      initialValue: _billingData['phone'],
                      onSaved: (value) => _billingData['phone'] = value,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.call, color: secondaryTextColor),
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
                      onChanged: (v) => _billingData['phone'] = v,
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
                initialValue: _billingData['company'],
                onSaved: (value) => _billingData['company'] = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.markunread_mailbox,
                        color: secondaryTextColor),
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
                onChanged: (v) => _billingData['company'] = v,
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
              DropdownButtonFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.map, color: secondaryTextColor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: Colors.grey, width: 2))),
                iconSize: 30.0,
                value: _billingData['country'],
                hint: Text(_billingData['country'] == null
                    ? 'Country'
                    : _billingData['country']),
                isExpanded: true,
                style: TextStyle(color: Colors.white70),
                onChanged: (v) {
                  for (var i = 0; i < simpleCountryCode.length; i++) {
                    Map e = simpleCountryCode[i];
                    if (e['name'] == v) {
                      return setState(() {
                        _billingData['country'] = v;
                      });
                    }
                  }
                },
                items: _countryList,
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
                    prefixIcon:
                        Icon(Icons.location_on, color: secondaryTextColor),
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
              (_type == 'pickup'
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          initialValue: _billingData['pickupDriverId']??'',
                          onChanged: (value) =>
                              _billingData['pickupDriverId'] = value,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on,
                                  color: secondaryTextColor),
                              labelText: 'Pickup Driver ID',
                              labelStyle: TextStyle(
                                color: secondaryTextColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2))),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    )
                  : Container()),
              SizedBox(
                height: 14,
              ),
              Row(
                children: <Widget>[
                  Text(''),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          if (_loading) {
                            return;
                          }
                          if (_billingData['firstName'] ==
                                  _customer['firstName'] &&
                              _billingData['lastName'] ==
                                  _customer['lastName'] &&
                              _billingData['phone'] == _customer['phone'] &&
                              _billingData['company'] == _customer['company'] &&
                              _billingData['country'] == _customer['country'] &&
                              _billingData['address'] == _customer['address'] &&
                          _billingData['pickupDriverId'] == _customer['pickupDriverId']) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return SmartAlert(
                                    title: "Alert",
                                    description: "No changes have been made");
                              },
                            );
                            return;
                          }
                          final form = _formKey.currentState;
                          form.save();
                          if (form.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            if (_loading) {
                              dialogMan.show();
                            }
                            f(res) {
                              _loading = false;
                              dialogMan.hide();

                              if (res is bool || res['error'] == true) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return SmartAlert(
                                        title: "Warning",
                                        description: "Please retry");
                                  },
                                );
                              } else {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return SmartAlert(
                                        title: "Alert",
                                        description:
                                            "Billing info saved sucessfully");
                                  },
                                );
                              }
                            }

                            patchAccount(_billingData).then(f);
                          }
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(color: primaryColor, fontSize: 16.0),
                          textAlign: TextAlign.right,
                        )),
                  )
                ],
              )
            ],
          ),
        ));
    Widget _buildBody() {
      return ListView(children: [
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Billing Address Information',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
        ),
        _buildForm
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        title: Text(
          "Checkout",
          style: TextStyle(color: liteTextColor),
        ),
        iconTheme: IconThemeData(color: liteTextColor),
        backgroundColor: liteColor,
      ),
      body: _buildBody(),
      bottomNavigationBar: _checkout,
    );
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
            _billingData['address'] = value['address'];
            _txtController.text = value['address'];
          });
        },
        initValue: _billingData['address'] ?? 'Address',
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => fancyDialog,
        barrierDismissible: false);
  }
}
