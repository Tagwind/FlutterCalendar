class WeatherData {
  final double tempF;
  final double tempC;
  final String iconUrl;

  WeatherData({required this.tempF, required this.iconUrl, required this.tempC});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      tempF: (json['current']['temp_f'] as num).toDouble(),
      tempC: (json['current']['temp_c'] as num).toDouble(),
      iconUrl: "https:${json['current']['condition']['icon']}",
    );
  }
}
