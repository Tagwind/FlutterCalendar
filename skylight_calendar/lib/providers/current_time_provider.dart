import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skylight_calendar/providers/settings_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants/default_settings.dart';

class CurrentTimeProvider with ChangeNotifier {
  SettingsProvider _settingsProvider;
  Timer? _timer;
  late tz.TZDateTime _now;

  CurrentTimeProvider(this._settingsProvider) {
    _now = tz.TZDateTime.now(tz.getLocation('America/New_York'));
    _init();
  }

  Future<void> _init() async {
    await _settingsProvider.initialized;
    _now = _getNow();
    _startTimer();
    notifyListeners();
  }

  void updateSettingsProvider(SettingsProvider newProvider) {
    if (identical(_settingsProvider, newProvider)) return;

    _timer?.cancel();
    _settingsProvider = newProvider;
    _init();
  }

  tz.TZDateTime get now => _now;

  tz.TZDateTime _getNow() {
    var timezone = _settingsProvider.get(SettingKey.timezone);
    if (timezone.isEmpty || !tz.timeZoneDatabase.locations.containsKey(timezone)) {
      timezone = 'America/New_York';
    }
    final location = tz.getLocation(timezone);
    return tz.TZDateTime.now(location);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = _getNow();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
