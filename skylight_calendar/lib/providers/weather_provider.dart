// lib/providers/weather_provider.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherProvider with ChangeNotifier {
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  String? _zipCode;
  WeatherData?  _weatherData;
  Timer? _timer;
  bool _isLoading = false;

  String? get zipCode => _zipCode;
  WeatherData?  get weatherData => _weatherData;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _startTimer();
  }

  WeatherProvider() {
    _init();
  }


  void updateZipCode(String newZip){
    if(_zipCode != newZip){
      _zipCode = newZip;
      fetchWeather();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 15), (_) {
      fetchWeather();
    });
  }

  Future<void> fetchWeather() async{
    if(_zipCode == null || _zipCode!.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$zipCode',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final weather = WeatherData.fromJson(data);
      _weatherData = weather;

    }
    _isLoading = false;
    notifyListeners();
  }
}
