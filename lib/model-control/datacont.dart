import 'package:demircelik/model-control/fireModel.dart';
import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:intl/intl.dart';

class Datacontroller {
 
static String formatallDateString(String date) {
  // İlk olarak / karakterinin varlığına göre biçimi tespit etmeye çalışın
  if (date.contains("/")) {
    try {
      // / biçimini - biçimine dönüştür
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      // Hatalı biçim, orijinal tarih dizesini geri döndür
      return date;
    }
  } else if (date.contains("-")) {
    try {
      // - biçimini / biçimine dönüştür
  DateTime dateTime = DateFormat('dd-MM-yyyy').parse(date);
 date = DateFormat('dd-MM-yyyy').format(dateTime);
  

      return date;
    } catch (e) {
      // Hatalı biçim, orijinal tarih dizesini geri döndür
      return date;
    }
  } else {
    // Hem / hem de - karakterleri içermiyor, orijinal tarih dizesini geri döndür
    return date;
  }
}
static getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    print(formattedDate);
   formattedDate;
    return formattedDate;
  }
 static DateTime parseDate(String dateStr) {
    print("parse data başladı");

    int day = 0;
    int month = 0;
    int year = 0;
   if (dateStr.contains("/")) {

    var parts = dateStr.split("/");
     day = int.parse(parts[0]);
     month = int.parse(parts[1]);
     year = int.parse(parts[2]);
    print("parse data bitti");
   }
    else if (dateStr.contains("-")) {
        var parts = dateStr.split("-");
     day = int.parse(parts[0]);
     month = int.parse(parts[1]);
     year = int.parse(parts[2]);
    }
    else if (dateStr.contains(".")) {
        var parts = dateStr.split(".");
     day = int.parse(parts[0]);
     month = int.parse(parts[1]);
     year = int.parse(parts[2]);
    }
    else{
      print("hata");
    }


    return DateTime(year, month, day);
  }


 static List<FireProduct> orderProductsByDate(List<FireProduct> productList) {
  productList.sort((a, b) {
    DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.date);
    DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.date);
    return dateA.compareTo(dateB);
  });

  return productList;
}
}