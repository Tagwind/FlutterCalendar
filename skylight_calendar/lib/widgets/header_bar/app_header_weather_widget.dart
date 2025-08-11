import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';

class AppHeaderWeather extends StatelessWidget {
  const AppHeaderWeather({super.key});

  @override
  Widget build(BuildContext context) {

    final weatherProvider = context.watch<WeatherProvider>();
    final weather = weatherProvider.weatherData;

    if (weatherProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (weatherProvider.weatherData != null) {
      return Row(
        children: [
          Image.network(
            weather?.current.icon ?? '',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          Text('${weather?.current.tempF.toStringAsFixed(1)}°F' ?? ''),
        ],
      );
    }
    return const Text("");
  }
}