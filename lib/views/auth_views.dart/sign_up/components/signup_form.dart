import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/main.dart';
import 'package:demircelik/views/auth_views.dart/sign_up/components/smsdog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../components/constants.dart';
import '../../../anaview.dart';
import '../../login/login_view.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ulkeController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController sifteController = TextEditingController();
  TextEditingController sehirController = TextEditingController();
  TextEditingController numaraController = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    if(isloading){
      return Center(child: CircularProgressIndicator(),);
    }
    return WillPopScope(
    onWillPop: () async {
      // Geri düğmesinin işlevsiz hale getirilmesini sağlayan boş bir Future döndürülüyor.
      return false;
    },
    child: Form(
      child: Column(
        children: [
          CustomTextField(
            keyboardType: TextInputType.name,
            icon: Icons.person,
            title: "İsim",
            textEditingController: nameController,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            textEditingController: ulkeController,
            keyboardType: TextInputType.name,
            icon: Icons.flag,
            title: "Ülke",
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            textEditingController: sehirController,
            keyboardType: TextInputType.name,
            icon: Icons.location_city,
            title: "Şehir",
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            textEditingController: mailController,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.mail,
            title: "Mail Adresin",
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            icon: Icons.lock,
            textEditingController: sifteController,
            title: "Şifre",
            password: true,
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: numaraController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Telefon Numarası',
              prefixIcon: Icon(Icons.phone),
            ),
            onChanged: (value) {
              if (!value.startsWith('+90')) {
                numaraController.text = '+90' + value;
                numaraController.selection = TextSelection.fromPosition(
                    TextPosition(offset: numaraController.text.length));
              }
            },
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isloading = true;
              });
             await  _register(context);
              setState(() {
                isloading = false;
              });
            },
            child: Text("Kayıt Ol".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
       )   );
  }

  Future<void> _register(BuildContext context) async {
      final AuthController authController = Get.find();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailController.text,
        password: sifteController.text,
      );
UserCredential emailCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: mailController.text,
    password: sifteController.text,
  );
  String userUid = emailCredential.user!.uid;

      // Kullanıcı Firestore'a kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': mailController.text,
        'ülke': ulkeController.text,
        'sehir': sehirController.text,
        'soyisim': nameController.text,
        'isim': nameController.text,
        'numara': numaraController.text,
        'onay': false,
      });

      // Telefon numarasına doğrulama kodu gönder
/*       await _sendVerificationCode(numaraController.text);
 */
      // Doğrulama kodunu al
    /*   String verificationCode = await _showVerificationDialog(context);

      // Doğrulama kodunu Firebase ile doğrula
      await _verifyPhoneNumber(userCredential.user!.uid, verificationCode); */

      print('Kayıt başarılı! Kullanıcı ID: ${userCredential.user!.uid}');
      authController.login();
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SmsDog()),
          (route) => false);
      // Kayıt başarılı olduysa yapılacak işlemleri buraya ekleyebilirsiniz.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Zayıf şifre');
         showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uyarı '),
          content: Text('Şifreniz çok kısa'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
      } else if (e.code == 'email-already-in-use') {
        print('Bu e-posta zaten kullanılıyor');
          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uyarı '),
          content: Text('Bu Eposta kullanılıyor'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
      } else {
          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uyarı '),
          content: Text('Hata meydana geldi'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
        print('Kayıt hatası: $e');
      }
    } catch (e) {
      print('Kayıt hatası: $e');
        showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata '),
          content: Text('$e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    }
  }

  /* // Telefon numarasına doğrulama kodu gönderen fonksiyon
  Future<void> _sendVerificationCode(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Otomatik doğrulama
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Doğrulama hatası: $e');
          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doğrulama Hatası '),
          content: Text('$e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Doğrulama kodu gönderildi
        final code = await _showVerificationDialog(context);
        _verifyPhoneNumber(verificationId, code);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
      
       showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doğrulama Kodu Zaman Aşımı '),
          content: Text('Doğrulama kodu zaman aşımına uğradı'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
        // Doğrulama kodu zaman aşımına uğradı
      },
      timeout: Duration(seconds: 120),

    );
  } */
/* 
  // Kullanıcıdan doğrulama kodunu alacak olan dialog
  Future<String> _showVerificationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Doğrulama Kodu'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {},
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                  context, ''); // Boş döndürerek iptal edildiğini belirtiyoruz
            },
            child: Text('Onayla'),
          ),
        ],
      ),
    );
  }

  // Doğrulama kodunu Firebase ile doğrulayan fonksiyon
  Future<void> _verifyPhoneNumber(
      String verificationId, String verificationCode) async {
    if (!verificationCode.startsWith('+90')) {
      verificationCode = '+90' + verificationCode;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Telefon doğrulama başarılı');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(verificationId)
          .update({'onay': true});
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AreaAndCouView()),
      );
    } on FirebaseAuthException catch (e) {
      print('Telefon doğrulama hatası: $e');
      throw Exception('Telefon doğrulama hatası');
    }
  }
}
 */ }
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.icon,
    required this.title,
    this.keyboardType,
    this.password,
    required this.textEditingController,
  });
  final IconData icon;
  final String title;
  final TextInputType? keyboardType;
  final bool? password;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: password ?? false,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      cursorColor: kPrimaryColor,
      onSaved: (email) {},
      decoration: InputDecoration(
        hintText: title,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Icon(icon),
        ),
      ),
    );
  }
}
