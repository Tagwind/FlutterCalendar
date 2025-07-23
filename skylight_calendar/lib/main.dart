import 'package:flutter/material.dart';
import 'screens/calendar_screen.dart';


void main() {
  runApp(SkylightApp());
}


class SkylightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smith Family',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: CalendarScreen(),
    );
  }
}
