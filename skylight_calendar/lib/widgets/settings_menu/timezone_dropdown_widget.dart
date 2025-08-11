import 'package:flutter/material.dart';

class TimezoneDropdown extends StatelessWidget {
  final List<String> timezones;
  final String selectedTimezone;
  final void Function(String?) onChanged;
  final TextStyle? textStyle;  // Optional to pass in style

  const TimezoneDropdown({
    Key? key,
    required this.timezones,
    required this.selectedTimezone,
    required this.onChanged,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTimezone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true, // Matches TextField spacing
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.normal, // Adjust weight to match
      ),
      items: timezones.map((tz) {
        return DropdownMenuItem(
          value: tz,
          child: Text(
            tz,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
