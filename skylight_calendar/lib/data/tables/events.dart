import 'package:drift/drift.dart';
import 'users.dart';

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get isGoogleEvent => boolean().withDefault(Constant(false))();
  TextColumn get googleEventId => text().nullable()(); // for syncing
}