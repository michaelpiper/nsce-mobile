import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/timehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';

// Notification screen
class OrderPage extends StatefulWidget {
  final int index;

  OrderPage({this.index});

  @override
  _OrderPageState createState() => _OrderPageState(index: this.index);
}

class _OrderPageState extends State<OrderPage> {
  final int index;
  int screen;
  bool loading = true;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String, dynamic> _order = {
    'name': 'stone',
    'quantity': '2000',
    'amount': '180,000.00',
    'measurement': 'Tonnes',
    'id': '12343232',
    'image': 'images/sample2.png',
    'createdAt': '2012 12:00pm',
    'shippingMethod': 'Pick up at Yard'
  };
  DateTime _date;

  _OrderPageState({this.index});

  void _loading(bool state) {
    setState(() {
      loading = state;
    });
  }

  void showSchedule() {
    screen = 1;
  }

  void showProduct() {
    setState(() {
      screen = 2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = storage.getItem(STORAGE_ORDER_KEY);
    _date = DateTime.parse(_order['createdAt']).toLocal();
    f(res) {
      if (res['data'] is num && res['data'] > 1) {
        showProduct();
      } else {
        showSchedule();
      }
      _loading(false);
    }

    countOrderDetails(_order['id'], q: 'grouped-count').then(f);
  }

  @override
  Widget build(BuildContext context) {
    Widget description() {
      return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Order ID # " + index.toString(),
                  style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      textBaseline: TextBaseline.alphabetic)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Placed On ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    Bart.myDate(_date),
                    style: TextStyle(color: primaryTextColor, fontSize: 15.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Reference number',
                          style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 15,
                              textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(_order['trnRef'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Shipping method',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                                textBaseline: TextBaseline.alphabetic)),
                        Text(
                            _order['type'] == 'pickup'
                                ? "Pick up at Yard"
                                : "Site Delivery",
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 18,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                textBaseline: TextBaseline.alphabetic)),
                        Text(_order['status'],
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 18,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      ],
                    )
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total        ',
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 15,
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.w700)),
                  Expanded(
                    child: Text(
                      CURRENCY['sign'] +
                          '' +
                          oCcy.format(
                              _order['totalPrice'] + _order['shippingFee']),
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget head() {
      return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: primaryColor,
        child: Container(
          height: 300.0,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: description(),
              )
            ],
          ),
        ),
      );
    }

    Widget status() {
      return Expanded(
        child: screen == 1 ? OrderDetails(index) : OrderProducts(index),
      );
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Order # $index ",
            style: TextStyle(color: primaryTextColor),
          ),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              head(),
              SizedBox(
                height: 10,
              ),
              status(),
              SizedBox(
                height: 10,
              ),
            ]));
  }
}

class OrderDetails extends StatefulWidget {
  final int orderId;

  OrderDetails(this.orderId);

