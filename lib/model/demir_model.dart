class FuelPrice {
  final String city;
  final String q8Price;
  final String q10Price;
  final String q12ToQ32Price;
  final String q8DailyChangePercentage;
  final String q10DailyChangePercentage;
  final String q12DailyChangePercentage;

  FuelPrice({
    required this.city,
    required this.q8DailyChangePercentage,
    required this.q12DailyChangePercentage,
    required this.q10DailyChangePercentage,
    required this.q8Price,
    required this.q10Price,
    required this.q12ToQ32Price,
  });
}
