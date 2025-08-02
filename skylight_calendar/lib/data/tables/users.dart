import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().withLength(min: 5, max: 100).nullable()();
  TextColumn get avatarUrl => text().nullable()();
}
