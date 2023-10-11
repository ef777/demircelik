import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(day, month, year);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

 Widget bottomTitleWidgets(double value, List<String> dates ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 7,
      color: Colors.white,
    );
   if(dates.length>20) {

 int index = value.toInt();
  String date = dates.length > index ? dates[index] : '';
    print(date);  
    String shortDate = date;
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Text(shortDate, style: style),
    );
   }
   else {
    int index = value.toInt();
  String date = dates.length > index ? dates[index] : '';
    print("gelen date111");
    print(date);  
    String shortDate = date;
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Text(shortDate, style: style),
    );
  }}
Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
  
    fontSize: 7,
    color: Colors.white,
  );

  
  // Eğer 'value' belirlenen aralığın tam katıysa, etiketi göster
  
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: Text(value.toString(), style: style, textAlign: TextAlign.left));
  
}
class RepeatableContainer extends StatelessWidget {
  final String priceText;
  final String nameText;
  final String tip;
  final Color color;

  const RepeatableContainer({
    Key? key, 
    required this.priceText,
    required this.color,
    required this.tip,
    required this.nameText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 3,
        left: 3,
        top: 3,
        bottom: 3,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.2),
          border:  Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      priceText ,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: tip == "1" ? 24 : 16,
                        color: color
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      nameText,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:  tip ==  "1" ? 16 : 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  int calculatePriceInterval(List<String> prices,int buyukmu) {
         if(prices.length > 35 ) {
  double interval = (20+buyukmu)  * log(prices.length + 1); // Logaritmik bir işlem uygula
  return interval.ceil();

      }
      if(prices.length > 25 ) {
  double interval = (20+buyukmu)  * log(prices.length + 1); // Logaritmik bir işlem uygula
  return interval.ceil();

      }
    
      if(prices.length > 15 ) {
  double interval = (10+buyukmu)  * log(prices.length + 1); // Logaritmik bir işlem uygula
  return interval.ceil();

      }
      else {

  double interval = 14 * log(prices.length + 1); // Logaritmik bir işlem uygula
  return interval.ceil();
}}

  int calculateInterval(List<String> dates) {
    // bu tarih için
      if (dates.length> 60) {

  double interval = 8 * log(dates.length + 1); // Logaritmik bir işlem uygula
    return interval.ceil();

    }
      if (dates.length> 40) {

  double interval = 7 * log(dates.length + 1); // Logaritmik bir işlem uygula
    return interval.ceil();

    }
    if (dates.length> 30) {

  double interval = 5 * log(dates.length + 1); // Logaritmik bir işlem uygula
    return interval.ceil();

    }
     if (dates.length> 20) {

  double interval = 4 * log(dates.length + 1); // Logaritmik bir işlem uygula
    return interval.ceil();

    }
     if (dates.length> 10) {

  double interval = 3 * log(dates.length + 1); // Logaritmik bir işlem uygula
    return interval.ceil();

    }
   
   
    else {
  double interval = 2 * log(dates.length + 1); // Logaritmik bir işlem uygula
  return interval.ceil();
}}
class LineCharScrapmonster extends StatefulWidget {
  LineCharScrapmonster(
      {super.key,
      required this.title,
      required this.price,
      required this.prices,
      required this.dates});
  String title;
  String price;
  List<String> prices;
  List<String> dates;
  State<LineCharScrapmonster> createState() => LineCharScrapmonsterstate();
}

class LineCharScrapmonsterstate extends State<LineCharScrapmonster> {
  List<Color> gradientColors = [Colors.white, Colors.white10];
 

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
List<int> intPrices = widget.prices.map((price) => double.parse(price).toInt()).toList();
int maxPrice = intPrices.reduce((value, element) => value > element ? value : element);
int minPrice = intPrices.reduce((value, element) => value < element ? value : element);
int percentageChange = (((maxPrice - minPrice) / minPrice) * 100).round();
int guncel= intPrices.last.round();

    return Column(
      children: <Widget>[
        
        Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: 

            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 0.10,
              
              
              child: 
              Row(
                children: [
                  Expanded(
                    
                    flex: 2,
                    child: Container(child: 
                    
                    RepeatableContainer(
                      color: Colors.white,
                                            tip: "1",

  priceText: "$guncel \$",
  nameText: "Güncel Fiyat", 
),
                    
                    ),
                    ),
               
   Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.orange,
                                            tip: "2",

  priceText: "$minPrice \$",
  nameText: "En Düşük", 
),
                    
                    ),
                    ),
                     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.green,
                      tip: "2",
  priceText: "$maxPrice\$",
  nameText: "En Yüksek", 
),
                    
                    ),
                    ),
     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                                              color: Colors.green,

