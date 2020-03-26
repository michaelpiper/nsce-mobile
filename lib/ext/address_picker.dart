import 'package:flutter/material.dart';
import "package:NSCE/services/request.dart";
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/ext/spinner.dart';
class AddressPicker extends StatefulWidget {
  final String initialValue;
  final Function onCancel;
  final Function onTap;
  final Function loadSearch;
  AddressPicker({this.initialValue,this.onTap,this.onCancel,this.loadSearch});
  @override
  _AddressPickerState createState() => new _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  var _controller;
  List <Map<String, dynamic>> _searchResult = [];
  bool _loading = false;
  Function _loadSearch;

  _AddressPickerState({Key key}) {
    if (widget.loadSearch == null) {
      _loadSearch = (e) {
        _changeLoading(true);
        f(search) {
          if (search is bool || search == null) {
            _changeSearchResult(<Map<String, dynamic>>[]);
          } else if (search['data'] is List) {
            List data = search['data'];
            _changeSearchResult(
                data.map<Map<String, dynamic>>((l) => l).toList());
          } else {
            _changeSearchResult(<Map<String, dynamic>>[]);
          }
          _changeLoading(false);
        }
        searchAddress(e).then(f);
      };
    }
  }

  _changeSearchResult(e) {
    setState(() {
      _searchResult = e;
    });
  }

  _changeLoading(bool state) {
    setState(() {
      _loading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    buildList(e) {
      return ListTile(
        title: Text(e['address']),
        onTap: () {
          widget.onTap(e);
        },
      );
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.of(context).pop(),
          ),

          centerTitle: false,
          automaticallyImplyLeading: false,
          title: TextField(
            controller: _controller,

            onChanged: (e) {
              _loadSearch(e);
            },
            onSubmitted: (e) {
              // print(e);
            },
            cursorColor: secondaryColor,
            style: TextStyle(
                color: primaryTextColor
            ),
            autofocus: true,
            decoration: const InputDecoration(
                hintText: "Search address?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 30.0,
                )
            ),
            textInputAction: TextInputAction.search,
          ),
          iconTheme: IconThemeData(color: primaryTextColor),
          actions: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: _loading ? Spinner(icon: Icons.sync) : SizedBox())
          ],
        ),
        body: Center(
            child: _searchResult.length == 0
                ? Text('Search result empty')
                : ListView(
              children: _searchResult.map(buildList).toList(),
            )
        )
    );
  }
}