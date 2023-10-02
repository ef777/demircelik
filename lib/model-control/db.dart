import 'dart:io';

import 'package:demircelik/model-control/fireModel.dart';
import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class dbcontroller{

static List<FireProduct> addProductsToList(List<DbProduct> dbProducts, List<FireProduct> fireProducts) {
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
  
  static Future<List<DbProduct>> querydb(DateTime start,DateTime end,String urunid,String grupid) async{
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
}

class DbProduct {
  
  final String id;
  final String date;
  final String productId;
  final String groupId;
  final String price;
  final String unit;
  final String taxExcluded;
  final String description;

  DbProduct({
    required this.id,
    required this.date,
    required this.productId,
    required this.groupId,
    required this.price,
    required this.unit,
    required this.taxExcluded,
    required this.description,
  });

  factory DbProduct.fromJson(Map<String, dynamic> json) {
      DateTime parsedDate = DateTime.parse(json['Tarih']);
  String formattedDate = '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
   // Fiyatı noktadan sonrasını atarak ve noktayı kaldırarak alın
   print(formattedDate.toString()+  "işte db");
   String priceString = json['Fiyat'];
  int dotIndex = priceString.indexOf('.');
  
  if (dotIndex != -1) {
    priceString = priceString.substring(0, dotIndex); // Noktadan sonrasını at
  }
  
  priceString = priceString.replaceAll(',', ''); // Virgülü kaldır
  priceString = priceString.replaceAll('"', ''); // Tırnak işaretini kaldır
  priceString = priceString.trim(); // Başındaki ve sonundaki boşlukları kaldır
  double price = double.parse(priceString); // String'i double'a çevir
  
    return DbProduct(
      id: json['ID'],
      date: formattedDate,
      productId: json['UrunID'],
      groupId: json['GrupID'],
      price:price.toString(), 
      unit: json['Birim'],
      taxExcluded: json['VergiHaric'],
      description: json['Aciklama'],
    );
  }

 
}




class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }
/* assets/urunler.sqlite
 */  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'urunler.sqlite');

    var exists = await databaseExists(path);
    if (!exists) {
      print("veri tabanı yazılıyor");
      // Veritabanı dosyası henüz kopyalanmamışsa, kopyalayalım
      ByteData data = await rootBundle.load('./assets/urunler.sqlite');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
      print("yazıldı");
    }

    try {
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Veritabanı tablosunu burada oluşturabilirsiniz
        },
      );

      print('Veritabanı yolu: $path');
      print('Veritabanı açıldı');
      return database;
    } catch (e) {
      print('Veritabanı yüklenirken bir hata oluştu: $e');
      throw Exception('Veritabanı yüklenirken bir hata oluştu: $e');
    }
  }
  Future<List<DbProduct>> getDataByDateAndIds(
       DateTime startDate, DateTime endDate,   String urunID, String grupID) async {
            print("soru başladı");

    final db = await database;
    print("db" + db.toString());
    final result = await db.query(
      'tableName',
      where: 'Tarih BETWEEN ? AND ? AND UrunID = ? AND GrupID = ?',
      whereArgs: [
       startDate.toIso8601String(),
        endDate.toIso8601String(), 
        urunID,
        grupID,
      ],
    );
/*     print("result " + result.toString() + " " + result.length.toString() );
 */      List<DbProduct> list = result.map((e) => DbProduct.fromJson(e)).toList();
 print("son db product list " + list.toString() + " " + list.length.toString() );
    return list;
  }
}
