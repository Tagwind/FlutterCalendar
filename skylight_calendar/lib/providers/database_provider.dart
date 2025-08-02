import 'package:flutter/material.dart';
import '../data/app_database.dart';

class DatabaseProvider extends ChangeNotifier {
  final AppDatabase _db = AppDatabase();

  AppDatabase get db => _db;
}
