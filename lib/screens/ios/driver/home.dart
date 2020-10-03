import 'dart:async';
import 'dart:io';
import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/services/driver_request.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';

// third screen
import 'package:geolocator/geolocator.dart';
import 'package:device_id/device_id.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatefulWidget {
  DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePage createState() => new _DriverHomePage();
}

class _DriverHomePage extends State<DriverHomePage> {
  List<Map<String, dynamic>> _dispatchList = [];
  String _title = 'Task';
  Map _userDetails = {};
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _loadingDispatchIndicator = true;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Timer _timer;

  init() async {
    final geoLocator = Geolocator();
    final locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    String deviceId = await DeviceId.getID;
    String device =
        Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'others';
//    StreamSubscription<Position> positionStream =
    Position position = await geoLocator.getCurrentPosition();
    updateUserLocation({
      'device': device,
      'deviceId': deviceId,
      'longitude': position.longitude.toString(),
      'latitude': position.latitude.toString()
    });
//    print('[location] - ${position.longitude.toString()}, ${position.latitude.toString()}');
    geoLocator.getPositionStream(locationOptions).listen((Position position) {
//      print('[deviceId] - $deviceId');
//      print('[location] - $position');
      if (position != null) {
        updateUserLocation({
          'device': device,
          'deviceId': deviceId,
          'longitude': position.longitude.toString(),
          'latitude': position.latitude.toString()
        });
      }
    });
    //
    // 2.  Configure the plugin
    //
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    init();
    _loadDispatch();
    onValue(v) {
      debugPrint('==================================');
      setState(() {
        _userDetails = v;
      });
    }

    AuthService.getUserDetails().then(onValue);
    _timer = new Timer.periodic(const Duration(seconds: 5), _checkLogin);
  }

  void _checkLogin(Timer timer) {
    AuthService.getAccount(id: "id").then((value) {
      if (value == false || value['error'] == true) {
        Provider.of<AuthService>(context).logout();
        timer.cancel();
      }
    });
  }

  _updateDispatch(dispatch) {
    print(dispatch);
    if (dispatch != null) {
      int idx = _dispatchList
          .indexWhere((element) => element['id'] == dispatch['id']);
      if (idx == -1) return;
      setState(() {
        _dispatchList[idx] = dispatch;
      });
    }
  }

  _buildDispatch() {
    f(e) {
      print(e);
      DateTime _datee = DateTime.parse(e['dateScheduled'] ?? '');
      return InkWell(
        onTap: () {
          storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, e).then((val) {
            return Navigator.pushNamed(
                context, '/driver-dispatch/' + e['id'].toString());
          }).then(_updateDispatch);
        },
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
                          "${_datee.day}-${short_month[_datee.month]}-${_datee.year}",
                          style: TextStyle(color: noteColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          isNull(e['status'], replace: ''),
                          style: TextStyle(color: primaryColor),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      );
    }

    return _dispatchList.map<Widget>(f).toList();
  }

  get _empty => Container(
        child: Center(
          child: Text('Disptach list is empty'),
        ),
      );

  _buildBody() {
    return Container(
      child: ListView(
        children: _dispatchList.length == 0 ? [_empty] : _buildDispatch(),
      ),
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
      SizedBox(
        height: 25.0,
      ),
      Text(
        _title,
        style: TextStyle(
          color: primaryTextColor,
        ),
      ),
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

  Future<Null> _loadDispatch() async {
    refreshKey.currentState?.show(atTop: false);
    _dispatchList = [];
    fn(res) {
      _dispatchLoaded();
      if (res is Map && res['data'] is List) {
        setState(() {
          _dispatchList = res['data']
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    }

    _dispatchLoaded(state: false);
    fetchDispatch().then(fn).catchError((e) {
      // print(e);
    });
    AuthService.getAccount(id: "id").then((value) {
      if (value == false || value['error'] == true) {
        Provider.of<AuthService>(context).logout();
      }
    });
    return null;
  }

  void _dispatchLoaded({bool state: true}) {
    setState(() {
      _loadingDispatchIndicator = !state;
    });
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Do you want to exit this application?'),
            content: new Text('We hate to see you leave...'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
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
        body: RefreshIndicator(
          key: refreshKey,
          child: _loadingDispatchIndicator
              ? Center(child: Loading())
              : _buildBody(),
          onRefresh: _loadDispatch,
        ),
      ),
    );
  }
}
