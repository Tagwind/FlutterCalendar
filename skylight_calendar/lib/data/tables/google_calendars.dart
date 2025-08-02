import 'package:drift/drift.dart';
import 'users.dart';

class GoogleCalendars extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get calendarId => text()(); // from Google API
  TextColumn get name => text()();
  BoolColumn get isPrimary => boolean().withDefault(Constant(false))();
  BoolColumn get isReadOnly => boolean().withDefault(Constant(false))();
}