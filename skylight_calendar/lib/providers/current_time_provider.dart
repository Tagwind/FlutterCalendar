import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skylight_calendar/providers/settings_provider.dart';

import 'package:timezone/timezone.dart' as tz;

import '../constants/default_settings.dart';

class CurrentTimeProvider with ChangeNotifier {
  final SettingsProvider settingsProvider;
  final List<String> allTimeZones = tz.timeZoneDatabase.locations.keys.toList();
  late tz.TZDateTime _now;
  Timer? _timer;
  bool _initialized = false;
  bool _disposed = false;

  bool get isReady => _initialized;

  CurrentTimeProvider(this.settingsProvider) {
    _init();
  }

  Future<void> _init() async {
    await settingsProvider.initialized;

    // Mark initialized even if disposed, so anyone awaiting knows it finished
    _initialized = true;

    if (_disposed) return;

    _now = _getNow();
    _startTimer();

    notifyListeners();
  }

  tz.TZDateTime? get now => _initialized ? _now : null;

  tz.TZDateTime _getNow() {
    final timezone = settingsProvider.get(SettingKey.timezone);
    final location = tz.getLocation(timezone);
    return tz.TZDateTime.now(location);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      _now = _getNow();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
