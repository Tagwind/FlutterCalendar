class WeatherData {
  final double tempF;
  final String iconUrl;

  WeatherData({required this.tempF, required this.iconUrl});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      tempF: (json['current']['temp_f'] as num).toDouble(),
      iconUrl: "https:${json['current']['condition']['icon']}",
    );
  }
}
