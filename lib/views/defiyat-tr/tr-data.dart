import 'dart:convert';

import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:demircelik/model-control/kurdata.dart';
import 'package:demircelik/views/defiyat-tr/tr_demir-data.dart';
import 'package:demircelik/wpbutton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import '../../components/Comp.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:html/dom.dart' as dom;
import 'package:kartal/kartal.dart';

import '../../components/LineChart.dart';
import '../eu-usa-scrap(sac)/us1-menu.dart';
import '../anaview.dart';
    Kur kur = Get.find<Kur>();



// butun demir celik.comdan alınan veriler burda


   TryToUsd(usdRate, amount) {
    print("çeviri");
    return amount * usdRate;
  }

class TurkeyAllPage extends StatefulWidget {
  TurkeyAllPage(
      {super.key,
      required this.href,
      required this.title,
      required this.appbarTitle});
  final String href;
  final String title;
  final String appbarTitle;
 static Future<dynamic> TurkeyFetchData(
      String urunid, String uruntur, String ilktarih, String sontarih) async {
    print("TurkeyFetchData çalıştı");
    print("giden tarihler $ilktarih $sontarih");
    var url = Uri.parse('https://www.demirfiyatlari.com/includes/islem.php');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'iop': 'liste',
      'dt1': '$ilktarih',
      'dt2': '$sontarih',
      'ma': '$urunid',
      'tr': '$uruntur',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Response:");
        print(response.body);
        var sonuc = jsonDecode(response.body);
        /*   print(sonuc);

        print("sonuç tablo");

        print(sonuc["tablo"]); */
        var apiResponse = ApiResponse.fromHtml(sonuc["tablo"]);
        /*   print("ApiResponse:");
        print(apiResponse);
        print("ApiResponse.TrBolgeler:");
        print(apiResponse.TrBolgeler[0].name); */
        return  apiResponse.trBolgeler;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data fetching: $e');
    }
  }

  @override
  State<TurkeyAllPage> createState() => _TurkeyAllPageState();
}

class TurkeyAllTabble {
  final String date;
  final String price;
/*   final String? degisim;
  final String? degisimYuzde; */
  final int numprice;
  final String birim;

  TurkeyAllTabble({
    required this.date,
    required this.price,
    required this.numprice,
    required this.birim,

    /*  this.degisim,
      this.degisimYuzde */
  });

  factory TurkeyAllTabble.fromHtml(dom.Element tr) {
    var tds = tr.getElementsByTagName('td');
     if (tds.length > 0) {
      print("tds" + tds.toString() + "tds");
      print("tds fiyat " + tds[0].text);
      print("hop fiyat " + tds[1].text);
    var date = tds.length > 0 ? tds[0].text.trim() : '';
    print("pşt date" + date);
     DateTime dateTime = DateFormat('dd.MM.yyyy').parse(date);
       
 var outputFormat = DateFormat('dd-MM-yyyy');
   var outputDate = outputFormat.format(dateTime);
   date = outputDate;

    var price = tds.length > 1 ? tds[1].text.trim() : '';
    print("tds" + tds.toString() + "tds");
  /*     print("tds fiyat " + tds[0].text);
      print("hop fiyat " + price); */
        print("adım 1");
print("ilk gelen fiyat" + price);
    RegExp regExp = RegExp(r"(\d+(,\d+)*)");
    double priceNumber = 0.0;
    Iterable<RegExpMatch> matches = regExp.allMatches(price);
    print("adım iki");

    if (matches.isNotEmpty) {
      String numericPart = matches.first.group(0) ?? "0"; // "19,500" or "570"
      print("çevrilecek double"+ numericPart);

      // 19,350 TL + KDV

      priceNumber = double.parse(numericPart.replaceAll(",", ""));
   var cikar = priceNumber * 0.18;
     priceNumber = priceNumber ; // - cikar;

      print("çevrilen double"+priceNumber.toString()); // prints: 19500.0 or 570.0
    } else {
      print("No match found.");
    }
// This regular expression captures both "TL" and "$" as possible units of currency
    RegExp unitRegExp = RegExp(r"(\$|TL)");
    String unit = unitRegExp.firstMatch(price)?.group(0) ?? ""; // "TL" or "$"
    print("adım üç");
   print("unit bu" + unit);
   print("priceNumber bu" + priceNumber.toString());
   print("price bu" + price);
    if (unit != "\$") {
      print("adım dört");
    
   var usd= kur.usdValue;

      priceNumber = TryToUsd(usd, priceNumber);
      //yüzde 18 al
     
     var cikar = priceNumber * 0.18;
     priceNumber = priceNumber ; // - cikar;
      print("priceNumber bu" + priceNumber.toString());
      unit = "USD";
      price = priceNumber.toString() + " " + unit + " KDV";
    }

/*  price= TryToUsd(usdkuru, priceNumber);
 */    return TurkeyAllTabble(
        date: date, price: price, numprice: priceNumber.toInt(), birim: unit);
      } 
      else {
        return TurkeyAllTabble(
            date: "", price: "", numprice: 0, birim: "");
       }
}}

class TrBolgeler {
  
  final String name;
  final String table;
  final List<TurkeyAllTabble> turkeyAllTabble;
   List<String> listefiyatlar;
  TrBolgeler(
      {required this.table,
      required this.turkeyAllTabble,
      required this.name,
      required this.listefiyatlar});
  TrBolgeler copyWith({List<String>? listefiyatlar}) {
    return TrBolgeler(
      table: this.table,
      turkeyAllTabble: this.turkeyAllTabble,
      name: this.name,
      listefiyatlar: listefiyatlar ?? this.listefiyatlar,
    );
  }

