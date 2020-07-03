import 'package:NSCE/ext/smartalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../ext/loading.dart';

// Notification screen
class MaterialCalculatorPage extends StatefulWidget {
  final int index;

  MaterialCalculatorPage({this.index});

  @override
  _MaterialCalculatorPageState createState() =>
      _MaterialCalculatorPageState(index: this.index);
}

class _MaterialCalculatorPageState extends State<MaterialCalculatorPage>
    with TickerProviderStateMixin {
  _MaterialCalculatorPageState({this.index});

  final int index;
  bool loading;
  bool showResult;
  Map<String, bool> use = {};
  Map<String, num> form = {};
  List<ProductType> products = [];
  Set<String> params;
  bool checkboxIsVisible;
  final _formKey = GlobalKey<FormState>();
  String disclaimer =
      'Please note that this might not be used as final value for product calculation, recommendations are subject to the material team';
  num calculateResult;

  int active;

  @override
  void initState() {
    super.initState();
    loading = false;
    showResult = false;
    checkboxIsVisible = true;
    calculateResult = 0;
    params = Set();
    params.add('Area');
    params.add('Length');
    params.add('Breath');
    params.add('Thickness');
    params.forEach((e) => use[e] = false);
    products = [
      ProductType({
        'avatar': 'images/asphalt.png',
        'title': 'Asphalt',
        'constant': 2.69,
      }),
      ProductType({
        'avatar': 'images/stones.png',
        'title': 'Stones',
        'constant': 1.84,
      }),
      ProductType({
        'avatar': 'images/concrete.png',
        'title': 'Concrete',
        'constant': 3.048
      })
    ];
  }

  _use(String param) {
    return use[param];
  }

  _inUse(String param) {
    return use[param] == true;
  }

  _changeUse(String param) {
    f(bool state) {
      setState(() {
        use[param] = state;
      });
      return use[param];
    }

    return f;
  }

  animate(int idx) {
    int adx = (products.length / 2).floor();
    ProductType productActive = products[idx];
    ProductType productPrevActive = products[adx];
    setState(() {
      products[idx] = productPrevActive;
      products[adx] = productActive;
      active = adx;
      if (showResult && products[adx].title == "Concrete")
        form['Wastage /Shrinkage Allowance(%)'] = 0;
      else
        form.removeWhere(
            (key, value) => key == 'Wastage /Shrinkage Allowance(%)');
    });
  }

  tryCalculate() {
    if (use['Area'] && !use['Length'] && !use['Breath'] && use['Thickness'] ||
        !use['Area'] && use['Length'] && use['Breath'] && use['Thickness']) {
      setState(() {
        loading = true;
        showResult = true;
        form = {};
        use.forEach((key, value) {
          if (value == true) form[key] = 0;
        });
        if (product.title == "Concrete")
          form['Wastage /Shrinkage Allowance(%)'] = 0;
      });
      Future.delayed(Duration(seconds: 2), () => _loading(false));
    } else {
      showDialog(
          context: context,
          child: SmartAlert(
            title: "Warning",
            description:
                "You can only select area and thickness or length, breath and thickness to calculate product",
          ));
    }
  }

  _loading(bool state) {
    setState(() {
      loading = state;
    });
  }

  get head => Container(
        height: 250,
        child: Card(
          elevation: 4,
          child: ListTile(
            title: Text('Select Product'),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: map<Widget>(
                      products,
                      (idx, e) => Product(
                            avatar: e.avatar,
                            title: e.title,
                            active: idx == active,
                            onTap: () => animate(idx),
                          )).toList()),
            ),
          ),
        ),
      );

  ProductType get product => active == null ? null : products[active];

  get textStyle => TextStyle(color: primaryColor);

  List<Widget> get checkbox {
    List<Widget> a = params
        .map<Widget>(
          (e) => Expanded(
            child: ListTile(
              leading: Checkbox(
                onChanged: _changeUse(e),
                value: _use(e),
              ),
              title: Text(e),
              selected: _inUse(e),
            ),
          ),
        )
        .toList();
    a.add(
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: 30),
          child: InkWell(
            onTap: tryCalculate,
            child: Text(
              'Done',
              style: textStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
    return a;
  }

  _checkboxIsVisible() {
    setState(() {
      checkboxIsVisible = !checkboxIsVisible;
    });
  }

  get decor => InputDecoration(
        enabledBorder: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.arrow_drop_down),
        contentPadding: EdgeInsets.all(0),
      );

  get decor2 => InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
      );

  get parameter => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onTap: _checkboxIsVisible,
              readOnly: true,
              decoration: decor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Select Parameters',
              style: textStyle,
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: checkboxIsVisible
                  ? Card(
                      elevation: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: checkbox,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      );

  inputField(e) {
    return Row(
      children: <Widget>[
        Text(e),
        SizedBox(
          width: 7,
        ),
        Expanded(
          child: TextFormField(
            initialValue: "${form[e]}",
            decoration: decor2,
            keyboardType: TextInputType.number,
            validator: (_) {
              if (_.isEmpty) {
                return "$e require a value";
              }
              return null;
            },
            onSaved: (_) => form[e] = num.tryParse(_),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Text('m'),
        SizedBox(
          width: 26,
        ),
      ],
    );
  }

  calculate() {
    final _form = _formKey.currentState;
    _form.save();

    if (_formKey.currentState.validate()) {
      num r = 0;
      if (form['Area'] != null) {
        if (product.title == "Concrete") {
          r = (form['Area'] * form['Thickness']) +
              ((form['Wastage /Shrinkage Allowance(%)'] / 100) *
                  (form['Area'] * form['Thickness']));
        } else {
          r = form['Area'] * form['Thickness'] * product.constant;
        }
      } else {
        if (product.title == "Concrete") {
          r = (form['Length'] * form['Breath'] * form['Thickness']) +
              ((form['Length'] * form['Breath'] * form['Thickness']) *
                  (form['Wastage /Shrinkage Allowance(%)'] / 100));
        } else {
          r = form['Length'] *
              form['Breath'] *
              form['Thickness'] *
              product.constant;
        }
      }
      setState(() {
        calculateResult = r;
      });
    }
  }

  get result {
    if (loading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        shrinkWrap: false,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Select Parameters',
            style: textStyle,
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 5,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: form
                  .map(
                    (e, c) => MapEntry(
                      e,
                      Card(
                        elevation: 7,
                        child: Padding(
                          padding: EdgeInsets.all(9),
                          child: inputField(e),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: calculate,
            color: primaryColor,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(25)),
            child: Text(
              'Calculate',
              style: TextStyle(color: primaryTextColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Required mass in $measurement',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$calculateResult  $measurement',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Disclaimer*',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            disclaimer,
            style: TextStyle(fontSize: 11),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  get body => active != null
      ? Container(
          child: screen,
        )
      : Container();

  get screen => showResult == true ? result : parameter;

  get measurement =>
      product != null && product.title == "Concrete" ? "Cubic" : "Tonnes";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        if (product != null) {
          setState(() {
            active = null;
            showResult = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: liteColor,
          title: Text(
            "Product Calculator",
            style: TextStyle(color: liteTextColor),
          ),
          iconTheme: IconThemeData(color: liteTextColor),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              head,
              Expanded(
                child: body,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  Product({
    Key key,
    this.avatar,
    this.title,
    this.active = false,
    this.onTap,
  }) : super(key: key) {
    init();
  }

  final String avatar;
  final String title;
  final List<Widget> children = [];
  final bool active;
  final Function onTap;

  void init() {
    if (avatar != null) {
      children.add(Image.asset(
        avatar,
        fit: BoxFit.fill,
        width: active ? 150 : 100,
        height: active ? 150 : 100,
      ));
    } else {
      children.add(SizedBox(
        width: active ? 150 : 100,
        height: active ? 150 : 100,
      ));
    }
    title != null ? children.add(Text(title)) : children.add(Text(''));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class ProductType {
  ProductType(Map data) {
    avatar = data['avatar'];
    title = data['title'];
    constant = data['constant'];
  }

  String avatar;
  String title;
  num constant;
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
