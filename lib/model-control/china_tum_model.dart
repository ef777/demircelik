import 'dart:convert';

import 'package:demircelik/model-control/datacont.dart';
import 'package:demircelik/model-control/db.dart';
import 'package:demircelik/model-control/us_ch_hurda_model.dart';
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

 
 class ch_tum_model{
  static Future<List<DataItem>> ch_api_db(Uri url ,String ilktarih,String sontarih) async{
// debden alınacak
// İnşaat Demiri
// Sıcak Haddelenmiş Sac
// Soğuk Haddelenmiş Sac
// diğerler istandaeet fetch
var db= 0;
var urungrup;
var urunid;
//sıcak sac
if(url.toString() == "http://www.sunsirs.com/tr/prodetail-195.html" ){
  print("dbden sıcak hac çekiliyor çin için ");
db = 1;
urungrup = 7;
urunid = 2;
}
//soğuk sac
if (url.toString()  == "http://www.sunsirs.com/tr/prodetail-318.html"){
db = 1;
urungrup = 7;
urunid = 1;
print("dbden soğuk hac çekiliyor çin için ");
}
//inşaat demir
if (url.toString()  == "http://www.sunsirs.com/tr/prodetail-927.html"){
urungrup = 7;
urunid = 9;
db =1;
print("dbden inşaat demir çekiliyor çin için ");
}

if (db!=1){
print("dbden çekilmeyecek çin verileri only api");
var apiden_gelen = await ChinaFetchData(url);
return await apiden_gelen;
}
else {
print("dbden çekilmeli çin verileri");









var apiden_gelen = await ChinaFetchData(url);
var dbden_gelen =  await dbcontroller.querydb(Datacontroller.parseDate("$ilktarih"), Datacontroller.parseDate("$sontarih"), "13", "6");

if (dbden_gelen.length>0 && apiden_gelen.length>0){  
  print("hem db hem api den çin  geldi") ;
var son = await ch_db_ve_api_birslestir(dbden_gelen , apiden_gelen);
return await son;
  }
if (dbden_gelen.length>0 && apiden_gelen.length==0){   
  print("sadece db den çin tum geldi") ;
var son = await ch_db_ve_api_birslestir(dbden_gelen ,[]);
return await son;
  }
  if ( dbden_gelen.length==0 && apiden_gelen.length>0){
    print("sadece api den çin tum geldi") ;
    var son = await ch_db_ve_api_birslestir([],apiden_gelen);

    return await son ;
  }
  else{
    print("hiç bir yerden çin veri gelmedi");
    return [];
  }


   
  


  }}


 
  static List<DataItem> ch_db_ve_api_birslestir(List<DbProduct> dbProducts, List<DataItem> apiProducts) {
  List<DataItem> newList = [...apiProducts]; // Mevcut listeyi kopyalayın
  print("apiden gelen tarihler ${apiProducts[0].date.toString()} ");
  for (var dbProduct in dbProducts) {
    DataItem sonProduct = DataItem(
      date: dbProduct.date, // Tarihi formatlayın
      price: double.parse(dbProduct.price),
      unit: dbProduct.unit,
    );
    print( "eklenen product tarihi "+sonProduct.date.toString()  );
    print("eklenen product fiyatı "+sonProduct.price.toString()   );
    if (sonProduct.price>0 && sonProduct.price<1000){
    newList.add(sonProduct);

    }

  }
   newList.forEach((item) {
    try {
      print("aganda gelen tarihler ${item.date.toString()}" );
     //item.date =  Datacontroller.formatallDateString( item.date);
      print("Tarih uygun biçimde");
        
    } catch (e) {
      print("*${item.date}* Tarih uygun biçimde değil $e ");
      // Tarih uygun biçimde değilse burada işlem yapabilirsiniz
      // Örnek: item.date = "Bir uygun biçim";
    }
  });
  newList.sort((a, b) {
    print("sırala başladı");
        DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime dateA = format.parse(a.date);
    DateTime dateB = format.parse(b.date);
    return dateA.compareTo(dateB);
  });
      print("sırala bitti");

  return newList;
} //h




 static List<DataItem> createDataItemsFromHtml(String htmlString, ) {
    // Parse the HTML.
    var document = parser.parse(htmlString);
    print("gelen doc");
    print(document.toString());
    // Find the tr elements in the table.
    List<dom.Element> rows = document.querySelectorAll('table tr');
    print("table rowlar");
    print(rows.toString());
    List<DataItem> items = [];

    // Starting from index 1, to skip the header row.
    for (int i = 1; i < rows.length; i++) {
      List<dom.Element> cells = rows[i].querySelectorAll('td');

      double price = double.parse(cells[2].text);
      String date = cells[3].text;
      print("çevirlmeden önce fiyat "+price.toString());
      print( kur.cnyValue.toString() + "kur.cnyValue");
      double cnykuru = kur.cnyValue;
 price = Kur.CnyToUsd(cnykuru, price);
      print("çeviriden sonra "+price.toString());
      String yeni = price.toStringAsFixed(2);
      price = double.parse(yeni);
      items.add(DataItem(price: price, date: date, unit: "USD"));
    }

    return items;
  }

 static Future<List<DataItem>> ChinaFetchData(urlson) async {
    print("ChinaFetchData çalıştı");
    print("giden url" + urlson.toString());
  
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
        List<DataItem> son = await createDataItemsFromHtml(document.body!.innerHtml);
son.forEach((item) {
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
      // Tarih uygun biçimde değilse burada işlem yapabilirsiniz
      // Örnek: item.date = "Bir uygun biçim";
    }
  });
  son.sort((a, b) {
    print("sırala başladı");
        DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime dateA = format.parse(a.date);
    DateTime dateB = format.parse(b.date);
    return dateA.compareTo(dateB);
  });
        return son;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error during data fetching: $e');
      return [];
    }
  }
 }