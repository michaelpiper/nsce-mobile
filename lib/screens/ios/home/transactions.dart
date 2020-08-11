import 'package:NSCE/services/dialog.dictionary.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../services/request.dart';
import 'package:intl/intl.dart';
import '../../../utils/timehelper.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';

// third screen
class TransactionsScreen extends StatefulWidget {
  final int length;

  TransactionsScreen({Key key, this.length}) : super(key: key);

  @override
  _TransactionsScreen createState() => new _TransactionsScreen();
}

class _TransactionsScreen extends State<TransactionsScreen> {
  List transList;
  bool _loadingIndicator;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final TextEditingController startDateController = new TextEditingController();
  final TextEditingController endDateController = new TextEditingController();
  final TextEditingController amountController = new TextEditingController();
  final TextEditingController refController = new TextEditingController();
  List data;
  List<Widget> filters = [];

  filter() {
    List filter = List.from(data);
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
            oCcy.format(e['amount']) != amountController.text) {
          remove = true;
        }
        if (refController.text != '' &&
            e['trnRef'] != refController.text.trim()) {
          remove = true;
        }
        return remove;
      });
    } else {
      filter.removeWhere((e) {
        bool remove = false;
        if (amountController.text != '' &&
            amountController.text != '0.00' &&
            oCcy.format(e['amount']) != amountController.text) {
          remove = true;
        }
        if (refController.text != '' &&
            e['trnRef'] != refController.text.trim()) {
          remove = true;
        }
        return remove;
      });
    }
    filter = buildList(filter);
    filter.insert(0, transFilter);
    setState(() {
      transList = filter;
    });
  }

  toggleFilter() {
    if (filters.length > 1) {
      setState(() {
        filters = [amountAndRefFilter];
        transList.removeAt(0);
        transList.insert(0, transFilter);
      });
    } else {
      setState(() {
        filters = [amountAndRefFilter, dateFilter];
        transList.removeAt(0);
        transList.insert(0, transFilter);
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

  List<Widget> buildList(List data) {
    List<Widget> listToPush = [];
    data.forEach((list) {
      String type;
      String subtile;
      Color color;
      if (list['typeId'] == 1) {
        type = dialogDictionary.creditToWallet;
        subtile = " ";
        color = Colors.black45;
      } else {
        type = dialogDictionary.debitToWallet;
        subtile = '#' + list['trnRef'];
        color = Colors.orangeAccent;
      }
      var now = DateTime.parse(list['createdAt']);
      var bart = Bart(now);
      String formatted = bart.diffNow();
      listToPush.add(Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        child: ListTile(
          onTap: () {
            storage.setItem(STORAGE_TRANSACTION_KEY, list).then((v) {
              Navigator.of(context)
                  .pushNamed('/transaction/' + list['id'].toString());
            });
          },
          title: Row(
            children: <Widget>[
              Text(type),
              SizedBox(
                width: 10,
              ),
              Text(
                subtile,
                style: TextStyle(color: color),
              )
            ],
          ),
          subtitle: Text(formatted),
          trailing: Text(CURRENCY['sign'] + ' ' + oCcy.format(list['amount']),
              style: TextStyle(color: color)),
        ),
      ));
    });
    return listToPush;
  }

  _TransactionsScreen() {
    fetchTrn().then((tran) {
      if (tran != false && tran['error'] == false) {
        data = tran['data'];
//
        List<Widget> listToPush = buildList(data);
        setState(() {
          _done();
          if (widget.length != null) {
            int len = widget.length > listToPush.length
                ? listToPush.length
                : widget.length;
            transList = listToPush.sublist(0, len).toList();
            if (transList.length <= 0) {
              transList.add(Text(
                'No transaction',
                textAlign: TextAlign.center,
              ));
            }
          } else {
            transList = listToPush.toList();
            transList.insert(0, transFilter);
            if (transList.length <= 0) {
              transList.add(Text(
                'No transaction',
                textAlign: TextAlign.center,
              ));
            }
          }
        });
      }
    });
  }

  Future _done() async {
    await Future.delayed(new Duration(seconds: 1));
    _dataLoaded();
  }

  void _dataLoaded() {
    setState(() {
      _loadingIndicator = false;
    });
  }

  @override
  initState() {
    super.initState();
    _loadingIndicator = true;
    filters.add(amountAndRefFilter);
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingIndicator) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return transList.length == 0
        ? Center(child: Text('No transaction'))
        : Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: transList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return transList[index];
              },
            ),
          );
  }
}
