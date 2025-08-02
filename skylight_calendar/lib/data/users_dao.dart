import 'package:drift/drift.dart';
import 'tables/users.dart';
import 'app_database.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(AppDatabase db) : super(db);

  Future<List<User>> getAllUsers() => select(users).get();
  Stream<List<User>> watchAllUsers() => select(users).watch();
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
  Future deleteUser(int id) => (delete(users)..where((u) => u.id.equals(id))).go();
  Future updateUser(User user) => update(users).replace(user);
}
