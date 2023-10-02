import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/model-control/kurdata.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:lottie/lottie.dart';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:html/dom.dart' as dom;
import 'package:kartal/kartal.dart';


import 'tr_demir-data.dart';

class TableDataYeni {
  final String date;
  final String q8;
  final String q12;
  final String q12_32;

/*   final String? degisim;
  final String? degisimYuzde; */
  final String birim;

  TableDataYeni({
    required this.date,
    required this.q8,
    required this.q12,
    required this.q12_32,
    required this.birim,
  });

  factory TableDataYeni.fromHtml(dom.Element tr) {
    var tds = tr.getElementsByTagName('td');
    print("bu q tds:");
    print(tds.toString());
    tds = tds.where((td) => td.text.trim().isNotEmpty).toList();
    /* if(tds.length==0){
      return TableDataYeni(
        date: "",
        price: "",
        numprice: 0,
        birim: "",
      );
    } */
    /*  if (tds.length > 1) {
      print(tds[1].text);
    }
    if (tds.length > 2) {
      print(tds[2].text);
    }
    if (tds.length > 3) {
      print(tds[3].text);
    } */

    var date = tds.length > 0 ? tds[0].text.trim() : '';
    var q8 = tds.length > 1 ? tds[1].text.trim() : '';
    var q10 = tds.length > 2 ? tds[2].text.trim() : '';
    var q12_32 = tds.length > 3 ? tds[3].text.trim() : '';

    RegExp regExp = RegExp(r"(\d+(,\d+)*)");
    double q8d = 0.0;
    double q10d = 0.0;
    double q12_32d = 0.0;

    Iterable<RegExpMatch> q8dmatches = regExp.allMatches(q8);
    Iterable<RegExpMatch> q10dmatches = regExp.allMatches(q10);
    Iterable<RegExpMatch> q12_32dmatches = regExp.allMatches(q12_32);
  Kur kur = Get.find<Kur>();
  TryToUsd(usdRate, amount) {
    print("çeviri");
    return amount * usdRate;
  }
   var usd= kur.usdValue;

    if (q8dmatches.isNotEmpty) {
      String numericPart = q8dmatches.first.group(0) ?? "0";
      q8d = double.parse(numericPart.replaceAll(",", ""));
            q8d = TryToUsd(usd, q8d);
          q8d =  q8d - (q8d * 0.18);

    }
    if (q10dmatches.isNotEmpty) {
      String numericPart = q10dmatches.first.group(0) ?? "0";
      q10d = double.parse(numericPart.replaceAll(",", ""));
                  q10d = TryToUsd(usd, q10d);
                   q10d =  q10d - (q10d * 0.18);

    }
    if (q12_32dmatches.isNotEmpty) {
      
      String numericPart = q12_32dmatches.first.group(0) ?? "0";
      q12_32d = double.parse(numericPart.replaceAll(",", ""));
                        q12_32d = TryToUsd(usd, q12_32d);
                        q12_32d =  q12_32d - (q12_32d * 0.18);

    }

// This regular expression captures both "TL" and "$" as possible units of currency
    RegExp unitRegExp = RegExp(r"(\$|TL)");
    String unit = unitRegExp.firstMatch(q8)?.group(0) ?? ""; // "TL" or "$"
    print(unit);

    return TableDataYeni(
        date: date,
        q8: q8d.toString(),
        q12: q10d.toString(),
        q12_32: q12_32d.toString(),
        birim: "USD");
  }
}

class Bolgeler {
  final String name;
  final String table;
  final List<TableDataYeni> tDataYeni;
  final List<String> listefiyatlar;
  Bolgeler(
      {required this.table,
      required this.tDataYeni,
      required this.name,
      required this.listefiyatlar});

  factory Bolgeler.fromHtml(dom.Element bolgeElement, {required String name}) {
    var trs = bolgeElement.getElementsByTagName("tr");
    var tDataYeni = trs.map((tr) => TableDataYeni.fromHtml(tr)).toList();
    tDataYeni = tDataYeni
        .where((td) => td.date.isNotEmpty && td.q8.isNotEmpty)
        .toList();

    print("TableDataYeni:");
    print(tDataYeni);

    return Bolgeler(
      name: name,
      table: bolgeElement.outerHtml,
      tDataYeni: tDataYeni,
      listefiyatlar: tDataYeni.map((e) => e.q8.toString()).toList(),
    );
  }
}

class ApiResponse {
  final List<Bolgeler> bolgeler;

  ApiResponse({required this.bolgeler});