  factory TrBolgeler.fromHtml(dom.Element bolgeElement, {required String name}) {
    var trs = bolgeElement.getElementsByTagName("tr");
    var turkeyAllTabble = trs.map((tr) => TurkeyAllTabble.fromHtml(tr)).toList();
    turkeyAllTabble = turkeyAllTabble
        .where((td) => td.date.isNotEmpty && td.price.isNotEmpty)
        .toList();

    print("TurkeyAllTabble:");
    print(TurkeyAllTabble);

    return TrBolgeler(
      name: name,
      table: bolgeElement.outerHtml,
      turkeyAllTabble: turkeyAllTabble,
      listefiyatlar: turkeyAllTabble.map((e) => e.numprice.toString()).toList(),
    );
  }
}

class ApiResponse {
  final List<TrBolgeler> trBolgeler;

  ApiResponse({required this.trBolgeler});

  factory ApiResponse.fromHtml(String htmlString) {
    var document = parser.parse(htmlString);

    var cityElements =
        document.querySelectorAll('#bolgelertablosu .nav-link.kisa');

    List<String> cityNames =
        cityElements.map((element) => element.text).toList();

    print(cityNames);
    var bolgeElements = document
        .querySelectorAll(".table.table-bordered.table-striped.analizliste");

    print("bolgeElements:");
    print(bolgeElements.toString());
    print("bolge ornek");
    print(bolgeElements[0].outerHtml);
    print("bolge ornek bitti");

    var trBolgeler = bolgeElements.asMap().entries.map((entry) {
      int index = entry.key;
      var be = entry.value;
      return TrBolgeler.fromHtml(be, name: cityNames[index]);
    }).toList();
    print("TrBolgeler:");
    print(TrBolgeler);

    return ApiResponse(
      trBolgeler: trBolgeler,
    );
  }
}

class _TurkeyAllPageState extends State<TurkeyAllPage> {
  List<TrBolgeler>? trBolgeler;
  

  cevir(String urun) {
    String urunid = "";
    String datatur = "";
    String sonuc = "";
    if (urun == "Demir") {
      urunid = "1";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Kütük") {
      urunid = "2";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Yerli Hurda") {
      urunid = "3";
      datatur = "Yerli";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "İthal Hurda") {
      urunid = "3";
      datatur = "İthal";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Çelik Hasır") {
      urunid = "4";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Demir Cevheri") {
      urunid = "5";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Düz Kangal") {
      urunid = "6";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
    if (urun == "Nervürlü Kangal") {
      urunid = "7";
      datatur = "";
      sonuc = "urunid:" + urunid + "datatur:" + datatur;
      return sonuc;
    }
  }

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
    print("butun turkey initstate çalıştı");
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
    var data = cevir(widget.href);
    print(data);
    Map<String, String?>? values = parseValues(data);
    if (values != null) {
      print('urunid: ${values['urunid']}, datatur: ${values['datatur']}');
      urunid = values['urunid'].toString();
      datatur = values['datatur'].toString();
    } else {
      print('No match found');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  var urunid = "";
  var datatur = "";
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
      future: TurkeyAllPage.TurkeyFetchData(
        urunid,
        datatur,
        _selectedDate,
        _selectedDate2,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          trBolgeler = data;

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
                        dates: trBolgeler![_selectedRegionIndex]
                            .turkeyAllTabble
                            .map((e) => e.date)
                            .toList(),
                        prices: trBolgeler![_selectedRegionIndex].listefiyatlar,
                        title: widget.title,
                        price:
                            "${trBolgeler![_selectedRegionIndex].listefiyatlar[0]}\$ USD",
                      ),
                      DropdownButton<int>(
                        value: _selectedRegionIndex,
                        items: List<DropdownMenuItem<int>>.generate(
                          trBolgeler!.length,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text(
                              trBolgeler![index].name ?? "",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedRegionIndex = newValue ?? 0;
                          });
                        },
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
                                  setState(() {
                                    TurkeyAllPage.TurkeyFetchData(
                                      urunid,
                                      datatur,
                                      _selectedDate,
                                      _selectedDate2,
                                    );
                                  });
                                },
                                child: Icon(
                                    Icons.refresh_outlined) //Text('Göster'),

                                )
                          ]),
                      ListView.builder(
                         reverse: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            trBolgeler![_selectedRegionIndex].turkeyAllTabble.length,
                        itemBuilder: (context, index) {
                       var sonucexp=    RegExp(r'\d+(?:\.\d+)?').allMatches(trBolgeler![_selectedRegionIndex]
                                        .turkeyAllTabble[index]
                                        .price);
                                       String pricem= sonucexp.first.group(0)!;
                                       pricem = double.parse(pricem).round().toString() + " USD";
                          return Container(
                              margin: EdgeInsets.all(
                                  5), // her öğenin etrafında 5 piksel boşluk
                              child:  
 Comp12(
                                date: trBolgeler![_selectedRegionIndex]
                                        .turkeyAllTabble[index]
                                        .date ??
                                    "",
                                price: pricem ??
                                    "",
                                title:
                                    trBolgeler![_selectedRegionIndex].name ?? "",
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
