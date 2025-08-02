import 'package:drift/drift.dart';
import 'users.dart';

class RecordLocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordType => text()(); // e.g., 'event', 'task'
  IntColumn get recordId => integer()();
  DateTimeColumn get lockedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get userId => integer().references(Users, #id)();
}