                                            tip: "2",

  priceText: "$percentageChange",
  nameText: "Değişim %", 
),
                    
                    ),
                    ),
               
                 
            
                  ])
          ),
        ),
      

        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: LineChart(
              mainData(widget.prices),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(prices) {
  
List<FlSpot> spots;
    double minY = 0;
    double maxY = 0;
     List<double> pricesAsDouble;
     if (prices.length > 30) { 
     print("30dan yüksek");
int calculateLogarithmicSkipInterval(List<String> prices) {
  double interval = log(prices.length + 1) / log(10); // Logaritmik bir işlem uygula
  return interval.ceil();
}
List<FlSpot> filterZeroSpots(List<FlSpot> spots) {
  List<FlSpot> filteredSpots = [];
  
  for (var spot in spots) {
    if (spot.y != 0) {
      filteredSpots.add(spot);
    }
  }
  
  return filteredSpots;
}
spots = List<FlSpot>.generate(
  prices.length,
  (index) {
    int skip = calculateLogarithmicSkipInterval(widget.prices);
    int newIndex = index % skip == 0 ? index : -1; // Atlama yap
    return FlSpot(index.toDouble(), newIndex >= 0 ? double.parse(widget.prices[newIndex]) :  0 );
  },
);
List<FlSpot> filteredSpots = filterZeroSpots(spots);
spots = filteredSpots;
    print("spots");
    print(spots);
     pricesAsDouble =
        widget.prices.map((price) => double.parse(price)).toList();
     minY = pricesAsDouble.reduce(min);
     maxY = pricesAsDouble.reduce(max);

     }
     else {
      print("30dan değil yüksek");
   spots = List<FlSpot>.generate(
      prices.length,
      (index) => FlSpot(index.toDouble(), double.parse(widget.prices[index])),
    );
    print("spots");
    print(spots);
   pricesAsDouble =
        widget.prices.map((price) => double.parse(price)).toList();
  minY = pricesAsDouble.reduce(min);
   maxY = pricesAsDouble.reduce(max);
}
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
       
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            
            reservedSize: 20,
             getTitlesWidget: (value, meta) {
            return bottomTitleWidgets(value,widget.dates); 
          },
           
            interval: calculateInterval(widget.dates).toDouble(),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 25,

            interval: calculatePriceInterval(widget.prices,400).toDouble(),
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: minY,
      maxY: maxY,
      minX: 0.0,
      maxX: (pricesAsDouble.length - 1).toDouble(),
      lineBarsData: [
        LineChartBarData(
          
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
//dfssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
class AppColors {
 
  static const Color mainGridLineColor = Colors.white10;

  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class MultiLineChart extends StatelessWidget {
  final List<String> prices1;
  final List<String> prices2;
    final List<String> prices3;
  final List<String> prices4;

  final List<String> dates1; // Add the list of dates for prices1
  final List<String> dates2; // Add the list of dates for prices2
  final List<String> dates3; // Add the list of dates for prices2
  final List<String> dates4; // Add the list of dates for prices2

  MultiLineChart({required this.prices1, required this.prices2, required this.prices3,required this.prices4,required this.dates1, required this.dates2,required this.dates3,required this.dates4});

  @override
  Widget build(BuildContext context) {
    print("multi başladı");
    var size = MediaQuery.of(context).size;
    if (prices1.length == 0 && prices2.length == 0 && prices3.length == 0 && prices4.length == 0) {
      return Container(child: Text("veri yok"));
    }
 
int guncel= 0;
int guncel2=0;
int guncel3= 0;
int guncel4=0;
int percentageChange2=0;
int ikidegerbolum=0;
int percentageChange = 0;
int maxPrice=0;
int minPrice=0;
 if (prices1.length > 0 ){
List<int> intPrices = prices1.map((price) => double.parse(price).toInt()).toList();
 maxPrice = intPrices.reduce((value, element) => value > element ? value : element);
 minPrice = intPrices.reduce((value, element) => value < element ? value : element);
 percentageChange = (((maxPrice - minPrice) / minPrice) * 100).round();
 guncel= intPrices.last;
 guncel2=0;
 guncel3= 0;
 guncel4=0;
 percentageChange2=0;
 ikidegerbolum=0;
 }
if (prices2.length>0) {
List<double> intPrices2 = prices2.map((price) => double.parse(price)).toList();
double maxPrice2 = intPrices2.reduce((value, element) => value > element ? value : element);
double minPrice2 = intPrices2.reduce((value, element) => value < element ? value : element);
 percentageChange2 = (((maxPrice2 - minPrice2) / minPrice2) * 100).round();
 ikidegerbolum= ((percentageChange+percentageChange2)/2).round();
 guncel2= intPrices2.last.round();



}
if (prices3.length>0) {
List<double> intPrices3 = prices3.map((price) => double.parse(price)).toList();
double maxPrice3 = intPrices3.reduce((value, element) => value > element ? value : element);
double minPrice3 = intPrices3.reduce((value, element) => value < element ? value : element);
int percentageChange3 = (((maxPrice3 - minPrice3) / minPrice3) * 100).round();
 ikidegerbolum= ((percentageChange+percentageChange2 + percentageChange3)/3).round();

 guncel3= intPrices3.last.round();
}
if (prices4.length>0) {
List<double> intPrices4 = prices4.map((price) => double.parse(price)).toList();
double maxPrice4 = intPrices4.reduce((value, element) => value > element ? value : element);
double minPrice4 = intPrices4.reduce((value, element) => value < element ? value : element);
   guncel4= intPrices4.last.round();
}

    return  Column(
      children: <Widget>[
        prices1.length>0 && prices2.length == 0 ?
        Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: 

            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 0.10,
              
              
              child: 
              Row(
                children: [
                  Expanded(
                    
                    flex: 2,
                    child: Container(child: 
                    
                    RepeatableContainer(
                      color: Colors.white,
                                            tip: "1",

  priceText: "$guncel \$",
  nameText: "Güncel Fiyat", 
),
                    
                    ),
                    ),
               
   Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.orange,
                                            tip: "2",

  priceText: "$minPrice \$",
  nameText: "En Düşük", 
),
                    
                    ),
                    ),
                     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.green,
                      tip: "2",
  priceText: "$maxPrice\$",
  nameText: "En Yüksek", 
),
                    
                    ),
                    ),
     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                                              color: Colors.green,

                                            tip: "2",

  priceText: "${ikidegerbolum}%",
  nameText: "Değişim %", 
),
                    
                    ),
                    ),
               
                 
            
                  ])
          ),
        )
       
