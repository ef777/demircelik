import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

// ignore: must_be_immutable
class Comp1 extends StatefulWidget {
  const Comp1(
      {super.key,
      required this.city,
      required this.product,
      required this.q8Degisim,
      required this.q8price,
      required this.q10price,
      required this.q12price,
      required this.q10Degisim,
      required this.q12Degisim,
      required this.yesil});
  final String city;
  final String product;
  final String q8Degisim;
  final String q10Degisim;
  final String q12Degisim;

  final String q8price;
  final String q10price;
  final String q12price;
  final bool yesil;

  @override
  State<Comp1> createState() => _Comp1State();
}

class _Comp1State extends State<Comp1> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  widget.yesil
                      ? Color.fromARGB(48, 4, 100, 7)
                      : Color.fromARGB(44, 146, 76, 76),
                  widget.yesil
                      ? Color.fromARGB(94, 7, 65, 113)
                      : Color.fromARGB(94, 229, 54, 54),
                ]),

            // gradient: LinearGradient(
            //     colors: [
            //       Color.fromARGB(255, 118, 190, 120),
            //       Color.fromARGB(255, 91, 91, 91),
            //       Colors.lightBlueAccent,
            //     ],
            //     stops: [
            //       0.0,
            //       0.5,
            //       1.0
            //     ],
            //     begin: FractionalOffset.bottomLeft,
            //     end: FractionalOffset.topRight,
            //     tileMode: TileMode.repeated),
            borderRadius: BorderRadius.circular(16)),
        // height: 200,
        // ignore: prefer_const_constructors
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Align(
              //     alignment: Alignment.centerRight,
              //     child: LineChartSample2(
              //       gradientColors: [
              //         Color.fromARGB(255, 62, 152, 65),
              //         Color.fromARGB(255, 15, 70, 44),
              //       ],
              //     )),
              Text(
                widget.city,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              Text(
                widget.product,
                style:
                    context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q8 mm : ${widget.q8price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q8Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q10 mm : ${widget.q10price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q10Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q12 - Q32 mm : ${widget.q12price}",
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                  Text(
                    widget.q12Degisim,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: widget.yesil ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class Comp12 extends StatelessWidget {
  const Comp12(
      {super.key,
      required this.price,
      required this.title,
      required this.date});
  final String price;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.fromLTRB(2, 3, 5, 2),
        height: size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(47, 153, 158, 153),
                  Color.fromARGB(94, 7, 65, 113)
                ]),
            borderRadius: BorderRadius.circular(16)),
        // height: 200,
        // ignore: prefer_const_constructors
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
   SizedBox(
                height: 4,
              ),
            Text(
                title,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white, fontSize: 0),
              ),
              Row(
                
                     crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
 Text(
                  date,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),   Text(
                price,
                style:
                    context.textTheme.labelLarge?.copyWith(color: Colors.green),
              ),
 Text(
                "USD / Ton",
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white, fontSize: 10),
              ),
              ],),
              
            
            
            ],
          ),
        ));
  }
}
