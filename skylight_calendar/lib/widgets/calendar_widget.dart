import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/dummy_events.dart';

class CalendarWidget extends StatefulWidget {
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.utc(2025, 7, 21);
  DateTime? _selectedDay;

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return dummyEvents.where((event) {
      final start = DateTime.utc(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      final end = DateTime.utc(
        event.effectiveEndDate.year,
        event.effectiveEndDate.month,
        event.effectiveEndDate.day,
      );
      return !normalizedDay.isBefore(start) && !normalizedDay.isAfter(end);
    }).toList();
  }

  String formatEventTime(CalendarEvent event) {
    final dt = event.startDate;
    if (dt.hour == 0 && dt.minute == 0) {
      return ''; // No time set, omit it
    } else {
      final time = TimeOfDay.fromDateTime(dt);
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final suffix = time.period == DayPeriod.am ? 'am' : 'pm';
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hour:$minutes$suffix';
    }
  }

  Widget _buildDayCell(
    DateTime day, {
    bool isToday = false,
    bool isSelected = false,
    bool isOutside = false,
    int weekday = 1,
  }) {
    final events = _getEventsForDay(day);
    final hasEvents = events.isNotEmpty;

    final borderColor = Colors.grey.shade400;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.indigo.shade100
            : isToday
            ? Colors.indigo.shade50
            : isOutside
            ? Colors.white.withOpacity(.4) // faded background for outside days
            : Colors.white,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
          bottom: BorderSide(color: borderColor, width: 0.5),
          left: weekday == DateTime.sunday
              ? BorderSide.none
              : BorderSide(color: borderColor, width: 0.5),
          right: weekday == DateTime.saturday
              ? BorderSide.none
              : BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.only(right: 4.0, top: 4.0),
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isOutside
                  ? Colors.black.withOpacity(0.2) // faded text for outside days
                  : Colors.black,
            ),
          ),
          if (hasEvents)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: events.map((e) {
                  final timeText = formatEventTime(e);
                  return Text(
                    timeText.isNotEmpty ? '$timeText ${e.title}' : e.title,
                    style: TextStyle(
                      color: isOutside
                          ? Colors.black.withOpacity(
                              0.4,
                            ) // faded events text too
                          : Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight / 6 / 2;
    final dayRowHeight = (screenHeight - headerHeight) / 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Skylight Calendar')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2099, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            rowHeight: dayRowHeight,
            daysOfWeekHeight: headerHeight,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              isTodayHighlighted: true,
              defaultTextStyle: TextStyle(fontSize: 12),
              weekendTextStyle: TextStyle(color: Colors.redAccent),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            calendarBuilders: CalendarBuilders<CalendarEvent>(
              defaultBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, weekday: day.weekday),
              selectedBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, isSelected: true, weekday: day.weekday),
              todayBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, isToday: true, weekday: day.weekday),
              outsideBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, isOutside: true, weekday: day.weekday),
              markerBuilder: (context, day, events) =>
                  const SizedBox.shrink(), // No black dots
              dowBuilder: (context, day) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    DateFormat.E().format(day),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
