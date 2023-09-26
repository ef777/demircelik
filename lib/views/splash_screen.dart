// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/main.dart';
import 'package:demircelik/views/auth_views.dart/login/login_view.dart';
import 'package:demircelik/views/auth_views.dart/sign_up/components/smsdog.dart';
import 'package:demircelik/model-control/kurdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:get/get.dart';

import 'anaview.dart';
    Kur kur = Get.find<Kur>();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   Future<void> fetchonay() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        print('Kullanıcı belgesi bulunamadı');
        userData = null;
      }
    } catch (e) {
      print('Firestore hatası: $e');
    }
  }

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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? data; // Çekilen kullanıcı verisi burada saklanacak
    Future<void> fetchkontrol() async {
        final AuthController authController = Get.find();

    try {
      DocumentSnapshot documentSnapshot = await firestore.collection('kontrol').doc("doc1").get();

      if (documentSnapshot.exists) {
        print("kontrol veri var");
        // Belge varsa verileri userData değişkenine ata
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>;
          print(data!['acilis'].toString());
          if(data!['acilis'].toString()=="1"){
            print("acilis 1");
  Future.delayed(const Duration(seconds: 2), () {
      // NextScreen, yönlendirilecek ekranın adıdır.
      authController.checkLoginStatus(); // Oturum açma durumunu kontrol edin
        if (userData != null ){

// && authController.isLoggedIn.value == false

      if (userData!['onay'] == true) {
        context.navigateToPage( AreaAndCouView());
      } else {

       context.navigateToPage( SmsDog()); }
      } else {
       context.navigateToPage( LoginScreen()); 
      }


    });       }

        });
      } else {
        // Belge yoksa veya hata oluşursa işlemleri burada yönetebilirsiniz
        print('Belge bulunamadı.');
      }
    } catch (e) {
     print('Hata oluştu: $e');
    }
  }
  aciliskont()async {
await fetchkontrol();
  await  fetchonay();
  }
  User? _user;
    Map<String, dynamic>? userData;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
        _user = _auth.currentUser;

    aciliskont();
 gettr_usd().then((value) =>  kur.usdValue = value  );
 getcny_usd().then((value) =>  kur.cnyValue = value  ) ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
        
      
      ),
    );
  } 
}  

