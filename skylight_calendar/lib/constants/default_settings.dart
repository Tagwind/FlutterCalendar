class SettingDefinition {
  final String defaultValue;
  final String section;
  final SettingValueType type;

  const SettingDefinition({
    required this.defaultValue,
    required this.section,
    required this.type,
  });
}

enum SettingValueType {
  string,
  integer,
  boolean,
  color,
  date,
}

enum SettingKey {
  timezone,
  calendarDisplayName,
  zipCode,
  weekStartDay,
}

extension SettingKeyExtension on SettingKey {
  String get keyString => toString().split('.').last;
}

const Map<SettingKey, SettingDefinition> settingDefinitions = {
  SettingKey.timezone: SettingDefinition(
    defaultValue: 'America/New_York',
    section: 'General',
    type: SettingValueType.string,
  ),
  SettingKey.calendarDisplayName: SettingDefinition(
    defaultValue: 'Highlight Calendar',
    section: 'General',
    type: SettingValueType.string,
  ),
  SettingKey.zipCode: SettingDefinition(
    defaultValue: '',
    section: 'General',
    type: SettingValueType.string,
  ),
  SettingKey.weekStartDay: SettingDefinition(
    defaultValue: 'Sunday',
    section: 'General',
    type: SettingValueType.string,
  ),
};
