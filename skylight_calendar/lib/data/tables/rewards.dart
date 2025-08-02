import 'package:drift/drift.dart';
import 'users.dart';

class Rewards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  IntColumn get points => integer().withDefault(Constant(0))();
  BoolColumn get isRedeemed => boolean().withDefault(Constant(false))();
}