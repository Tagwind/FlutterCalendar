import 'package:flutter/material.dart';

class TimezoneDropdown extends StatelessWidget {
  final List<String> timezones;
  final String selectedTimezone;
  final void Function(String?) onChanged;

  const TimezoneDropdown({
    Key? key,
    required this.timezones,
    required this.selectedTimezone,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTimezone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
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