: prices1.length>0 && prices2.length>0 && prices3.length == 0 ?
       
        Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: 

            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 0.10,
              
              
              child: 
              Row(
                children: [
                  Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                      color: Colors.white,
                                            tip: "2",

  priceText: "$guncel \$",
  nameText: "1. Fiyat", 
),
                    
                    ),
                    ),
               
   Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.white,
                                            tip: "2",

  priceText: "${guncel2} \$",
  nameText: "2. Fiyat", 
),
                    
                    ),
                    ),
                     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.green,
                      tip: "2",
  priceText: "${guncel2.round()-guncel.round()}\$",
  nameText: "Fark", 
),
                    
                    ),
                    ),
     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                                              color: Colors.green,

                                            tip: "2",

  priceText: "$ikidegerbolum",
  nameText: "Değişim %", 
),
                    
                    ),
                    ),
               
                 
            
                  ])
          ),
        )
       
:  prices1.length>0 && prices2.length>0 && prices3.length > 0 && prices4.length == 0 ?
     
        Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: 

            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 0.10,
              
              
              child: 
              Row(
                children: [
                  Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                      color: Colors.white,
                                            tip: "2",

  priceText: "$guncel \$",
  nameText: "1. Fiyat", 
),
                    
                    ),
                    ),
               
   Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.white,
                                            tip: "2",

  priceText: "${guncel2} \$",
  nameText: "2. Fiyat", 
),
                    
                    ),
                    ),
                     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.green,
                      tip: "2",
  priceText: "${guncel3}\$",
  nameText: "3. Fiyat", 
),
                    
                    ),
                    ),
     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                                              color: Colors.green,

                                            tip: "2",

  priceText: "$ikidegerbolum",
  nameText: "Değişim %", 
),
                    
                    ),
                    ),
               
                 
            
                  ])
          ),
        )
      //ahanda 4 
