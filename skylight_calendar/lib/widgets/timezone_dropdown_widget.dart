import 'package:flutter/material.dart';

class TimezoneDropdown extends StatelessWidget {
  final List<String> timezones;
  final String selectedTimezone;
  final void Function(String?) onChanged;

  const TimezoneDropdown({
    required this.timezones,
    required this.selectedTimezone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTimezone,
      items: timezones.map((tz) {
        return DropdownMenuItem(
          value: tz,
          child: Text(tz),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
