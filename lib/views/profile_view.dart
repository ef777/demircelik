import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/views/auth_views.dart/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartal/kartal.dart';
// ignore_for_file: file_names, duplicate_ignore

import 'package:shared_preferences/shared_preferences.dart';

import 'area_and_product_view.dart';

class ProfilViews extends StatefulWidget {
  const ProfilViews({super.key});

  @override
  State<ProfilViews> createState() => _ProfilViewsState();
}

class _ProfilViewsState extends State<ProfilViews> {
  late Stream<DocumentSnapshot> _userStream;
  @override
  User? _user;
    Map<String, dynamic>? userData;
 final FirebaseAuth _auth = FirebaseAuth.instance;
  userveri() async {

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
   return snapshot;
  }
  @override
  void initState() {
        _user = _auth.currentUser;

 
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Profil",
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: userveri(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          
          if(snapshot.hasData){
if(snapshot.data?["isim"]==null){
            return Center(child: Text("Lütfen Giriş Yapınız"),);
          }

         

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ProfilWidget(
                    icons: Icons.person,
                    title: snapshot.data?["isim"] +
                        " " +
                        snapshot.data?["soyisim"]),
                ProfilWidget(
                    icons: Icons.email, title: snapshot.data?["email"]),
                ProfilWidget(icons: Icons.flag, title: snapshot.data?["ülke"]),
                ProfilWidget(
                    icons: Icons.location_city, title: snapshot.data?["sehir"]),
                ProfilWidget(
                    onTap: () {
   FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  LoginScreen()),
                          (route) => false);
                    },
                    icons: Icons.settings_power_outlined,
                    sufficIcon: Icons.arrow_forward_rounded,
                    title: "Çıkış Yap"),
              ],
            ),
          ); }            return const CircularProgressIndicator();

        },
      ),
    );
  }


}

class ProfilWidget extends StatelessWidget {
  const ProfilWidget(
      {super.key,
      required this.icons,
      this.sufficIcon,
      required this.title,
      this.desc,
      this.onTap,
      this.isHtml = false});
  final IconData icons;
  final IconData? sufficIcon;
  final String title;
  final String? desc;
  final Function()? onTap;
  final bool isHtml;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: context.paddingLow,
          decoration: BoxDecoration(
              border: Border.all(width: .1, color: Colors.blueAccent),
              borderRadius: context.lowBorderRadius,
              color: const Color.fromRGBO(24, 31, 44, 1),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 3,
                    blurRadius: 2,
                    color: Colors.grey.withOpacity(.02))
              ]),
          child: Row(
            children: [
              Icon(
                icons,
                color: Colors.white,
              ),
              SizedBox(
                width: context.width * .06,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    desc == null
                        ? const SizedBox.shrink()
                        : Text(
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            desc ?? "",
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: Colors.white),
                          ),
                  ],
                ),
              ),
              isHtml ? const Text("") : const Spacer(),
              sufficIcon == null
                  ? const Text("")
                  : InkWell(
                      onTap: onTap,
                      child: Icon(
                        sufficIcon,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
