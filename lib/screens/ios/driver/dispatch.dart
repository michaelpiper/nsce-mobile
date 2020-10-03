import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/services/driver_request.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/ext/dialogman.dart';
// third screen

class DriverDispatchPage extends StatefulWidget {
  final int index;

  DriverDispatchPage({Key key, this.index: 0}) : super(key: key);

  @override
  _DriverDispatchPage createState() => new _DriverDispatchPage();
}

class _DriverDispatchPage extends State<DriverDispatchPage> {
  int index;
  String _title = 'Task';
  Map _dispatch;
  Map _userDetails = {};
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final DialogMan dialogMan = DialogMan(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator())));
  final geoLocator = Geolocator();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.index = widget.index;
    _dispatch = storage.getItem(STORAGE_DRIVER_DISPATCH_KEY);
    onValue(v) {
      debugPrint('==================================');
      setState(() {
        _userDetails = v;
      });
    }

    AuthService.getUserDetails().then(onValue);
  }

  _calculateDistance() async {
    dialogMan.show();
    Position position = await geoLocator.getCurrentPosition();
    if (position == null) {
      dialogMan.hide();
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description: "Couldn't get driver location please turn on location",
        ),
      );
      return;
    }
    dynamic res = await distanceMatrix(
        origins: '${position.longitude}, ${position.latitude}',
        destinations:
            '${_dispatch['OrderDetail']['Order']['shippingAddress'] ?? ''}');
    if (res is bool ||
        res is Map && res['status'] == false ||
        res['data'] == null) {
      dialogMan.hide();
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description:
              "Couldn't calculate distance at of this time please try again.",
        ),
      );
      return;
    }
    final List matrix = res['data'];
    String text = 'Couldn\'t calculate distance.';
    if (matrix[0].length > 0 &&
        matrix[0] != null &&
        matrix[0] is Map &&
        matrix[0] != null &&
        matrix[0]['distance'] != null) {
      text = "Possible distance to destination is ";
      text += matrix[0]['distance']['text'] ?? '';
    }
    dialogMan.hide();
    showDialog(
      context: context,
      child: SmartAlert(
        title: "Alert",
        description: text,
      ),
    );
  }

  _fillHead(e) {
    DateTime _datee = DateTime.parse(e['dateScheduled'] ?? '');

    return InkWell(
      onTap: _calculateDistance,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dispatch#' + e['id'].toString(),
                  style: TextStyle(color: primaryColor),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  'Customer name',
                  style: TextStyle(color: secondaryTextColor),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  isNull(e['OrderDetail']['Order']['contactPerson'],
                      replace: 'Not provided'),
                  style: TextStyle(color: noteColor),
                ),
                Text(
                  'Address',
                  style: TextStyle(color: secondaryTextColor),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  isNull(e['OrderDetail']['Order']['shippingAddress'],
                      replace: 'Not provided'),
                  style: TextStyle(color: noteColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Vehicle',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Delivery Date',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      e['Vehicle'] == null
                          ? 'Vehicle not assigned'
                          : isNull(e['Vehicle']['uniqueIdentifier'],
                              replace: 'Not available'),
                      style: TextStyle(color: noteColor),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "${_datee.day}-${short_month[_datee.month]}-${_datee.year} ${e['timeScheduled']}",
                      style: TextStyle(color: noteColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAvailability() {
    f(id) {
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description: 'Vehicle reported as arrived',
        ),
      );
      updateVehicleStatus(id);
    }

    if (_dispatch['Vehicle'] == null) {
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description: 'No vehicle on transit',
        ),
      );
      return;
    }
    if (_dispatch['Vehicle']['status'] == "Available") {
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description: 'Vehicle already reported as available.',
        ),
      );
      return;
    }
    f(_dispatch['Vehicle']['id']);
  }

  _fillButton() {
    switch (_dispatch['status']) {
      case 'Completed':
        return Center(
            child: Column(
          children: <Widget>[
            Container(
              child: Text('Dispatch completed'),
            ),
            MaterialButton(
              onPressed: updateAvailability,
              color: primaryTextColor,
              child: Text(
                'Report Arrival',
                style: TextStyle(color: primaryColor),
              ),
              padding: EdgeInsets.all(10),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: primaryColor),
              ),
            ),
          ],
        ));
      case 'On-Transit':
      case 'Feedback':
      case 'Failed':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  dialogMan.show();
                  fn(res) {
                    dialogMan.hide();
                    setState(() {
                      _dispatch['status'] = 'Completed';
                    });
                    storage
                        .setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch)
                        .then((v) {});
                  }

                  updateDispatch(_dispatch['id'], {'status': 'Completed'})
                      .then(fn);
                },
                color: primaryColor,
                child: Text(
                  'Arrived',
                  style: TextStyle(color: primaryTextColor),
                ),
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              MaterialButton(
                onPressed: () async {
                  dialogMan.show();
                  await Future.delayed(Duration(seconds: 5), dialogMan.hide);
                  showDialog(context: context, builder: showQuickLinks).then(
                    (c) {
                      fn(res) {
                        if (_dispatch['status'] != 'Feedback') {
                          setState(() {
                            _dispatch['status'] = 'Feedback';
                          });
                          storage
                              .setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch)
                              .then((v) {});
                        }
                      }

                      if (c)
                        updateDispatch(_dispatch['id'], {'status': 'Feedback'})
                            .then(fn);
                    },
                  );
                },
                color: primaryTextColor,
                child: Text(
                  'Quick Links',
                  style: TextStyle(color: primaryColor),
                ),
                padding: EdgeInsets.all(10),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: primaryColor),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  dialogMan.show();
                  await Future.delayed(Duration(seconds: 5), dialogMan.hide);

                  showDialog(context: context, builder: showIssuesDialog)
                      .then((c) {
                    fn(res) {
                      dialogMan.hide();
                      if (_dispatch['status'] != 'Feedback') {
                        setState(() {
                          _dispatch['status'] = 'Feedback';
                        });
                        storage
                            .setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch)
                            .then((v) {});
                      }
                    }

                    if (c)
                      updateDispatch(_dispatch['id'], {'status': 'Feedback'})
                          .then(fn);
                  });
                },
                color: primaryTextColor,
                child: Text(
                  _dispatch['status'] != 'Feedback'
                      ? 'Report an Issue'
                      : 'Update',
                  style: TextStyle(color: primaryColor),
                ),
                padding: EdgeInsets.all(10),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: primaryColor),
                ),
              ),
            ],
          ),
        );
      case 'Pending':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: MaterialButton(
            onPressed: () {
              dialogMan.show();
              fn(res) {
                // print(res);
                dialogMan.hide();

                setState(() {
                  _dispatch['status'] = 'On-Transit';
                });
                storage
                    .setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch)
                    .then((v) {});
              }

              updateDispatch(_dispatch['id'], {'status': 'On-Transit'})
                  .then(fn);
            },
            color: primaryColor,
            child: Text(
              'Start',
              style: TextStyle(color: primaryTextColor),
            ),
            padding: EdgeInsets.all(10),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        );
      default:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: MaterialButton(
            onPressed: () {
              dialogMan.show();
              fn(res) {
                // print(res);
                dialogMan.hide();
                setState(() {
                  _dispatch['status'] = 'Completed';
                });
                storage
                    .setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch)
                    .then((v) {
                  Navigator.of(context).setState(() {});
                });
              }

              updateDispatch(_dispatch['id'], {'status': 'Completed'}).then(fn);
            },
            color: primaryColor,
            child: Text(
              'Completed',
              style: TextStyle(color: primaryTextColor),
            ),
            padding: EdgeInsets.all(10),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        );
    }
  }

  _buildBody() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _fillHead(_dispatch),
            Card(
              child: ListTile(
                title: Text('Contact Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_dispatch['OrderDetail']['Order']['contactPhone'] ??
                        'nil'),
                    Text(_dispatch['OrderDetail']['Order']['shippingAddress'] ??
                        'nil')
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Dispatch Status'),
                trailing: Text(_dispatch['status'] ?? 'Pending'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                    'Quantity: ${_dispatch['OrderDetail']['quantity']} ${_dispatch['OrderDetail']['Product']['unit'] ?? 'unit'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        'UnitPrice: ${CURRENCY['sign']} ${_dispatch['OrderDetail']['unitPrice']}'),
                    Text(
                        'ShippingFee: ${CURRENCY['sign']} ${_dispatch['OrderDetail']['shippingFee']}'),
                    Text(
                        'TotalPrice: ${CURRENCY['sign']} ${_dispatch['OrderDetail']['totalPrice']}'),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Product'),
                trailing:
                    Text(_dispatch['OrderDetail']['Product']['name'] ?? 'nil'),
              ),
            ),
            _fillButton()
          ],
        )
      ],
    );
  }

  Widget _avatar() {
    ImageProvider bgIm;
    if (_userDetails['image'] == null || _userDetails['image'] == '') {
      bgIm = AssetImage('images/avatar.png');
    } else {
      bgIm = NetworkImage(baseURL('${_userDetails['image']}'));
    }

    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: CircleAvatar(
        backgroundImage: bgIm,
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/driver-profile');
          },
          child: _avatar(),
        ),
      ),
      SizedBox(
        width: 25.0,
      ),
    ];
  }

  Dialog showQuickLinks(BuildContext context) {
    List<QuickLink> quickLinks = [
      QuickLink('i have an engine problem', 'Critical'),
      QuickLink('I am in heavy traffic', 'Medium'),
      QuickLink('I have police issue', 'Critical'),
      QuickLink('i have flat tire ', 'Medium'),
      QuickLink('i have all flat tire', 'Medium'),
    ];
    void send(QuickLink quickLink) {
      f(resp) {
        if (resp == false || resp is Map && resp['error'] == true) {
          showDialog(
            context: context,
            child: SmartAlert(
              title: 'Alert',
              description: 'Report not sent please try again.',
            ),
          );
          return;
        }
        if (resp is Map && resp['message'] != null) {
          showDialog(
            context: context,
            child: SmartAlert(
              title: 'Alert',
              description: resp['message'],
              onOk: () => Navigator.of(context).pop(true),
            ),
          );
          return;
        }
        showDialog(
          context: context,
          child: SmartAlert(
            title: 'Alert',
            description: 'Report sent.',
            onOk: () => Navigator.of(context).pop(true),
          ),
        );
      }

      reportIssue(
        _dispatch['id'],
        quickLink.message,
        priority: quickLink.priority,
      ).then(f);
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: quickLinks.length,
              itemBuilder: (context, idx) {
                QuickLink quickLink = quickLinks[idx];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => send(quickLink),
                        title: Text(quickLink.message),
                        subtitle: Text(quickLink.priority),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              },
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
      ),
    );
  }

  Dialog showIssuesDialog(BuildContext context) {
    String issues = '';
    void send() {
      f(resp) {
        if (resp == false || resp is Map && resp['error'] == true) {
          showDialog(
            context: context,
            child: SmartAlert(
              title: 'Alert',
              description: 'Report not sent please try again.',
            ),
          );
          return;
        }
        if (resp is Map && resp['message'] != null) {
          showDialog(
            context: context,
            child: SmartAlert(
              title: 'Alert',
              description: resp['message'],
              onOk: () => Navigator.of(context).pop(true),
            ),
          );
          return;
        }
        showDialog(
          context: context,
          child: SmartAlert(
            title: 'Alert',
            description: 'Report sent.',
            onOk: () => Navigator.of(context).pop(true),
          ),
        );
      }

      reportIssue(_dispatch['id'], issues).then(f);
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
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
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      hintText: 'Report an Issue'),
                  minLines: 4,
                  onChanged: (v) => issues = v,
                  maxLines: 5,
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
                  "",
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
                onTap: send,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Send",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    dialogMan.buildContext(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_dispatch);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: AppBar(
            elevation: 0,
            title: Row(
              children: _buildActions(),
            ),
            iconTheme: IconThemeData(color: primaryTextColor),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }
}

class QuickLink {
  final String message;
  final String priority;

  QuickLink(this.message, this.priority);
}