  factory ApiResponse.fromHtml(String htmlString) {
    var document = parser.parse(htmlString);

    var cityElements =
        document.querySelectorAll('#bolgelertablosu .nav-link.kisa');

    List<String> cityNames =
        cityElements.map((element) => element.text).toList();

    print(cityNames);
    var bolgeElements = document
        .querySelectorAll(".table.table-bordered.table-striped.analizliste");

    print("bolgeElements:");
    print(bolgeElements.toString());
    print("bolge ornek");
    print(bolgeElements[0].outerHtml);
    print("bolge ornek bitti");

    var bolgeler = bolgeElements.asMap().entries.map((entry) {
      int index = entry.key;
      var be = entry.value;
      return Bolgeler.fromHtml(be, name: cityNames[index]);
    }).toList();
    print("bolgeler:");
    print(bolgeler);

    return ApiResponse(
      bolgeler: bolgeler,
    );
  }
}

class DemirYeni extends StatefulWidget {
  DemirYeni(
      {super.key,
      required this.href,
      required this.title,
      required this.appbarTitle});
  final String href;
  final String title;
  final String appbarTitle;

  @override
  State<DemirYeni> createState() => _DemirYeniState();
}

class _DemirYeniState extends State<DemirYeni> {
  List<Bolgeler>? bolgeler;
  Future<dynamic> fetchData(
      String urunid, String uruntur, String ilktarih, String sontarih) async {
    print("fetchdata çalıştı");
    print("giden tarihler $ilktarih $sontarih");
    var url = Uri.parse('https://www.demirfiyatlari.com/includes/islem.php');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'iop': 'liste',
      'dt1': '$ilktarih',
      'dt2': '$sontarih',
      'ma': '$urunid',
      'tr': '$uruntur',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Response:");
        print(response.body);
        var sonuc = jsonDecode(response.body);
        /*   print(sonuc);

        print("sonuç tablo");

        print(sonuc["tablo"]); */
        var apiResponse = ApiResponse.fromHtml(sonuc["tablo"]);

        return await apiResponse.bolgeler;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data fetching: $e');
    }
  }

  Map<String, String?> parseValues(String input) {
    final RegExp exp1 = RegExp(r'urunid:(\S+)');
    final Match? match1 = exp1.firstMatch(input);
    final RegExp exp2 = RegExp(r'datatur:(\S+)');
    final Match? match2 = exp2.firstMatch(input);
    var urun = "";
    var tur = "";
    if (match1 != null) {
      urun = match1.group(1) ?? "1";
    } else {
      print("değer 1 ayrıştırılamadı");
    }
    if (match2 != null) {
      tur = match2.group(1) ?? "";
    } else {
      print("değer 2 ayrıştırılamadı");
    }
    return {
      'urunid': urun,
      'datatur': tur,
    };
  }

  @override
  void initState() {
    getDate();

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 7));
    picked = startDate;
    picked2 = endDate;
    ilkbas = DateFormat('dd-MM-yyyy').format(startDate);
    sonbas = DateFormat('dd-MM-yyyy').format(endDate);
    _selectedDate = ilkbas;
    _selectedDate2 = sonbas;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  var urunid = "";
  var datatur = "";
  String date = "";
  void getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    print(formattedDate);
    date = formattedDate;
  }

  DateTime? picked;
  DateTime? picked2;
  String _selectedDate = '';
  String _selectedDate2 = '';
  String ilkbas = "";
  String sonbas = "";

  Future<void> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2025, 12),
    );
    if (picked != null)
      setState(() {
        _selectedDate = DateFormat('dd-MM-yyyy').format(picked!);
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    picked2 = await showDatePicker(
      context: context,
      initialDate: picked2 ?? DateTime.now(),
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2025, 12),
    );

    if (picked2 != null)
      setState(() {
        if (picked2!.isBefore(picked!)) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Uyarı'),
                  content: Text('Son tarih başlangıç tarihinden önce olamaz.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Tamam'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else {
          _selectedDate2 = DateFormat('dd-MM-yyyy').format(picked2!);
        }
      });
  }

  int _selectedRegionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: fetchData(
        "1",
        "",
        _selectedDate,
        _selectedDate2,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          bolgeler = data;

          return Scaffold(
              appBar: AppBar(
                title: Text(widget.appbarTitle),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LineCharScrapmonster(
                        dates: bolgeler![_selectedRegionIndex]
                            .tDataYeni
                            .map((e) => e.date)
                            .toList(),
                        prices: bolgeler![_selectedRegionIndex].listefiyatlar,
                        title: widget.title,
                        price:
                            "${bolgeler![_selectedRegionIndex].listefiyatlar[0]}\$ USD",
                      ),
                      DropdownButton<int>(
                        value: _selectedRegionIndex,
                        items: List<DropdownMenuItem<int>>.generate(
                          bolgeler!.length,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text(
                              bolgeler![index].name ?? "",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedRegionIndex = newValue ?? 0;
                          });
                        },
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => _selectDate(context),
                                child: Column(children: [
                                  Text('Başlangıç  '),
                                  Text(_selectedDate),
                                ])),
                            TextButton(
                                onPressed: () => _selectDate2(context),
                                child: Column(children: [
                                  Text('Bitiş  '),
                                  Text(_selectedDate2),
                                ])),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    fetchData(
                                      urunid,
                                      datatur,
                                      _selectedDate,
                                      _selectedDate2,
                                    );
                                  });
                                },
                                child: Icon(Icons.refresh_outlined))
                          ]),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            bolgeler![_selectedRegionIndex].tDataYeni.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(
                                  5), // her öğenin etrafında 5 piksel boşluk
                              child: DemirComp12(
                                date: bolgeler![_selectedRegionIndex]
                                        .tDataYeni[index]
                                        .date ??
                                    "",
                                q8: bolgeler![_selectedRegionIndex]
                                        .tDataYeni[index]
                                        .q8 ??
                                    "",
                                q10: bolgeler![_selectedRegionIndex]
                                        .tDataYeni[index]
                                        .q12 ??
                                    "",
                                q12: bolgeler![_selectedRegionIndex]
                                        .tDataYeni[index]
                                        .q12_32 ??
                                    "",
                                title:
                                    bolgeler![_selectedRegionIndex].name ?? "",
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ));
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else {
          return Center(
            child: SizedBox(
              height: 122,
              child: Lottie.asset('assets/images/loading.json'),
            ),
          );
        }
      },
    );
  }
}

