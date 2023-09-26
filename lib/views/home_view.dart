import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../components/LineChart.dart';
import 'Comp.dart';
import '../constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Demir Çelik Uygulaması"),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      body: Column(children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  fillColor: Color.fromRGBO(24, 24, 28, 1),
                  hintText: "Arama Yap",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        SizedBox(
          height: context.height * .02,
        ),

        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: HomeViewWidget(),
        // ),
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: HomeViewWidget2(),
        // )
      ]),
    );
  }
}
