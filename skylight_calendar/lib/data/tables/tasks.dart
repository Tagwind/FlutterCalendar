import 'package:drift/drift.dart';
import 'users.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  BoolColumn get isComplete => boolean().withDefault(Constant(false))();
  DateTimeColumn get dueDate => dateTime().nullable()();
}