import 'package:drift/drift.dart';

class Settings extends Table {
  TextColumn get key => text()();

  TextColumn get value => text().nullable()();

  TextColumn get section => text().nullable()();

  TextColumn get type => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

