import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/default_settings.dart';
import '../../providers/current_time_provider.dart';
import '../../providers/settings_provider.dart';

class AppHeaderClock extends StatelessWidget {
  const AppHeaderClock({super.key});

  @override
  Widget build(BuildContext context) {
    // Only listen to CurrentTimeProvider here
    final now = context.select<CurrentTimeProvider, DateTime>(
          (ctp) => ctp.now,
    );
    final timeFormat = context.select<SettingsProvider, String?>(
          (sp) => sp.get(SettingKey.timeFormat),
    );

    // Decide format pattern
    final pattern = (timeFormat == '12') ? 'h:mm a' : 'HH:mm';
    final formattedTime = DateFormat(pattern).format(now);


    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
