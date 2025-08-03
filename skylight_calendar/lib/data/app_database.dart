import 'package:drift/drift.dart';
import 'tables/events.dart';
import 'tables/google_calendars.dart';
import 'tables/record_locks.dart';
import 'tables/rewards.dart';
import 'tables/users.dart';
import 'tables/tasks.dart';
import 'tables/settings.dart';

import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'users_dao.dart';
import 'settings_dao.dart';

part 'app_database.g.dart'; // Important!

@DriftDatabase(
  tables: [Users, Tasks, Rewards, Events, GoogleCalendars, RecordLocks, Settings],
    daos: [UsersDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