class Comp1 extends StatefulWidget {
  const Comp1(
      {super.key,
      required this.city,
      required this.product,
      required this.q8Degisim,
      required this.q8price,
      required this.q10price,
      required this.q12price,
      required this.q10Degisim,
      required this.q12Degisim,
      required this.yesil});
  final String city;
  final String product;
  final String q8Degisim;
  final String q10Degisim;
  final String q12Degisim;

  final String q8price;
  final String q10price;
  final String q12price;
  final bool yesil;

  @override
  State<Comp1> createState() => _Comp1State();
}

class _Comp1State extends State<Comp1> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  widget.yesil
                      ? Color.fromARGB(48, 4, 100, 7)
                      : Color.fromARGB(44, 146, 76, 76),
                  widget.yesil
                      ? Color.fromARGB(94, 7, 65, 113)
                      : Color.fromARGB(94, 229, 54, 54),
                ]),

            // gradient: LinearGradient(
            //     colors: [
            //       Color.fromARGB(255, 118, 190, 120),
            //       Color.fromARGB(255, 91, 91, 91),
            //       Colors.lightBlueAccent,
            //     ],
            //     stops: [
            //       0.0,
            //       0.5,
            //       1.0
            //     ],
            //     begin: FractionalOffset.bottomLeft,
            //     end: FractionalOffset.topRight,
            //     tileMode: TileMode.repeated),
            borderRadius: BorderRadius.circular(16)),
        // height: 200,
        // ignore: prefer_const_constructors
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Align(
              //     alignment: Alignment.centerRight,
              //     child: LineChartSample2(
              //       gradientColors: [
              //         Color.fromARGB(255, 62, 152, 65),
              //         Color.fromARGB(255, 15, 70, 44),
              //       ],
              //     )),
              Text(
                widget.city,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              Text(
                widget.product,
                style:
                    context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q8 mm : ${widget.q8price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q8Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q10 mm : ${widget.q10price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q10Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q12 - Q32 mm : ${widget.q12price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q12Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class DemirComp12 extends StatelessWidget {
  const DemirComp12(
      {super.key,
      required this.q8,
      required this.q10,
      required this.q12,
      required this.title,
      required this.date});
  final String q8;
  final String q10;
  final String q12;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.fromLTRB(3, 5, 10, 3),
        height: size.height * 0.18,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(48, 4, 100, 7),
                  Color.fromARGB(94, 7, 65, 113)
                ]),
            borderRadius: BorderRadius.circular(16)),
        // height: 200,
        // ignore: prefer_const_constructors
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  date,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Q8 mm " + q8 + " USD",
                style:
                    context.textTheme.labelLarge?.copyWith(color: Colors.green),
              ),
              Text(
                "Q10 mm	 " + q10 + " USD",
                style:
                    context.textTheme.labelLarge?.copyWith(color: Colors.green),
              ),
              Text(
                "Q12-Q32 mm	 " + q12 + " USD",
                style:
                    context.textTheme.labelLarge?.copyWith(color: Colors.green),
              ),
            ],
          ),
        ));
  }
}
