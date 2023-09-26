import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart'; // Import intl package for date formatting

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
    return LineChart(
      mainData1(),
    );
  }
 Widget multibottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.white,
    );

          
                        int index = value.toInt();

                     /*   DateTime date = parseDate(dates1[index]); */
                        

/*   var dat=  formatDate(date);

 */  var leng = dates1[index].length;
String lastTwoChars = dates1[index].substring(leng - 2);

 String shortDate =lastTwoChars;
    return SideTitleWidget(
      axisSide: meta.axisSide,
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
    List<double> prices1AsDouble =
        prices1.map((price) => double.parse(price)).toList();
    double minY1 = prices1AsDouble.reduce(min);
    double maxY1 = prices1AsDouble.reduce(max);

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
        horizontalInterval: 1,
        verticalInterval: 1,
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
            reservedSize: 30,
            getTitlesWidget: multibottomTitleWidgets,
            interval: 1,
        
        )),


leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),

        /* leftTitles: AxisTitleData(
          show: true,
          reservedSize: 42,
          getTitles: (value) {
            return value.toInt().toString();
          },
        ), */
      ),
       
    /* minY : min(min(minY1, minY2), min( prices3.length>0 ? minY3 : 99999 ,  prices4.length>0 ? minY4 : 99999)),
     maxY : max(max(maxY1, maxY2), max(prices3.length>0 ? maxY3 : 99999  , prices4.length>0 ?  maxY4 : 99999)),
    minX: 0.0, */
     minY: 0,
    maxY:  1000,
    
 

      

    
    // maxX: (prices1AsDouble.length - 1).toDouble(),
     
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

  DateTime parseDate(String dateStr) {
    // Assume dateStr is in the format "dd.mm.yyyy"
    List<String> parts = dateStr.split('.');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  String formatDate(DateTime date) {
    // Format date as "dd.MM.yyyy"
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
class LineChartSample2 extends StatefulWidget {
  LineChartSample2(
      {super.key,
      required this.title,
      required this.price,
      required this.prices,
      required this.dates});
  String title;
  String price;
  List<String> prices;
  List<String> dates;
  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [Colors.green, Colors.greenAccent];
Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    
    fontSize: 8,
    color: Colors.white,
  );

  int index = value.toInt();
  String date = widget.dates.length > index ? widget.dates[index] : '';
  
  String shortDate = date.substring(0, 2);

  // Eğer price uzunluğu 20'den büyükse ve tarihin yıl kısmı 4 karakterden fazlaysa yılları da gösterme
  if (widget.prices.length > 20 && date.length > 4) {
    shortDate = date.substring(3, 5); // Ayı göster
  }
   if (widget.prices.length > 40 && date.length > 4) {
    shortDate = date.substring(8, 10); // Ayı göster
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(shortDate, style: style),
  );
}


  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
    List<FlSpot> spots = List<FlSpot>.generate(
      prices.length,
      
      (index) => FlSpot(index.toDouble(), double.parse(widget.prices[index])),
    );
    print("spots");
    print(spots);
    List<double> pricesAsDouble =
        widget.prices.map((price) => double.parse(price)).toList();
    double minY = pricesAsDouble.reduce(min);
    double maxY = pricesAsDouble.reduce(max);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
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
            getTitlesWidget: bottomTitleWidgets,
            interval: prices.length / 10,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
            interval: prices.length < 10 ? 2 : prices.length < 20 ? 5 : 8,
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

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 10,
    color: Colors.white,
  );

  int labelInterval;

  if (value < 1000) {
    // Eğer 'value' 1000'in altındaysa, etiket aralığını manuel olarak ayarla
    labelInterval = 50;
  } else {
    // Eğer 'value' 1000'in üzerindeyse, 'value' değerinin karekökünü al
    labelInterval = math.sqrt(value).round();
  }

  // Eğer 'value' belirlenen aralığın tam katıysa, etiketi göster
  if (value % labelInterval == 0) {
    return Text(value.toString(), style: style, textAlign: TextAlign.left);
  } else {
    // Aksi halde, bir etiket gösterme
    return Text('', style: style);
  }
}

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
  List<Color> gradientColors = [Colors.green, Colors.greenAccent];
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.white,
    );

    int index = value.toInt();
    String date = widget.dates.length > index ? widget.dates[index] : '';
    String shortDate = date.substring(0, 2);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(shortDate, style: style),
    );
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
    List<FlSpot> spots = List<FlSpot>.generate(
      prices.length,
      (index) => FlSpot(index.toDouble(), double.parse(widget.prices[index])),
    );
    print("spots");
    print(spots);
    List<double> pricesAsDouble =
        widget.prices.map((price) => double.parse(price)).toList();
    double minY = pricesAsDouble.reduce(min);
    double maxY = pricesAsDouble.reduce(max);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
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
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
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

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

