import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherDetailScreen extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // We'll just use the first forecast day for hourly display
    final todayForecast = weatherData.forecast.first;
    final hourlyData = todayForecast.hour;

    return Scaffold(
      appBar: AppBar(title: Text("Weather - ${weatherData.location.name}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current weather
            Row(
              children: [
                Image.network(weatherData.current.icon, width: 60, height: 60),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${weatherData.current.tempF.toStringAsFixed(1)}°F",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(weatherData.current.text),
                    Text(weatherData.location.name),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hourly forecast (horizontal)
            const Text("Hourly Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyData.length,
                itemBuilder: (context, index) {
                  final hour = hourlyData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(hour.time.split(" ").last), // show only time
                          Image.network(hour.icon, width: 40, height: 40),
                          Text("${hour.tempC.toStringAsFixed(0)}°C"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 3-day forecast (vertical cards)
            const Text("3-Day Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: weatherData.forecast.take(3).map((day) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Image.network(day.day.icon, width: 40, height: 40),
                    title: Text(day.date),
                    subtitle: Text(day.day.text),
                    trailing: Text(
                        "${day.day.maxtempC.toStringAsFixed(0)}° / ${day.day.mintempC.toStringAsFixed(0)}°C"
                    ),
                    onTap: () {
                      // If you want to view hourly for this day
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WeatherDetailScreen(
                            weatherData: WeatherData(
                              location: weatherData.location,
                              current: weatherData.current,
                              forecast: [day], // Pass just the tapped day
                              alerts: weatherData.alerts,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
