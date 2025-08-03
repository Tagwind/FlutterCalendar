import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../constants/default_settings.dart';

class SettingsProvider extends ChangeNotifier {
  final AppDatabase? _db;
  final Map<SettingKey, String> _settings = {};

  SettingsProvider(this._db);

  Future<void> loadSettings() async {
    for (var entry in settingDefinitions.entries) {
      final key = entry.key;
      final definition = entry.value;

      final storedValue = await _db?.settingsDao.getSetting(key.keyString);
      _settings[key] = storedValue ?? definition.defaultValue;

      if (storedValue == null) {
        await _db?.settingsDao.upsertSetting(
          key: key.keyString,
          value: definition.defaultValue,
        );
      }
    }
    notifyListeners();
  }

  String get(SettingKey key) => _settings[key] ?? settingDefinitions[key]!.defaultValue;

  Future<void> update(SettingKey key, String value) async {
    _settings[key] = value;
    await _db?.settingsDao.upsertSetting(key: key.keyString, value: value);
    notifyListeners();
  }

  /// Get section info (optional)
  String getSection(SettingKey key) => settingDefinitions[key]?.section ?? 'General';

  SettingValueType getType(SettingKey key) => settingDefinitions[key]?.type ?? SettingValueType.string;
}

