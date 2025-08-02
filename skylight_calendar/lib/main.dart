import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/app_database.dart';
import 'screens/calendar_screen.dart';
import 'providers/database_provider.dart';

void main() {

  runApp(SkylightApp());
}

class SkylightApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
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
