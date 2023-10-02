import 'package:get/get.dart';

import 'dart:convert';

import 'package:demircelik/model-control/datacont.dart';
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
class Kur extends GetxService {
  
 Future<double> gettr_usd() async {
    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/TRY'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rates = data['rates'];
      final usdRate = rates['USD'];
      return  await usdRate;
    }

    return 0;
  }Future<double> getcny_usd() async {
    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/CNY'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rates = data['rates'];
      final usdRate = rates['USD'];
      return  await usdRate;
    }

    return 0;
  }
   
   static CnyToUsd(usdRate, amount) {
    print("çeviri");
    return amount * usdRate;
    
  }

  static double usd = 0.0;
  static double cny = 0.0;

  double get usdValue => usd;
  double get cnyValue => cny;

  set usdValue(double value) {
    usd = value;
  }

  set cnyValue(double value) {
    cny = value;
  }
}
