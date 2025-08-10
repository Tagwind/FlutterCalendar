import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:skylight_calendar/providers/current_time_provider.dart';
import 'package:skylight_calendar/providers/weather_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';

import 'constants/default_settings.dart';
import 'data/app_database.dart';
import 'screens/calendar_screen.dart';
import 'providers/database_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize time zone database
  tzdata.initializeTimeZones();
  await dotenv.load(fileName: ".env");
  runApp(SkylightApp());
}

class SkylightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),

        ChangeNotifierProxyProvider<DatabaseProvider, SettingsProvider>(
          create: (context) => SettingsProvider(context.read<DatabaseProvider>().db),
          update: (context, dbProvider, previous) {
            if (previous != null) {
              return previous;
            }
            return SettingsProvider(dbProvider.db);
          },
        ),

        ChangeNotifierProxyProvider<SettingsProvider, CurrentTimeProvider>(
          create: (context) => CurrentTimeProvider(context.read<SettingsProvider>()),
          update: (context, settingsProvider, previous) {
            previous ??= CurrentTimeProvider(settingsProvider);
            previous.updateSettingsProvider(settingsProvider);
            return previous;
          },
        ),

        // Provider(create: (_) => WeatherService()),

        ChangeNotifierProxyProvider<SettingsProvider, WeatherProvider>(
          create: (_) => WeatherProvider(),
          update: (_, settings, weather) {
            weather ??= WeatherProvider();
            weather.updateZipCode(settings.get(SettingKey.zipCode));
            return weather;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Smith Family',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: CalendarScreen(),
      ),
    );
  }
}
