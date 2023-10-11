import 'dart:convert';

import 'package:demircelik/model-control/datacont.dart';
import 'package:demircelik/model-control/us_ch_hurda_model.dart';
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

import '../../components/Comp.dart';
import '../../components/LineChart.dart';

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



class _UsAndChinaScrapmonsState extends State<UsAndChinaScrapmons> {
  Uri url = Uri.parse("");


  
/*  'startdate': '2023-04-04',
      'enddate': '2023-07-21',
      'countryid': '69',
      'commodityid': '594', */

  @override
  void initState() {
     date = Datacontroller.getDate();
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
      future: Us_Ch_Hurdamodel.fetch_us_hurda_db_ve_api(widget.isUSA, _selectedDate, _selectedDate2),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List<DataItem> items = data;
          print("hurda-us-ch-data sayfası gelen değer " + items.toString());
          var dates = Us_Ch_Hurdamodel.getAllDates(items);
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
