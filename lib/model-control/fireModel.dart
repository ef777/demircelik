
import 'package:cloud_firestore/cloud_firestore.dart';
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
class firemodeltum {

  static Future<List<FireProduct>> getFireProduct(String product, String _selectedDate,String _selectedDate2) async {
          var sonuc=   await FirebaseFirestore.instance.collection(product).get();
                   print("ilk gelen dosyalar");
          print(sonuc.docs.toString());
          print("gelen tarih 1 ve 2 : $_selectedDate ve $_selectedDate2");
          DateTime startDate = Datacontroller.parseDate(_selectedDate);
          DateTime endDate = Datacontroller.parseDate(_selectedDate2);
          print("çeviri tamam");
          print(startDate.day);
          List<FireProduct> products = sonuc.docs.map((doc) => FireProduct.fromDocument(doc))
              .where((product) {
            var deger= Datacontroller.parseDate(product.date);
            DateTime productDate =   deger;
            print("atladı");
            print("product date gelen bu tarih ");
            print(productDate);
            print("bu ilk tarih");
            print(startDate);
            print("bu son tarih");
            print(endDate);
            return productDate.isAfter(startDate) &&
                productDate.isBefore(endDate);
          }).toList();
         return products;
  }  // sadece widget id alır sayfadan
 static dbdenfireal(id , _selectedDate,_selectedDate2) async {
    var secilenqrsorgu = "1"; // urun grup
       id== "1" ? secilenqrsorgu = "2" :  id==3 ? secilenqrsorgu = "4" : secilenqrsorgu = "1"; 
       var cevrilen1 =  Datacontroller.parseDate(_selectedDate);
        var cevrilen2 =  Datacontroller.parseDate(_selectedDate2);
DateTime ilk = cevrilen1;
DateTime son = cevrilen2;

       List<DbProduct> sondb= await  dbcontroller.querydb(ilk!, son!, secilenqrsorgu, "1");
            return sondb;
  }

 static  Future<List<FireProduct>> butunfirebasedata(String product,String _selectedDate,String _selectedDate2)async{
    var id = 0;
    print("gelen zzaman 1 ve 2 : $_selectedDate ve $_selectedDate2");
    if (  product=="Sıcak Haddelenmiş Sac"){
 id=1;
    }
    else if ( product=="Soğuk Haddelenmiş Sac"){

id=2;
    }
    else if ( product=="Galvaniz Sac"){

      id=3;
    }

      
    
var products = await getFireProduct( product,_selectedDate,_selectedDate2);
var qrdata = await dbdenfireal(id.toString(), _selectedDate,_selectedDate2);

            if (qrdata.isEmpty && products.isEmpty) {
              print("ikiside boş");
              return [ FireProduct(
                id: "0",
                countryId: "0",
                date: "0",
                price: "10",
                unit: "0",)];
      
                   }

             if (qrdata.isEmpty && products.isNotEmpty) {
                print("qr boş ama fire dolu");
          products = products;
 products = Datacontroller.orderProductsByDate(products);
             } 
   if (qrdata.isNotEmpty && products.isEmpty) {
                         print("qr dolu ama fire boş");
          products = dbcontroller.addProductsToList(qrdata ,[]);
 products = Datacontroller.orderProductsByDate(products);
             } 
             if (qrdata.isNotEmpty && products.isNotEmpty) {
              

          products = dbcontroller.addProductsToList(qrdata, products);
 products = Datacontroller.orderProductsByDate(products);
             }

           print("son pro");
          print(products.toString());
                    print(products);
                    return products;


  }

}