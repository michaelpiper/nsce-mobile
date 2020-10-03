import 'package:NSCE/ext/search.dart';
import 'package:NSCE/ext/spinner.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/request.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';

// Notification screen
class ConfirmOrderPage extends StatefulWidget {
  @override
  _ConfirmOrderPage createState() => _ConfirmOrderPage();
}

class _ConfirmOrderPage extends State<ConfirmOrderPage> {
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  TextEditingController _ctxCoupon = new TextEditingController();
  List _cart;
  Map _userDetails = {};
  String _type;
  String _shippingAddress;
  num discount = 0;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final DialogMan dialogMan = DialogMan(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator())));

  @override
  initState() {
    super.initState();
    _cart = localStorage.getItem(STORAGE_CART_KEY);
    _userDetails = localStorage.getItem(STORAGE_USER_DETAILS_KEY);
    _type = _cart[0]['type'];
    _shippingAddress = localStorage.getItem(STORAGE_SHIPPING_ADDRESS_KEY);
  }

  Future openDialog(Function dialog) {
    return showDialog(
        context: context, builder: dialog, barrierDismissible: false);
  }

  Future openCouponDialog() {
    return openDialog(showFancyCustomDialog).then((couponData) {
      if (couponData == null || couponData == false) {
        _ctxCoupon.text = "";
        setState(() {
          discount = 0;
        });
        return;
      }
      setState(() {
        discount = couponData['amount'];
      });
    });
  }

  Dialog showFancyCustomDialog(BuildContext context) {
    bool _verifying = false;
    bool _valid;
    Map _coupon = {};
    String _msg;
    String errorText;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Container form = Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(20),
            height: 320.0,
            width: 320.0,
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
                    child: TextField(
                      controller: _ctxCoupon,
                      decoration: InputDecoration(
                          hintText: "L123452",
                          labelText: "Enter Coupon Code",
                          errorText: errorText),
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
                      "Coupon",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _verifying = true;
                        errorText = null;
                      });

                      if (_ctxCoupon.text.isEmpty) {
                        setState(() {
                          _verifying = false;
                          errorText = "Coupon can't be empty";
                        });
                        return;
                      }

                      fetchCart(id: "coupon/" + _ctxCoupon.text).then((_) {
                        setState(() {
                          _verifying = false;
                          _valid = !_['error'];
                          _msg = _['message'];
                          _coupon = _['data'];
                        });
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: _verifying
                            ? Spinner(
                                icon: Icons.refresh,
                                color: primaryTextColor,
                              )
                            : Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
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
                      Navigator.pop(context, false);
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
          );
          InkWell success = InkWell(
            onTap: () {
              Navigator.pop(context, _coupon);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.all(20),
              height: 320.0,
              width: 320.0,
              alignment: Alignment.center,
              child: ListTile(
                title: Text(
                  "Successful",
                  style: TextStyle(color: actionColor),
                  textAlign: TextAlign.center,
                ),
                subtitle: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: actionColor,
                ),
              ),
            ),
          );
