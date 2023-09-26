import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:kartal/kartal.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import '../../components/Comp.dart';
import '../../components/LineChart.dart';
import '../../model-control/kurdata.dart';
    Kur kur = Get.find<Kur>();

/* all_historytable
https://www.scrapmonster.com/prices/united-states-1-hms-price-history-chart-1-44
// burada ameerika ve çin hurda alınıyor scrapmonsterdan */

class ChinaData extends StatefulWidget {
  ChinaData({
    super.key,
    required this.href,
    required this.title,
    required this.appbarTitle,
  });
  final String href;
  final String title;
  final String appbarTitle;

  static CnyToUsd(usdRate, amount) {
    print("çeviri");
    return amount * usdRate;
  }
  static List<ChinaDataitem> createChinaDataitemsFromHtml(String htmlString, ) {
    // Parse the HTML.
    var document = parser.parse(htmlString);
    print("gelen doc");
    print(document.toString());
    // Find the tr elements in the table.
    List<dom.Element> rows = document.querySelectorAll('table tr');
    print("table rowlar");
    print(rows.toString());
    List<ChinaDataitem> items = [];

    // Starting from index 1, to skip the header row.
    for (int i = 1; i < rows.length; i++) {
      List<dom.Element> cells = rows[i].querySelectorAll('td');

      double price = double.parse(cells[2].text);
      String date = cells[3].text;
      print("çevirlmeden önce fiyat "+price.toString());
      print( kur.cnyValue.toString() + "kur.cnyValue");
      double cnykuru = kur.cnyValue;
 price = CnyToUsd(cnykuru, price);
      print("çeviriden sonra "+price.toString());
      String yeni = price.toStringAsFixed(2);
      price = double.parse(yeni);
      items.add(ChinaDataitem(price: price, date: date, unit: "USD"));
    }

    return items;
  }

 static Future<List<ChinaDataitem>> ChinaFetchData(urlson) async {
    print("ChinaFetchData çalıştı");
    print("giden url" + urlson.toString());
    /* var url = Uri.parse(
        'https://www.scrapmonster.com/prices/united-states-1-hms-price-history-chart-1-44'); */

    try {
      var response = await http.post(
        urlson,
      );

      if (response.statusCode == 200) {
        print("Response:");
        print(response.bodyBytes.toString());
        print("Response bitti:");

        var document = parser.parse(response.bodyBytes);
        print("doc");
        print(document.toString());
        return createChinaDataitemsFromHtml(document.body!.innerHtml);
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
  State<ChinaData> createState() => UsAndChinaScrapmonsState();
}

class ChinaDataitem {
  final String date;
  final double price;
  final String unit;

  ChinaDataitem({required this.date, required this.price, required this.unit});
}

class UsAndChinaScrapmonsState extends State<ChinaData> {
  Uri urlson = Uri.parse('http://www.sunsirs.com/tr/prodetail-195.html');
 
/*  'startdate': '2023-04-04',
      'enddate': '2023-07-21',
      'countryid': '69',
      'commodityid': '594', */
  @override
  void initState() {
    getDate();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 7));
    picked = startDate;
    picked2 = endDate;
    ilkbas = DateFormat('dd.MM.yyyy').format(startDate);
    sonbas = DateFormat('dd.MM.yyyy').format(endDate);
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
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
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
        _selectedDate = DateFormat('dd.MM.yyyy').format(picked!);
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
          _selectedDate2 = DateFormat('dd.MM.yyyy').format(picked2!);
        }
      });
  }

 static List<String> getAllDates(List<ChinaDataitem> items) {
    List<String> dates = [];
    for (ChinaDataitem item in items) {
      dates.add(item.date);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: ChinaData.ChinaFetchData(Uri.parse(widget.href)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List<ChinaDataitem> items = data;
          var dates = getAllDates(items);
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
                        dates: dates,
                        prices: items.map((e) => e.price.toString()).toList(),
                        title: widget.title,
                        price: items[0].price.toString(),
                      ),
                      /*  DropdownButton<int>(
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
                      ), */
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
