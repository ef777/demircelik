import 'dart:convert';

import 'package:demircelik/components/Comp.dart';
import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/model-control/us_ch_hurda_model.dart';
import 'package:demircelik/wpbutton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:kartal/kartal.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

// burada sıcak ve soğuk hac avrupa amerika
class hacUsaEu extends StatefulWidget {
  hacUsaEu(
      {super.key,
      required this.href,
      required this.title,
      required this.appbarTitle,
      required bool isAvrupa});
  final String href;
  final String title;
  final String appbarTitle;
static Future<List<DataItem>> UsaFetch(String countryid, String commodityid,
      String startdate, String enddate) async {
    print("UsaFetch çalıştı!");
    print("giden tarihler $startdate $enddate");
    var url =
        Uri.parse('https://www.scrapmonster.com/steelprice/gethistoricaldata');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'startdate': startdate,
      'enddate': enddate,
      'countryid': countryid,
      'commodityid': commodityid,
    };

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Response:");
        print(response.body);
        var document = parser.parse(response.body);
        List<DataItem> items = [];
        items= createDataItemsFromHtml(document.body!.innerHtml);
        items.forEach((item) {
    try {
         print("başladı");
     DateTime dateTime = DateFormat('yyyy-MM-dd').parse(item.date);
                print("başladı1");

 var outputFormat = DateFormat('dd-MM-yyyy');
          print("başladı2");

   var outputDate = outputFormat.format(dateTime);
            print("başladı3");

    item.date = outputDate;
    } catch (e) {
      print("*${item.date}* Tarih uygun biçimde değil $e ");
      
    }
  });  items.sort((a, b) {
    print("sırala başladı");
        DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime dateA = format.parse(a.date);
    DateTime dateB = format.parse(b.date);
    return dateA.compareTo(dateB);
  });

        return  items;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error during data fetching: $e');
      return [];
    }
  }
  @override
  State<hacUsaEu> createState() => hacUsaEuState();
}



List<DataItem> createDataItemsFromHtml(String htmlString) {
  // Parse the HTML.
  var document = parser.parse(htmlString);

  // Find the divs with class "col-4".
  List<dom.Element> divs = document.getElementsByClassName('col-4');

  // Check that the number of divs is a multiple of 3 (date, price, unit).
  if (divs.length % 3 != 0) {
    throw Exception('Unexpected number of divs');
  }

  // Create a list of DataItems.
  List<DataItem> items = [];
  for (int i = 0; i < divs.length; i += 3) {
    String date = divs[i].text;
    double price = double.parse(divs[i + 1].text);
    String unit = divs[i + 2].text;

    items.add(DataItem(date: date, price: price, unit: unit));
  }

  return items;
}

class hacUsaEuState extends State<hacUsaEu> {
  

  String date = "";

/*  'startdate': '2023-04-04',
      'enddate': '2023-07-21',
      'countryid': '69',
      'commodityid': '594', */
  String bolge = "";
  String urun = "";
  String tarih1 = "";
  String tarih2 = "";
  String gelenistek = "";
  istek(istek, gtarih1, gtarih2) async {

  

    if (istek == "avrupasicakhac") {
      bolge = "71";
      urun = "593";
      tarih1 = "$gtarih1";
      tarih2 = "$gtarih2";
      print("eu sıcak başladı");
    }
    if (istek == "usasogukhac") {
      bolge = "69";
      urun = "594";
      tarih1 = "$gtarih1";
      tarih2 = "$gtarih2";
    }
    if (istek == "usasicakhac") {
      bolge = "69";
      urun = "593";
      tarih1 = "$gtarih1";
      tarih2 = "$gtarih2";
    }

    /*  "69",
        "594",
        "2023-04-04",
        "2023-07-21", */
  }

  @override
  void initState() {
    getDate();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 120));
    picked = startDate;
    picked2 = endDate;
    ilkbas = DateFormat('dd-MM-yyyy').format(startDate);
    sonbas = DateFormat('dd-MM-yyyy').format(endDate);
    _selectedDate = ilkbas;
    _selectedDate2 = sonbas;
    istek(widget.href, ilkbas, sonbas);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  var urunid = "";
  var datatur = "";
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
        print("ilk tarih" + _selectedDate);
        tarih1 = _selectedDate;
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
          print("son tarih" + _selectedDate2);
          tarih2 = _selectedDate2;
        }
      });
  }

  List<String> getAllDates(List<DataItem> items) {
    List<String> dates = [];
    for (DataItem item in items) {
      dates.add(item.date);
    }
    return dates;
  }

  int _selectedRegionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: hacUsaEu.UsaFetch(bolge, urun, tarih1, tarih2),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List<DataItem> items = data;
          var dates = getAllDates(items);
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.appbarTitle),
              ),
              
         
           floatingActionButton:   WhatsAppMessageButton(
                textim: "Merhaba!, " +
                    widget.title +
                    " fiyatları hakkında bilgi almak istiyorum.",
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LineCharScrapmonster(
                        dates: dates,
                        prices: items.map((e) => e.price.toString()).toList(),
                        title: widget.title,
                        price: items[0].price.toString(),
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
                                  setState(() {});
                                },
                                child: Icon(Icons.refresh_outlined))
                          ]),
                      ListView.builder(
                         reverse: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(
                                  5), // her öğenin etrafında 5 piksel boşluk
                              child: Comp12(
                                date: items[index].date.toString() ?? "",
                                price: items[index].price.toString() +
                                        " " +
                                        items[index].unit.toString() ??
                                    "",
                                title: widget.title,
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
