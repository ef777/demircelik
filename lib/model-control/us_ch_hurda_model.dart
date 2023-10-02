
import 'dart:convert';

import 'package:demircelik/model-control/datacont.dart';
import 'package:demircelik/model-control/db.dart';
import 'package:demircelik/model-control/fireModel.dart';
import 'package:demircelik/model-control/kurdata.dart';
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
class DataItem {
   String date;
   double price;
   String unit;

  DataItem({required this.date, required this.price, required this.unit});

}
class Us_Ch_Hurdamodel {
 
  static List<DataItem> us_ch_db_ve_api_birslestir(List<DbProduct> dbProducts, List<DataItem> apiProducts) {
  List<DataItem> newList = [...apiProducts]; // Mevcut listeyi kopyalayın

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
   //  item.date =  Datacontroller.formatallDateString( item.date);
   List<String> parts = item.date.split('-');
    String day = parts[2].padLeft(2, '0');
    String month = parts[1].padLeft(2, '0');
    String year = parts[0];
    item.date = '$day-$month-$year';

      print("Tarih uygun biçimde ${item.date}");
    } catch (e) {
      print("*${item.date}* Tarih uygun biçimde değil $e ");
      // Tarih uygun biçimde değilse burada işlem yapabilirsiniz
      // Örnek: item.date = "Bir uygun biçim";
    }
  });
  newList.sort((a, b) {
         DateFormat format = DateFormat("dd-MM-yyyy");

    DateTime dateA = format.parse(a.date);
    DateTime dateB = format.parse(b.date);
    return dateA.compareTo(dateB);
  });
  return newList;
} 

  static Future<List<DataItem>> fetch_us_hurda_db_ve_api(isUSA ,String ilktarih,String sontarih) async{

     if (isUSA){

var apiden_gelen = await fetch_us_china_hurda(isUSA);
var dbden_gelen =  await dbcontroller.querydb(Datacontroller.parseDate("$ilktarih"), Datacontroller.parseDate("$sontarih"), "13", "6");
print("dbden gelen uzunluk "+dbden_gelen.length.toString());
print("apiden gelen uzunluk "+apiden_gelen.length.toString());

if (dbden_gelen.length>0 && apiden_gelen.length>0){  
  print("hem db hem api den usa hurda geldi") ;
var son = await us_ch_db_ve_api_birslestir(dbden_gelen , apiden_gelen);
return await son;
  }
if (dbden_gelen.length>0 && apiden_gelen.length==0){   
  print("sadece db den usa hurda geldi") ;
var son = await us_ch_db_ve_api_birslestir(dbden_gelen ,[]);
return await son;
  }
  if ( dbden_gelen.length==0 && apiden_gelen.length>0){
    print("sadece api den usa hurda geldi") ;
    var son = await us_ch_db_ve_api_birslestir([],apiden_gelen);

    return await son ;
  }
  else{
    print("hiç bir yerden usa hurda gelmedi");
    return [];
  }


     }
      else{
        var apiden_gelen = await fetch_us_china_hurda(isUSA);
       return await apiden_gelen;
      }


  }

 static Future<List<DataItem>> fetch_us_china_hurda(isUSA) async {
    print("fetch_us_china_hurda çalıştı");
    var url;
    if (isUSA) {
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
   static List<String> getAllDates(List<DataItem> items) {
    List<String> dates = [];
    for (DataItem item in items) {
      dates.add(item.date);
    }
    return dates;
  }
 
static List<DataItem> createDataItemsFromHtml(String htmlString, bool isusa) {
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
       price = Kur.CnyToUsd(Kur.cny, price);
print("çeviriden sonra "+price.toString());
      String yeni = price.toStringAsFixed(2);
      price = double.parse(yeni);
      items.add(DataItem(date: date, price: price, unit: "USD"));
    }

    return items;
  }




}