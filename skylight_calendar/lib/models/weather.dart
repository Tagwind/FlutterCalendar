class WeatherData {
  final LocationInfo location;
  final CurrentWeather current;
  final List<ForecastDay> forecast;
  final List<Alert> alerts;

  WeatherData({
    required this.location,
    required this.current,
    required this.forecast,
    required this.alerts,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: LocationInfo.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
      forecast: (json['forecast']['forecastday'] as List)
          .map((d) => ForecastDay.fromJson(d))
          .toList(),
      alerts: json['alerts']?['alert'] != null
          ? (json['alerts']['alert'] as List)
          .map((a) => Alert.fromJson(a))
          .toList()
          : [],
    );
  }
}

class LocationInfo {
  final String name, region, country, tzId, localtime;
  final double lat, lon;

  LocationInfo({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtime,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      tzId: json['tz_id'],
      localtime: json['localtime'],
    );
  }
}

class CurrentWeather {
  final double tempC, tempF;
  final int isDay;
  final String text, icon;
  final double windKph, windMph;
  final int humidity, cloud;
  final double uv;
  final AirQuality airQuality;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.text,
    required this.icon,
    required this.windKph,
    required this.windMph,
    required this.humidity,
    required this.cloud,
    required this.uv,
    required this.airQuality,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      isDay: json['is_day'],
      text: json['condition']['text'],
      icon: "https:${json['condition']['icon']}",
      windKph: (json['wind_kph'] as num).toDouble(),
      windMph: (json['wind_mph'] as num).toDouble(),
      humidity: json['humidity'],
      cloud: json['cloud'],
      uv: (json['uv'] as num).toDouble(),
      airQuality: AirQuality.fromJson(json['air_quality'] ?? {}),
    );
  }
}

class AirQuality {
  final double co, no2, o3, so2, pm2_5, pm10;
  final int usEpaIndex, gbDefraIndex;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: (json['co'] as num?)?.toDouble() ?? 0,
      no2: (json['no2'] as num?)?.toDouble() ?? 0,
      o3: (json['o3'] as num?)?.toDouble() ?? 0,
      so2: (json['so2'] as num?)?.toDouble() ?? 0,
      pm2_5: (json['pm2_5'] as num?)?.toDouble() ?? 0,
      pm10: (json['pm10'] as num?)?.toDouble() ?? 0,
      usEpaIndex: json['us-epa-index'] ?? 0,
      gbDefraIndex: json['gb-defra-index'] ?? 0,
    );
  }
}

class ForecastDay {
  final String date;
  final DayForecast day;
  final Astro astro;
  final List<HourForecast> hour;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: DayForecast.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hour: (json['hour'] as List)
          .map((h) => HourForecast.fromJson(h))
          .toList(),
    );
  }
}

class DayForecast {
  final double maxtempC, mintempC, avgtempC;
  final String text, icon;

  DayForecast({
    required this.maxtempC,
    required this.mintempC,
    required this.avgtempC,
    required this.text,
    required this.icon,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    return DayForecast(
      maxtempC: (json['maxtemp_c'] as num).toDouble(),
      mintempC: (json['mintemp_c'] as num).toDouble(),
      avgtempC: (json['avgtemp_c'] as num).toDouble(),
      text: json['condition']['text'],
      icon: "https:${json['condition']['icon']}",
    );
  }
}

class Astro {
  final String sunrise, sunset, moonPhase;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonPhase: json['moon_phase'],
    );
  }
}

class HourForecast {
  final String time;
  final double tempC;
  final String text, icon;

  HourForecast({
    required this.time,
    required this.tempC,
    required this.text,
    required this.icon,
  });

  factory HourForecast.fromJson(Map<String, dynamic> json) {
    return HourForecast(
      time: json['time'],
      tempC: (json['temp_c'] as num).toDouble(),
      text: json['condition']['text'],
      icon: "https:${json['condition']['icon']}",
    );
  }
}

class Alert {
  final String headline, msgType, severity, desc, instruction;

  Alert({
    required this.headline,
    required this.msgType,
    required this.severity,
    required this.desc,
    required this.instruction,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      headline: json['headline'] ?? '',
      msgType: json['msgtype'] ?? '',
      severity: json['severity'] ?? '',
      desc: json['desc'] ?? '',
      instruction: json['instruction'] ?? '',
    );
  }
}
