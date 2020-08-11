import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/timehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

// Notification screen
class OrdersPage extends StatefulWidget {
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  bool _loading;
  String _name = "All";
  List<dynamic> _orders = [];
  List<Map<String, dynamic>> _cacheOrder = [];
  final TextEditingController startDateController = new TextEditingController();
  final TextEditingController endDateController = new TextEditingController();
  final TextEditingController amountController = new TextEditingController();
  final TextEditingController refController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    filters.add(amountAndRefFilter);
  }

  List<Widget> filters = [];

  filter() {
    List filter = List.from(_cacheOrder);
    if (filters.length > 1) {
      filter.removeWhere((e) {
        bool remove = false;
        var tDate = DateTime.tryParse(e['createdAt']);
        var startDate = DateTime.tryParse(startDateController.text);
        var endDate = DateTime.tryParse(endDateController.text);
        final Duration sub = Duration(hours: 23);
        if (tDate != null && startDate != null && endDate != null) {
          if (tDate.toLocal().isBefore(startDate.subtract(sub)) ||
              tDate.toLocal().isAfter(endDate.add(sub))) remove = true;
        } else if (tDate != null &&
            startDate != null &&
            tDate.toLocal().isBefore(startDate.subtract(sub))) {
          remove = true;
        } else if (tDate != null &&
            endDate != null &&
            tDate.toLocal().isAfter(endDate.add(sub))) {
          remove = true;
        }

        if (amountController.text != '' &&
            amountController.text != '0.00' &&
           oCcy.format(e['totalPrice'] +
                e['shippingFee']) != amountController.text) {
          remove = true;
        }
        if (refController.text != '' &&
            e['id'].toString() != refController.text.trim()) {
          remove = true;
        }
        return remove;
      });
    } else {
      filter.removeWhere((e) {
        bool remove = false;
        if (amountController.text != '' &&
            amountController.text != '0.00' &&
            oCcy.format(e['totalPrice'] +
                e['shippingFee']) != amountController.text) {
          remove = true;
        }
        if (refController.text != '' &&
            e['id'].toString() != refController.text.trim()) {
          remove = true;
        }
        return remove;
      });
    }

    filter.insert(0, transFilter);
    setState(() {
      _name = "All";
      _orders = filter;
    });
  }

  toggleFilter() {
    if (filters.length > 1) {
      setState(() {
        filters = [amountAndRefFilter];
        _orders.removeAt(0);
        _orders.insert(0, transFilter);
      });
    } else {
      setState(() {
        filters = [amountAndRefFilter, dateFilter];
        _orders.removeAt(0);
        _orders.insert(0, transFilter);
      });
    }
  }

  onEditDate(e, TextEditingController controller) {
    try {
      e = e.replaceAll('-', '');
      final date = [];
      if (e.length > 8) {
        e = e.substring(0, 8);
      }

      if (e.length >= 6) {
        date.add(e.substring(0, 4));
        date.add(e.substring(4, 6));
        date.add(e.substring(6, e.length));
      } else if (e.length >= 4) {
        date.add(e.substring(0, 4));
        date.add(e.substring(4, e.length));
      } else {
        date.add(e.substring(0, e.length));
      }
      controller.text = date.join('-');
      if (e.length == 4 || e.length == 6) {
        controller.selection = TextSelection.fromPosition(TextPosition(
          offset: controller.text.length - 1,
          affinity: TextAffinity.upstream,
        ));
      } else {
        controller.selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
      }
    } catch (e) {
      controller.text = '';
      controller.selection = TextSelection.fromPosition(
        TextPosition(
            offset: controller.text.length, affinity: TextAffinity.upstream),
      );
    }
  }

  onEditAmount(e, TextEditingController controller) {
    try {
      String amount = e.replaceAll(',', '').replaceAll('.', '');
      amount = amount.substring(0, amount.length - 2) +
          '.' +
          amount.substring(amount.length - 2, amount.length);
      controller.text = oCcy.format(num.tryParse(amount));

      if (e.length == 4 || e.length == 6) {
        controller.selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller.text.length - 1,
            affinity: TextAffinity.upstream,
          ),
        );
      } else {
        controller.selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
      }
    } catch (e) {
      controller.text = '0.00';
      controller.selection = TextSelection.fromPosition(
        TextPosition(
          offset: controller.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
    }
  }

  startDateOnChange(e) {
    onEditDate(e, startDateController);
  }

  endDateOnChange(e) {
    onEditDate(e, endDateController);
  }

  amountOnChange(e) {
    onEditAmount(e, amountController);
  }

  Widget get amountAndRefFilter => Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              key: Key('amount'),
              controller: amountController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: '1,000.00',
              ),
              onChanged: amountOnChange,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: TextField(
              key: Key('reference'),
              controller: refController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Ref',
                hintText: 'trn_23WEWDWWE',
              ),
            ),
          ),
        ],
      );

  Widget get dateFilter => Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              key: Key('startdate'),
              controller: startDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Start date',
                hintText: 'yyyy-mm-dd',
              ),
              onChanged: startDateOnChange,
              maxLength: 10,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: TextField(
              key: Key('enddate'),
              controller: endDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'End date',
                hintText: 'yyyy-mm-dd',
              ),
              onChanged: endDateOnChange,
              maxLength: 10,
            ),
          ),
        ],
      );

  toggleFilterView() {
    setState(() {
      if (_orders.elementAt(0) is Widget) {
        _orders.removeAt(0);
      } else {
        _orders.insert(0, transFilter);
      }
    });
  }

  Widget get transFilter => Card(
        elevation: 3.0,
        key: Key('transFilter'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        child: ListTile(
//        title: Text('Filter'),
          title: Column(children: filters),
          trailing: IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: toggleFilter,
          ),
          subtitle: FlatButton(
            color: primaryColor,
            child: Text(
              'Filter',
              style: TextStyle(color: primaryTextColor),
            ),
            onPressed: filter,
          ),
        ),
      );

  void _loadOrder() {
    f(res) {
      if (res is Map && res['data'] is List) {
        // print(res['data']);
        setState(() {
          _cacheOrder = res['data']
              .map<Map<String, dynamic>>(
                  (e) => new Map<String, dynamic>.from(e))
              .toList();
          _orders = res['data']
              .map<dynamic>((e) => new Map<String, dynamic>.from(e))
              .toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    }

    fetchOrders().then(f);
  }

  void _sort(n) {
    List<Map<String, dynamic>> orders = [];

    f(order) {
      if (order['status'] == n) {
        orders.add(order);
      }
    }

    if (n == "All") {
      orders = _cacheOrder;
    } else {
      _cacheOrder.forEach(f);
    }
    setState(() {
      _name = n;
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      _loadOrder();
    }
    Widget _builList() {
      Widget f(e) {
        if (e is Widget) {
          return e;
        }
        DateTime _date = DateTime.parse(e['createdAt']).toLocal();
        return Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                storage.setItem(STORAGE_ORDER_KEY, e).then((re) =>
                    Navigator.pushNamed(
                        context, '/order/' + e['id'].toString()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Order#" + e['id'].toString(),
                              style: TextStyle(
                                  color: noteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  textBaseline: TextBaseline.alphabetic)),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.0),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text('Placed on: ',
                                        style: TextStyle(
                                            color: noteColor,
                                            fontSize: 15,
                                            textBaseline:
                                                TextBaseline.alphabetic)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 3.0),
                                  ),
                                  Expanded(
                                      child: Text(Bart.myDate(_date),
                                          style: TextStyle(
                                              color: noteColor,
                                              fontSize: 20,
                                              textBaseline:
                                                  TextBaseline.alphabetic)))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.0),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text('Total',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            textBaseline:
                                                TextBaseline.alphabetic)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 3.0),
                                  ),
                                  Expanded(
                                      child: Text(
                                          CURRENCY['sign'] +
                                              ' ' +
                                              oCcy.format(e['totalPrice'] +
                                                  e['shippingFee']),
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              textBaseline:
                                                  TextBaseline.alphabetic)))
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Icon(Icons.check_circle,
                                  size: 19, color: primaryColor),
                              Text(e['status'],
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 19,
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      )),
                    )
                  ],
                ),
              )),
        );
      }

      return _loading
          ? Center(child: CircularProgressIndicator())
          : _orders.length == 0
              ? Center(
                  child: Text('Empty list'),
                )
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return f(_orders[index]);
                  });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "My Orders",
            style: TextStyle(color: liteTextColor),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: toggleFilterView,
            )
          ],
          iconTheme: IconThemeData(color: liteTextColor),
          backgroundColor: liteColor,
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.99),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: liteColor,
              child: Center(
                  child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _sort("All");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    color: _name == 'All' ? primaryColor : liteColor,
                    child: Text(
                      'All',
                      style: TextStyle(
                          color: _name == 'All'
                              ? primaryTextColor
                              : liteTextColor),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _sort("Pending");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    color: _name == 'Pending' ? primaryColor : liteColor,
                    child: Text(
                      'Pending',
                      style: TextStyle(
                          color: _name == 'Pending'
                              ? primaryTextColor
                              : liteTextColor),
                    ),
                  ),
//                        FlatButton(
//                          onPressed: (){
//                            _sort("Processing");
//                          },
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(5))
//                          ),
//                          color: _name=='Processing'?primaryColor:liteColor,
//                          child: Text('Processing',style: TextStyle(color: _name=='Processing'?primaryTextColor:liteTextColor),),
//                        ),
                  FlatButton(
                    onPressed: () {
                      _sort("Completed");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    color: _name == 'Completed' ? primaryColor : liteColor,
                    child: Text(
                      'Completed',
                      style: TextStyle(
                          color: _name == 'Completed'
                              ? primaryTextColor
                              : liteTextColor),
                    ),
                  )
                ],
              )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                child: _builList(),
              ),
            )
          ],
        ));
  }
}
