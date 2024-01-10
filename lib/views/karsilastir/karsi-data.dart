import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/components/Comp.dart';
import 'package:demircelik/components/LineChart.dart';
import 'package:demircelik/model-control/china_tum_model.dart';
import 'package:demircelik/model-control/fireModel.dart';
import 'package:demircelik/model-control/us_ch_hurda_model.dart';
import 'package:demircelik/views/defiyat-tr/tr-data.dart';
import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:demircelik/views/sunsirs-ch/ch-data.dart';
import 'package:demircelik/views/eu-usa-scrap(sac)/sac-usa-eu-data.dart';
import 'package:demircelik/model-control/db.dart';
import 'package:demircelik/model-control/datacont.dart';
import 'package:demircelik/model-control/fireModel.dart';
import 'package:demircelik/wpbutton.dart';
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
    List<dynamic> findLongestList(List<List<dynamic>> lists) {
  if (lists.isEmpty) {
    throw Exception("List of lists cannot be empty");
  }

  List<dynamic> longestList = lists[0];

  for (int i = 0; i < lists.length; i++) {
     print( "liste  ${lists[i].length} ");
    if (lists[i].length > longestList.length) {

      longestList = lists[i];
    }
  }

  return longestList;
}

datatamamla(List list ,int eklesayi, String tur ){
List tamamlanan = [];
  Type listType = list.runtimeType;
  
//tipini öğren ok

if(tur == "tr2"){
List<String> list2 = list as List<String>;
var adet = list2.length;
var toplam = 0;
List<String> birinciliste = list2;
for(var i in  birinciliste){

toplam = toplam + int.parse(i);
}
var ortalama = toplam/adet;
var kacadeteklenecek = eklesayi - adet;
 for(int i = 0 ; i<kacadeteklenecek;i++){
  var eklenecek =  ortalama.toInt().toString();
  birinciliste.insert(0, eklenecek);
}
return birinciliste;
}


if(tur=="tr"){

List<FireProduct> list2 = list as List<FireProduct>;

var adet = list2.length;
var toplam = 0;
for(FireProduct i in list2){ 

toplam = toplam + int.parse(i.price);


}
var ortalama = toplam/adet;
var kacadeteklenecek = eklesayi - adet;
for(int i = 0 ; i<kacadeteklenecek;i++){
  var eklenecek = FireProduct(
    id: "0",
    countryId: "0",
    date: "0",
    price: ortalama.toString(),
    unit: "0",
  );
  list2.insert(0, eklenecek);
}

}
else {


List<DataItem> list2 = list as List<DataItem>;

var adet = list2.length;
var toplam = 0;
for(DataItem i in list2){
toplam = toplam + i.price.toInt();
}
var ortalama = toplam/adet;
var kacadeteklenecek = eklesayi - adet;
for(int i = 0 ; i<kacadeteklenecek;i++){
  var eklenecek = DataItem(
    
    date: "0",
    price: ortalama.toDouble(),
    unit: "0",
    
  );
  list2.insert(0, eklenecek);
}



}
// listenin ortalamsını al
// listeyi ortalama ile baştan tamamla
 //dondur
}
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

fetchData2() async {
return 0;
}

  String tarih1 = "";
  String tarih2 = "";
  String gelenistek = "";
  String date = "";
 

 
  void getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
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
    DateTime productDate = Datacontroller.parseDate(product.date);
    return productDate.isAfter(startDate) && productDate.isBefore(endDate);
  }).toList();

  return products;
}


