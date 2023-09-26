import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:kartal/kartal.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import 'Comp.dart';
import '../components/LineChart.dart';

/* all_historytable
https://www.scrapmonster.com/prices/united-states-1-hms-price-history-chart-1-44
// burada ameerika ve çin hurda alınıyor scrapmonsterdan */
class UsAndChinaScrapmons extends StatefulWidget {
  UsAndChinaScrapmons(
      {super.key,
      required this.href,
      required this.title,
      required this.appbarTitle,
      required this.isUSA});
  final String href;
  final String title;
  final String appbarTitle;
  final bool isUSA;

  @override
  State<UsAndChinaScrapmons> createState() => _UsAndChinaScrapmonsState();
}

class DataItem {
  final String date;
  final double price;
  final String unit;

  DataItem({required this.date, required this.price, required this.unit});
}

class _UsAndChinaScrapmonsState extends State<UsAndChinaScrapmons> {
  Uri url = Uri.parse("");
  var cnykuru = 0.0;
 Future<double> getusd() async {
    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/CNY'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rates = data['rates'];
      final usdRate = rates['USD'];
      return  await usdRate;
    }

    return 0;
  }

  CnyToUsd(usdRate, amount) {
    print("çeviri");
    return amount * usdRate;
  }
  List<DataItem> createDataItemsFromHtml(String htmlString, bool isusa) {
    // Parse the HTML.
    var document = parser.parse(htmlString);
    dom.Element? table ;
    if (isusa){
   table = document.getElementById('all_historytable');
 print("bu amerika tablosu");
  print(table.toString());

    }
    else{
      table = document.querySelector('.tablescroll'); // Örnek olarak class ile seçme

     /* table = document.getElementById('2_historytable'); */
     print("çin tablosu ");
      print(table!.outerHtml);
    }
    print("gelen div");
    print(table.toString());
    // Check that the number of divs is a multiple of 3 (date, price, unit).

    // Find the tr elements in the tbody with id "all_historytable".
    List<dom.Element> rows = table!.getElementsByTagName('tr');
    if(isusa){
      print("ilk element kaldırıldı");
      rows.removeAt(0);
    }
    print("seçilen trler");
    print(rows.toString());
    List<DataItem> items = [];
    for (dom.Element row in rows) {
      List<dom.Element> cells = row.querySelectorAll('td');
      print("seçilen tdler");
      print(cells.toString());
      print("ilk text price ");
      print(cells[1].text);
      print("bittş");
      String date = cells[0].text;
      print("date");
      print(date);
      double price = double.parse(cells[1].text);
      print("price");
      print(price);
       price = CnyToUsd(cnykuru, price);
print("çeviriden sonra "+price.toString());
      String yeni = price.toStringAsFixed(2);
      price = double.parse(yeni);
      items.add(DataItem(date: date, price: price, unit: "USD"));
    }

    return items;
  }

  Future<List<DataItem>> fetchData(isUSA) async {
    print("fetchdata çalıştı");
    if (widget.isUSA) {
      url = Uri.parse(
          'https://www.scrapmonster.com/prices/united-states-1-hms-price-history-chart-1-44');
    } else {
      print("çin datası çekiliyor");
      url = Uri.parse(
          'https://www.scrapmonster.com/prices/china-1-hms-price-history-chart-2-44');
    }
 
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
   /*  var body = {
      /* 
      'startdate': startdate,
      'enddate': enddate,
      'countryid': countryid,
      'commodityid': commodityid,
     */
    }; */

    try {
      var response = await http.get(
        url,
        headers: headers, /*  body: body */
      );

      if (response.statusCode == 200) {
        print("Response:");
        print(response.body);
        var document = parser.parse(response.body);
        return createDataItemsFromHtml(document.body!.innerHtml, isUSA);
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error during data fetching: $e');
      return [];
    }
  }
/*  'startdate': '2023-04-04',
      'enddate': '2023-07-21',
      'countryid': '69',
      'commodityid': '594', */

  @override
  void initState() {
    getDate();
getusd().then((value) => cnykuru = value);
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
      future: fetchData(widget.isUSA),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List<DataItem> items = data;
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
