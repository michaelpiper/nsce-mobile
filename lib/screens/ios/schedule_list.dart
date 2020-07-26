import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';

// Notification screen
class ScheduleListPage extends StatefulWidget {
  final int index;

  ScheduleListPage({this.index});

  @override
  _ScheduleListPageState createState() =>
      _ScheduleListPageState(index: this.index);
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final int index;

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String, dynamic> _schedule = {};
  Map<String, dynamic> _order = {};

  _ScheduleListPageState({this.index});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _schedule = storage.getItem(STORAGE_SCHEDULE_LIST_KEY);
    _order = storage.getItem(STORAGE_ORDER_KEY);
  }

  void setSch(val) {
    if (val != null && !(val is bool))
      storage.setItem(STORAGE_SCHEDULE_LIST_KEY, val).then((_) => setState(() {
            _schedule = val;
          }));
  }

  void openReschedule() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ReScheduleScreen(_schedule, order: _order)))
        .then(setSch);
  }

  Widget get reSchedule {
    DateTime _now = DateTime.now();
    DateTime _s = DateTime.parse(_schedule['dateScheduled']);
    if (_s.isAfter(_now) && _schedule['status'] == "Pending") {
      return SizedBox(
        height: 35,
        child: MaterialButton(
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Icon(
                  Icons.schedule,
                  color: primaryTextColor,
                ),
              ),
              Expanded(
                child: Text(
                  'Reschedule',
                  style: TextStyle(color: primaryTextColor),
                ),
              )
            ],
          ),
          onPressed: openReschedule,
        ),
      );
    }
    return null;
  }

  orderChangeDriverId() {
    showDialog(
      context: context,
      child: Dialog(
        child: TextField(
          onSubmitted: (e) {
            print(e);
            if (e.isNotEmpty) {
              print('==================== am here ===================');
              changeOrderDriverId(_order['id'].toString(), e);
              setState(() {
                _order['pickupDriverId'] = e;
                storage.setItem(STORAGE_ORDER_KEY, _order);
              });
            }
            Navigator.of(context).pop();
          },
          decoration: InputDecoration(
            hintText: 'Enter driver ID',
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }

  Widget get changeDriverId {
    DateTime _now = DateTime.now();
    DateTime _s = DateTime.parse(_schedule['dateScheduled']);
    if (_s.isAfter(_now) && _schedule['status'] == "Pending") {
      return InkWell(
        onTap: orderChangeDriverId,
        child: Text('Change'),
      );
    }
    return null;
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
              Text("Schedule # ${_schedule['id']}",
                  style: TextStyle(
                      color: noteColor,
                      fontSize: 16,
                      textBaseline: TextBaseline.alphabetic)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('item',
                          style: TextStyle(
                              color: noteColor,
                              fontSize: 15,
                              textBaseline: TextBaseline.alphabetic)),
                      Text('Quantity',
                          style: TextStyle(
                              color: noteColor,
                              fontSize: 15,
                              textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            '${isNull(_schedule['Product']['name'], replace: '')}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                                color: noteColor,
                                fontSize: 15,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      ),
                      Text(
                          '${_schedule['quantity']} ${isNull(_schedule['Product']['unit'], replace: 'unit')}'
                                  .toString() +
                              ' ',
                          style: TextStyle(
                              color: noteColor,
                              fontSize: 18,
                              textBaseline: TextBaseline.alphabetic,
                              fontWeight: FontWeight.w700))
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
                                color: noteColor,
                                fontSize: 14,
                                textBaseline: TextBaseline.alphabetic)),
                        Text(
                            _order['type'] == 'pickup'
                                ? "Pick up at Yard"
                                : "Site Delivery",
                            style: TextStyle(
                                color: noteColor,
                                fontSize: 18,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Distance',
                          style: TextStyle(
                            color: noteColor,
                            fontSize: 14,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
                        _order['type'] == 'pickup'
                            ? Container()
                            : FutureBuilder(
                                future: distanceProductMatrix(
                                    productId:
                                        '${_schedule['productId']}' ?? '',
                                    destinations: ' Lagos, Nigeria'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Map> snapshot) {
                                  String text = '';
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data is Map &&
                                      snapshot.data['error'] == false) {
                                    final List res = snapshot.data['data'];
                                    if (res[0].length > 0 &&
                                        res[0] != null &&
                                        res[0] is Map &&
                                        res[0] != null &&
                                        res[0]['distance'] != null) {
                                      text = res[0]['distance']['text'] ?? '';
                                    }
                                  }

                                  return Text(
                                    snapshot.hasData ? text : "Loading.....",
                                    style: TextStyle(
                                      color: noteColor,
                                      fontSize: 18,
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status',
                            style: TextStyle(
                                color: noteColor,
                                fontSize: 15,
                                textBaseline: TextBaseline.alphabetic)),
                        Text(_schedule['status'],
                            style: TextStyle(
                                color: noteColor,
                                fontSize: 18,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.w700)),
                      ],
                    )
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Schedule Date',
                    style: TextStyle(color: noteColor, fontSize: 15.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    ("${_schedule['dateScheduled']} ${_schedule['PlantTime']['timeSlot']}"),
                    style: TextStyle(color: noteColor, fontSize: 15.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total      ',
                      style: TextStyle(
                          color: noteColor,
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
                          color: noteColor,
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
        color: liteColor,
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
      if (_order['type'] == 'pickup') {
        return Card(
          child: ListTile(
            trailing: changeDriverId,
            title: Text('Pickup Driver Id'),
            subtitle: Text('${_order['pickupDriverId'] ?? ''}'),
          ),
        );
      }
      return Expanded(
        child: Dispatch(
          _schedule['id'],
          unit: _schedule['Product']['unit'],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Order # ${_order['id']}",
          style: TextStyle(color: primaryTextColor),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            head(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(_order['type'] == 'pickup' ? "" : "Dispatch list",
                  style: TextStyle(
                      color: noteColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left),
            ),
            SizedBox(
              height: 10,
            ),
            status(),
            SizedBox(
              height: 10,
            ),
          ]),
      floatingActionButton: reSchedule,
    );
  }
}

class Dispatch extends StatefulWidget {
  final int orderDetailId;
  final String unit;

  Dispatch(this.orderDetailId, {this.unit});

  @override
  _Dispatch createState() => _Dispatch();
}

class _Dispatch extends State<Dispatch> {
  bool loading;
  List<Map<String, dynamic>> _dispatches = [];
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
  }

  void _loadDispatch() {
    void f(res) {
      print(res);
      _loading(false);
      if (res is Map && res['data'] is List) {
        setState(() {
          _dispatches = res['data']
              .map<Map<String, dynamic>>(
                  (e) => new Map<String, dynamic>.from(e))
              .toList();
        });
      }
    }

    _loading(true);
    fetchOrderDispatch(id: 'scheduleId=${widget.orderDetailId}').then(f);
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
      _loadDispatch();
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    f(Map dispatch) {
      return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          onTap: () {
            dispatch['unit'] = widget.unit;
            storage.setItem(STORAGE_DISPATCH_KEY, dispatch).then((_) {
              Navigator.of(context).pushNamed('/dispatch/${dispatch['id']}');
            });
          },
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          title: Text(
              'Qty: ${dispatch['quantity']}  ${isNull(widget.unit, replace: 'unit')}'
                  .toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('scheduled',
                  style: TextStyle(color: textColor, fontSize: 12.0)),
              Text(
                ("${dispatch['dateScheduled']} ( ${dispatch['timeScheduled']} )"),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(color: textColor, fontSize: 15.0),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Text("View details",
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

    return _dispatches.length == 0
        ? Center(
            child: Text('Empty'),
          )
        : ListView.builder(
            itemCount: _dispatches.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return f(_dispatches[index]);
            });
  }
}

class ReScheduleScreen extends StatefulWidget {
  ReScheduleScreen(this.schedule, {@required this.order});

  final Map<String, dynamic> schedule;
  final Map<String, dynamic> order;

  @override
  _ReScheduleScreenState createState() => _ReScheduleScreenState();
}

class _ReScheduleScreenState extends State<ReScheduleScreen>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  Map schedule = {};
  Map order = {};
  List _selectedEvents = [];
  bool _loadingScheduleIndicator;
  String _message;
  int unit;
  int totalUnit;
  bool _continue;
  Map _reschedule;

  _ReScheduleScreenState();

  @override
  void initState() {
    super.initState();
    _continue = false;
    _loadingScheduleIndicator = true;
    final _selectedDay = DateTime.now();
    schedule = widget.schedule;
    if (widget.order != null) order = widget.order;
    print(schedule);
    print(order);
    _events = {};
    _calendarController = CalendarController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animationController.forward();
    unit = schedule['quantity'];
    totalUnit = 0;
    _loadSchedule(_selectedDay);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    debugPrint('Callback: _onDaySelected');
    _loadSchedule(day);
    debugPrint(events.toString());
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    debugPrint('Callback: _onVisibleDaysChanged');
  }

  void _warning(msg) {
    setState(() {
      _message = msg;
    });
  }

  Widget _buildEventList() {
    return SizedBox(
        height: 200,
        child: ListView(
          shrinkWrap: true,
          children: _selectedEvents
              .map<Widget>((event) => Container(
                    child: ListTile(
                      selected: false,
                      title:
                          Text(isNull(event['timeSlot'], replace: 'Time Slot')),
                      subtitle: Text(
                          '${event['quantityLeft']} ${isNull(schedule['Product']['unit'], replace: 'unit')} left'),
                      leading: Checkbox(
                        value: _events[_calendarController.selectedDay] !=
                                null &&
                            _events[_calendarController.selectedDay].any((e) {
                              return e['id'] == event['id'];
                            }),
                        onChanged: (_) {
                          if (_) {
                            Map<String, dynamic> item = {};
                            item['id'] = event['id'];
                            item['title'] = event['timeSlot'];
                            item['quantityLeft'] = event['quantityLeft'];
                            item['time'] = _calendarController.selectedDay;
                            _addSchd(item);
                          } else {
                            Map<String, dynamic> item = {};
                            item['id'] = event['id'];
                            item['title'] = event['timeSlot'];
                            item['quantityLeft'] = event['quantityLeft'];
                            item['time'] = _calendarController.selectedDay;
                            _removeSchd(item);
                          }
                          return _;
                        },
                      ),
                    ),
                  ))
              .toList(),
        ));
  }

  void _loadSchedule(DateTime day) {
    _scheduleLoaded(state: false);
    _warning(null);
    DateTime _check = day.toUtc();
    DateTime _now = DateTime.now().toUtc();
    if (_check.isBefore(_now)) {
      _scheduleLoaded();
      _warning("You can't choose previous date");
      return;
    }
    if (_check.day == _now.day &&
        _check.year == _now.year &&
        _check.month == _now.month) {
      _scheduleLoaded();
      _warning("You can't schedule for today");
      return;
    }
    String productId = schedule['Product']['id'].toString();
    scheduleOrder(
            {'productId': productId, 'schedule': _check.toIso8601String()})
        .then((schedules) {
      if (schedules == false || schedules == null) return;
      if (schedules['data'] is List) {
        List data = schedules['data'];
        setState(() {
          _selectedEvents = data;
          _scheduleLoaded();
        });
      } else {
        setState(() {
          _selectedEvents = [];
          _scheduleLoaded();
        });
      }
    });
  }

  void _scheduleLoaded({state = true}) {
    setState(() {
      _loadingScheduleIndicator = !state;
    });
  }

  void _removeSchd(item) {
    setState(() {
      _events[item['time']].removeWhere((e) {
        bool test = e['id'] == item['id'];
        if (test) {
          _reschedule = null;
          totalUnit -= e['qty'];
        }
        return test;
      });
    });
  }

  void _addSchd(item) {
    int qty = schedule['quantity'];
    if (totalUnit + unit > qty) {
      num _left = qty - totalUnit;
      String _msg;
      if (_left > 0) {
        _msg =
            "You have only $_left to schedule. you are trying to schedule more than 'Quantity Needed'";
      } else {
        _msg = "You have already scheduled all 'Quantity Needed'";
      }
      showDialog(
          context: context,
          child: SmartAlert(
            title: 'Alert',
            description: _msg,
          ));
      return;
    } else if (unit > item['quantityLeft']) {
      showDialog(
          context: context,
          child: SmartAlert(
            title: 'Alert',
            description:
                'You can only schedule ${item['quantityLeft']} for this time',
          ));
      return;
    }
    setState(() {
      if (_events[item['time']] == null) _events[item['time']] = [];
      totalUnit += unit;
      _reschedule = {
        'dateScheduled': item['time'],
        'plantTimeId': item['id'],
        'timeSlot': item['title'],
      };
      _events[item['time']].add({
        'id': item['id'],
        'time': item['time'],
        'title': item['title'],
        'qty': unit
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CalendarStyle _calendarStyle = CalendarStyle(
        selectedColor: primaryColor,
        todayColor: primarySwatch,
        markersColor: secondaryColor,
        outsideDaysVisible: false);
    HeaderStyle _headerStyle = HeaderStyle(
      formatButtonTextStyle:
          TextStyle().copyWith(color: primaryTextColor, fontSize: 15.0),
      formatButtonDecoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
    Widget _done = _continue == true
        ? Container()
        : InkWell(
            onTap: () {
              if (totalUnit == schedule['quantity']) {
                setState(() {
                  _continue = true;
                });
              } else {
                showDialog(
                    context: context,
                    child: SmartAlert(
                        title: 'Alert',
                        description:
                            'Schedule can\'t be made done until Quantity needed is equal to quantity scheduled.'));
              }
            },
            child: Text('Done', style: TextStyle(color: primaryColor)),
          );
    Widget _saveButton = Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
        child: MaterialButton(
          color: primaryColor,
          onPressed: () {
            if (_continue) {
              String id = '${schedule['id']}';
              String plantTimeId = '${_reschedule['plantTimeId']}';
              DateTime dateSchedule = _reschedule['dateScheduled'];
              fn(res) {
                print(res);
                if (res is Map && res['error'] == false) {
                  schedule['dateScheduled'] =
                      dateSchedule.toIso8601String().substring(0, 10);
                  schedule['plantTimeId'] = _reschedule['plantTimeId'];
                  schedule['PlantTime']['id'] = _reschedule['plantTimeId'];
                  schedule['PlantTime']['timeSlot'] = _reschedule['timeSlot'];
                  showDialog(
                      context: context,
                      child: SmartAlert(
                        title: 'Alert',
                        onOk: () => Navigator.of(context).pop(schedule),
                        description:
                            (res['message'] ?? "Rescheduled successfully."),
                      ));
                } else {
                  showDialog(
                      context: context,
                      child: SmartAlert(
                        title: 'Alert',
                        description: (res['message'] ?? "Can't reschedule."),
                      ));
                }
              }

              cartReschedule(
                      id: id,
                      schedule: dateSchedule.toIso8601String(),
                      plantTimeId: plantTimeId)
                  .then(fn);
            } else {
              showDialog(
                  context: context,
                  child: SmartAlert(
                    title: 'Alert',
                    description: "Reschedule not marked as done.",
                  ));
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(15.0, 15.0),
                  bottom: Radius.elliptical(15.0, 15.0)),
              side: BorderSide(
                color: primarySwatch,
              )),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 45.0),
          child: Text(
            'Reschedule',
            style: TextStyle(color: primaryTextColor),
          ),
        ));
    Widget _buildHead = Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: Text(
                        'Quantity needed',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                              '${schedule['quantity']}  ${isNull(schedule['Product']['unit'], replace: 'unit')}',
                              style: TextStyle(color: noteColor)))
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: noteColor,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: Text(
                        'Delivery address',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        order['type'] == 'pickup'
                            ? 'Pickup at yard'
                            : isNull(order['shippingAddress'], replace: ""),
                        style: TextStyle(color: noteColor),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
    Widget _calendar = Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        'Select Date',
                        style: TextStyle(color: noteColor),
                      ))
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  TableCalendar(
                    events: _events,
                    headerStyle: _headerStyle,
                    calendarStyle: _calendarStyle,
                    onDaySelected: _onDaySelected,
                    onVisibleDaysChanged: _onVisibleDaysChanged,
                    calendarController: _calendarController,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Text('Select Production time slot'),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  (_loadingScheduleIndicator
                      ? Center(child: CircularProgressIndicator())
                      : _message == null
                          ? _buildEventList()
                          : Center(
                              child: Text(
                                'Warning\n $_message',
                                style: TextStyle(color: rejectColor),
                                textAlign: TextAlign.center,
                              ),
                            )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[_done],
                  )
                ],
              ),
            ),
          )),
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Reschedule Delivery",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              _buildHead,
              _calendar,
              const SizedBox(
                height: 8.0,
              ),
              _saveButton
            ],
          ),
        ));
  }
}
