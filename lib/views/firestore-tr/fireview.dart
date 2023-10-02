import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/components/Comp.dart';
import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/model-control/db.dart';
import 'package:demircelik/model-control/datacont.dart';
import 'package:demircelik/model-control/fireModel.dart';
import 'package:flutter/material.dart';
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

class FireView extends StatefulWidget {
  FireView(
      {super.key,
      required this.href,
      required this.title,
      required this.id,
      required this.appbarTitle,
      required this.product});
  final String href;
  final String title;
  final String id;
  final String appbarTitle;
  final String product;
  @override
  State<FireView> createState() => _FireViewState();
}
 





class _FireViewState extends State<FireView> {
 

  @override
  void initState() {
     date = Datacontroller.getDate();

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 90));
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
    return   FutureBuilder<List<FireProduct>>(
      future: firemodeltum.butunfirebasedata(widget.product,_selectedDate,_selectedDate2),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Veri yok durumu
          return Center(child: Text('Veri tabanı hatası.'));
        } else {
          List<FireProduct> products = snapshot.data!;
         

          return Scaffold(
              appBar: AppBar(
                title: Text(widget.appbarTitle),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    products != null || products != [] || products.toString() != "[]"    ?  LineCharScrapmonster(
                        dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(),
                        title: widget.title,
                        price: "${products[0].price ?? 0 }\$ USD",
                      ): Text("Veri yok"),
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
                    products != null  || products != []  ?     ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(
                                  5), // her öğenin etrafında 5 piksel boşluk
                              child: Comp12(
                                date: products[index].date ?? "",
                                price: products[index].price ?? "",
                                title: "${widget.product}\$ TL",
                              ));
                        },
                      ): Text("Veri yok"),
                    ],
                  ),
                ),
              ));
        
         
  }});}}

 
