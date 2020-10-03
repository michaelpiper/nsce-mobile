import 'package:intl/intl.dart';

class Bart {
  String format;
  DateTime _now;
  DateFormat formatter;
  String formatted;

  Bart(date, {this.format}) {
    if (date is DateTime) {
      _now = date.toUtc();
    } else {
      _now = DateTime.parse(date);
      _now = _now.toUtc();
    }
    formatter = new DateFormat(format);
    formatted = formatter.format(_now);
  }

  static myDate(DateTime _date) {
    _date = _date.toLocal();
    return "${_date.day}-${_date.month}-${_date.year} ${_date.hour > 12 ? _date.hour - 12 : _date.hour > 9 ? _date.hour : "0${_date.hour}"}:${_date.minute > 9 ? _date.minute : "0${_date.minute}"} " +
        (_date.hour > 12 ? 'p' : 'a') +
        "m";
  }

  addYear(int a) {
    _now = _now.add(Duration(days: a * 365));
  }

  addMonth(int a) {
    _now = _now.add(Duration(days: a * 30));
  }

  addDay(int a) {
    _now = _now.add(Duration(days: a));
  }

  addHour(int a) {
    _now = _now.add(Duration(hours: a));
  }

  addMinute(int a) {
    _now = _now.add(Duration(minutes: a));
  }

  addSecond(int a) {
    _now = _now.add(Duration(seconds: a));
  }

  addMSecond(int a) {
    _now = _now.add(Duration(microseconds: a));
  }

  subYear(int a) {
    _now = _now.subtract(Duration(days: a * 365));
  }

  subMonth(int a) {
    _now = _now.subtract(Duration(days: a * 30));
  }

  subDay(int a) {
    _now = _now.subtract(Duration(days: a));
  }

  subHour(int a) {
    _now = _now.subtract(Duration(hours: a));
  }

  subMinute(int a) {
    _now = _now.subtract(Duration(minutes: a));
  }

  subSecond(int a) {
    _now = _now.subtract(Duration(seconds: a));
  }

  subMSecond(int a) {
    _now = _now.subtract(Duration(microseconds: a));
  }

  diff(DateTime now) {}

  diffHuman(DateTime now) {
    var diff = 0;
    String text = "ago";
    if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour == now.hour &&
        _now.minute == now.minute &&
        _now.second == now.second) {
      return "just now";
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour == now.hour &&
        _now.minute == now.minute &&
        _now.second < now.second) {
      diff = now.second - _now.second;
      if (diff == 1) {
        return "a second " + text;
      }
      return diff.toString() + " seconds " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour == now.hour &&
        _now.minute < now.minute) {
      diff = now.minute - _now.minute;
      if (diff == 1) {
        return "a minute " + text;
      }
      return diff.toString() + " minutes " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour < now.hour) {
      diff = now.hour - _now.hour;
      if (diff == 1) {
        return "an hour " + text;
      }
      return diff.toString() + " hours " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day < now.day) {
      diff = now.day - _now.day;
      if (diff == 1) {
        return "a day " + text;
      }
      return diff.toString() + " days " + text;
    } else if (_now.year == now.year && _now.month < now.month) {
      diff = now.month - _now.month;
      if (diff == 1) {
        return "a month " + text;
      }
      return diff.toString() + " months " + text;
    } else if (_now.year < now.year) {
      diff = now.year - _now.year;
      if (diff == 1) {
        return "a year " + text;
      }
      return diff.toString() + " years " + text;
    } else {
      return formatter.format(_now);
    }
  }

  fromHuman(DateTime now) {
    var diff = 0;
    String text = "from now";
    if (_now.year > now.year) {
      diff = _now.year - now.year;
      if (diff == 1) {
        return "a year " + text;
      }
      return diff.toString() + " years " + text;
    } else if (_now.year == now.year && _now.month > now.month) {
      diff = _now.month - now.month;
      if (diff == 1) {
        return "a month " + text;
      }
      return diff.toString() + " months " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day > now.day) {
      diff = _now.day - now.day;
      if (diff == 1) {
        return "a day " + text;
      }
      return diff.toString() + " days " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour > now.hour) {
      diff = _now.hour - now.hour;
      if (diff == 1) {
        return "an hour " + text;
      }
      return diff.toString() + " hours " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour == now.hour &&
        _now.minute > now.minute) {
      diff = _now.minute - now.minute;
      if (diff == 1) {
        return "a minute " + text;
      }
      return diff.toString() + " minutes " + text;
    } else if (_now.year == now.year &&
        _now.month == now.month &&
        _now.day == now.day &&
        _now.hour == now.hour &&
        _now.minute == now.minute &&
        _now.second > now.second) {
      diff = _now.second - now.second;
      if (diff == 1) {
        return "a second " + text;
      }
      return diff.toString() + " seconds " + text;
    } else {
      return formatter.format(_now);
    }
  }

  diffNow() {
    DateTime now = new DateTime.now();
    now = now.toUtc();
    return this.diffHuman(now);
  }

  fromNow() {
    DateTime now = new DateTime.now();
    return this.fromHuman(now);
  }
}