  @override
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  bool loading;
  Map _orderDetails = {};
  List<Map<String, dynamic>> _schedules = [];
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    _loadOrderDetails();
  }

  void _loadOrderDetails() {
    void f(res) {
      _loading(false);
      print(res);
      if (res is Map && res['data'] is Map) {
        setState(() {
          _orderDetails = Map<String, dynamic>.from(res['data']);
          _schedules =
              List<Map<String, dynamic>>.from(_orderDetails['Schedules']);
        });
      }
    }

    _loading(true);
    fetchOrderDetailsSchedule('${widget.orderId}', asOrderId: true).then(f);
  }

  void _loading(bool state) {
    setState(() {
      loading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    f(Map schedule) {
      return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          onTap: () {
            schedule['Product'] = _orderDetails['Product'];
            storage.setItem(STORAGE_SCHEDULE_LIST_KEY, schedule).then((_) {
              return Navigator.of(context).pushNamed('/schedule-list');
            }).then((value) => _loadOrderDetails());
          },
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          title: Text(
            ' ${isNull(_orderDetails['Product']['name'], replace: 'Product')}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Qty: ${schedule['quantity']} ${isNull(_orderDetails['Product']['unit'], replace: 'unit')}'),
              SizedBox(
                height: 6,
              ),
              Text('schedule Date', style: TextStyle(color: textColor)),
              Text(
                ("${schedule['dateScheduled']} ( ${schedule['PlantTime']['timeSlot']} )"),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Icon(Icons.check_circle, size: 19, color: primaryColor),
                  Text(isNull(schedule['status'], replace: 'Status'),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 19,
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return _schedules.length == 0
        ? Center(
            child: Text('Empty'),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Schedule list",
                      style: TextStyle(
                          color: noteColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: _schedules.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return f(_schedules[index]);
                      }),
                )
              ]);
  }
}

class OrderProducts extends StatefulWidget {
  final int orderId;

  OrderProducts(this.orderId);

  @override
  _OrderProducts createState() => _OrderProducts();
}

class _OrderProducts extends State<OrderProducts> {
  bool loading;
  List<Map<String, dynamic>> _orderProducts = [];
  List<Map<String, dynamic>> _orderDetails = [];
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    _loadProducts();
  }

  void _loadProducts() {
    void f(res) {
      _loading(false);
      print(res);
      if (res is Map && res['data'] is List) {
        setState(() {
          _orderProducts = res['data']
              .map<Map<String, dynamic>>(
                  (e) => new Map<String, dynamic>.from(e))
              .toList();
        });
      }
    }

    _loading(true);
    fetchOrderDetails('${widget.orderId}').then(f);
  }

  void _loading(bool state) {
    setState(() {
      loading = state;
    });
  }

  void _loadDetails(int orderDetailId, int productId) {
    void f(res) {
      _loading(false);
      print(res);
      if (res is Map && res['data'] is List) {
        setState(() {
          _orderDetails = res['data']
              .map<Map<String, dynamic>>(
                  (e) => new Map<String, dynamic>.from(e))
              .toList();
        });
      }
    }

    _loading(true);
    fetchOrderDetailsSchedule('$orderDetailId', productId: '$productId')
        .then(f);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    f(Map schedule) {
      return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          onTap: () {
            print(schedule['productId']);
            _loadDetails(schedule['id'], schedule['productId']);
          },
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          title: Text(
            ' ${isNull(schedule['Product']['name'], replace: 'Product')}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Qty: ${schedule['quantity']} ${isNull(schedule['Product']['unit'], replace: 'unit')}'),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      );
    }

    f2(Map schedule) {
      return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          onTap: () {
            storage.setItem(STORAGE_SCHEDULE_LIST_KEY, schedule).then((_) {
              return Navigator.of(context).pushNamed('/schedule-list');
            }).then((value) => _loadProducts());
          },
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          title: Text(
            ' ${isNull(schedule['Product']['name'], replace: 'Product')}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Qty: ${schedule['quantity']} ${isNull(schedule['Product']['unit'], replace: 'unit')}'),
              SizedBox(
                height: 6,
              ),
              Text('schedule Date', style: TextStyle(color: textColor)),
              Text(
                ("${schedule['dateScheduled']} ( ${schedule['PlantTime']['timeSlot']} )"),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Icon(Icons.check_circle, size: 19, color: primaryColor),
                  Text(isNull(schedule['status'], replace: 'Status'),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 19,
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (_orderDetails.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    tooltip: "Back",
                    onPressed: () {
                      setState(() {
                        _orderDetails = [];
                      });
                    },
                    padding: EdgeInsets.zero,
                  ),
                  Text("Schedule list",
                      style: TextStyle(
                          color: noteColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: _orderDetails.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    final Map newSchedule = _orderDetails[index];
                    newSchedule['Product'] =
                        _orderDetails[index]['OrderDetail']['Product'];
                    return f2(newSchedule);
                  }))
        ],
      );
    } else if (_orderProducts.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Product list",
                style: TextStyle(
                    color: noteColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: _orderProducts.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return f(_orderProducts[index]);
                  }))
        ],
      );
    } else {
      return Center(
        child: Text('Empty'),
      );
    }
  }
}
