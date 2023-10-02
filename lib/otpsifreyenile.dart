import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final auth = FirebaseAuth.instance;
  String verificationId = "";
  bool otpSent = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = "";
    otpController.text = "";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Şifre Sıfırla"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
          
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Telefon Numarası",
                border: OutlineInputBorder()  
              ),
              validator: (value) {
                if(value!.isEmpty) {
                  return "Lütfen telefon numarası giriniz";
                }
                return null;
              },
            ),
            
            SizedBox(height: 16),
            
            if(otpSent)
              TextFormField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: "SMS Kodu",
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Lütfen SMS kodunu giriniz";
                  }
                  return null;
                }  
              ),
              
            SizedBox(height: 16),
          
            ElevatedButton(
              onPressed: submit,
              child: Text(otpSent ? "OTP'yi Doğrula" : "OTP Gönder"),
            ),
            
          ],  
        ),
      ),
    );

  }

  Future<void> submit() async {

    if(formKey.currentState!.validate()) {

      try {

        if(!otpSent) {
          await sendOTP();
        } else {
          await verifyOTP(); 
        }

      } catch(e) {
        print("Hata: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu!"))  
        );
      }

    }

  }

  Future<void> sendOTP() async {

    await auth.verifyPhoneNumber(
      phoneNumber: '+90${phoneController.text}',
      verificationCompleted: (_) {},
      verificationFailed: (_) {},
      codeSent: (String verId, int? token) {
        setState(() {
          otpSent = true;
          verificationId = verId;
        });
      },
      codeAutoRetrievalTimeout: (_) {},
    );

  }

  Future<void> verifyOTP() async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text
    );

    await auth.signInWithCredential(credential);

    updatePassword();

  }

  Future<void> updatePassword() async {

    final newPassword = await showUpdatePasswordDialog();

    if(newPassword != null) {
      await auth.currentUser!.updatePassword(newPassword);  
      Navigator.of(context).pop();
    }

  }

  Future<String?> showUpdatePasswordDialog() async {

    final newPasswordCtrl = TextEditingController();

    return await showDialog(
      context: context, 
      builder: (context) {

        return AlertDialog(
          title: Text("Yeni Şifre"),
          content: TextField(
            controller: newPasswordCtrl,
            obscureText: true,
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: Text("İPTAL"),
              onPressed: () {
                Navigator.pop(context);
              }, 
            ),
            TextButton(
              child: Text("KAYDET"),
              onPressed: () {
                if(newPasswordCtrl.text.length >= 6) {
                  Navigator.pop(context, newPasswordCtrl.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Şifre en az 6 karakter olmalıdır!"))
                  );
                }
              }, 
            )
          ],
        );

      }
    );

  }

}