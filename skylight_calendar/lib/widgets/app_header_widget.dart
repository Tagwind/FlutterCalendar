import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylight_calendar/widgets/header_bar/app_header_clock_widget.dart';
import '../constants/default_settings.dart';
import '../providers/settings_provider.dart';
import 'header_bar/app_header_weather_widget.dart';


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
                  settingsProvider.get(SettingKey.calendarDisplayName),
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 20),
                const AppHeaderClock(),
                const SizedBox(width: 20),
                const AppHeaderWeather(),
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
