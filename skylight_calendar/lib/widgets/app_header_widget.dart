import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/default_settings.dart';
import '../providers/current_time_provider.dart';
import '../providers/settings_provider.dart';


class AppHeader extends StatefulWidget {
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final String monthLabel;
  final String title;
  final Function(String) onViewTypeChanged;
  final String currentViewType;

  const AppHeader({
    Key? key,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.monthLabel,
    required this.title,
    required this.onViewTypeChanged,
    required this.currentViewType,
  }) : super(key: key);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {


  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final currentTimeProvider = context.watch<CurrentTimeProvider>();

    // Don't render if settings are not ready or CurrentTimeProvider hasn't run _init yet
    if (!settingsProvider.isInitialized || currentTimeProvider.now == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final now = currentTimeProvider.now!;
    final timeZoneId = settingsProvider.get(SettingKey.timezone);
    final formattedTime = DateFormat.Hm().format(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Text(
                  "$formattedTime ($timeZoneId)",
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                const Text("72°F & Sunny", style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blueAccent,
                  child: Text('T', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: widget.currentViewType,
                  items: const [
                    DropdownMenuItem(value: 'month', child: Text('Month')),
                    DropdownMenuItem(value: 'week', child: Text('Week')),
                    DropdownMenuItem(value: 'day', child: Text('Day')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      widget.onViewTypeChanged(value);
                    }
                  },
                  underline: const SizedBox(),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: widget.onPrevMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(widget.monthLabel, style: const TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: widget.onNextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
