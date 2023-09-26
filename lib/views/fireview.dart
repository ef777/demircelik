import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/views/Comp.dart';
import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/views/db.dart';
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

class FireProduct {
  final String id;
  final String countryId;
  final String date;
  final String price;
  final String unit;

  FireProduct({
    required this.id,
    required this.countryId,
    required this.date,
    required this.price,
    required this.unit,
  });

  factory FireProduct.fromDocument(DocumentSnapshot doc) {
    return FireProduct(
      id: doc['id'],
      countryId: doc['countryId'],
      date: doc['date'],
      price: doc['price'],
      unit: doc['unit'],
    );
  }
}

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
 List<FireProduct> addProductsToList(List<DbProduct> dbProducts, List<FireProduct> fireProducts) {
  List<FireProduct> newList = [...fireProducts]; // Mevcut listeyi kopyalayın

  for (var dbProduct in dbProducts) {
    FireProduct fireProduct = FireProduct(
      id: dbProduct.id,
      countryId: dbProduct.groupId,
      date: dbProduct.date, // Tarihi formatlayın
      price: dbProduct.price,
      unit: dbProduct.unit,
    );
    newList.add(fireProduct);
  }

  return newList;
}


List<FireProduct> orderProductsByDate(List<FireProduct> productList) {
  productList.sort((a, b) {
    DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
    DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
    return dateA.compareTo(dateB);
  });

  return productList;
}


class _FireViewState extends State<FireView> {
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
    DateTime startDate = endDate.subtract(Duration(days: 50));
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


  Future<List<DbProduct>> querydb(DateTime start,DateTime end,String urunid,String grupid) async{
   final startDate = DateTime(start.year, start.month,  start.day);
    final endDate = DateTime(end.year, end.month,  end.day); 
         var dbdat = await DatabaseHelper().getDataByDateAndIds(
      startDate,
      endDate, 
      urunid, 
      grupid,
    );
  /*   print("querydb sonuc");
    print(dbdat.toList());
   dbdat.forEach((element) {
      print(element.date);
    }); */
    return dbdat;
  } 
  int _selectedRegionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection(widget.product).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: SizedBox(
                height: 122,
                child: Lottie.asset('assets/images/loading.json'),
              ),
            );
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }
           print("ilk gelen dosyalar");
          print(snapshot.data!.docs);
          print("gelen tarih 1 ve 2 : $_selectedDate ve $_selectedDate2");
          DateTime startDate = parseDatenokta(_selectedDate);
          DateTime endDate = parseDatenokta(_selectedDate2);
          print("çeviri tamam");
          print(startDate.day);
          List<FireProduct> products = snapshot.data!.docs
              .map((doc) => FireProduct.fromDocument(doc))
              .where((product) {

            DateTime productDate = parseDate(product.date);
         //   DateTime   productDate = DateTime.parse(product.date);
//String output = DateFormat('dd.MM.yyyy').format(productDate);
            print("product date gelen bu tarih ");
            print(productDate);
            print("bu ilk tarih");
            print(startDate);
            print("bu son tarih");
            print(endDate);
            return productDate.isAfter(startDate) &&
                productDate.isBefore(endDate);
          }).toList();
          var secilenqrsorgu = "1";
          widget.id== "1" ? secilenqrsorgu = "2" : widget.id==3 ? secilenqrsorgu = "4" : secilenqrsorgu = "1"; 
  return FutureBuilder<List<DbProduct>>(
      future: querydb(picked!, picked2!, secilenqrsorgu, "1"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Veri yok durumu
          return Center(child: Text('Veri tabanı hatası.'));
        } else {
          List<DbProduct> qrdata = snapshot.data!;
             print("işte gelen data");
          print(qrdata.toString());
            if (qrdata.isEmpty && products.isEmpty) {
              print("ikiside boş");
              return Text("veri yok");
        /*       var a =  FireProduct(id: "1", countryId: "1", date: "$_selectedDate2", price: "1", unit: "USD");
          products =[a,a]; */

                   }

             if (qrdata.isEmpty && products.isNotEmpty) {
                print("qr boş ama fire dolu");
          products = products;
 products = orderProductsByDate(products);
             } 
   if (qrdata.isNotEmpty && products.isEmpty) {
                         print("qr dolu ama fire boş");
          products = addProductsToList(qrdata ,[]);
 products = orderProductsByDate(products);
             } 
             if (qrdata.isNotEmpty && products.isNotEmpty) {
              

          products = addProductsToList(qrdata, products);
 products = orderProductsByDate(products);
             }

           print("son pro");
          print(products.toString());
                    print(products);



          return Scaffold(
              appBar: AppBar(
                title: Text(widget.appbarTitle),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    products != null || products != [] || products.toString() != "[]"    ?  LineChartSample2(
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
        
         
  }});});}

  DateTime parseDate(String dateStr) {
    print("parse data başladı");
    var parts = dateStr.split("/");
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    print("parse data bitti");

    return DateTime(year, month, day);
  }

  DateTime parseDatenokta(String dateStr) {
    print("parse data başladı");
    var parts = dateStr.split(".");
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    print("parse data bitti");

    return DateTime(year, month, day);
  }
}
