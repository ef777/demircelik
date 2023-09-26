import 'package:get/get.dart';

class Kur extends GetxService {
  double _usd = 0.0;
  double _cny = 0.0;

  double get usdValue => _usd;
  double get cnyValue => _cny;

  set usdValue(double value) {
    _usd = value;
  }

  set cnyValue(double value) {
    _cny = value;
  }
}
