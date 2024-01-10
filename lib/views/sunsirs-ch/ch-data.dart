import 'dart:convert';

import 'package:demircelik/model-control/china_tum_model.dart';
import 'package:demircelik/model-control/us_ch_hurda_model.dart';
import 'package:demircelik/wpbutton.dart';
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

 
  

  @override
  State<ChinaData> createState() => ChinaView();
}



class ChinaView extends State<ChinaData> {
 
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

 static List<String> getAllDates(List<DataItem> items) {
    List<String> dates = [];
    for (DataItem item in items) {
      dates.add(item.date);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
   Uri url= Uri.parse(widget.href);
    return FutureBuilder<dynamic>(
      future: ch_tum_model.ch_api_db(url, _selectedDate, _selectedDate2 ),
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
