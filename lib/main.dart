import 'package:demircelik/model-control/kurdata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kartal/kartal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constants.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init(); // GetStorage'ı başlatın

  runApp( MyApp());
}

class AuthController extends GetxController {
  final box = GetStorage(); // GetStorage örneği oluşturun

  RxBool isLoggedIn = false.obs;

  void login() {
    isLoggedIn.value = true;
    box.write('isLoggedIn', true); // Veriyi kutuya yazın
  }

  void logout() {
    isLoggedIn.value = false;
    box.remove('isLoggedIn'); // Veriyi kutudan silin
  }

  void checkLoginStatus() {
    // Başlangıçta oturum durumunu kontrol edin
    isLoggedIn.value = box.read('isLoggedIn') ?? false;
  }
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
             Get.put(Kur());
   Get.put(AuthController()) ;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            scaffoldBackgroundColor: const Color.fromRGBO(24, 24, 28, 1),
            appBarTheme: AppBarTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: const Color.fromRGBO(24, 31, 44, 1),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color.fromARGB(255, 227, 227, 227),
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),

        // ThemeData(

        //   primarySwatch: Colors.blue,
        // ),
        home: SplashScreen());
  }
}