fetchData(id , zaman1,zaman2)async {
  if(id == "6"){
//inşaat demiri
print("hurda");
// turkey veri
print("turkey veri hurda başladı");
 var demir_tr_data ;
 demir_tr_data = await TurkeyAllPage.TurkeyFetchData(
                                      "3",
                                      "Yerli",
                                      _selectedDate,
                                      _selectedDate2,
                                    );
print("demir_tr_data");
print(demir_tr_data);
List<DataItem> DataItemss  =await Us_Ch_Hurdamodel.fetch_us_hurda_db_ve_api(true,_selectedDate,_selectedDate2);
//*98 usa hurda ekle *ok
//*98 çin hurda ekle noral fetch *ok

var ChnDemirDatam;
   ChnDemirDatam = await Us_Ch_Hurdamodel.fetch_us_hurda_db_ve_api(false,_selectedDate,_selectedDate2);



var enuzun =findLongestList([demir_tr_data[0].listefiyatlar , ChnDemirData,DataItemss]);
            print("en uzun liste! ${enuzun.length}");
print("hurda ok?");
List<String> sonuctr= datatamamla(demir_tr_data[0].listefiyatlar,enuzun.length,"tr2");
print("tamamlanmış sonuç $sonuctr");


  TrBolgeler yeniNesne = demir_tr_data[0].copyWith(listefiyatlar: sonuctr );
print("işte yeni nesne $yeniNesne");


datatamamla(ChnDemirDatam,enuzun.length,"ch");
datatamamla(DataItemss,enuzun.length,"usa");

   
return [yeniNesne,ChnDemirDatam,DataItemss]; 

}

if(id == "1"){
//inşaat demiri
print("inşaat demiri");
// turkey veri
print("turkey veri demir başladı");
  List<TrBolgeler> demir_tr_data= await TurkeyAllPage.TurkeyFetchData(
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
List<DataItem> ChnDemirData = [];
   ChnDemirData = await ch_tum_model.ch_api_db(Uri.parse("http://www.sunsirs.com/tr/prodetail-927.html"), _selectedDate, _selectedDate2 );
//ok98 ok dbden çekildi inşaat

var enuzun =findLongestList([demir_tr_data[0].listefiyatlar , ChnDemirData]);
            print("en uzun liste! ${enuzun.length}");
print("demir ok?");
List<String> sonuctr= datatamamla(demir_tr_data[0].listefiyatlar,enuzun.length,"tr2");
print("tamamlanmış sonuç $sonuctr");


  TrBolgeler yeniNesne = demir_tr_data[0].copyWith(listefiyatlar: sonuctr );
print("işte yeni nesne $yeniNesne");

datatamamla(ChnDemirData,enuzun.length,"ch");
//enson
// burayı düzelt diper yerlere aynısını yap 
return [yeniNesne , ChnDemirData]; 
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
 print("çin veri demir  cechei başladı");
 if(demir_tr_data.length==0 || demir_tr_data == null){
   print("turkey veri demir cevheri boş");

 }
// çin veri
List<DataItem> ChnDemirData = [];
   ChnDemirData = await   ch_tum_model.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-961.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri demir bitti");
      
var enuzun =findLongestList([demir_tr_data[0].listefiyatlar , ChnDemirData]);
            print("en uzun liste! ${enuzun.length}");
print("cevher ok?");
List<String> sonuctr= datatamamla(demir_tr_data[0].listefiyatlar,enuzun.length,"tr2");
print("tamamlanmış sonuç $sonuctr");


  TrBolgeler yeniNesne = demir_tr_data[0].copyWith(listefiyatlar: sonuctr );
print("işte yeni nesne $yeniNesne");


datatamamla(ChnDemirData,enuzun.length,"ch");

return [yeniNesne , ChnDemirData]; 
}

if (widget.id == "4"){
print("galvaniz sac");
print("turkey veri galvaniz sac başladı from firebase");
  List<FireProduct> fireproduct  = await firemodeltum.butunfirebasedata("Galvaniz Sac", _selectedDate!, _selectedDate2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri galvaniz sac bitti from firebase");

List<DataItem> ChnDemirData = [];
   ChnDemirData = await   ch_tum_model.ChinaFetchData( Uri.parse("http://www.sunsirs.com/tr/prodetail-301.html"));
      print("çin veri");
      print(ChnDemirData);
      print("çin veri demir bitti");
      var enuzun =findLongestList([fireproduct , ChnDemirData ,DataItemss,EUitems]);
            print("en uzun liste ${enuzun.length}");

datatamamla(fireproduct,enuzun.length,"tr");
datatamamla(ChnDemirData,enuzun.length,"ch");



                        return [fireproduct , ChnDemirData]; 

}
if (widget.id == "2"){



print("Sıcak haddelenmiş sac");
print("turkey veri Sıcak haddelenmiş sac başladı from firebase");
  List<FireProduct> fireproduct  = await  firemodeltum.butunfirebasedata("Sıcak Haddelenmiş Sac", _selectedDate!, _selectedDate2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri Sıcak haddelenmiş sac bitti from firebase");

List<DataItem> ChnDemirData = [];
   ChnDemirData = await   ch_tum_model.ch_api_db( Uri.parse("http://www.sunsirs.com/tr/prodetail-195.html"), _selectedDate, _selectedDate2);
      print("çin veri");
      print(ChnDemirData);
      print("çin veri Sıcak haddelenmiş sac bitti?");

   List<DataItem> DataItemss  = await hacUsaEu.UsaFetch("69", "593","${usaformatdate(_selectedDate)}" ,"${usaformatdate( _selectedDate2)}");
                           List<DataItem> EUitems  = await hacUsaEu.UsaFetch("71", "593","${usaformatdate(_selectedDate)}" ,"${usaformatdate( _selectedDate2)}");
                        
         print("dataitems geçt");
         print("eu fiyat sıcak $EUitems");

var enuzun =findLongestList([fireproduct , ChnDemirData ,DataItemss,EUitems]);
            print("en uzun liste ${enuzun.length}");

datatamamla(fireproduct,enuzun.length,"tr");
datatamamla(ChnDemirData,enuzun.length,"ch");
datatamamla(DataItemss,enuzun.length,"usa");
datatamamla(EUitems,enuzun.length,"eu");

            
                        return [fireproduct , ChnDemirData,DataItemss,EUitems]; 
//98* çin de eklenecek dbden çi ok*
}
if (widget.id == "3"){

  //98* burda çin dbden eklenecek *ok
print("sOĞUK haddelenmiş sac başladı");
print("turkey veri Soğuk haddelenmiş sac başladı from firebase");
  List<FireProduct> fireproduct  = await  firemodeltum.butunfirebasedata("Soğuk Haddelenmiş Sac", _selectedDate!, _selectedDate2!);
 /*  dates: products.map((e) => e.date).toList(),
                        prices: products.map((e) => e.price).toList(), */
print(fireproduct.toString());
print("turkey veri Sıcak haddelenmiş sac bitti from firebase");

List<DataItem> ChnDemirData = [];
   ChnDemirData = await   ch_tum_model.ch_api_db( Uri.parse("http://www.sunsirs.com/tr/prodetail-318.html") , _selectedDate, _selectedDate2);
      print("çin veri");
      print(ChnDemirData);
      print("çin veri soguk haddelenmiş sac bitti!!!");

   List<DataItem> DataItemss  = await hacUsaEu.UsaFetch("69", "594","${usaformatdate(_selectedDate)}" ,"${usaformatdate( _selectedDate2)}");
       var enuzun =findLongestList([fireproduct , ChnDemirData ,DataItemss,EUitems]);
            print("en uzun liste ${enuzun.length}");

datatamamla(fireproduct,enuzun.length,"tr");
datatamamla(ChnDemirData,enuzun.length,"ch");
datatamamla(DataItemss,enuzun.length,"usa");

                        return [fireproduct , ChnDemirData,DataItemss]; 

}
}
 List<DataItem> DataItemss = [];
 String usaformatdate(String date) {
  List<String> dateParts = date.split('-');
  if (dateParts.length != 3) {
    throw Exception("Geçersiz tarih formatı");
  }

  String day = dateParts[0].padLeft(2, '0');
  String month = dateParts[1].padLeft(2, '0');
  String year = dateParts[2];

  return "$day-$month-$year";
}

 @override
  void initState() {
   getDate();
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
   List<TrBolgeler>? trdemirdata = [];
     List<DataItem> ChnDemirData = [];
var ch_dates ;
List<DataItem> EUitems  = [];
 List<FireProduct> fireproduct  = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: 
      widget.id == "1" ?  fetchData(widget.id , Datacontroller.parseDate(_selectedDate) ,Datacontroller.parseDate(_selectedDate2)) :
      widget.id == "2" ?  fetchData(widget.id,Datacontroller.parseDate(_selectedDate) ,Datacontroller.parseDate(_selectedDate2)) :
      widget.id == "5" ?  fetchData(widget.id ,Datacontroller.parseDate(_selectedDate) ,Datacontroller.parseDate(_selectedDate2)) :
      widget.id == "4" ?  fetchData( widget.id  ,Datacontroller.parseDate(_selectedDate) ,Datacontroller.parseDate(_selectedDate2)) :
      widget.id == "3" ?  fetchData(widget.id  , Datacontroller.parseDate(_selectedDate) ,Datacontroller.parseDate(_selectedDate2)) :
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
            trdemirdata =   [data[0]];

ChnDemirData = data[1];
print("id 1 tr  date ornek " + trdemirdata![0]
                            .turkeyAllTabble
                            [0].date.toString() );
print("id 1 ch date ornek  " + ChnDemirData[0].date.toString() );

                   ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();

print("çin tarihleri ");
print(ch_dates.toString());
          } 
             if(widget.id == "6" ){
              
             trdemirdata =    [data[0]];
ChnDemirData = data[1] ;
DataItemss = data[2];
                   ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();

print("id 6 tr  date ornek " + trdemirdata![0]
                            .turkeyAllTabble
                            [0].date.toString() );
print("id 6 ch date ornek  " + ChnDemirData[0].date.toString() );



          } 
          if(widget.id == "5" ){
            

            trdemirdata =      [data[0]];
ChnDemirData = data[1];
                   ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();
 


          } 

          if( widget.id == "4" ){
            

             fireproduct  = data[0];
             ChnDemirData = data[1];
             
              ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();


          }
           if( widget.id == "2" ){
            

            print("id2 build");
             fireproduct  = data[0];
             ChnDemirData = data[1];
            
              ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();
  DataItemss = data[2];
    EUitems  = data[3];
  print("id 2 usa date ornek  " + DataItemss[0].date.toString() );
  print("id 2 tr  date ornek " + fireproduct[0].date.toString() );

print("id 2 ch date ornek  " + ChnDemirData[0].date.toString() );
print("eu fiyat sicak $EUitems");


          }
           if( widget.id == "3" ){
             fireproduct  = data[0];
             ChnDemirData = data[1];
             
              ch_dates = ChinaView.getAllDates(ChnDemirData);
  ch_dates = ch_dates.reversed.toList();
  DataItemss = data[2];
 

 
// hepsini nu fortama döndür 2023-10-01

          }
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              
         
           floatingActionButton:   WhatsAppMessageButton(
                textim: "Merhaba!, " +
                    widget.title +
                    " fiyatları hakkında bilgi almak istiyorum.",
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
            dates1:   trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), 
            dates2:  ch_dates, // Sample dates for prices 2
            dates3: [],
            dates4: [],
                            
                    ) : 
                   //id 2 sıcak hac tr firebase + çin + usa 
                    widget.id == "2" ?  MultiLineChart(
            prices1: fireproduct.map((e) => e.price).toList() , // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3: DataItemss.map((e) => e.price.toString()).toList(),
              prices4: EUitems.map((e) => e.price.toString()).toList(),
            dates1:   fireproduct.map((e) => e.date).toList() ,
            dates2:   ch_dates,// Sample dates for prices 2
            dates3: DataItemss.map((e) => e.date.toString()).toList(), /* DataItemss.map((e) => e.date).toList(), */
                        dates4:EUitems.map((e) => e.date.toString()).toList(),

                            
                    ) 
                                       //id 3 soğuk hac tr firebase + site çin usa eu yapıalcak !!

                    : widget.id=="3" ?  MultiLineChart(

            prices1: fireproduct.map((e) => e.price).toList(), // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3: DataItemss.map((e) => e.price.toString()).toList(),
            prices4: [],
            dates1:  fireproduct.map((e) => e.date).toList() ,
            dates2:   ch_dates,// Sample dates for prices 2
             dates3: DataItemss.map((e) => e.date.toString()).toList(), /* DataItemss.map((e) => e.date).toList(), */
            dates4: [],
                            // id 4 galvanizli sac tr firebase + site çin

                    ) : widget.id=="4" ?  MultiLineChart(



            prices1:fireproduct.map((e) => e.price).toList(), /// 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3:[],
            prices4: [], 
            dates1: fireproduct.map((e) => e.date).toList() ,
            dates2:   ch_dates,/*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), 
                             */// Sample dates for prices 2
            dates3: [],
            dates4: [],


            // id 5 demir cevheri site tr+ site çin
                    ) : widget.id=="5" ?  MultiLineChart(




            prices1: trdemirdata.isNotNullOrEmpty ? 
            
            
             trdemirdata![0].listefiyatlar : [], // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
            prices3:[],
            prices4: [],
            dates1: trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), 
            dates2: ch_dates/*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList() */, // Sample dates for prices 2
            dates3: [],
            dates4: [],
                    ) : MultiLineChart(



            prices1: trdemirdata![0].listefiyatlar, // 
            prices2: ChnDemirData.map((e) => e.price.toString()).toList(), // Sample prices 2
                    prices3: DataItemss.map((e) => e.price.toString()).toList(),

            prices4: [],
            dates1:  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(), 
            dates2: ch_dates /*  trdemirdata![0]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList() */, // Sample dates for prices 2
            dates3: DataItemss.map((e) => e.date.toString()).toList(),
            dates4: [],
                    ) ),
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
                     SizedBox(width: 25,),
                     Container(
                       width: 5,
                       height: 5,
                       color: Colors.yellow,
                     ),
                     Text("Avrupa",style :TextStyle(fontSize: 14
                    , color:Colors.yellow )),
                    
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
