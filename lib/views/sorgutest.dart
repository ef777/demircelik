/* 
import 'package:demircelik/views/db.dart';
import 'package:flutter/material.dart';



class testsorgu extends StatefulWidget {
  @override
  _testsorguState createState() => _testsorguState();
}

class _testsorguState extends State<testsorgu> {
  @override
  void initState() {
    super.initState();
    _queryData();
  }

  Future<void> _queryData() async {
    
    final startDate = DateTime(2019, 1, 1);
    final endDate = DateTime(2019, 12, 31); 
    final urunID = "2";
    final grupID = "1";

    final data = await DatabaseHelper().getDataByDateAndIds(
      startDate,
      endDate, 
      urunID,
      grupID,
    );

    for (var item in data) {
      print(item.id);
      print(item.tarih);
      print(item.urunID);
      print(item.grupID);
      print(item.fiyat);
      print(item.birim);
      print(item.vergiHaric);
      print(item.aciklama);
      print('-------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Example'),
      ),
      body: Center(
        child: Text('Check the console for query results.'),
      ),
    );
  }
} */