import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../components/constants.dart';
import '../../../anaview.dart';
import '../../login/login_view.dart';

class SmsDog extends StatefulWidget {
  const SmsDog({
    Key? key,
  }) : super(key: key);
  @override
  State<SmsDog> createState() => _SmsDogState();
}

class _SmsDogState extends State<SmsDog> {
 final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool isloading= false;
    Map<String, dynamic>? userData;

   Future<void> _fetchUserData() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        print('Kullanıcı belgesi bulunamadı');
      }
    } catch (e) {
      print('Firestore hatası: $e');
    }
  }

  @override
  var dogrulamakodu="";
  var verifi="";
  void initState() {
    super.initState();
    // Uygulama başlatıldığında mevcut oturumu açık olan kullanıcıyı al
    _user = _auth.currentUser;
        _fetchUserData();

  }
  @override
  Widget build(BuildContext context) {
    if(isloading){
      return Center(child: CircularProgressIndicator(),);
    }
    return  WillPopScope(
    onWillPop: () async {
      // Geri düğmesinin işlevsiz hale getirilmesini sağlayan boş bir Future döndürülüyor.
      return false;
    },
    child: Scaffold(body :
     Column(
        children: [
     const SizedBox(
            height: 300,
          ),

                Text("logo"),
 const SizedBox(
            height: 250,
          ),
              Text("Numara onayı : ${userData!['onay']}",style: TextStyle(color: Colors.white),),
          const SizedBox(height: defaultPadding / 2),
        Center(child:  ElevatedButton(
            onPressed: () {
              setState(() {
                
              isloading = true;

              });
              _sendVerificationCode(userData!['numara']);
            },
            child: Text("Numara Doğrula".toUpperCase()),
        ) ),
         
          const SizedBox(
            height: 32,
          ),
        ],
      ),
     ) );
  }

  

  Future<void> _sendVerificationCode(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        print('Doğrulama tamamlandı');
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AreaAndCouView();
        },
      ), (route) => false);

        // Otomatik doğrulama
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isloading = false;
        });
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
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AreaAndCouView();
        },
      ), (route) => false);
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
                verifi = verificationId;

        await _showVerificationDialog(context);
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
  }

  // Kullanıcıdan doğrulama kodunu alacak olan dialog
  Future<String> _showVerificationDialog(BuildContext context) async {

    return await showDialog(
      context: context,
          barrierDismissible: false, // Dışarı tıklamayı kapatmayı engelle

      builder: (context) => AlertDialog(
        title: Text('Doğrulama Kodu'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                dogrulamakodu = value;
              });
            }
          },
          
        ),
        actions: [
         
          TextButton(
            onPressed: ()async {
               setState(() {
          isloading = true;
        });
                   var sonuc=  await _verifyPhoneNumber(verifi, dogrulamakodu);
                        setState(() {
          isloading = false;
        });
                    if (sonuc) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AreaAndCouView();
        }, ), (route) => false);
                    } else {

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AreaAndCouView();
        }, ), (route) => false);
                   
                    }
                 
 
               },
            child: Text('Onayla'),
          ),
        ],
      ),
    );
  }

  // Doğrulama kodunu Firebase ile doğrulayan fonksiyon
  Future<bool> _verifyPhoneNumber(
      String verificationId, String verificationCode) async {
   
    print("verificationCode = $verificationCode");
        print("verification id = $verificationId");

    print("doğrulama işlemi başladı");

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode,
      );

         await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);

/*       await FirebaseAuth.instance.signInWithCredential(credential);
 */
      print('Telefon doğrulama başarılı');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({'onay': true});
    
        return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
          isloading = false;
        });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AreaAndCouView();
        },
      ), (route) => false);
      print('Telefon doğrulama hatası: $e');
      return false;
    }
  }
}
