import 'package:demircelik/otpsifreyenile.dart';
import 'package:demircelik/views/auth_views.dart/sign_up/sign_up_view.dart';
import 'package:demircelik/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:demircelik/main.dart';
import 'package:demircelik/views/anaview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mailController = TextEditingController();

    TextEditingController sifreController = TextEditingController();

   bool isLoading = false;

  final AuthController authController = Get.find();

  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Giriş başarılı
      User? user = userCredential.user;
      print(user?.uid);
      
                  authController.login(); // Oturum açıldığında
      
      id = user?.uid ?? "h";
      print('Giriş yapıldı: ${user?.uid}');
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return SplashScreen();
        },
      ), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
         showDialog(
      context: context,
          barrierDismissible: false, // Dışarı tıklamayı kapatmayı engelle

      builder: (context) => AlertDialog(
        title: Text('Hata'),
        content:  Text('Hata: "Kullanıcı bulunamadı"'),
        
        actions: [
         
          TextButton(
            onPressed: () {
                      Navigator.pop(context); 
              
               },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
        print('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
         showDialog(
      context: context,
          barrierDismissible: false, // Dışarı tıklamayı kapatmayı engelle

      builder: (context) => AlertDialog(
        title: Text('Hata'),
        content:  Text('Hata: "Hatalı parola yada kullanıcı adı"'),
        
        actions: [
         
          TextButton(
            onPressed: () {
                      Navigator.pop(context); 
              
               },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
        print('Hatalı parola.');
      }
    } catch (e) {
      print('Hata: $e');
      showDialog(
      context: context,
          barrierDismissible: false, // Dışarı tıklamayı kapatmayı engelle

      builder: (context) => AlertDialog(
        title: Text('Doğrulama Kodu'),
        content:  Text('Hata: $e'),
        
        actions: [
         
          TextButton(
            onPressed: () {
                      Navigator.pop(context); 
              
               },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

    }
  

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }

   
    return WillPopScope(
    onWillPop: () async {
      // Geri düğmesinin işlevsiz hale getirilmesini sağlayan boş bir Future döndürülüyor.
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Yap"),
      ),
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          const Center(
            child: Text(
              "X",
              style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Row(
            children:  [
              Spacer(),
              Expanded(
                flex: 26,
                child: Form(
      child: Column(
        children: [
          TextFormField(
            controller: mailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Mail Adresin",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: sifreController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Şifre",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async{
                
                setState(() {
                  isLoading = true;
                });
               await signInWithEmail(
                    mailController.text, sifreController.text, context);
                      setState(() {
                  isLoading = false;
                });
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pushReplacement( 
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
           Forget_pass(
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  ResetPasswordPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    )
              ),
              Spacer(),
            ],
          ),
          const Spacer(
            flex: 4,
          ),
        ],
      ),
     ) );
  }
}


