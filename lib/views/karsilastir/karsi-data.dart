import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/components/Comp.dart';
import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/views/defiyat-tr/tr-data.dart';
import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:demircelik/views/sunsirs-ch/ch-data.dart';
import 'package:demircelik/views/eu-usa-scrap(sac)/sac-usa-eu-data.dart';

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



class KarsilastirDetay extends StatefulWidget {
  KarsilastirDetay(
      {super.key,
      required this.id,
      required this.title,
     });
  final String id;
  final String title;

  @override
  State<KarsilastirDetay> createState() => _KarsilastirDetayState();
}


class _KarsilastirDetayState extends State<KarsilastirDetay> {
 
fetchData2() async {
return 0;
}

  String tarih1 = "";
  String tarih2 = "";
  String gelenistek = "";
  String date = "";
 

 
  void getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);
    print(formattedDate);
    date = formattedDate;
  }

  DateTime? picked;
  DateTime? picked2;
  String _selectedDate = '';
  String _selectedDate2 = '';
  String ilkbas = "";
  String sonbas = "";


 var urunid = "";
  var datatur = "";

 // id 1 inşaat demiri
// id 2 sıcak haddelenmiş sac
// id 3 soğuk haddelenmiş sac
// id 4 galvanizli sac
// id 5 demir cevheri
// id 6 hurda 
Future<List<FireProduct>> FireFetch(
  String collectionName,
  DateTime startDate,
  DateTime endDate,
) async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection(collectionName).get();

  List<FireProduct> products = snapshot.docs
      .map((doc) => FireProduct.fromDocument(doc))
      .where((product) {
    DateTime productDate = parseDate(product.date);
    return productDate.isAfter(startDate) && productDate.isBefore(endDate);
  }).toList();

  return products;
}
 DateTime parseDate(String dateStr) {
    print("parse data başladı");
    print(dateStr);
    var parts = dateStr.split("/");
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    print("parse data bitti");

    return DateTime(year, month, day);
  }
  DateTime parseDateNoktali(String dateStr) {
    print("parsenoktali data başladı");
    print(dateStr);
    var parts = dateStr.split(".");
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    print("parse data bitti");

    return DateTime(year, month, day);
  }
