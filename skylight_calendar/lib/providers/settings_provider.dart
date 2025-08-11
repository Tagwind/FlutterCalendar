import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../constants/default_settings.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class SettingsProvider extends ChangeNotifier {
  final AppDatabase? _db;
  final Map<SettingKey, String> _settings = {
    for (var entry in settingDefinitions.entries)
      entry.key: entry.value.defaultValue,
  };

  bool _initialized = false;
  late final Future<void> initialized;

  SettingsProvider(this._db) {
    // Initialize Future but do NOT start loading yet
    initialized = _loadSettingsOnce();
  }

  Future<void> _loadSettingsOnce() async {
    if (_initialized) return;
    _initialized = true;

    // Your existing loadSettings() logic here, renamed to _loadSettingsOnce
    final allTimeZones = tz.timeZoneDatabase.locations.keys;

    for (var entry in settingDefinitions.entries) {
      final keyString = entry.key.keyString;
      final definition = entry.value;
      final storedValue = await _db?.settingsDao.getSetting(keyString);

      if (storedValue != null && storedValue.isNotEmpty) {
        if (entry.key == SettingKey.timezone) {
          if (allTimeZones.contains(storedValue)) {
            _settings[entry.key] = storedValue;
          } else {
            final fallback = 'America/New_York';
            _settings[entry.key] = fallback;
            await _db?.settingsDao.upsertSetting(
              key: keyString,
              value: fallback,
              section: definition.section,
              type: definition.type.toString().split('.').last,
            );
          }
        } else {
          _settings[entry.key] = storedValue;
        }
      } else {
        // Default value and timezone fallback logic here as before
        String value = definition.defaultValue;
        if (entry.key == SettingKey.timezone) {
          try {
            final localTimezone = await FlutterNativeTimezone.getLocalTimezone();
            if (allTimeZones.contains(localTimezone)) {
              value = localTimezone;
            } else {
              value = 'America/New_York';
            }
          } catch (_) {
            value = 'America/New_York';
          }
        }
        _settings[entry.key] = value;
        await _db?.settingsDao.upsertSetting(
          key: keyString,
          value: value,
          section: definition.section,
          type: definition.type.toString().split('.').last,
        );
      }
    }

    notifyListeners();
  }

  bool get isInitialized => _initialized;


  String get(SettingKey key) => _settings[key]!;

  Future<void> update(SettingKey key, String value) async {
    final oldValue = _settings[key];
    //Skip updated if the value didnt actually change
    if(oldValue == value) return;
    _settings[key] = value;
    await _db?.settingsDao.upsertSetting(
      key: key.keyString,
      value: value,
      section: settingDefinitions[key]!.section,
      type: settingDefinitions[key]!.type.toString().split('.').last,
    );
    notifyListeners();
  }


  /// Get section info (optional)
  String getSection(SettingKey key) => settingDefinitions[key]?.section ?? 'General';

  SettingValueType getType(SettingKey key) => settingDefinitions[key]?.type ?? SettingValueType.string;
}

