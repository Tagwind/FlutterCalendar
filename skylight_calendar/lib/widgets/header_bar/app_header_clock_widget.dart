import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/current_time_provider.dart';

class AppHeaderClock extends StatelessWidget {
  const AppHeaderClock({super.key});

  @override
  Widget build(BuildContext context) {
    // Only listen to CurrentTimeProvider here
    final now = context.select<CurrentTimeProvider, DateTime>(
          (ctp) => ctp.now,
    );

    final formattedTime = DateFormat.Hm().format(now);

    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