fetchData(id , zaman1,zaman2)async {
  if(id == "6"){
//inşaat demiri
print("inşaat demiri");
// turkey veri
print("turkey veri demir başladı");
 var demir_tr_data ;
 demir_tr_data = await TurkeyAllPage.TurkeyFetchData(
                                      "3",
                                      "Yerli",
                                      _selectedDate,
                                      _selectedDate2,
                                    );
print("demir_tr_data");
print(demir_tr_data);

return [demir_tr_data]; 
}

if(id == "1"){
//inşaat demiri
print("inşaat demiri");
// turkey veri
print("turkey veri demir başladı");
 var demir_tr_data ;
 demir_tr_data = await TurkeyAllPage.TurkeyFetchData(
                                      "1",
                                      "",
                                      _selectedDate,
                                      _selectedDate2,
                                    );
print("demir_tr_data");
print(demir_tr_data);
print("turkey veri demir bitti");
 print("çin veri demir başladı");
// çin veri
List<ChinaDataitem> ChnDemirData = [];
   ChnDemirData = await   ChinaData.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-927.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri demir bitti");

return [demir_tr_data , ChnDemirData]; 
}

if(id == "5"){
//demir cevheri

print("turkey veri demir cevheri başladı");
 var demir_tr_data ;
 demir_tr_data = await TurkeyAllPage.TurkeyFetchData(
                                      "5",
                                      "",
                                      _selectedDate,
                                      _selectedDate2,
                                    );
print("demir_tr_data");
print(demir_tr_data);
print("turkey veri demir bitti");
 print("çin veri demir başladı");
// çin veri
List<ChinaDataitem> ChnDemirData = [];
   ChnDemirData = await   ChinaData.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-961.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri demir bitti");

return [demir_tr_data , ChnDemirData]; 
}

if (widget.id == "4"){
print("galvaniz sac");
print("turkey veri galvaniz sac başladı from firebase");
  List<FireProduct> fireproduct  = await FireFetch("Galvaniz Sac", zaman1!, zaman2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri galvaniz sac bitti from firebase");

List<ChinaDataitem> ChnDemirData = [];
   ChnDemirData = await   ChinaData.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-301.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri demir bitti");

                        return [fireproduct , ChnDemirData]; 

}
if (widget.id == "2"){
print("Sıcak haddelenmiş sac");
print("turkey veri Sıcak haddelenmiş sac başladı from firebase");
  List<FireProduct> fireproduct  = await FireFetch("Sıcak Haddelenmiş Sac", zaman1!, zaman2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri Sıcak haddelenmiş sac bitti from firebase");

List<ChinaDataitem> ChnDemirData = [];
   ChnDemirData = await   ChinaData.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-195.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri Sıcak haddelenmiş sac bitti");

   List<UsaItem> Usaitems  = await hacUsaEu.UsaFetch("69", "593","${usaformatdate(_selectedDate)}" ,"${usaformatdate( _selectedDate2)}");
                        return [fireproduct , ChnDemirData,Usaitems]; 

}
if (widget.id == "3"){
print("sOĞUK haddelenmiş sac");
print("turkey veri Sıcak haddelenmiş sac başladı from firebase");
  List<FireProduct> fireproduct  = await FireFetch("Soğuk Haddelenmiş Sac", zaman1!, zaman2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri Sıcak haddelenmiş sac bitti from firebase");

List<ChinaDataitem> ChnDemirData = [];
   ChnDemirData = await   ChinaData.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-318.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri Sıcak haddelenmiş sac bitti");

   List<UsaItem> Usaitems  = await hacUsaEu.UsaFetch("69", "594", "_selectedDate", "_selectedDate2");
                        List<UsaItem> EUitems  = await hacUsaEu.UsaFetch("71", "594", "_selectedDate", "_selectedDate2");
                    
                       
                        return [fireproduct , ChnDemirData,Usaitems,EUitems]; 

}
}
 List<UsaItem> Usaitems = [];
 String usaformatdate(String date) {
  List<String> dateParts = date.split('.');
  if (dateParts.length != 3) {
    throw Exception("Geçersiz tarih formatı");
  }

  String day = dateParts[0].padLeft(2, '0');
  String month = dateParts[1].padLeft(2, '0');
  String year = dateParts[2];

  return "$year-$month-$day";
}

 @override
  void initState() {
   getDate();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 30));
    picked = startDate;
    picked2 = endDate;
    ilkbas = DateFormat('dd.MM.yyyy').format(startDate);
    sonbas = DateFormat('dd.MM.yyyy').format(endDate);
    _selectedDate = ilkbas;
    _selectedDate2 = sonbas;
 
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }
   List<TrBolgeler>? trdemirdata = [];
     List<ChinaDataitem> ChnDemirData = [];
var ch_dates ;
List<UsaItem> EUitems  = [];
 List<FireProduct> fireproduct  = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: 
      widget.id == "1" ?  fetchData(widget.id , tarih1,tarih2) :
      widget.id == "2" ?  fetchData(widget.id,parseDateNoktali(_selectedDate) ,parseDateNoktali(_selectedDate2)) :
      widget.id == "5" ?  fetchData(widget.id , tarih1,tarih2) :
      widget.id == "4" ?  fetchData( widget.id  ,parseDateNoktali(_selectedDate) ,parseDateNoktali(_selectedDate2)) :
      widget.id == "3" ?  fetchData(widget.id  , parseDateNoktali(_selectedDate) ,parseDateNoktali(_selectedDate2)) :
      fetchData(widget.id , tarih1,tarih2),
    

         // id 1 inşaat demiri
// id 2 sıcak haddelenmiş sac
// id 3 soğuk haddelenmiş sac
// id 4 galvanizli sac
// id 5 demir cevheri
// id 6 hurda 
     
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
       if(widget.id == "1" ){
            trdemirdata = data[0];
ChnDemirData = data[1];
                   ch_dates = UsAndChinaScrapmonsState.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();

print("çin tarihleri ");
print(ch_dates.toString());
          } 
             if(widget.id == "6" ){
            trdemirdata = data[0];

          } 
          if(widget.id == "5" ){
            trdemirdata = data[0];
ChnDemirData = data[1];
                   ch_dates = UsAndChinaScrapmonsState.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();

print("çin tarihleri ");
print(ch_dates.toString());
          } 

          if( widget.id == "4" ){
             fireproduct  = data[0];
             ChnDemirData = data[1];
             
              ch_dates = UsAndChinaScrapmonsState.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();

          }
           if( widget.id == "2" ){
             fireproduct  = data[0];
             ChnDemirData = data[1];
              ch_dates = UsAndChinaScrapmonsState.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();
  Usaitems = data[2];

          }
           if( widget.id == "3" ){
             fireproduct  = data[0];
             ChnDemirData = data[1];
              ch_dates = UsAndChinaScrapmonsState.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();
  Usaitems = data[2];
   EUitems  = data[3];

          }
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Padding(
                padding: const EdgeInsets.all(1.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                   Container(
                    height: 500,
                    child:  
     // id 1 inşaat demiri
// id 2 sıcak haddelenmiş sac
// id 3 soğuk haddelenmiş sac
// id 4 galvanizli sac
// id 5 demir cevheri
// id 6 hurda 
     
                    widget.id == "1" ?  MultiLineChart(
// id 1 inşaat demiri tr site - site çin
            prices1: trdemirdata![0].listefiyatlar, // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3:[],
            prices4: [],
            dates1:  ch_dates,
            dates2:  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), // Sample dates for prices 2
            dates3: [],
            dates4: [],
                            
                    ) : 
                   //id 2 sıcak hac tr firebase + çin + usa
                    widget.id == "2" ?  MultiLineChart(

            prices1: fireproduct.map((e) => e.price).toList(), // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3: Usaitems.map((e) => e.price.toString()).toList(),
            prices4: [],
            dates1:  ch_dates,
            dates2:   [],// Sample dates for prices 2
            dates3:  [], /* Usaitems.map((e) => e.date).toList(), */
            dates4: [],
                            
                    ) 
                                       //id 3 soğuk hac tr firebase + site çin usa eu yapıalcak !!

                    : widget.id=="3" ?  MultiLineChart(

            prices1: fireproduct.map((e) => e.price).toList(), // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3: Usaitems.map((e) => e.price.toString()).toList(),
            prices4: EUitems.map((e) => e.price.toString()).toList(),
            dates1:  ch_dates,
            dates2:  [] ,// Sample dates for prices 2
            dates3: [] ,/* Usaitems.map((e) => e.date).toList(), */
            dates4: [],
                            // id 4 galvanizli sac tr firebase + site çin

                    ) : widget.id=="4" ?  MultiLineChart(



            prices1:fireproduct.map((e) => e.price).toList(), /// 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3:[],
            prices4: [],
            dates1:  ch_dates,
            dates2:[], /*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), 
                             */// Sample dates for prices 2
            dates3: [],
            dates4: [],


            // id 5 demir cevheri site tr+ site çin
                    ) : widget.id=="5" ?  MultiLineChart(




            prices1: trdemirdata![0].listefiyatlar, // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3:[],
            prices4: [],
            dates1:  ch_dates,
            dates2: [] /*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList() */, // Sample dates for prices 2
            dates3: [],
            dates4: [],
                    ) : MultiLineChart(




            prices1: trdemirdata![0].listefiyatlar, // 
            prices2:  trdemirdata![0].listefiyatlar,  // Sample prices 2
            prices3:[],
            prices4: [],
            dates1:  ["2023.07. 1" ,"2023.07. 2" ,"2023.07. 3" ,"2023.07. 4" ,"2023.07. 5" ,"2023.07. 6" ,"2023.07. 7" ],
            dates2: [] /*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList() */, // Sample dates for prices 2
            dates3: [],
            dates4: [],
                    ) ),
                  
                   widget.id== "1" ?
                   Container(child: 
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                   ],),)) : Container(),

                      widget.id== "2" ?
                   Container(child: 
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                       SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.green,
                     ),
                     Text("Amerika",style :TextStyle(fontSize: 14
                    , color:Colors.green )),
                   ],),)) : Container(),

   widget.id== "3" ?
                   Container(child: 
                
                
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                       SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.green,
                     ),
                     Text("Amerika",style :TextStyle(fontSize: 14
                    , color:Colors.green )),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.yellow,
                     ),
                     Text("Avrupa",style :TextStyle(fontSize: 14
                    , color:Colors.yellow )),
                     ],),)) : Container(),
                        widget.id== "4" ?
                   Container(child: 
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                   ],),)) : Container(),

                        widget.id== "5" ?
                   Container(child: 
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                   ],),)) : Container(),
      widget.id== "6" ?
                   Container(child: 
                Center(child:   Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.blue,
                     ),
                     Text("Türkiye",style: TextStyle(fontSize: 14
                    , color:Colors.blue ),),
                    SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.red,
                     ),
                     Text("Çin",style :TextStyle(fontSize: 14
                    , color:Colors.red )),
                       SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.green,
                     ),
                     Text("Amerika",style :TextStyle(fontSize: 14
                    , color:Colors.green )),
                   ],),)) : Container(),

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