: prices1.length>0 && prices2.length>0 && prices3.length > 0 && prices4.length > 0 ?
Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: 

            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 0.10,
              
              
              child: 
              Row(
                children: [
                  Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                      color: Colors.white,
                                            tip: "2",

  priceText: "$guncel \$",
  nameText: "1. Fiyat", 
),
                    
                    ),
                    ),
               
   Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.white,
                                            tip: "2",

  priceText: "${guncel2} \$",
  nameText: "2. Fiyat", 
),
                    
                    ),
                    ),
                     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                        color: Colors.green,
                      tip: "2",
  priceText: "${guncel3}\$",
  nameText: "3. Fiyat", 
),
                    
                    ),
                    ),
     Expanded(
                    
                    flex: 1,
                    child: Container(child: 
                    
                    RepeatableContainer(
                                              color: Colors.green,

                                            tip: "2",

 priceText: "${guncel4}\$",
  nameText: "3. Fiyat", 
),
                    
                    ),
                    ),
               
                 
            
                  ])
          ),
        )

 : Container(),
        AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
              bottom: 15,
            ),
            child: LineChart(
      mainData1(),
            ),
          ),
        ),
      ],
    );
  }
    

 Widget multibottomTitleWidgets(double value, List<String> dates) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 7,
      color: Colors.white,
    );
     int index = value.round();
var dates1 = this.dates1;
var dates2 = this.dates2;

