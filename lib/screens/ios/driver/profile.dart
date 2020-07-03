import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/driver_request.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/colors.dart';
// third screen

class DriverProfilePage extends StatefulWidget {
  DriverProfilePage({Key key}) : super(key: key);

  @override
  _DriverProfilePage createState() => new _DriverProfilePage();
}

class _DriverProfilePage extends State<DriverProfilePage>
    with TickerProviderStateMixin {
  Map _userDetails;
  bool _loadingDispatchIndicator = true;
  List<Map> _dispatchList;
  double ratings = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dispatchList = [];
    _loadDispatch();
    onValue(v) {
      setState(() {
        _userDetails = v;
      });
    }

    fetchDispatch(id: 'ratings').then(_updateRating);
    AuthService.getUserDetails().then(onValue);
  }

  _updateRating(data) {
    if (data is Map && data['data'] is Map && data['data']['ratings'] != null) {
      setState(() {
        _ratings(data['data']['ratings']);
      });
    }
  }

  _ratings(num state) {
    setState(() {
      ratings = state.toDouble();
    });
  }

  void _loadDispatch() {
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
    fetchDispatch(id: 'completed').then(fn).catchError((e) {
      // print(e);
    });
  }

  void _dispatchLoaded({bool state: true}) {
    setState(() {
      _loadingDispatchIndicator = !state;
    });
  }

  Widget _avatar() {
    ImageProvider bgIm;
    if (_userDetails['image'] == null || _userDetails['image'] == '') {
      bgIm = AssetImage('images/avatar.png');
    } else {
      bgIm = NetworkImage(baseURL('${_userDetails['image']}'));
    }

    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: CircleAvatar(
        backgroundImage: bgIm,
      ),
    );
  }

  void updateAvailability() {
    f(resp) {
      print(resp);
      if (resp is bool || resp is Map && resp['error'] == true) {
        showDialog(
          context: context,
          child: SmartAlert(
            title: "Alert",
            description: 'No vehicle on transit',
          ),
        );
        return;
      } else if (resp is Map && resp['message'] != null) {
        showDialog(
          context: context,
          child: SmartAlert(
            title: "Alert",
            description: resp['message'],
          ),
        );
        return;
      }
      showDialog(
        context: context,
        child: SmartAlert(
          title: "Alert",
          description: 'Vehicle reported as arrived',
        ),
      );
      updateVehicleStatus(resp['Vehicle']['id']);
    }

    getVehicleStatus().then(f);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _buildHead() {
      const space = const SizedBox(
        height: 10,
      );
      return Column(
        children: <Widget>[
          Text(
            (_userDetails['firstName'] ?? '') +
                ' ' +
                (_userDetails['lastName'] ?? ''),
          ),
          space,
          Text(_userDetails['phone'] ?? ''),
          space,
          Text('Ratings'),
          space,
          RatingBarIndicator(
            rating: ratings,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
        ],
      );
    }

    Widget _buildDispatch() {
      Widget f(element) {
        DateTime _date = DateTime.parse(element['dateScheduled'] ?? '');
        return Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
                title: Text(
                  "Dispatch#${element['id']}",
                  style: TextStyle(color: primaryColor),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text('Delivery Date'),
                          Text(
                            "${_date.day}-${short_month[_date.month]}-${_date.year}",
                            style: TextStyle(color: noteColor),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text(
                            'Delivered',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      }

      if (_dispatchList.length == 0) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text("No dispatch delivered yet."),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          shrinkWrap: true,
          children: _dispatchList.map<Widget>(f).toList(),
        ),
      );
    }

    Widget _reportAvailability() {
      return Container(
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: updateAvailability,
          padding: EdgeInsets.all(10),
          color: primaryColor,
          child: Text(
            'Report Availability',
            style: TextStyle(color: primaryTextColor),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
    }

    _buildBody() {
      final Size size = MediaQuery.of(context).size;
      return _userDetails == null
          ? Container()
          : Stack(
              children: <Widget>[
                Positioned(
                  top: 40,
                  width: size.width,
                  height: size.height - 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryTextColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: ListView(
                        children: <Widget>[
                          _buildHead(),
                          Divider(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _reportAvailability(),
                          _buildDispatch(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    child: _avatar(),
                    alignment: Alignment.center,
                  ),
                  height: 100,
                  width: size.width,
                ),
              ],
            );
    }

    _buildActions() {
      return <Widget>[
        SizedBox(
          height: 25.0,
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: InkWell(
            onTap: () {
              Provider.of<AuthService>(context).logout();
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: primaryTextColor),
            ),
          ),
        ),
        SizedBox(
          width: 25.0,
        ),
      ];
    }

    return Scaffold(
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
      backgroundColor: primaryColor,
      body: _buildBody(),
    );
  }
}
