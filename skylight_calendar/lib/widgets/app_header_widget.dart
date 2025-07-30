import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late String _time;

  @override
  void initState() {
    super.initState();
    _time = DateFormat.Hm().format(DateTime.now());
    _updateTime();
  }

  void _updateTime() {
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _time = DateFormat.Hm().format(DateTime.now());
        });
        _updateTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity, // or your preferred height
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Center(
                  child: Text(
                    _time,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Center(
                  child: const Text("72°F & Sunny", style: TextStyle(fontSize: 28)),
                ),
              ],
            ),
          ),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.onPrevMonth,
                  icon: const Icon(Icons.chevron_left),
                ),

                Text(widget.monthLabel, style: const TextStyle(fontSize: 16)),

                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