var dates = dates1;
if (dates1.length>dates2.length){
  dates = dates1;
}
else {
  dates = dates2;
}  
print("gelen dates ${dates[index]}");
  String date = dates.length > index ? dates[index] : '1';
    print("son dateler " + date);
       String shortDate = "";

        
    if (date.contains("/")) {
      // / biçimini - biçimine dönüştür
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(date);
      date = DateFormat('dd-MM-yyyy').format(dateTime);
      List<String> parts = date.split('-');
  
  String year = parts[0];
  String month = parts[1];
   String day = parts[2];
     shortDate = "$month $day";
    } 
    else if (date.contains(".") ) {
      // - biçimini / biçimine dönüştür
      DateTime dateTime = DateFormat('dd.MM.yyyy').parse(date);
      date = DateFormat('dd-MM-yyyy').format(dateTime);
      List<String> parts = date.split('-');
  
  String year = parts[0];
  String month = parts[1];
  String day = parts[2];
     shortDate = "$month $day";
    }
    
    else if (date.contains("-")) {
     List<String> parts = date.split('-');
  
  String year = parts[0];
  String month = parts[1];
  String day = parts[2];
     shortDate = "$month $day";
    } else {

      // Hem / hem de - karakterleri içermiyor, orijinal tarih dizesini geri döndür
    }
    return SideTitleWidget(
      axisSide:  AxisSide.bottom,
      child: Text(shortDate, style: style),
    );
  }

  LineChartData mainData1() {
    List<FlSpot> spots1 = List<FlSpot>.generate(
      prices1.length,
      (index) => FlSpot(index.toDouble(), double.parse(prices1[index])),
    );

    List<FlSpot> spots2 = List<FlSpot>.generate(
      prices2.length,
      (index) => FlSpot(index.toDouble(), double.parse(prices2[index])),
    );
    List<FlSpot> spots3 = [];
        if (prices3.length>0) {
   spots3 = List<FlSpot>.generate(
      prices3.length,
      (index) => FlSpot(index.toDouble(), double.parse(prices3[index])),
    );
        }
         List<FlSpot> spots4 = [];
            if (prices4.length>0) {
 spots4 = List<FlSpot>.generate(
      prices4.length,
      (index) => FlSpot(index.toDouble(), double.parse(prices4[index])),
    );
            }
  List<double> prices1AsDouble =  prices1.isEmpty ? 
        prices1.map((price) => double.parse(price)).toList(): [];
    double minY1 =  prices1AsDouble.isNotEmpty ? prices1AsDouble.reduce(min) : 0;
    double maxY1 = prices1AsDouble.isNotEmpty ? prices1AsDouble.reduce(max) : 0;

    List<double> prices2AsDouble =
        prices2.map((price) => double.parse(price)).toList();
    double minY2 = prices2AsDouble.reduce(min);
    double maxY2 = prices2AsDouble.reduce(max);
    List<double> prices3AsDouble = [];
     double minY3 = 0;
    double maxY3 = 0;
     if(prices3.length>0){
     prices3AsDouble =
        prices3.map((price) => double.parse(price)).toList();
        minY3 = prices3AsDouble.reduce(min);
     maxY3 = prices3AsDouble.reduce(max);
     }
    List<double> prices4AsDouble = [];
     double minY4 = 0;
    double maxY4 = 0;
      if(prices4.length>0){
      prices4AsDouble =
          prices4.map((price) => double.parse(price)).toList();
             minY4 = prices3AsDouble.reduce(min);
     maxY4 = prices3AsDouble.reduce(max);
        }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
     
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles:AxisTitles(
          sideTitles: SideTitles(
          showTitles: true,
            reservedSize: 20,
              getTitlesWidget: (value, meta) {
            return multibottomTitleWidgets(dates1.length.toDouble()-1 ,dates1); 
          },
            interval: calculateInterval(dates1).toDouble(),
        
        )),


leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
            interval: calculatePriceInterval(prices1,500).toDouble(),
          ),
        ),

       
      ),
       

     minY: -100,
    maxY:  1300,
  
      lineBarsData: [
        LineChartBarData(
          spots: spots1,
          isCurved: true,
          color: Colors.blue, // First graph color
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0), // First graph area color
          ),
        ),
        LineChartBarData(
          spots: spots2,
          isCurved: true,
          color: Colors.red, // Second graph color
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.red.withOpacity(0), // Second graph area color
          ),
        ),
        if (prices3.length>0) LineChartBarData(
          spots: spots3,
          isCurved: true,
          color: Colors.green, // Second graph color
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0), // Second graph area color
          ),
        ),
        if (prices4.length>0) LineChartBarData(
          spots: spots4,
          isCurved: true,
          color: Colors.yellow, // Second graph color
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.yellow.withOpacity(0), // Second graph area color
          ),
        ),
      ],
    );
  }
}


