import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'generated/l10n.dart';

// TODO: build a factory for the buildTextField method.

const request =
    "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/brl.json";

void main() async {
  runApp(MaterialApp(
    localizationsDelegates: [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    title: "Currencies Converter",
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoArsController = TextEditingController();
  final pesoClpController = TextEditingController();

  double dolar;
  double euro;
  double pesoArs;
  double pesoClp;
  String quotationDate;
  int lang = 0;
  List lLang = S.delegate.supportedLocales;
  String sLang = 'es';
  String sFlag = 'images/es.jpg';
  String sepCurr = 'en_US';


  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoArsController.text = "";
    pesoClpController.text = "";
  }

  String _dateFormated(String date) {
    sLang = lLang[lang].toString();
    S.load(Locale(sLang));
    var prv = date.split('-');
    print('$date - $prv - $sLang - $lang - $lLang');
    if (sLang != 'en') {
      sepCurr = 'pt_BR';
      return "${prv[2]}/${prv[1]}/${prv[0]}";
    } else {
      sepCurr = 'en_US';
      return "${prv[1]}-${prv[2]}-${prv[0]}";
    }
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    final value = NumberFormat('#,##0.00', sepCurr);
    double real = double.parse(text);
    realController.text = value.format(real);
    dolarController.text = value.format(real / dolar);
    euroController.text = value.format(real / euro);
    pesoArsController.text = value.format(real / pesoArs);
    pesoClpController.text = value.format(real / pesoClp);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    final value = NumberFormat('#,##0.00', sepCurr);
    double dolar = double.parse(text);
    dolarController.text = value.format(dolar);
    realController.text = value.format(dolar * this.dolar);
    euroController.text = value.format(dolar * this.dolar / euro);
    pesoArsController.text = value.format(dolar * this.dolar / pesoArs);
    pesoClpController.text = value.format(dolar * this.dolar / pesoClp);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    final value = NumberFormat('#,##0.00', sepCurr);
    double euro = double.parse(text);
    euroController.text = value.format(euro);
    realController.text = value.format(euro * this.euro);
    dolarController.text = value.format(euro * this.euro / dolar);
    pesoArsController.text = value.format(euro * this.euro / pesoArs);
    pesoClpController.text = value.format(euro * this.euro / pesoClp);
  }

  void _pesoArsChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    final value = NumberFormat('#,##0.00', sepCurr);
    double pesoArs = double.parse(text);
    pesoArsController.text = value.format(pesoArs);
    realController.text = value.format(pesoArs * this.pesoArs);
    dolarController.text = value.format(pesoArs * this.pesoArs / dolar);
    euroController.text = value.format(pesoArs * this.pesoArs / euro);
    pesoClpController.text = value.format(pesoArs * this.pesoArs / pesoClp);
  }

  void _pesoClpChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    final value = NumberFormat('#,##0.00', sepCurr);
    double pesoClp = double.parse(text);
    pesoClpController.text = value.format(pesoClp);
    realController.text = value.format(pesoClp * this.pesoClp);
    dolarController.text = value.format(pesoClp * this.pesoClp / dolar);
    pesoArsController.text = value.format(pesoClp * this.pesoClp / pesoArs);
    euroController.text = value.format(pesoClp * this.pesoClp / euro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.all(12),
            tooltip: sLang,
            icon: Image.asset(sFlag),
            onPressed: () {
              setState(() {
                _clearAll();
                lang == lLang.length - 1 ? lang = 0 : lang++;
                sLang = lLang[lang].toString();
                print('$lang - $sLang - $lLang');
                S.load(Locale(sLang));
                if (lang == lLang.length - 1) {
                  sLang = lLang[0].toString();
                } else {
                  sLang = lLang[lang + 1].toString();
                }
                sFlag = 'images/$sLang.jpg';
              });
            },
          ),
          title: Text(
            S.of(context).title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(onPressed: _clearAll, icon: Icon(Icons.refresh)),
          ],
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    S.of(context).loadingData,
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "${S.of(context).loadingDataError} \n ${snapshot.connectionState} \n ${snapshot.error}",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar = snapshot.data["brl"]["usd"];
                    dolar = 1 / dolar;
                    euro = snapshot.data["brl"]["eur"];
                    euro = 1 / euro;
                    pesoArs = snapshot.data["brl"]["ars"];
                    pesoArs = 1 / pesoArs;
                    pesoClp = snapshot.data["brl"]["clp"];
                    pesoClp = 1 / pesoClp;
                    quotationDate = snapshot.data["date"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.monetization_on,
                                    size:55.0, color: Colors.amber),
                                Icon(Icons.arrow_right_outlined,
                                    size: 70.0, color: Colors.amberAccent),
                                Text(_dateFormated(quotationDate),
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Icon(Icons.arrow_right_outlined,
                                    size: 70.0, color: Colors.yellow),
                                Icon(Icons.monetization_on,
                                    size: 55.0, color: Colors.yellowAccent),
                              ],
                            ),
                          ),
                          buildTextField(S.of(context).dollars, "US\$ ",
                              dolarController, _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euros (eu)", "€ ", euroController, _euroChanged),
                          Divider(),
                          buildTextField(S.of(context).reals, "R\$ ",
                              realController, _realChanged),
                          Divider(),
                          buildTextField("Pesos (ars)", "\$ ",
                              pesoArsController, _pesoArsChanged),
                          Divider(),
                          buildTextField("Pesos (clp)", "\$ ",
                              pesoClpController, _pesoClpChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.black12,
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onSubmitted: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
  );
}
