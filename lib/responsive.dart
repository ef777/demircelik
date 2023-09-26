/* import 'package:demir_app/views/celik_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

//data tur = matur
//data id = maid
//  data-id="1" data-tur="" Demir
// data-id="2" data-tur="" Kütük
// data-id="3" data-tur="Yerli" Yerli Hurda
// data-id="3" data-tur="İthal" İthal Hurda
// data-id="4" data-tur="" Çelik Hasır
// 	data-id="5" data-tur="" Demir Cevheri
// data-id="6" data-tur="" Düz Kangal
// data-id="7" data-tur="" Nervürlü Kangal Son

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Bolge>? bolgeler;
  Future<dynamic> fetchData() async {
    var url = Uri.parse('https://www.demirfiyatlari.com/includes/islem.php');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'iop': 'liste',
      'dt1': '08.07.2023',
      'dt2': '22.07.2023',
      'ma': '1',
      'tr': '',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Response:");
        print(response.body.toString());

        var apiResponse = ApiResponse.fromHtml(response.body);

        print("ApiResponse:");
        print(apiResponse);
/*         demirFiyatlari = await apiResponse.tableData;
 */
        return await apiResponse.bolgeler;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data fetching: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print("init başladı");

    setfonk();
  }

  Future<void> setfonk() async {
    try {
      print("fetch başladı");
      var data = await fetchData();
      setState(() {
        bolgeler = data;
      });
    } catch (e) {
      print("fetch alınamadı");
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demir Fiyatları'),
      ),
      body: Center(
        child: demirFiyatlari != null
            ? ListView.builder(
                itemCount: demirFiyatlari!.length,
                itemBuilder: (context, index) {
                  var rowData = demirFiyatlari;
                  return ListTile(
                    title: Text(rowData.date + " " + rowData.price),
                  );
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
 */