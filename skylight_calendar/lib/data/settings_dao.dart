import 'package:drift/drift.dart';
import 'tables/settings.dart';
import 'app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  // Insert or update setting
  Future<void> upsertSetting({
    required String key,
    required String value,
    String? section,
    String? type,
  }) async {
    print('Saving setting: $key = $value');
    await into(settings).insertOnConflictUpdate(SettingsCompanion(
      key: Value(key),
      value: Value(value),
      section: Value(section),
      type: Value(type),
      updatedAt: Value(DateTime.now()), // Pass DateTime here, Drift handles storage
    ));
  }




  // Get setting by key
  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  // Get all settings in a section
  Future<List<Setting>> getSettingsBySection(String section) {
    return (select(settings)..where((s) => s.section.equals(section))).get();
  }

  // Delete a setting by key
  Future<void> deleteSetting(String key) async {
    await (delete(settings)..where((s) => s.key.equals(key))).go();
  }

  // Clear all settings
  Future<void> clearAllSettings() async {
    await delete(settings).go();
  }
}