//          1596740279311
          InkWell failed([String msg = "Coupon already used"]) => InkWell(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(20),
                  height: 320.0,
                  width: 320.0,
                  alignment: Alignment.center,
                  child: ListTile(
                    title: Text(
                      msg,
                      style: TextStyle(color: rejectColor),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Icon(
                      Icons.cancel,
                      size: 50,
                      color: rejectColor,
                    ),
                  ),
                ),
              );

          if (_valid == null) {
            return form;
          }
          if (_valid == false && _msg != null) {
            return failed(_msg);
          } else {
            return failed();
          }
          return success;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    Widget _confirmOrder = Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: () {
                  dialogMan.show();
                  f(res) {
                    dialogMan.hide();
                    if (res is bool || res['error'] == true) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return SmartAlert(
                              title: "Warning",
                              description:
                                  "Something went wrong will trying to confirm you order.");
                        },
                      );
                    } else {
                      localStorage
                          .setItem(STORAGE_CART_CHECKOUT_KEY, res['data'])
                          .then((value) {
                        return Navigator.popAndPushNamed(
                            context, '/save_and_pay');
                      });
                    }
                  }

                  fetchCart(
                          id: _ctxCoupon.text.isNotEmpty
                              ? 'checkout?coupon=' + _ctxCoupon.text
                              : 'checkout')
                      .then(f);
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
                  'Confirm Order',
                  style: TextStyle(color: primaryTextColor),
                ),
              )
            ]));
    Widget billingSection = Container(
      padding: EdgeInsets.only(top: 0.12, right: 0.0, left: 0.0),
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Text(
                  'Billing Info',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: textColor),
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                  child: Text('Edit', style: TextStyle(color: primaryColor)))
            ]),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 1.0),
                ),
                SizedBox(
                  width: 100,
                  child: Text('Name',
                      style: TextStyle(
                          color: noteColor,
                          fontSize: 16,
                          textBaseline: TextBaseline.alphabetic)),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 3.0),
                ),
                Expanded(
                    child: Text('Phone number',
                        style: TextStyle(
                            color: noteColor,
                            fontSize: 16,
                            textBaseline: TextBaseline.alphabetic)))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 1.0),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                      _userDetails['firstName'] +
                          ' ' +
                          _userDetails['lastName'],
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          textBaseline: TextBaseline.alphabetic)),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 3.0),
                ),
                Expanded(
                    child: Text(_userDetails['phone'],
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            textBaseline: TextBaseline.alphabetic)))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 1.0),
              ),
              Icon(Icons.location_on, color: Colors.blue),
              Padding(
                padding: EdgeInsets.only(right: 3.0),
              ),
              Expanded(
                  child: Text(_userDetails['address'],
                      style: TextStyle(
                          color: noteColor,
                          fontSize: 16,
                          textBaseline: TextBaseline.alphabetic)))
            ]),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
    Widget shippingSection = Container(
      padding: EdgeInsets.only(top: 0.12, right: 0.0, left: 0.0),
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Text(
                  'Shipping Info',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: textColor),
                ),
              ),
              _type == 'pickup'
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        onSelect(e) {
                          Map<String, String> post = {};
                          post['contactPhone'] = _userDetails['phone'];
                          post['contactPerson'] = _userDetails['firstName'] +
                              ' ' +
                              _userDetails['lastName'];
                          post['shippingAddress'] = e['address'];
                          List arrAddress = e['address'].split(',');
                          post['shippingState'] = isNull(
                              arrAddress[arrAddress.length - 1],
                              replace: '');
                          post['shippingLGA'] = isNull(
                              arrAddress[arrAddress.length - 2],
                              replace: '');
                          post['shippingLatLng'] = e['geolocation'];
                          updateShippingAddress(post).then((e) => print(e));
                          Navigator.of(context).pop();
                          setState(() {
                            _shippingAddress = e['address'];
                          });
                        }

                        return showDialog(
                            context: context,
                            child: Dialog(
                              child: Search(
                                  initValue:
                                      isNull(_shippingAddress, replace: ''),
                                  onSelect: onSelect),
                            ));
                      },
                      child:
                          Text('Edit', style: TextStyle(color: primaryColor)))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 7.0),
                ),
                Icon(Icons.local_shipping, color: noteColor),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                ),
                Expanded(
                    child: Text(
                        _type == 'pickup' ? 'Pickup at Yard' : 'Site Delivery',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            textBaseline: TextBaseline.alphabetic)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 7.0),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                ),
                Expanded(
                    child: Text(
                        _type == 'pickup'
                            ? ''
                            : isNull(_shippingAddress, replace: ''),
                        style: TextStyle(
                            color: noteColor,
                            fontSize: 16,
                            textBaseline: TextBaseline.alphabetic)))
              ],
            )
          ]),
        ),
      ),
    );
    List orderTitle = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Order Details',
            style: TextStyle(color: noteColor),
          ),
          Text(' '),
        ],
      ),
      SizedBox(
        height: 5,
      )
    ];
    num total = 0;
    num shippingFee = 0;
    updateOrder(e) {
      total += e['unitPrice'] * int.tryParse(e['quantity']);
      shippingFee += e['shippingFee'];
      orderTitle.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              e['Product']['name'],
              style: TextStyle(color: noteColor),
            ),
            Text(CURRENCY['sign'] +
                ' ' +
                oCcy.format(isNull(e['totalPrice'], replace: 0))),
          ],
        ),
      );
      orderTitle.add(SizedBox(
        height: 2,
      ));
    }

    orderTitle.add(SizedBox(
      height: 10,
    ));
    _cart.forEach(updateOrder);
    orderTitle.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sub Total',
          style: TextStyle(color: textColor),
        ),
        Text(CURRENCY['sign'] + ' ' + oCcy.format(total)),
      ],
    ));
    if (shippingFee > 0) {
      orderTitle.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Shipping Fee',
            style: TextStyle(color: textColor),
          ),
          Text(CURRENCY['sign'] + ' ' + oCcy.format(shippingFee)),
        ],
      ));
    }
    orderTitle.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Total',
          style: TextStyle(color: textColor),
        ),
        Text(
          CURRENCY['sign'] +
              ' ' +
              oCcy.format(
                (total + shippingFee) - discount > 0
                    ? (total + shippingFee) - discount
                    : 0,
              ),
        ),
      ],
    ));
    Widget ordersSection = Container(
      padding: EdgeInsets.only(top: 0.12, right: 0.0, left: 0.0),
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(
            children: orderTitle,
          ),
        ),
      ),
    );
    Widget orderCoupon = Container(
      padding: EdgeInsets.only(top: 0.12, right: 0.0, left: 0.0),
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: ListTile(
              title: InkWell(
                onTap: discount <= 0
                    ? openCouponDialog
                    : () {
                        setState(() {
                          discount = 0;
                          _ctxCoupon.text = "";
                        });
                      },
                child: Text(
                  discount <= 0
                      ? "Do you have a coupon?"
                      : "Do you want to cancel coupon?",
                  style: TextStyle(
                    fontSize: 20,
                    color: discount <= 0 ? actionColor : rejectColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              subtitle: Text("discount: " +
                  CURRENCY['sign'] +
                  " " +
                  oCcy.format(discount))),
        ),
      ),
    );
    Widget _buildBody() {
      return ListView(children: <Widget>[
        billingSection,
        shippingSection,
        orderCoupon,
        ordersSection
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: liteColor,
        title: Text(
          "Order Summary",
          style: TextStyle(color: liteTextColor),
        ),
        iconTheme: IconThemeData(color: liteTextColor),
      ),
      body: _buildBody(),
      bottomNavigationBar: _confirmOrder,
    );
  }
}
