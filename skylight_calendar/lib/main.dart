import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:skylight_calendar/providers/current_time_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';

import 'data/app_database.dart';
import 'screens/calendar_screen.dart';
import 'providers/database_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize time zone database
  tzdata.initializeTimeZones();

  runApp(SkylightApp());
}

class SkylightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),

        ChangeNotifierProxyProvider<DatabaseProvider, SettingsProvider>(
          create: (_) => SettingsProvider(null),
          update: (_, dbProvider, previous) {
            if (previous != null) {
              previous.setDb(dbProvider.db);
              previous.loadSettings();
              return previous;
            }
            return SettingsProvider(dbProvider.db)..loadSettings();
          },
        ),

        ChangeNotifierProxyProvider<SettingsProvider, CurrentTimeProvider>(
          create: (_) => CurrentTimeProvider(SettingsProvider(null)), // fallback
          update: (_, settingsProvider, __) => CurrentTimeProvider(settingsProvider),
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
