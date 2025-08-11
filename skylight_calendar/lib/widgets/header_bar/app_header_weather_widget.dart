import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/default_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../../screens/weather_details_screen.dart';

class AppHeaderWeather extends StatelessWidget {
  const AppHeaderWeather({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final weather = weatherProvider.weatherData;

    final weatherUnits = context.select<SettingsProvider, String?>(
      (sp) => sp.get(SettingKey.weatherUnits),
    );

    if (weatherProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (weather != null) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WeatherDetailScreen(weatherData: weather),
            ),
          );
        },
        child: Row(
          children: [
            Image.network(weather.current.icon, width: 40, height: 40),
            const SizedBox(width: 8),
            Text(
              weatherUnits == 'F'
                  ? '${weather.current.tempF.toStringAsFixed(1)}°F'
                  : '${weather.current.tempC.toStringAsFixed(1)}°C',
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
